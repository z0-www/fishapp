import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';

import 'models.dart';

const _maxSessions = 200;
const _maxMessages = 50000;
const _maxTextBytes = 32 * 1024 * 1024;
const _maxMessageBytes = 2 * 1024 * 1024;

const _roleAliases = <String, String>{
  'user': 'user',
  'human': 'user',
  'you': 'user',
  'me': 'user',
  '用户': 'user',
  '玩家': 'user',
  '我': 'user',
  'assistant': 'assistant',
  'ai': 'assistant',
  'bot': 'assistant',
  'model': 'assistant',
  'chatgpt': 'assistant',
  'deepseek': 'assistant',
  '助手': 'assistant',
  '模型': 'assistant',
  '系统': 'system',
  'system': 'system',
  'developer': 'system',
  'tool': 'tool',
  'function': 'tool',
  '工具': 'tool',
};

final _credentialPattern = RegExp(
  r'(sk-[A-Za-z0-9_-]{20,}|Bearer\s+[A-Za-z0-9_-]{16,})',
);

String normalizeRole(Object? value) {
  final role = value?.toString().trim().toLowerCase() ?? '';
  return _roleAliases[role] ?? 'unknown';
}

bool containsCredential(String value) => _credentialPattern.hasMatch(value);

/// Detects the format from bytes/structure, never from the file extension.
ParseResult parseConversationFile(String fileName, Uint8List bytes) {
  if (bytes.isEmpty) {
    throw const ConversionException('文件为空。');
  }
  if (bytes.length > _maxTextBytes) {
    throw const ConversionException('文件超过 32 MiB，转换器不支持这么大的单文件。');
  }
  if (_isZip(bytes)) return _parseZip(fileName, bytes);
  final text = _decodeText(bytes);
  final trimmed = text.trimLeft();
  if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
    return _parseJson(fileName, text);
  }
  return _parseMarkdown(fileName, text);
}

bool _isZip(Uint8List bytes) =>
    bytes.length >= 4 && bytes[0] == 0x50 && bytes[1] == 0x4b;

String _decodeText(Uint8List bytes) {
  try {
    var text = utf8.decode(bytes);
    if (text.startsWith('\ufeff')) text = text.substring(1);
    return text;
  } on FormatException {
    throw const ConversionException('文件不是有效的 UTF-8 文本；转换器不会猜测编码。');
  }
}

ParseResult _parseJson(String fileName, String text) {
  Object? root;
  try {
    root = jsonDecode(text);
  } on FormatException {
    throw const ConversionException('文件看起来是 JSON，但无法解析；原始文件未被修改。');
  }
  final sessions = <ConvertSession>[];
  final warnings = <String>[];
  _collectSessions(root, fileName, sessions, warnings);
  if (sessions.isEmpty) {
    throw const ConversionException(
      '没有识别到包含 messages 的对话结构。请确认这是 Chatbox/DeepSeek 的对话导出，而不是设置备份。',
    );
  }
  final format = _jsonFormat(root);
  return ParseResult(
    format: format,
    sessions: [
      for (final session in sessions)
        ConvertSession(
          id: session.id,
          title: session.title,
          format: format,
          sourceName: session.sourceName,
          messages: session.messages,
          model: session.model,
          createdAt: session.createdAt,
          warnings: session.warnings,
        ),
    ],
    warnings: warnings,
  );
}

String _jsonFormat(Object? root) {
  if (root is Map) {
    if (root['format'] == 'chatbox-backup') return 'Chatbox 备份 JSON';
    if (root.containsKey('chat-sessions-list')) return 'Chatbox JSON（旧版）';
    if (root.containsKey('sessions')) return 'Chatbox JSON';
    if (root.containsKey('chats')) return 'Chatbox JSON';
    if (root.containsKey('conversations')) return 'JSON 对话';
  }
  return 'JSON 对话';
}

