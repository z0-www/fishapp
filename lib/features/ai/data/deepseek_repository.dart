import 'dart:math';

import '../../../core/security/api_key_storage.dart';
import '../../usage/deepseek_prices.dart';
import '../../usage/usage_repository.dart';
import 'deepseek_api_client.dart';
import 'deepseek_error_handler.dart';
import 'deepseek_http_protocol.dart';

class ConnectionTestResult {
  const ConnectionTestResult(this.receipt);
  final ConnectionReceipt receipt;
  String get message {
    final r = receipt;
    final input = r.usage['prompt_tokens'];
    final output = r.usage['completion_tokens'];
    return 'DeepSeek 真实连接成功 · ${r.model} · '
        '${r.elapsed.inMilliseconds} ms'
        '${input == null ? '' : ' · 输入 $input / 输出 ${output ?? '—'} Token'}';
  }
}

abstract interface class DeepSeekRepository {
  Future<ConnectionTestResult> testConnection(String apiKey);
}

class ExperimentalDeepSeekRepository implements DeepSeekRepository {
  ExperimentalDeepSeekRepository(this.client, this.usage);
  final DeepSeekApiClient client;
  final UsageRepository usage;

  @override
  Future<ConnectionTestResult> testConnection(String apiKey) async {
    // Leave enforcement to the API client for disabled builds. No probe is
    // recorded when the request cannot be dispatched.
    if (!client.config.permitsDirectCalls) {
      return ConnectionTestResult(await client.testConnection(apiKey));
    }
    if (!ApiKeyStorage.isValidInput(apiKey)) {
      throw const DeepSeekFailure('请输入格式完整的 API Key。');
    }
    final now = DateTime.now();
    final requestId =
        'connection-${now.microsecondsSinceEpoch}-${Random.secure().nextInt(1 << 32)}';
    await usage.markAwaitingUsage(
      requestId: requestId,
      model: client.config.model,
    );
    try {
      final receipt = await client.testConnection(apiKey);
      final input = receipt.usage['prompt_tokens'];
      final output = receipt.usage['completion_tokens'];
      if (input != null && output != null) {
        await usage.record(
          requestedAt: now,
          model: receipt.model,
          inputTokens: input,
          outputTokens: output,
          cacheTokens: receipt.usage['prompt_cache_hit_tokens'],
          price: DeepSeekPrices.forModel(receipt.model),
          requestId: requestId,
          httpStatus: receipt.httpStatus,
          elapsedMs: receipt.elapsed.inMilliseconds,
        );
      }
      return ConnectionTestResult(receipt);
    } catch (error) {
      final failure = DeepSeekErrorHandler.sanitize(error);
      if (failure.rejectedBeforeGeneration) {
        try {
          await usage.discardAwaitingUsage(requestId);
        } catch (_) {
          // Preserve the primary error if local cleanup is unavailable.
        }
      }
      throw failure;
    }
  }
}
