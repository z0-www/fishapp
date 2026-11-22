// V0.4.8 local verification tool. Not part of the mobile composition root.
//
// Rules enforced here:
//  * the key is read from stdin only (never argv, environment, files or flags);
//  * at most one paid request per invocation, and only after --confirm-cost;
//  * the report contains sanitized status/model/usage and a short text preview,
//    and never the key or request headers.
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_error_handler.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_http_protocol.dart';

const _version = '0.4.9';
const _endpoint = 'https://api.deepseek.com';

Future<void> main(List<String> args) async {
  final modes = [
    if (args.contains('--models')) 'models',
    if (args.contains('--probe')) 'probe',
    if (args.contains('--stream')) 'stream',
    if (args.contains('--story')) 'story',
  ];
  final known = {
    '--models',
    '--probe',
    '--stream',
    '--story',
    '--confirm-cost',
    '--yes',
  };
  final reports = args.where((a) => a.startsWith('--report=')).toList();
  final unknown = args.where(
    (a) => !known.contains(a) && !a.startsWith('--report='),
  );
  if (modes.length != 1 ||
      unknown.isNotEmpty ||
      reports.length > 1 ||
      reports.any((a) => a == '--report=')) {
    stderr.writeln(
      '用法：dart run tool/deepseek_verify.dart '
      '(--models | --probe | --stream | --story) [--confirm-cost] [--yes] '
      '[--report=路径]',
    );
    exitCode = 2;
    return;
  }
  final mode = modes.single;
  if (mode == 'story' && !stdin.hasTerminal) {
    stderr.writeln('连续剧情测试需要交互式终端逐次确认费用。');
    exitCode = 2;
    return;
  }
  final paid = mode != 'models' && mode != 'story';
  final preConfirmed = args.contains('--confirm-cost');
  final pipedConsent = args.contains('--yes');
  final reportFile = reports.isEmpty
      ? null
      : File(reports.single.substring('--report='.length));

  final result = <String, Object?>{
    'tool': 'deepseek_verify',
    'version': _version,
    'mode': mode,
    'endpoint': _endpoint,
    'startedAt': DateTime.now().toIso8601String(),
    'requestAttempted': false,
    'result': 'not_started',
  };
  void writeReport() {
    try {
      reportFile
        ?..parent.createSync(recursive: true)
        ..writeAsStringSync(const JsonEncoder.withIndent('  ').convert(result));
    } catch (e) {
      stderr.writeln('无法写入报告文件（不影响请求结果）。');
    }
  }

  if (paid && !preConfirmed) {
    if (!stdin.hasTerminal) {
      stderr.writeln('未执行：付费模式需要 --confirm-cost。');
      result['result'] = 'refused';
      writeReport();
      exitCode = 2;
      return;
    }
    stdout.writeln(
      '将发出一次 DeepSeek 付费请求（${mode == 'probe' ? '非流式，输出上限 8 Token' : '流式 JSON，输出上限 200 Token'}）。输入 YES 继续：',
    );
    if (stdin.readLineSync() != 'YES') {
      result['result'] = 'cancelled';
      writeReport();
      stdout.writeln('已取消，0 次请求。');
      return;
    }
  }

  String? key;
  try {
    if (pipedConsent) {
      key = stdin.readLineSync()?.trim();
    } else {
      final interactive = stdin.hasTerminal;
      if (interactive) stdout.write('API Key（隐藏输入，不保存）：');
      final previousEcho = stdin.echoMode;
      try {
        if (interactive) stdin.echoMode = false;
        key = stdin.readLineSync()?.trim();
      } finally {
        if (interactive) {
          stdin.echoMode = previousEcho;
          stdout.writeln();
        }
      }
    }
    if (key == null || !RegExp(r'^[\x21-\x7E]{8,512}$').hasMatch(key)) {
      result['result'] = 'invalid_local_key';
      writeReport();
      stderr.writeln('未执行：密钥格式无效。');
      exitCode = 2;
      return;
    }
    if (mode == 'story') {
      await _story(key, result, writeReport);
    } else {
      await _run(mode, key, result, writeReport);
    }
  } finally {
    key = null;
  }
  if (result['result'] != 'success') exitCode = 1;
}

