import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ai/application/ai_providers.dart';
import '../../ai/data/deepseek_api_client.dart';
import '../../ai/data/deepseek_http_protocol.dart';
import '../../ai/data/deepseek_config.dart';
import '../../ai/data/deepseek_error_handler.dart';
import '../../../core/security/api_key_storage.dart';
import '../../usage/usage_repository.dart';
import '../domain/world_definition.dart';

class WorldSuggestion {
  const WorldSuggestion(this.field, this.label, this.value);
  final String field, label;
  final Object? value;
}

class SuggestionRequest {
  const SuggestionRequest(this.id, this.scope, this.openingOnly);
  final String id;
  final Map<String, dynamic> scope;
  final bool openingOnly;
  int get estimatedTokens => utf8.encode(jsonEncode(scope)).length + 600;
}

class WorldSuggestionEngine {
  WorldSuggestionEngine(this.config, this.storage, this.usage);
  final DeepSeekConfig config;
  final ApiKeyStorage storage;
  final UsageRepository usage;
  final _used = <String>{};
  SuggestionRequest prepare(WorldDefinition d, {bool openingOnly = false}) =>
      SuggestionRequest('suggest-${DateTime.now().microsecondsSinceEpoch}', {
        'title': d.title,
        'description': d.text('description'),
        'playerProfile': d.data['playerProfile'],
        'openingScene': d.text('openingScene'),
      }, openingOnly);
  Future<List<WorldSuggestion>> generate(
    SuggestionRequest request, {
    required bool confirmed,
    CancelToken? cancellation,
  }) async {
    if (!confirmed) throw const DefinitionFailure('请先确认处理范围和预算。');
    if (!config.permitsDirectCalls) {
      throw const DefinitionFailure('真实调用不可用：需要先确认适用许可及开发测试配置。');
    }
    if (WorldDefinitionExchange.containsCredential(request.scope)) {
      throw const DefinitionFailure('请从设定中移除凭据。');
    }
    if (request.estimatedTokens > 12000) {
      throw const DefinitionFailure('待处理设定过长，请精简范围。');
    }
    if (cancellation?.isCancelled == true) {
      throw const DefinitionFailure('已停止建议请求。');
    }
    if (!_used.add(request.id)) {
      throw const DefinitionFailure('此确认已使用，请重新确认后重试。');
    }
    String? key;
    final requestedAt = DateTime.now();
    var tracked = false;
    final client = DeepSeekApiClient(config);
    try {
      key = await storage.readApiKey();
      if (key == null) throw const DefinitionFailure('请先在 AI 服务设置中配置密钥。');
      if (cancellation?.isCancelled == true) {
        throw const DefinitionFailure('已停止建议请求。');
      }
      await usage.markAwaitingUsage(requestId: request.id, model: config.model);
      tracked = true;
      final text = StringBuffer();
      Map? usageData;
      String? finishReason;
      await for (final event in client.streamMessages(
        key,
        [
          {
            'role': 'system',
            'content': '为用户提出世界设定建议，只返回JSON {"suggestions":[{"field":"openingScene 或 narrativePreferences","label":"中文说明","value":"文字或叙事偏好对象"}]}。不要改变玩家明确身份，不替玩家行动。所有建议必须等待用户逐项确认。开场只描写可见环境，不发明确定的世界规则。',
          },
          {
            'role': 'user',
            'content': jsonEncode({
              'openingOnly': request.openingOnly,
              'settings': request.scope,
            }),
          },
        ],
        cancelToken: cancellation ?? CancelToken(),
        maxOutput: 1000,
      )) {
        final choices = event['choices'] as List? ?? [];
        final finishChoices = event['choices'];
        if (finishChoices is List &&
            finishChoices.isNotEmpty &&
            finishChoices.first is Map &&
            finishChoices.first['finish_reason'] is String) {
          finishReason = finishChoices.first['finish_reason'] as String;
        }
        if (choices.isNotEmpty) {
          text.write(
            ((choices.first as Map)['delta'] as Map?)?['content'] as String? ??
                '',
          );
        }
        if (text.length > 24000) throw const DefinitionFailure('建议过长，未应用。');
        if (event['usage'] is Map) usageData = event['usage'] as Map;
      }
      if (usageData?['prompt_tokens'] is num &&
          usageData?['completion_tokens'] is num) {
        await usage.record(
          requestedAt: requestedAt,
          requestId: request.id,
          model: config.model,
          inputTokens: (usageData!['prompt_tokens'] as num).toInt(),
          outputTokens: (usageData['completion_tokens'] as num).toInt(),
          cacheTokens: (usageData['prompt_cache_hit_tokens'] as num?)?.toInt(),
        );
      }
      final issue = DeepSeekHttpProtocol.finishIssue(finishReason);
      if (issue != null) throw DeepSeekFailure(issue);
      final result = jsonDecode(text.toString()) as Map;
      final rows = result['suggestions'] as List;
      if (rows.length > 8) throw const FormatException();
      return rows.map((r) {
        final m = Map<String, dynamic>.from(r as Map);
        final field = m['field'];
        final value = m['value'];
        if (!['openingScene', 'narrativePreferences'].contains(field) ||
            request.openingOnly && field != 'openingScene' ||
            field == 'openingScene' && value is! String ||
            field == 'narrativePreferences' && value is! Map ||
            WorldDefinitionExchange.containsCredential(value)) {
          throw const FormatException();
        }
        return WorldSuggestion(
          field as String,
          m['label'] as String? ?? '建议',
          value,
        );
      }).toList();
    } catch (e) {
      if (e is DefinitionFailure) rethrow;
      final failure = DeepSeekErrorHandler.sanitize(e);
      if (tracked && failure.rejectedBeforeGeneration) {
        try {
          await usage.discardAwaitingUsage(request.id);
        } catch (_) {}
      }
      throw DefinitionFailure(failure.message);
    } finally {
      key = null;
      client.close();
    }
  }
}

final worldSuggestionEngineProvider = Provider(
  (ref) => WorldSuggestionEngine(
    ref.watch(deepSeekConfigProvider),
    ref.watch(apiKeyStorageProvider),
    ref.watch(usageRepositoryProvider),
  ),
);
