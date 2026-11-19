import 'deepseek_balance.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;

import 'deepseek_config.dart';
import 'deepseek_error_handler.dart';
import 'deepseek_http_protocol.dart';

/// Only mobile app entry to the transport. Rechecks policy on every request.
class DeepSeekApiClient implements DeepSeekTransport {
  DeepSeekApiClient(DeepSeekConfig config) : this._(config);

  @visibleForTesting
  DeepSeekApiClient.withAdapter(
    DeepSeekConfig config,
    HttpClientAdapter adapter,
  ) : this._(config, adapter: adapter);

  DeepSeekApiClient._(this.config, {HttpClientAdapter? adapter})
    : _protocol = DeepSeekHttpProtocol(
        model: config.model,
        thinking: config.thinking,
        adapter: adapter,
      );
  final DeepSeekConfig config;
  final DeepSeekHttpProtocol _protocol;
  void _check() {
    if (!config.permitsDirectCalls || !config.hasSafeEndpoint) {
      throw const DeepSeekFailure(DeepSeekConfig.blockedMessage);
    }
  }

  Future<DeepSeekBalance> balance(String key) {
    _check();
    return _protocol.balance(key);
  }

  Future<List<String>> listModels(String key) {
    _check();
    return _protocol.listModels(key);
  }

  @override
  Future<ConnectionReceipt> testConnection(String key) async {
    _check();
    return _protocol.testConnection(key);
  }

  @override
  Stream<Map<String, dynamic>> streamMessages(
    String key,
    List<Map<String, String>> messages, {
    required CancelToken cancelToken,
    int maxOutput = 1200,
    void Function(int)? onResponseStatus,
  }) async* {
    _check();
    yield* _protocol.streamMessages(
      key,
      messages,
      cancelToken: cancelToken,
      maxOutput: maxOutput,
      onResponseStatus: onResponseStatus,
    );
  }

  static Stream<Map<String, dynamic>> decodeSse(Stream<List<int>> bytes) =>
      DeepSeekHttpProtocol.decodeSse(bytes);
  @override
  void close() => _protocol.close();
}