void _collectSessions(
  Object? node,
  String fileName,
  List<ConvertSession> output,
  List<String> warnings, {
  int depth = 0,
}) {
  if (node == null || depth > 6) return;
  if (node is List) {
    if (node.isEmpty) return;
    if (node.every((e) => e is Map && e.containsKey('messages'))) {
      for (final item in node) {
        _addSession(item as Map, fileName, output, warnings);
      }
      return;
    }
    if (node.every((e) => e is Map && (e.containsKey('role') || e.containsKey('content')))) {
      _addSession({'messages': node}, fileName, output, warnings);
      return;
    }
    for (final item in node) {
      _collectSessions(item, fileName, output, warnings, depth: depth + 1);
    }
    return;
  }
  if (node is! Map) return;
  final messages = node['messages'];
  if (messages is List) {
    _addSession(node, fileName, output, warnings);
    return;
  }
  var foundContainer = false;
  for (final key in const [
    'sessions',
    'chats',
    'conversations',
    'data',
    'backup',
    'items',
    'chat',
    'session',
  ]) {
    if (node.containsKey(key)) {
      foundContainer = true;
      _collectSessions(node[key], fileName, output, warnings, depth: depth + 1);
    }
  }
  if (!foundContainer) {
    // Some exports use an object keyed by session id instead of an array.
    for (final value in node.values) {
      if (value is Map && value['messages'] is List) {
        _addSession(value, fileName, output, warnings);
      }
    }
  }
}

void _addSession(
  Map raw,
  String fileName,
  List<ConvertSession> output,
  List<String> warnings,
) {
  if (output.length >= _maxSessions) {
    throw const ConversionException('会话数量超过 200 个，请拆分文件后再转换。');
  }
  final session = raw.cast<String, dynamic>();
  final messagesRaw = session['messages'];
  if (messagesRaw is! List) return;
  final title = _firstString(session, const ['title', 'name', 'topic', 'subject'])?.trim();
  final id = _firstString(session, const ['id', 'sessionId', 'uuid']) ??
      sha1.convert(utf8.encode('$fileName|${output.length}|$title')).toString();
  final model = _firstString(session, const ['model']) ??
      _nestedString(session['settings'], 'model');
  final createdAt = _firstValueString(session, const [
    'createdAt',
    'created_at',
    'timestamp',
    'updatedAt',
    'updated_at',
  ]);
  final sessionWarnings = <String>[];
  final parsed = <ConvertMessage>[];
  for (var index = 0; index < messagesRaw.length; index++) {
    if (index >= _maxMessages) {
      throw const ConversionException('单文件消息数超过 50000 条，请拆分后再转换。');
    }
    final rawMessage = messagesRaw[index];
    if (rawMessage is! Map) {
      sessionWarnings.add('第 ${index + 1} 条消息不是对象，已跳过；原始文件未修改。');
      continue;
    }
    final map = rawMessage.cast<String, dynamic>();
    final role = normalizeRole(_firstValue(map, const ['role', 'author', 'from', 'sender']));
    if (role == 'unknown') {
      sessionWarnings.add('第 ${index + 1} 条消息缺少可识别角色，已标记为 unknown。');
    }
    final contentResult = _contentOf(map, index, sessionWarnings);
    if (contentResult.content.length > _maxMessageBytes) {
      throw ConversionException('第 ${index + 1} 条消息超过 2 MiB，未转换。');
    }
    if (containsCredential(contentResult.content)) {
      throw const ConversionException(
        '对话正文包含疑似 API Key；为避免把密钥写进归档，转换已停止。请先移除密钥。',
      );
    }
    final originalId = _firstString(map, const ['id', 'messageId', 'message_id', 'uuid']);
    final parentRaw = _firstString(map, const ['parentId', 'parent_id', 'parent']);
    parsed.add(
      ConvertMessage(
        id: 'm-${(index + 1).toString().padLeft(6, '0')}',
        role: role,
        content: contentResult.content,
        rawJson: jsonEncode(map),
        parentId: parentRaw,
        timestamp: _firstValueString(map, const [
          'timestamp',
          'createdAt',
          'created_at',
          'time',
        ]),
        model: _firstString(map, const ['model']) ?? model,
        originalId: originalId,
      ),
    );
    if (contentResult.attachmentCount > 0) {
      sessionWarnings.add(
        '第 ${index + 1} 条消息含 ${contentResult.attachmentCount} 个图片/附件，转换器不包含二进制内容。',
      );
    }
    if (contentResult.reasoningSkipped) {
      sessionWarnings.add('第 ${index + 1} 条消息的 reasoning/thinking 未加入正文（不是对话正文）。');
    }
    if (contentResult.toolSkipped) {
      sessionWarnings.add('第 ${index + 1} 条消息含工具调用；工具参数未转换，消息保留为空正文。');
    }
  }
  if (parsed.isEmpty) {
    warnings.add('已跳过空会话：${title ?? '未命名'}');
    return;
  }
  final threads = session['threads'];
  if (threads is List && threads.isNotEmpty) {
    var threadMessages = 0;
    for (final thread in threads) {
      if (thread is Map && thread['messages'] is List) {
        threadMessages += (thread['messages'] as List).length;
      }
    }
    sessionWarnings.add(
      '会话含 ${threads.length} 个历史线程、$threadMessages 条历史消息；'
      '转换器只保留当前消息时间线，未合并历史分支（避免错误排序）。',
    );
  }
  if (title == null || title.isEmpty) {
    sessionWarnings.add('会话没有标题，使用“Chatbox 对话”作为默认标题。');
  }
  output.add(
    ConvertSession(
      id: id,
      title: (title == null || title.trim().isEmpty) ? 'Chatbox 对话' : title,
      format: 'Chatbox JSON',
      sourceName: fileName,
      messages: parsed,
      model: model,
      createdAt: createdAt,
      warnings: sessionWarnings,
    ),
  );
}

