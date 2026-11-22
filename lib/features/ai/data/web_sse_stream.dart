import 'dart:async';

import 'package:dio/dio.dart';

import 'web_sse_bytes_stub.dart'
    if (dart.library.js_interop) 'web_sse_bytes_web.dart' as impl;

/// Whether this build can stream real DeepSeek SSE frames in the browser.
bool get webSseAvailable => impl.available;

/// Opens `POST https://api.deepseek.com/chat/completions` with `fetch` and
/// exposes the raw response body bytes as they arrive.
///
/// Dio's browser adapter uses XMLHttpRequest, which only exposes the complete
/// body after the request finishes. Flutter web therefore needs this small
/// fetch/ReadableStream adapter to keep genuine token-by-token streaming.
Stream<List<int>> webSseBytes({
  required String key,
  required String model,
  required List<Map<String, String>> messages,
  required int maxOutput,
  required bool thinking,
  required CancelToken cancelToken,
  void Function(int)? onResponseStatus,
}) => impl.stream(
  key: key,
  model: model,
  messages: messages,
  maxOutput: maxOutput,
  thinking: thinking,
  cancelToken: cancelToken,
  onResponseStatus: onResponseStatus,
);
