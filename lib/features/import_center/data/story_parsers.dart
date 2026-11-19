import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';

import '../domain/import_models.dart';

class ConversationNormalizer {
  ConversationDraft text(String text, List<ImportedAttachment> files) {
    final pattern = RegExp(
      r'^[ \t]*(?:#{1,6}[ \t]+)?(?:\*{1,2})?(用户|玩家|提问|User|Human|助手|回答|AI|Assistant|DeepSeek)(?:\*{1,2})?[ \t]*(?:[:：][ \t]*(.*)|\r?$)',
      caseSensitive: false,
      multiLine: true,
    );
    final matches = pattern.allMatches(text).toList();
    final header = matches.isEmpty
        ? ''
        : text.substring(0, matches.first.start).trim();
    if (matches.length < 2 ||
        header.split('\n').length > 2 ||
        header.length > 160) {
      return ConversationDraft(
        title: _title(text),
        messages: [
          ImportedMessage(
            id: '0',
            role: 'unknown',
            content: text,
            rawJson: jsonEncode({'text': text}),
          ),
        ],
        attachments: files,
        warnings: const ['文本未可靠识别发言人，用户与 AI 数量不会猜测。'],
      );
    }
    final messages = <ImportedMessage>[];
    for (final e in matches.indexed) {
      final m = e.$2;
      final end = e.$1 + 1 < matches.length
          ? matches[e.$1 + 1].start
          : text.length;
      final role =
          RegExp(
            r'^(用户|玩家|提问|user|human)$',
            caseSensitive: false,
          ).hasMatch(m[1]!)
          ? 'user'
          : 'assistant';
      messages.add(
        ImportedMessage(
          id: '${e.$1}',
          parentId: e.$1 == 0 ? null : '${e.$1 - 1}',
          role: role,
          content: '${m[2] ?? ''}${text.substring(m.end, end)}'.trim(),
          rawJson: jsonEncode({
            'segment': text.substring(m.start, end),
            'label': m[1],
          }),
        ),
      );
    }
    if (!messages.any((message) => message.content.trim().isNotEmpty)) {
      throw const ImportFailure('只识别到角色标签，未取得对话正文。');
    }
    return ConversationDraft(
      title: _title(text),
      messages: messages,
      attachments: files,
      currentMessageId: messages.last.id,
      warnings: const ['角色按明确标签识别；原始文本在暂存档案中完整保留，请核对标签。'],
    );
  }

  String _title(String s) {
    final t = s.trim().split('\n').first;
    return t.length > 40 ? '${t.substring(0, 40)}…' : t;
  }

  List<T> branch<T>(
    List<T> messages,
    String end,
    String Function(T) id,
    String? Function(T) parent,
  ) {
    final map = {for (final m in messages) id(m): m};
    final output = <T>[], seen = <String>{};
    String? current = end;
    while (current != null) {
      if (!seen.add(current) || !map.containsKey(current)) {
        throw const ImportFailure('消息树存在循环或缺失父节点。');
      }
      final m = map[current] as T;
      output.add(m);
      current = parent(m);
    }
    return output.reversed.toList();
  }
}

class DeepSeekArchiveParser {
  static bool safePath(String name) =>
      name.isNotEmpty &&
      !name.startsWith('/') &&
      !name.contains('\\') &&
      !name.contains(':') &&
      !name.split('/').contains('..') &&
      !name.contains('\u0000');
  static int? _messageNumber(Object? value) {
    if (value is int) return value;
    if (value is! String || !RegExp(r'^[0-9]{1,18}$').hasMatch(value)) {
      return null;
    }
    return int.tryParse(value);
  }

  static bool isSession(Map data) =>
      data['messages'] is List &&
      _messageNumber(data['current_message_id']) != null;