class _ContentResult {
  const _ContentResult(
    this.content, {
    this.attachmentCount = 0,
    this.reasoningSkipped = false,
    this.toolSkipped = false,
  });
  final String content;
  final int attachmentCount;
  final bool reasoningSkipped;
  final bool toolSkipped;
}

_ContentResult _contentOf(
  Map<String, dynamic> message,
  int index,
  List<String> warnings,
) {
  var attachments = 0;
  var reasoning = false;
  var tool = false;
  for (final key in const ['attachments', 'files', 'images', 'links']) {
    final value = message[key];
    if (value is List) attachments += value.length;
  }
  if (message['reasoning'] is String &&
      (message['reasoning'] as String).trim().isNotEmpty) {
    reasoning = true;
  }
  if (message['tool_calls'] is List && (message['tool_calls'] as List).isNotEmpty ||
      message['toolCalls'] is List && (message['toolCalls'] as List).isNotEmpty) {
    tool = true;
  }

  final content = message['content'] ?? message['text'] ?? message['body'];
  if (content is String) return _ContentResult(content, attachmentCount: attachments, reasoningSkipped: reasoning, toolSkipped: tool);

  // Chatbox v1/v2 store visible text in contentParts, not `content`.
  final contentParts = message['contentParts'];
  if (contentParts is List) {
    final parts = <String>[];
    for (final part in contentParts) {
      if (part is String) {
        parts.add(part);
      } else if (part is Map) {
        final type = part['type']?.toString();
        if (const ['text', 'input_text', 'output_text'].contains(type)) {
          final text = part['text'];
          if (text is String) parts.add(text);
        } else if (type == 'image' || type == 'image_url') {
          attachments++;
        } else if (type == 'file' || type == 'link') {
          attachments++;
        } else if (type == 'tool_use' || type == 'tool_result') {
          tool = true;
        }
      }
    }
    return _ContentResult(
      parts.join('\n'),
      attachmentCount: attachments,
      reasoningSkipped: reasoning,
      toolSkipped: tool,
    );
  }

  if (content is List) {
    final parts = <String>[];
    for (final part in content) {
      if (part is String) {
        parts.add(part);
      } else if (part is Map) {
        final type = part['type']?.toString();
        if (const ['text', 'input_text', 'output_text'].contains(type)) {
          final text = part['text'];
          if (text is String) parts.add(text);
        } else if (type == 'image' || type == 'image_url') {
          attachments++;
        } else if (type == 'tool_use' || type == 'tool_result') {
          tool = true;
        }
      }
    }
    return _ContentResult(parts.join('\n'), attachmentCount: attachments, reasoningSkipped: reasoning, toolSkipped: tool);
  }
  if (content is Map && content['text'] is String) {
    return _ContentResult(content['text'] as String, attachmentCount: attachments, reasoningSkipped: reasoning, toolSkipped: tool);
  }
  // DeepSeek official export stores visible text in fragments.
  final fragments = message['fragments'];
  if (fragments is List) {
    final parts = <String>[];
    for (final fragment in fragments) {
      if (fragment is! Map) continue;
      final type = fragment['type']?.toString();
      if (type == 'REQUEST' || type == 'RESPONSE') {
        final text = fragment['content'] ?? fragment['text'];
        if (text is String) parts.add(text);
      } else if (type == 'THINK' || type == 'REASONING') {
        reasoning = true;
      } else if (type == 'FILE') {
        attachments++;
      }
    }
    return _ContentResult(parts.join('\n'), attachmentCount: attachments, reasoningSkipped: reasoning, toolSkipped: tool);
  }
  warnings.add('第 ${index + 1} 条消息没有可读正文。');
  return _ContentResult('', attachmentCount: attachments, reasoningSkipped: reasoning, toolSkipped: tool);
}

Object? _firstValue(Map map, List<String> keys) {
  for (final key in keys) {
    if (map.containsKey(key) && map[key] != null) return map[key];
  }
  return null;
}