Future<void> _run(
  String mode,
  String key,
  Map<String, Object?> result,
  void Function() writeReport,
) async {
  int? httpStatus;
  final protocol = DeepSeekHttpProtocol(
    onHttpStatus: (status) => httpStatus = status,
  );
  final watch = Stopwatch()..start();
  result['requestAttempted'] = true;
  try {
    if (mode == 'models') {
      final ids = await protocol.listModels(key);
      result
        ..['httpStatus'] = httpStatus
        ..['models'] = ids
        ..['result'] = ids.isEmpty ? 'failed' : 'success';
      stdout.writeln(
        '${httpStatus == null ? 'HTTP 未知' : 'HTTP $httpStatus'} · '
        '模型 ${ids.join(', ')}',
      );
      return;
    }
    if (mode == 'probe') {
      final receipt = await protocol.testConnection(key);
      result
        ..['httpStatus'] = httpStatus
        ..['model'] = receipt.model
        ..['usage'] = receipt.usage
        ..['hasModelText'] = true
        ..['elapsedMs'] = receipt.elapsed.inMilliseconds
        ..['result'] = 'success';
      stdout.writeln(
        'HTTP $httpStatus · ${receipt.model} · ${receipt.elapsed.inMilliseconds} ms · '
        'usage=${receipt.usage}',
      );
      return;
    }
    // stream: the same SSE + JSON + usage path the roleplay engine uses.
    final body = StringBuffer();
    String? finish;
    String? model;
    var usage = <String, int>{};
    await for (final event in protocol.streamMessages(
      key,
      [
        {
          'role': 'system',
          'content':
              '你是文字角色扮演引擎。只返回 JSON 对象：'
              '{"narration":"一句话可见场景","replies":[],"proposal":{"minutes":1,"npcMoves":[]}}。'
              '不要输出 JSON 以外的任何内容。',
        },
        {'role': 'user', 'content': '玩家推门走进雨夜的茶馆。'},
      ],
      cancelToken: CancelToken(),
      maxOutput: 200,
    )) {
      final rawModel = event['model'];
      if (rawModel is String) model = rawModel;
      final choices = event['choices'];
      if (choices is List && choices.isNotEmpty && choices.first is Map) {
        final choice = choices.first as Map;
        final delta = choice['delta'];
        if (delta is Map && delta['content'] is String) {
          body.write(delta['content']);
        }
        if (choice['finish_reason'] is String) {
          finish = choice['finish_reason'] as String;
        }
      }
      if (event['usage'] != null) {
        usage = DeepSeekHttpProtocol.readUsage(event['usage']);
      }
    }
    final text = body.toString();
    Object? parsed;
    var jsonValid = false;
    try {
      parsed = jsonDecode(text);
      jsonValid = parsed is Map && parsed['narration'] is String;
    } catch (_) {
      jsonValid = false;
    }
    result
      ..['httpStatus'] = httpStatus
      ..['model'] = model
      ..['usage'] = usage
      ..['finishReason'] = finish
      ..['hasModelText'] = text.trim().isNotEmpty
      ..['jsonValid'] = jsonValid
      ..['textPreview'] = _preview(text, key)
      ..['elapsedMs'] = watch.elapsedMilliseconds;
    if (finish != 'stop') {
      result
        ..['result'] = 'failed'
        ..['error'] = DeepSeekHttpProtocol.finishIssue(finish);
      stderr.writeln('未正常结束：finish_reason=$finish');
      return;
    }
    if (text.trim().isEmpty) {
      result
        ..['result'] = 'failed'
        ..['error'] = '模型返回空内容。';
      return;
    }
    result['result'] = 'success';
    stdout.writeln(
      'HTTP $httpStatus · ${model ?? '未知模型'} · ${watch.elapsedMilliseconds} ms · '
      'usage=$usage · jsonValid=$jsonValid',
    );
    stdout.writeln('模型正文预览：${result['textPreview']}');
  } catch (e) {
    final failure = e is DeepSeekFailure ? e : DeepSeekErrorHandler.sanitize(e);
    result
      ..['httpStatus'] = httpStatus
      ..['elapsedMs'] = watch.elapsedMilliseconds
      ..['result'] = 'failed'
      ..['error'] = failure.message;
    stderr.writeln(
      '${httpStatus == null ? '未取得 HTTP 状态' : 'HTTP $httpStatus'} · ${failure.message}',
    );
  } finally {
    protocol.close();
    writeReport();
  }
}

/// Removes control characters and the key itself, then bounds the preview.
String _preview(String text, String key) {
  var safe = text.replaceAll(key, '[已隐藏]');
  safe = safe.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), ' ');
  final flat = safe.replaceAll(RegExp(r'\s+'), ' ').trim();
  return flat.length <= 400 ? flat : '${flat.substring(0, 400)}…';
}

