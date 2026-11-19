import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/security/api_key_storage.dart';
import '../../usage/usage_repository.dart';
import '../../world_creator/application/providers.dart';
import '../data/deepseek_api_client.dart';
import '../data/deepseek_config.dart';
import '../data/deepseek_repository.dart';
import '../data/deepseek_error_handler.dart';
import '../data/deepseek_http_protocol.dart';
import '../data/deepseek_models.dart';

final apiKeyStorageProvider = Provider<ApiKeyStorage>((ref) => ApiKeyStorage());
final apiKeyStatusProvider = FutureProvider<bool>(
  (ref) => ref.watch(apiKeyStorageProvider).hasApiKey(),
);
const deepSeekModelPreferenceKey = 'preferences/deepseek-model-v1';
final deepSeekModelPreferenceProvider = FutureProvider<String?>((ref) async {
  final saved = await ref
      .watch(worldDefinitionRepositoryProvider)
      .draft(deepSeekModelPreferenceKey);
  final model = saved?['model'];
  return model is String && DeepSeekModels.supported.contains(model)
      ? model
      : null;
});

final deepSeekConfigProvider = Provider<DeepSeekConfig>((ref) {
  final model = ref.watch(deepSeekModelPreferenceProvider).asData?.value;
  const build = DeepSeekConfig.applicationBuild;
  return model == null ? build : build.withModel(model);
});
final deepSeekRepositoryProvider = Provider<DeepSeekRepository>((ref) {
  final config = ref.watch(deepSeekConfigProvider);
  final client = DeepSeekApiClient(config);
  ref.onDispose(client.close);
  return ExperimentalDeepSeekRepository(
    client,
    ref.watch(usageRepositoryProvider),
  );
});

class ConnectionStatus extends Notifier<String> {
  @override
  String build() => '';
  void setStatus(String message) => state = message;
}

final connectionStatusProvider = NotifierProvider<ConnectionStatus, String>(
  ConnectionStatus.new,
);

enum AiConnectionState {
  unconfigured('未配置 API Key'),
  waiting('已配置，等待连接'),
  connected('真实 DeepSeek 已连接'),
  offline('网络不可用'),
  invalidKey('API Key 无效'),
  insufficientCredit('额度不足'),
  serviceError('接口异常'),
  restricted('AI 服务暂不可用');

  const AiConnectionState(this.label);
  final String label;
}

class ApiDiagnostics {
  const ApiDiagnostics({
    this.state,
    this.lastError,
    this.receipt,
    this.lastFailureHttpStatus,
  });
  final AiConnectionState? state;
  final String? lastError;
  final ConnectionReceipt? receipt;
  final int? lastFailureHttpStatus;
}

class ApiDiagnosticsController extends Notifier<ApiDiagnostics> {
  @override
  ApiDiagnostics build() => const ApiDiagnostics();

  void connected([ConnectionReceipt? receipt]) {
    state = ApiDiagnostics(
      state: AiConnectionState.connected,
      receipt: receipt ?? state.receipt,
    );
  }

  void requestFailed(Object error) {
    final failure = DeepSeekErrorHandler.sanitize(error);
    _setFailure(failure.message, failure.status);
  }

  void requestFailedMessage(String message) => _setFailure(
    message,
    message == state.lastError ? state.lastFailureHttpStatus : null,
  );

  void _setFailure(String message, int? httpStatus) {
    final status = switch (message) {
      'API Key 无效，请检查或更换密钥。' => AiConnectionState.invalidKey,
      '账户余额不足，请前往官方平台查看。' => AiConnectionState.insufficientCredit,
      '连接失败，请检查网络后重试。' ||
      '请求超时，请检查网络后重试。' ||
      DeepSeekErrorHandler.connectTimeoutMessage ||
      DeepSeekErrorHandler.sendTimeoutMessage ||
      DeepSeekErrorHandler.receiveTimeoutMessage ||
      '流式连接中断，请重试。' ||
      '流式连接中断，未收到完成标记，请重试。' => AiConnectionState.offline,
      missingDeepSeekKeyMessage ||
      '尚未保存密钥，请先配置。' => AiConnectionState.unconfigured,
      _ => AiConnectionState.serviceError,
    };
    state = ApiDiagnostics(
      state: status,
      lastError: message,
      lastFailureHttpStatus: httpStatus,
    );
  }

  void reset() => state = const ApiDiagnostics();
}

final apiDiagnosticsProvider =
    NotifierProvider<ApiDiagnosticsController, ApiDiagnostics>(
      ApiDiagnosticsController.new,
    );

final aiConnectionStateProvider = Provider<AiConnectionState>((ref) {
  final key = ref.watch(apiKeyStatusProvider);
  if (key.hasError) return AiConnectionState.serviceError;
  if (key.asData?.value != true) return AiConnectionState.unconfigured;
  if (!ref.watch(deepSeekConfigProvider).permitsDirectCalls) {
    return AiConnectionState.restricted;
  }
  return ref.watch(apiDiagnosticsProvider).state ?? AiConnectionState.waiting;
});

/// A connection test is optional. Transient network and service failures can
/// be retried by submitting a new action and confirming its own budget.
final aiActionUnavailableProvider = Provider<String?>((ref) {
  final key = ref.watch(apiKeyStatusProvider);
  if (key.isLoading) return '正在读取 API Key 状态…';
  if (key.hasError) return '暂时无法读取本机 API Key。';
  if (key.asData?.value != true) return missingDeepSeekKeyMessage;
  if (!ref.watch(deepSeekConfigProvider).permitsDirectCalls) {
    return '当前版本暂时无法生成 AI 回复。';
  }
  return ref.watch(aiConnectionStateProvider) == AiConnectionState.invalidKey
      ? 'API Key 无效，请在设置中更换或重新测试。'
      : null;
});
