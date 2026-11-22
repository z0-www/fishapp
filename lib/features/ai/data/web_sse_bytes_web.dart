import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:dio/dio.dart';
import 'package:web/web.dart' as web;

import 'deepseek_error_handler.dart';

bool get available => true;

const _endpoint = 'https://api.deepseek.com/chat/completions';

Stream<List<int>> stream({
  required String key,
  required String model,
  required List<Map<String, String>> messages,
  required int maxOutput,
  required bool thinking,
  required CancelToken cancelToken,
  void Function(int)? onResponseStatus,
}) async* {
  final abort = web.AbortController();
  var active = true;
  var aborted = false;
  // A Dio CancelToken is the single cancellation surface shared with the rest
  // of the app, including the stop button in the roleplay page.
  unawaited(
    cancelToken.whenCancel.then((_) {
      if (!active) return;
      aborted = true;
      abort.abort();
    }),
  );

  final payload = jsonEncode({
    'model': model,
    'messages': messages,
    'max_tokens': maxOutput,
    'stream': true,
    'response_format': {'type': 'json_object'},
    'thinking': {'type': thinking ? 'enabled' : 'disabled'},
    'stream_options': {'include_usage': true},
  });

  web.Response response;
  try {
    response = await web.window
        .fetch(
          _endpoint.toJS,
          web.RequestInit(
            method: 'POST',
            headers: web.Headers()
              ..set('Authorization', 'Bearer $key')
              ..set('Content-Type', 'application/json')
              ..set('Accept', 'text/event-stream'),
            body: payload.toJS,
            signal: abort.signal,
          ),
        )
        .toDart
        .timeout(const Duration(seconds: 30));
  } on TimeoutException {
    aborted = true;
    abort.abort();
    throw const DeepSeekFailure(DeepSeekErrorHandler.connectTimeoutMessage);
  } catch (error) {
    if (aborted) {
      throw const DeepSeekFailure('已停止请求；服务端可能已消耗 Token。');
    }
    throw const DeepSeekFailure('连接失败，请检查网络后重试。');
  }

  onResponseStatus?.call(response.status);
  if (response.status != 200) {
    try {
      await response.text().toDart;
    } catch (_) {
      // The body is only drained; the HTTP status is the actionable fact.
    }
    throw DeepSeekErrorHandler.fromStatus(response.status);
  }
  final type = response.headers.get('content-type') ?? '';
  if (!type.toLowerCase().startsWith('text/event-stream')) {
    throw const DeepSeekFailure('流式响应格式异常，请重试。');
  }
  final body = response.body;
  if (body == null) {
    throw const DeepSeekFailure('流式响应格式异常，请重试。');
  }
  final reader = body.getReader() as web.ReadableStreamDefaultReader;
  try {
    while (true) {
      final result = await reader.read().toDart.timeout(
        const Duration(seconds: 180),
      );
      if (result.done) break;
      final value = result.value;
      if (value == null) continue;
      yield (value as JSUint8Array).toDart;
    }
  } on TimeoutException {
    aborted = true;
    abort.abort();
    throw const DeepSeekFailure(DeepSeekErrorHandler.receiveTimeoutMessage);
  } catch (error) {
    if (aborted) {
      throw const DeepSeekFailure('已停止请求；服务端可能已消耗 Token。');
    }
    throw const DeepSeekFailure('流式连接中断，请重试。');
  } finally {
    active = false;
    try {
      reader.releaseLock();
    } catch (_) {
      // The stream may already be closed by an abort.
    }
  }
}