  ConversationDraft session(
    Map<String, dynamic> data, {
    String prefix = '',
    List<ImportedAttachment> attachments = const [],
  }) {
    try {
      if (data['id'] is! String || !isSession(data)) {
        throw const FormatException();
      }
      final raw = data['messages'] as List;
      if (raw.length > 10000) {
        throw const ImportFailure('单个故事消息超过10000条，请分批导入。');
      }
      final ids = <int>{};
      final parsed = <ImportedMessage>[], warnings = <String>{};
      final map = <int, Map<String, dynamic>>{};
      for (final value in raw) {
        final m = Map<String, dynamic>.from(value as Map);
        final id = _messageNumber(m['message_id'] ?? m['id']);
        if (m['message_id'] != null &&
            m['id'] != null &&
            _messageNumber(m['message_id']) != _messageNumber(m['id'])) {
          throw const FormatException();
        }
        if (id == null ||
            id < 0 ||
            !ids.add(id) ||
            !['USER', 'ASSISTANT'].contains(m['role']) ||
            m['fragments'] is! List) {
          throw const FormatException();
        }
        map[id] = m;
      }
      final ordered = map.keys.toList()..sort();
      for (final id in ordered) {
        final m = map[id]!;
        final rawParent = m['parent_id'];
        final parent = _messageNumber(rawParent);
        if (rawParent != null &&
            (parent == null ||
                parent >= id ||
                !map.containsKey(parent) ||
                map[parent]!['role'] == m['role'])) {
          throw const FormatException();
        }
        if (parent == null && m['role'] != 'USER') {
          throw const FormatException();
        }
        final body = <String>[];
        for (final f in m['fragments'] as List) {
          if (f is! Map || f['type'] is! String) throw const FormatException();
          if (f['type'] == (m['role'] == 'USER' ? 'REQUEST' : 'RESPONSE')) {
            if (f['content'] is! String) throw const FormatException();
            body.add(f['content'] as String);
          } else if (![
            'THINK',
            'FILE',
            'TIP',
            'CONTENT_RISK',
            'PARTIAL_FILE_READ',
            'TEMPLATE_RESPONSE',
            'TOOL_SEARCH',
            'TOOL_OPEN',
            'TOOL_FIND',
            'READ_LINK',
            'TOOL_IMAGE_SEARCH',
          ].contains(f['type'])) {
            warnings.add('包含未知内容片段：仅保留原始数据，未将其猜测为正文。');
          }
        }
        if (m['status'] != 'FINISHED') {
          warnings.add('包含中断或未完成消息；状态原样保留，恢复时需审核。');
        }
        parsed.add(
          ImportedMessage(
            id: '$prefix$id',
            parentId: parent == null ? null : '$prefix$parent',
            role: m['role'] == 'USER' ? 'user' : 'assistant',
            content: body.join('\n'),
            rawJson: jsonEncode({
              'session': safeImportMetadata({
                for (final k in data.keys.where((k) => k != 'messages'))
                  k: data[k],
              }),
              'message': safeImportMetadata(m),
            }),
          ),
        );
      }
      final current = _messageNumber(data['current_message_id'])!;
      if (parsed.isNotEmpty && !ids.contains(current)) {
        throw const FormatException();
      }
      final children = <String, int>{};
      for (final m in parsed) {
        if (m.parentId != null) {
          children.update(m.parentId!, (n) => n + 1, ifAbsent: () => 1);
        }
      }
      return ConversationDraft(
        title: data['title'] as String? ?? '未命名导入故事',
        messages: parsed,
        canSave: parsed.any((message) => message.content.trim().isNotEmpty),
        attachments: attachments,
        currentMessageId: parsed.isEmpty ? null : '$prefix$current',
        branches: children.values.where((n) => n > 1).length,
        warnings: warnings.toList(),
      );
    } on ImportFailure {
      rethrow;
    } catch (_) {
      throw const ImportFailure('DeepSeek 会话结构、角色或消息树无效，未写入正式存档。');
    }
  }

  Future<ConversationDraft> parseFile(
    ImportedAttachment file,
    ImportCancellation cancel, {
    bool catalogOnly = false,
    String? selectedSession,
  }) async {
    if (await File(file.path).length() > 64 * 1024 * 1024) {
      throw const ImportFailure('ZIP 超过64MB。');
    }
    cancel.check();
    final result = await Isolate.run(() {
      final input = InputFileStream(file.path);
      try {
        return DeepSeekArchiveParser()._parse(
          input,
          ImportCancellation(),
          source: file,
          catalogOnly: catalogOnly,
          selectedSession: selectedSession,
        );
      } finally {
        input.closeSync();
      }
    });
    cancel.check();
    return result;
  }

  ConversationDraft parseBytes(
    List<int> bytes,
    ImportCancellation cancel, {
    ImportedAttachment? source,
  }) => _parse(InputMemoryStream(bytes), cancel, source: source);