Future<void> _story(
  String key,
  Map<String, Object?> report,
  void Function() writeReport,
) async {
  const actions = [
    '我推开茶馆的门，问今天是谁寄来一只刻着月亮的木盒。',
    '我观察她收起木盒的动作，问她以前是否见过这个刻痕。',
    '我把木盒推回她面前，告诉她我愿意听原因。',
    '我问她钟楼为什么停摆，等她回答。',
    '我走到窗边看看钟楼，再问她想带什么出门。',
    '我提议从平常送茶的巷子绕到钟楼，她会同行吗？',
    '我记下木盒刻痕的方向，问她是否记得寄件人。',
    '我问起她为何如此在意旧钟楼。',
    '我提出先去查寄件人，然后回来归还木盒。',
    '我问她是否还记得我刚进门时的第一个问题。',
  ];
  final messages = <Map<String, String>>[
    {
      'role': 'system',
      'content': '雨夜的蓝灯茶馆。店主梁砚惜字如金，谨慎而重情。玩家是外地钟表匠。保持人物独立性，不替玩家决定。用中文返回 JSON，含 narration 字符串和 replies 列表，回复保持简短。',
    },
  ];
  final receipts = <Map<String, Object?>>[];
  report['receipts'] = receipts;
  int? httpStatus;
  String? probeText;
  final protocol = DeepSeekHttpProtocol(
    onHttpStatus: (status) => httpStatus = status,
    onProbeText: (value) => probeText = value,
  );
  try {
    for (var number = 0; number <= actions.length; number++) {
      final probe = number == 0;
      final label = probe ? '连通测试' : '剧情第 $number 轮';
      final maxOutput = probe ? 8 : 200;
      final inputEstimate = probe
          ? 32
          : utf8.encode(messages.map((m) => m['content']).join()).length +
                utf8.encode(actions[number - 1]).length +
                64;
      final estimatedUsd = ((inputEstimate * 0.30 + maxOutput * 1.20) / 1000000)
          .toStringAsFixed(6);
      stdout.writeln(
        '$label · deepseek-flash · 预估输入 $inputEstimate Token · 最大输出 '
        '$maxOutput Token · 预计费用（非严格上限）USD $estimatedUsd',
      );
      stdout.write('输入 YES 确认这一笔请求，其他输入结束：');
      if (stdin.readLineSync() != 'YES') {
        report['result'] = 'stopped_by_user';
        break;
      }
      final row = <String, Object?>{'step': number};
      receipts.add(row);
      report['requestAttempted'] = true;
      httpStatus = null;
      final watch = Stopwatch()..start();
      try {
        if (probe) {
          final response = await protocol.testConnection(key);
          row
            ..['model'] = response.model
            ..['usage'] = response.usage
            ..['textPreview'] = _preview(probeText ?? '', key);
        } else {
          messages.add({'role': 'user', 'content': actions[number - 1]});
          final body = StringBuffer();
          String? finish;
          await for (final event in protocol.streamMessages(
            key,
            messages,
            cancelToken: CancelToken(),
            maxOutput: maxOutput,
          )) {
            if (event['model'] is String) row['model'] = event['model'];
            if (event['usage'] != null) {
              row['usage'] = DeepSeekHttpProtocol.readUsage(event['usage']);
            }
            final choices = event['choices'];
            if (choices is! List || choices.isEmpty) continue;
            final choice = choices.first;
            if (choice is! Map) continue;
            final delta = choice['delta'];
            if (delta is Map && delta['content'] is String) {
              body.write(delta['content']);
            }
            if (choice['finish_reason'] case final String reason) {
              finish = reason;
            }
          }
          row['finishReason'] = finish;
          if (finish != 'stop') {
            throw DeepSeekFailure(
              DeepSeekHttpProtocol.finishIssue(finish) ?? '模型生成未正常结束。',
            );
          }
          final response = body.toString();
          final json = jsonDecode(response);
          if (json is! Map ||
              json['narration'] is! String ||
              json['replies'] is! List) {
            throw const DeepSeekFailure('模型剧情 JSON 结构异常。');
          }
          row['textPreview'] = _preview(response, key);
          messages.add({'role': 'assistant', 'content': response});
        }
        row['result'] = 'success';
        report['result'] = number == actions.length ? 'success' : 'partial';
      } catch (error) {
        row['result'] = 'failed';
        row['error'] = error is FormatException
            ? '模型剧情 JSON 无法解析。'
            : DeepSeekErrorHandler.sanitize(error).message;
        report['result'] = 'failed';
      } finally {
        row
          ..['httpStatus'] = httpStatus
          ..['elapsedMs'] = watch.elapsedMilliseconds;
        writeReport();
        stdout.writeln(jsonEncode(row));
      }
      if (row['result'] == 'failed') break;
    }
  } finally {
    protocol.close();
    writeReport();
  }
}
