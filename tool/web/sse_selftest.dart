// Browser self-test for the real Flutter-web SSE transport.
//
// This file is compiled with `dart compile js` and loaded by sse_selftest.html.
// The page replaces `window.fetch` with deterministic ReadableStream responses,
// so the production code in `web_sse_bytes_web.dart` is exercised for:
//   * incremental SSE parsing / [DONE]
//   * usage frame extraction
//   * mid-stream network failure
//   * clean EOF without [DONE]
//   * HTTP 401
//   * user cancellation via Dio CancelToken
//
// It is a transport test with a browser-level network stub, NOT a real
// DeepSeek call.
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_error_handler.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_http_protocol.dart';
import 'package:fishtextadventure/features/ai/data/web_sse_stream.dart';
import 'package:web/web.dart' as web;

final _lines = <String>[];

void report(String message) {
  _lines.add(message);
  web.document.body?.innerText = _lines.join('\n');
}

void check(bool ok, String message) {
  if (!ok) throw StateError(message);
}

Future<List<Map<String, dynamic>>> collect({
  CancelToken? cancelToken,
  String key = 'test-key-not-a-secret',
}) async {
  final events = <Map<String, dynamic>>[];
  final stream = DeepSeekHttpProtocol.decodeSse(
    webSseBytes(
      key: key,
      model: 'deepseek-flash',
      messages: const [
        {'role': 'user', 'content': 'ping'},
      ],
      maxOutput: 64,
      thinking: false,
      cancelToken: cancelToken ?? CancelToken(),
    ),
  );
  await for (final event in stream) {
    events.add(event);
  }
  return events;
}

Future<void> runCase(String name, Future<void> Function() body) async {
  try {
    await body();
    report('PASS $name');
  } catch (error) {
    report('FAIL $name: $error');
  }
}

Future<void> main() async {
  await runCase('success-stream-usage-done', () async {
    final events = await collect();
    check(events.length == 3, 'expected 3 events, got ${events.length}');
    check(
      events[0]['choices']?[0]?['delta']?['content'] == '你',
      'first delta',
    );
    check(
      events[1]['choices']?[0]?['delta']?['content'] == '好',
      'second delta',
    );
    check(events[2]['usage']?['prompt_tokens'] == 10, 'usage prompt tokens');
    check(events[2]['usage']?['completion_tokens'] == 4, 'usage output tokens');
    check(events[2]['usage']?['prompt_cache_hit_tokens'] == 6, 'cache tokens');
  });

  await runCase('mid-stream-disconnect', () async {
    try {
      await collect();
      throw StateError('stream unexpectedly succeeded');
    } on DeepSeekFailure catch (error) {
      check(error.message == '流式连接中断，请重试。', 'unexpected message: ${error.message}');
    }
  });

  await runCase('eof-without-done', () async {
    try {
      await collect();
      throw StateError('stream unexpectedly succeeded');
    } on DeepSeekFailure catch (error) {
      check(error.message == '流式连接中断，请重试。', 'unexpected message: ${error.message}');
    }
  });

  await runCase('http-401', () async {
    try {
      await collect();
      throw StateError('401 unexpectedly succeeded');
    } on DeepSeekFailure catch (error) {
      check(error.status == 401, 'status should be 401, got ${error.status}');
      check(error.message.contains('API Key 无效'), 'unexpected message: ${error.message}');
    }
  });

  await runCase('user-cancel', () async {
    final token = CancelToken();
    final pending = collect(cancelToken: token);
    unawaited(Future<void>.delayed(const Duration(milliseconds: 5), token.cancel));
    try {
      await pending;
      throw StateError('cancelled stream unexpectedly succeeded');
    } on DeepSeekFailure catch (error) {
      check(
        error.message.contains('已停止请求'),
        'unexpected cancel message: ${error.message}',
      );
    }
  });

  final failures = _lines.where((line) => line.startsWith('FAIL')).length;
  report('SUMMARY failures=$failures');
  report('DONE');
}