String? _firstString(Map map, List<String> keys) {
  final value = _firstValue(map, keys);
  return value is String && value.trim().isNotEmpty ? value : null;
}

String? _firstValueString(Map map, List<String> keys) {
  final value = _firstValue(map, keys);
  if (value == null) return null;
  if (value is String) return value;
  if (value is num) return value.toString();
  return value.toString();
}

String? _nestedString(Object? object, String key) {
  if (object is Map && object[key] is String) return object[key] as String;
  return null;
}

ParseResult _parseZip(String fileName, Uint8List bytes) {
  late Archive archive;
  try {
    archive = ZipDecoder().decodeBytes(bytes, verify: true);
  } catch (_) {
    throw const ConversionException('ZIP 损坏或不是标准 ZIP 文件；原始文件未被修改。');
  }
  if (archive.files.length > 5000) {
    throw const ConversionException('ZIP 条目超过 5000 个，已停止。');
  }
  final sessions = <ConvertSession>[];
  final warnings = <String>[];
  var deepSeek = false;
  var chatbox = false;
  var total = 0;
  final jsonFiles = <String, Map<String, dynamic>>{};
  for (final file in archive.files) {
    if (!file.isFile || !file.name.toLowerCase().endsWith('.json')) continue;
    if (file.size > 8 * 1024 * 1024) {
      warnings.add('跳过超过 8 MiB 的 JSON：${file.name}');
      continue;
    }
    final data = file.readBytes();
    if (data == null) continue;
    total += data.length;
    if (total > 64 * 1024 * 1024) {
      throw const ConversionException('ZIP 解压后的 JSON 超过 64 MiB，已停止。');
    }
    Object? decoded;
    try {
      decoded = jsonDecode(utf8.decode(data));
    } catch (_) {
      continue;
    }
    if (decoded is Map<String, dynamic>) jsonFiles[file.name] = decoded;
    if (decoded is Map && decoded['format'] == 'chatbox-backup') chatbox = true;
    if (decoded is Map && decoded['export_format_version'] == 3) deepSeek = true;
  }
  for (final entry in jsonFiles.entries) {
    if (entry.key == 'manifest.json' || entry.key.endsWith('index.json')) continue;
    _collectSessions(entry.value, fileName, sessions, warnings);
  }
  if (sessions.isEmpty) {
    throw const ConversionException(
      'ZIP 中没有识别到会话消息。若是 Chatbox 备份，请确认选择的是聊天记录而不是设置/资源包。',
    );
  }
  final format = deepSeek
      ? 'DeepSeek 官方导出 ZIP'
      : chatbox
      ? 'Chatbox 备份 ZIP'
      : 'ZIP JSON 对话';
  for (var i = 0; i < sessions.length; i++) {
    final session = sessions[i];
    sessions[i] = ConvertSession(
      id: session.id,
      title: session.title,
      format: format,
      sourceName: fileName,
      messages: session.messages,
      model: session.model,
      createdAt: session.createdAt,
      warnings: session.warnings,
    );
  }
  return ParseResult(format: format, sessions: sessions, warnings: warnings);
}

String? _basenameWithoutExtension(String name) {
  final base = name.replaceAll('\\', '/').split('/').last;
  final dot = base.lastIndexOf('.');
  return dot > 0 ? base.substring(0, dot) : base;
}

