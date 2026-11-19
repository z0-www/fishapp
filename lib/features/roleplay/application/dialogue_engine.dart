import '../../../core/security/api_key_storage.dart';
import '../../ai/data/deepseek_api_client.dart';
import '../../ai/data/deepseek_http_protocol.dart';
import '../../ai/data/deepseek_config.dart';
import '../../ai/data/deepseek_error_handler.dart';
import '../../usage/usage_repository.dart';
import '../domain/models.dart';

abstract interface class DialogueEngine {
  Future<DialogueOutput> generate(TurnPlan plan, TurnCancellation cancellation);
}

class BlockedDialogueEngine implements DialogueEngine {
  const BlockedDialogueEngine();
  static const message = DeepSeekConfig.blockedMessage;
  @override
  Future<DialogueOutput> generate(
    TurnPlan plan,
    TurnCancellation cancellation,
  ) async => throw const RoleplayFailure(message);
}

class DeepSeekDialogueEngine implements DialogueEngine {
  DeepSeekDialogueEngine(
    this.config,
    this.storage, {
    DeepSeekTransport? transport,
    this.onError,
    this.usageRepository,
  }) : client = transport ?? DeepSeekApiClient(config);
  final DeepSeekConfig config;
  final ApiKeyStorage storage;
  final DeepSeekTransport client;
  final void Function(Object)? onError;
  final UsageRepository? usageRepository;
  @override
  Future<DialogueOutput> generate(
    TurnPlan plan,
    TurnCancellation cancellation,
  ) async {
    String? key;
    var awaitingUsage = false;
    int? input, output, cache, httpStatus;
    String? responseModel;
    final watch = Stopwatch();
    try {
      cancellation.check();
      key = await storage.readApiKey();
      if (key == null) {
        throw const RoleplayFailure(
          missingDeepSeekKeyMessage,
          source: 'configuration',
        );
      }
      if (!ApiKeyStorage.isValidInput(key)) {
        throw const DeepSeekFailure('请输入格式完整的 API Key。');
      }
      cancellation.check();
      if (usageRepository case final usage?) {
        await usage.markAwaitingUsage(
          requestId: plan.id,
          model: config.model,
          worldId: plan.state.worldId,
        );
        awaitingUsage = true;
        if (cancellation.cancelled) {
          await usage.discardAwaitingUsage(plan.id);
          awaitingUsage = false;
          cancellation.check();
        }
      }
      final body = StringBuffer();
      String? finish, issue, issueSource;
      watch.start();
      final transport = client;
      final events = transport is DeepSeekApiClient
          ? transport.streamMessages(
              key,
              plan.messages,
              cancelToken: cancellation.dio,
              maxOutput: plan.maxOutputTokens,
              onResponseStatus: (status) => httpStatus = status,
            )
          : transport.streamMessages(
              key,
              plan.messages,
              cancelToken: cancellation.dio,
              maxOutput: plan.maxOutputTokens,
            );
      await for (final event in events) {
        if (event['usage'] != null) {
          final usage = DeepSeekHttpProtocol.readUsage(event['usage']);
          input = usage['prompt_tokens'];
          output = usage['completion_tokens'];
          cache = usage['prompt_cache_hit_tokens'];
        }
        cancellation.check();
        final model = event['model'];
        if (model is String &&
            RegExp(r'^deepseek-[a-zA-Z0-9._-]{1,80}$').hasMatch(model)) {
          responseModel = model;
        }
        final choices = event['choices'];
        if (choices is! List || choices.length > 1) {
          throw const RoleplayFailure('流式响应格式异常，未提交状态。');
        }
        if (choices.isNotEmpty) {
          final choice = choices.single;
          if (choice is! Map || choice['delta'] is! Map) {
            throw const RoleplayFailure('流式响应格式异常，未提交状态。');
          }
          final delta = choice['delta'] as Map;
          final content = delta['content'];
          if (content != null && content is! String) {
            throw const RoleplayFailure('流式响应格式异常，未提交状态。');
          }
          body.write(content ?? '');
          if (delta['tool_calls'] != null || delta['refusal'] != null) {
            issue = '上游模型未返回可用剧情，未提交状态。';
            issueSource = 'upstreamModel';
          }
          final reason = choice['finish_reason'];
          if (reason != null) {
            if (reason is! String) {
              throw const RoleplayFailure(
                '流式响应格式异常，未提交状态。',
                source: 'jsonStructure',
              );
            }
            finish = reason;
          }
        }
        if (body.length > 24000) throw const RoleplayFailure('回复过长，未提交状态。');
      }
      if (finish != 'stop') {
        issue = DeepSeekHttpProtocol.finishIssue(finish);
        issueSource = finish == 'content_filter'
            ? 'upstreamModel'
            : finish == 'length'
            ? 'quota'
            : 'jsonStructure';
      }
      if (body.toString().trim().isEmpty && issue == null) {
        issue = '模型返回空内容，未提交状态。';
      }
      if (issue != null) {
        onError?.call(DeepSeekFailure(issue, status: httpStatus));
      }
      return DialogueOutput(
        body.toString(),
        inputTokens: input,
        outputTokens: output,
        cacheTokens: cache,
        model: responseModel ?? config.model,
        httpStatus: httpStatus,
        elapsedMs: watch.elapsedMilliseconds,
        issue: issue,
        issueSource: issueSource,
      );
    } catch (e) {
      final failure = e is RoleplayFailure
          ? null
          : DeepSeekErrorHandler.sanitize(e);
      if (awaitingUsage && failure?.rejectedBeforeGeneration == true) {
        try {
          await usageRepository!.discardAwaitingUsage(plan.id);
        } catch (_) {
          // Keeping the unknown record is safer than hiding the HTTP error.
        }
      }
      final safe = e is RoleplayFailure ? e.message : failure!.message;
      if (input != null && output != null) {
        // Keep known usage even if the transport later fails. The coordinator
        // records it before surfacing the error, without committing any prose.
        onError?.call(
          DeepSeekFailure(safe, status: httpStatus ?? failure?.status),
        );
        return DialogueOutput(
          '',
          inputTokens: input,
          outputTokens: output,
          cacheTokens: cache,
          model: responseModel ?? config.model,
          httpStatus: httpStatus,
          elapsedMs: watch.elapsedMilliseconds,
          issue: safe,
          issueSource: e is RoleplayFailure ? e.source : 'network',
        );
      }
      if (cancellation.cancelled) {
        onError?.call(const DeepSeekFailure('已停止请求；服务端可能已消耗 Token。'));
        cancellation.check();
      }
      onError?.call(
        e is RoleplayFailure
            ? DeepSeekFailure(
                e.source == 'configuration'
                    ? missingDeepSeekKeyMessage
                    : '响应格式异常，未确认连接成功。',
                status: httpStatus,
              )
            : DeepSeekFailure(
                failure!.message,
                status: httpStatus ?? failure.status,
              ),
      );
      throw RoleplayFailure(
        safe,
        source: e is RoleplayFailure
            ? e.source
            : safe.contains('格式')
            ? 'jsonStructure'
            : safe.contains('余额') || safe.contains('上限')
            ? 'quota'
            : failure?.status == 401 || safe == '请输入格式完整的 API Key。'
            ? 'configuration'
            : 'network',
      );
    } finally {
      key = null;
    }
  }

  void dispose() => client.close();
}
