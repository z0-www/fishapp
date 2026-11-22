// Independent Windows developer tool, excluded from the mobile composition root.
// Never place a key in command arguments, environment setup, source or build flags.
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_error_handler.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_http_protocol.dart';

Future<void> main(List<String> args) async {
  final reports = args.where((v) => v.startsWith('--report=')).toList();
  final probe = args.contains('--probe');
  if (reports.length > 1 || reports.any((v) => v == '--report=')) {
    stderr.writeln('只允许指定一个验收结果路径。');
    exitCode = 2;
    return;
  }
  final report = reports.isEmpty ? null : File(reports.single.substring(9));
  void record(Map<String, Object?> result) {
    report?.writeAsStringSync(jsonEncode(result));
  }

  if (!args.contains('--confirm-cost') ||
      args.any(
        (v) =>
            !['--confirm-cost', '--probe'].contains(v) &&
            !v.startsWith('--report='),
      )) {
    stderr.writeln(
      '未执行：本工具每次最多一次收费请求。接受费用后使用 --confirm-cost；可选 --probe 仅测非流式。',
    );
    exitCode = 2;
    return;
  }
  if (!stdin.hasTerminal) {
    stderr.writeln('未执行：需要交互终端隐藏输入密钥；不读取环境变量或参数中的密钥。');
    exitCode = 2;
    return;
  }
  stdout.writeln(
    probe ? '将发出一次 DeepSeek 请求，输出上限 8 Token，费用参考约 0.00009 美元。输入 YES 继续：' : '将发出一次 DeepSeek SSE 请求，输出上限 120 Token，费用参考约 0.000298 美元。输入 YES 继续：',
  );
  if (stdin.readLineSync() != 'YES') {
    record({'result': 'cancelled', 'requestAttempted': false});
    stdout.writeln('已取消，0 次请求。');
    return;
  }
  String? key;
  final previousEcho = stdin.echoMode;
  try {
    stdout.write('API Key（隐藏输入，不保存）：');
    stdin.echoMode = false;
    key = stdin.readLineSync()?.trim();
  } finally {
    stdin.echoMode = previousEcho;
    stdout.writeln();
  }
  if (key == null ||
      key.length < 8 ||
      key.length > 512 ||
      key.contains(RegExp(r'\s'))) {
    record({'result': 'invalid_local_key', 'requestAttempted': false});
    stderr.writeln('未执行：密钥格式无效。');
    exitCode = 2;
    return;
  }
  int? httpStatus;
  String? probeText;
  void showText(String text) {
    stdout.writeln('模型正文（仅此终端）');
    stdout.writeln(
      text
          .replaceAll(key!, '[已隐藏]')
          .replaceAll(RegExp(r'[\x00-\x1F\x7F]'), ' '),
    );
  }

  final protocol = DeepSeekHttpProtocol(
    onHttpStatus: (status) => httpStatus = status,
    onProbeText: (text) => probeText = text,
  );
  record({'result': 'started', 'requestAttempted': true});
  final watch = Stopwatch()..start();
  try {
    if (probe) {
      final receipt = await protocol.testConnection(key);
      record({
        'result': 'success',
        'requestAttempted': true,
        'httpStatus': httpStatus,
        'model': receipt.model,
        'elapsedMs': receipt.elapsed.inMilliseconds,
        'usage': receipt.usage,
        'hasModelText': probeText?.isNotEmpty == true,
      });
      showText(probeText!);
      stdout.writeln(
        '仅此开发测试收到真实响应；elapsedMs=${receipt.elapsed.inMilliseconds}; usage=${receipt.usage}',
      );
    } else {
      final body = StringBuffer();
      String? finish;
      var usage = <String, int>{};
      await for (final event in protocol.streamMessages(
        key,
        [
          {'role': 'system', 'content': 'Return JSON only: {"ok":true}.'},
          {'role': 'user', 'content': 'Connection test.'},
        ],
        cancelToken: CancelToken(),
        maxOutput: 120,
      )) {
        final choices = event['choices'];
        if (choices is List && choices.isNotEmpty && choices.first is Map) {
          final choice = choices.first as Map;
          if (choice['delta'] is Map && choice['delta']['content'] is String) {
            body.write(choice['delta']['content']);
          }
          if (choice['finish_reason'] is String) {
            finish = choice['finish_reason'] as String;
          }
        }
        if (body.length > 4000) throw const DeepSeekFailure('流式响应过大，已停止。');
        if (event['usage'] != null) {
          usage = DeepSeekHttpProtocol.readUsage(event['usage']);
        }
      }
      if (finish != 'stop' || jsonDecode(body.toString()) is! Map) {
        throw const FormatException();
      }
      record({
        'result': 'success',
        'requestAttempted': true,
        'httpStatus': httpStatus,
        'elapsedMs': watch.elapsedMilliseconds,
        'usage': usage,
        'hasModelText': true,
      });
      showText(body.toString());
      stdout.writeln(
        '仅此开发测试收到真实 SSE/JSON；elapsedMs=${watch.elapsedMilliseconds}; usage=$usage',
      );
    }
    stdout.writeln('HTTP ${httpStatus?.toString() ?? '未知'}');
  } catch (e) {
    final failure = e is FormatException
        ? '模型输出格式异常。'
        : DeepSeekErrorHandler.sanitize(e).message;
    record({
      'result': 'failed',
      'requestAttempted': true,
      'httpStatus': httpStatus,
      'elapsedMs': watch.elapsedMilliseconds,
      'error': failure,
    });
    stderr.writeln(
      '${httpStatus == null ? '未取得 HTTP 状态' : 'HTTP $httpStatus'} · $failure',
    );
    exitCode = 1;
  } finally {
    key = null;
    protocol.close();
  }
}