ParseResult _parseMarkdown(String fileName, String text) {
  final lines = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n').split('\n');
  final sessions = <ConvertSession>[];
  final warnings = <String>[];
  var currentTitle = _basenameWithoutExtension(fileName) ?? 'Markdown 对话';
  var titleFromFile = true;
  var current = <ConvertMessage>[];
  String? role;
  StringBuffer? body;
  var inFence = false;
  var index = 0;
  var preface = <String>[];
  var prefaceUsed = false;

  void flush() {
    if (role == null || body == null) return;
    final textBody = body.toString().trim();
    current.add(
      ConvertMessage(
        id: 'm-${(current.length + 1).toString().padLeft(6, '0')}',
        role: role!,
        content: textBody,
        rawJson: jsonEncode({'format': 'markdown', 'role': role, 'line': index}),
      ),
    );
    role = null;
    body = null;
  }

  void flushSession() {
    flush();
    if (current.isEmpty) return;
    sessions.add(
      ConvertSession(
        id: sha1.convert(utf8.encode('$fileName|$currentTitle|${sessions.length}')).toString(),
        title: currentTitle,
        format: 'Chatbox Markdown',
        sourceName: fileName,
        messages: current,
        warnings: [
          if (titleFromFile) '未找到 Markdown 标题，使用文件名作为会话标题。',
        ],
      ),
    );
    current = <ConvertMessage>[];
  }

  String? matchRole(String line, {bool allowHeading = true}) {
    final colon = RegExp(
      r'^\s{0,3}(?:#{2,4}\s+)?(?:\*\*|__)?\s*(用户|玩家|我|User|Human|You|Assistant|AI|Bot|ChatGPT|DeepSeek|助手|模型|System|系统)\s*(?:\*\*|__)?\s*[:：]\s*(.*)$',
      caseSensitive: false,
    ).firstMatch(line);
    if (colon != null) return colon.group(1);
    if (!allowHeading) return null;
    final heading = RegExp(
      r'^\s{0,3}(?:#{2,4}\s+|\*\*|__)\s*(用户|玩家|我|User|Human|You|Assistant|AI|Bot|ChatGPT|DeepSeek|助手|模型|System|系统)\s*(?:\*\*|__)?\s*$',
      caseSensitive: false,
    ).firstMatch(line);
    return heading?.group(1);
  }

  String restAfterRole(String line) {
    var rest =
        (RegExp(r'[:：]\s*(.*)$', caseSensitive: false).firstMatch(line)?.group(1) ??
                '')
            .trim();
    rest = rest.replaceFirst(RegExp(r'^(\*\*|__)\s*'), '').trim();
    return rest;
  }

  // Chatbox Markdown often uses an H1 export title and H2 session titles.
  // Do not mistake "## User"/"## Assistant" role headings for session titles.
  final headingLines = <int, List<String>>{1: [], 2: []};
  for (final line in lines) {
    final heading = RegExp(r'^\s{0,3}(#{1,4})\s+(.+?)\s*$').firstMatch(line);
    if (heading == null) continue;
    final level = heading.group(1)!.length;
    if (level > 2) continue;
    final title = heading.group(2)!.trim();
    if (title.isEmpty || matchRole(line, allowHeading: false) != null) continue;
    if (RegExp(
          r'^(用户|玩家|我|User|Human|You|Assistant|AI|Bot|ChatGPT|DeepSeek|助手|模型|System|系统)$',
          caseSensitive: false,
        ).hasMatch(title.replaceAll(RegExp(r'[*_`]'), '').trim())) {
      continue;
    }
    headingLines[level]!.add(title);
  }
  final h1 = headingLines[1]!;
  final h2 = headingLines[2]!;
  final int sessionLevel;
  if (h1.length >= 2) {
    sessionLevel = 1;
  } else if (h2.isNotEmpty && h1.length <= 1) {
    sessionLevel = 2;
  } else if (h1.length == 1) {
    sessionLevel = 1;
  } else {
    sessionLevel = 0;
  }
  final sessionHeading = sessionLevel == 0
      ? null
      : RegExp(
          '^\\s{0,3}#{$sessionLevel}\\s+(.+?)\\s*\$',
        );

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    index = i + 1;
    if (line.trimLeft().startsWith('```')) {
      inFence = !inFence;
    }
    if (!inFence) {
      final heading = sessionHeading?.firstMatch(line);
      if (heading != null && matchRole(line, allowHeading: false) == null) {
        final title = heading.group(1)!.trim();
        if (title.isNotEmpty &&
            !RegExp(
              r'^(用户|玩家|我|User|Human|You|Assistant|AI|Bot|ChatGPT|DeepSeek|助手|模型|System|系统)$',
              caseSensitive: false,
            ).hasMatch(title.replaceAll(RegExp(r'[*_`]'), '').trim())) {
          flushSession();
          currentTitle = title;
          titleFromFile = false;
          continue;
        }
      }
      final found = matchRole(line);
      if (found != null) {
        flush();
        role = normalizeRole(found);
        body = StringBuffer();
        final rest = restAfterRole(line);
        if (rest.isNotEmpty) body!.writeln(rest);
        if (preface.isNotEmpty && !prefaceUsed) {
          prefaceUsed = true;
          warnings.add('首个角色标记前的 ${preface.length} 行文本未纳入对话（可能是标题/说明）。');
        }
        continue;
      }
    }
    if (role != null) {
      body!.writeln(line);
    } else if (!inFence && line.trim().isNotEmpty) {
      preface.add(line);
    }
  }
  flushSession();
  if (sessions.isEmpty) {
    throw const ConversionException(
      '未识别到对话角色标记（如 User: / Assistant: / 用户：/ 助手：）。未转换任何内容。',
    );
  }
  return ParseResult(format: 'Chatbox Markdown', sessions: sessions, warnings: warnings);
}