  ConversationDraft _parse(
    InputStream input,
    ImportCancellation cancel, {
    ImportedAttachment? source,
    bool catalogOnly = false,
    String? selectedSession,
  }) {
    try {
      cancel.check();
      if (input.length > 64 * 1024 * 1024) {
        throw const ImportFailure('ZIP 超过64MB。');
      }
      final directory = ZipDirectory();
      final names = <String>{};
      var total = 0, count = 0;
      for (final h in directory.headers(input, files: false, verify: true)) {
        if (++count > 4096 ||
            !safePath(h.filename) ||
            !names.add(h.filename) ||
            (h.generalPurposeBitFlag & 1) != 0 ||
            ((h.externalFileAttributes >> 16) & 0xf000) == 0xa000) {
          throw const ImportFailure('ZIP 包含重复、不安全、加密条目或超过数量限制。');
        }
        total += h.uncompressedSize;
        if (h.uncompressedSize > 16 * 1024 * 1024 ||
            total > 128 * 1024 * 1024 ||
            h.uncompressedSize > (h.compressedSize + 1) * 500) {
          throw const ImportFailure('ZIP 解压后大小或压缩比例超过安全限制。');
        }
      }
      if (count == 0) throw const ImportFailure('ZIP 为空或损坏。');
      input.position = 0;
      final archive = ZipDecoder().decodeStream(
        input,
        verify: true,
        throwOnError: true,
      );
      final files = {
        for (final f in archive.files.where((f) => f.isFile)) f.name: f,
      };
      if (archive.files.first.name != 'manifest.json') {
        throw const ImportFailure('不支持的归档：首个条目必须为 manifest.json。');
      }
      final verified = <String>{};
      List<int> readFile(ArchiveFile file) {
        final bytes = file.readBytes();
        file.clear();
        if (bytes == null || bytes.length != file.size) {
          throw const FormatException();
        }
        verified.add(file.name);
        return bytes;
      }

      Object? read(String n) {
        final file = files[n];
        if (file == null) throw const ImportFailure('归档缺少必需文件。');
        return jsonDecode(utf8.decode(readFile(file)));
      }

      final manifest = read('manifest.json') as Map;
      if (manifest['export_format_version'] != 3) {
        throw const ImportFailure(
          '不支持此 DeepSeek 导出版本；目前支持 export_format_version 3。原文件保留。',
        );
      }
      final index = read('chat_session_index.json') as List;
      final sessions = <ArchiveSession>[];
      final sessionIds = <String>{};
      for (final item in index) {
        if (item is! Map ||
            item['id'] is! String ||
            !RegExp(r'^[A-Za-z0-9_-]{1,128}$').hasMatch(item['id'] as String) ||
            !sessionIds.add(item['id'] as String) ||
            item['message_count'] is! int ||
            (item['message_count'] as int) < 0) {
          throw const FormatException();
        }
        final id = item['id'] as String;
        if (!files.containsKey('chat_sessions/$id.json')) {
          throw const FormatException();
        }
        final title = item['title'];
        sessions.add(
          ArchiveSession(
            id,
            title is String && title.trim().isNotEmpty
                ? String.fromCharCodes(title.runes.take(200))
                : '未命名会话',
            item['message_count'] as int,
          ),
        );
      }
      final actual = files.keys
          .where((k) => RegExp(r'^chat_sessions/[^/]+\.json$').hasMatch(k))
          .length;
      if (sessions.isEmpty || actual != sessions.length) {
        throw const ImportFailure('会话索引与归档文件不一致。');
      }
      if (catalogOnly) {
        return ConversationDraft(
          title: '选择要恢复的 DeepSeek 会话',
          messages: const [],
          canSave: false,
          archiveSessions: sessions,
        );
      }
      final targets = selectedSession == null
          ? sessions
          : sessions.where((session) => session.id == selectedSession).toList();
      if (targets.isEmpty) throw const ImportFailure('归档中找不到选中的 DeepSeek 会话。');
      final output = <ImportedMessage>[],
          attachments = <ImportedAttachment>[
            if (selectedSession == null) ?source,
          ],
          warnings = <String>{};
      String? current;
      for (final entry in targets) {
        cancel.check();
        final id = entry.id;
        final data = read('chat_sessions/$id.json') as Map<String, dynamic>;
        if (data['id'] != id ||
            (data['messages'] as List).length != entry.messageCount) {
          throw const FormatException();
        }
        final draft = session(data, prefix: '$id:');
        current ??= draft.currentMessageId;
        output.addAll(draft.messages);
        warnings.addAll(draft.warnings);
        for (final m in data['messages'] as List) {
          for (final f in (m as Map)['fragments'] as List) {
            if (f is Map && f['type'] == 'FILE') {
              final records = f['files'];
              if (records is! List) throw const FormatException();
              for (final raw in records) {
                final meta = Map<String, dynamic>.from(raw as Map);
                final export = meta['export_path'];
                if (export != null &&
                    (export is! String || !safePath(export))) {
                  throw const FormatException();
                }
                final image = export == null ? null : files[export];
                if (image == null) {
                  warnings.add('部分附件仅有元数据或缺失原件；不会自动上传或补造。');
                } else {
                  if (image.size != meta['file_size']) {
                    throw const FormatException();
                  }
                  if (!verified.contains(image.name)) readFile(image);
                }
                attachments.add(
                  ImportedAttachment(
                    path: '${source?.path ?? 'archive'}::$export',
                    name: meta['file_name'] as String,
                    mime: 'application/octet-stream',
                    size: meta['file_size'] as int,
                  ),
                );
              }
            }
          }
        }
      }
      // Unselected account conversations need not be read to restore one.
      if (selectedSession == null) {
        for (final f in files.values) {
          cancel.check();
          if (!verified.contains(f.name)) readFile(f);
        }
      }
      if (selectedSession == null && index.length > 1) {
        warnings.add('含 ${index.length} 个会话，全部树节点已保留；恢复时请选定所属故事节点。');
      }
      return ConversationDraft(
        title: targets.length == 1
            ? targets.single.title
            : 'DeepSeek 归档（${index.length} 个故事）',
        messages: output,
        canSave: output.any((message) => message.content.trim().isNotEmpty),
        attachments: attachments,
        currentMessageId: current,
        warnings: warnings.toList(),
      );
    } on ImportFailure {
      rethrow;
    } catch (_) {
      throw const ImportFailure('ZIP 损坏或格式校验失败，未修改正式世界。');
    }
  }
}
