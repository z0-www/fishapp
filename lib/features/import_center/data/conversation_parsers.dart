import 'share_link.dart';

import 'dart:convert';
import 'dart:io';

import 'story_parsers.dart';
import 'deepseek_share_import_service.dart';

import 'package:html/parser.dart' as html;

import '../domain/import_models.dart';

abstract interface class ConversationParser {
  String get name;
  bool accepts(String mime, String filename);
  Future<ConversationDraft> parse(
    String text,
    List<ImportedAttachment> files,
    ImportCancellation cancel,
  );
}

class PlainTextParser implements ConversationParser {
  @override
  String get name => '文本';
  @override
  bool accepts(String mime, String filename) =>
      mime.startsWith('text/') || filename.toLowerCase().endsWith('.txt');
  @override
  Future<ConversationDraft> parse(
    String text,
    List<ImportedAttachment> files,
    ImportCancellation cancel,
  ) async {
    cancel.check();
    if (text.trim().isEmpty) throw const ImportFailure('没有可预览的文本。');
    final links = DeepSeekShareParser();
    if (links.linkIn(text) != null) return links.parse(text, files, cancel);
    return ConversationNormalizer().text(text, files);
  }
}

class DeepSeekShareParser extends PlainTextParser {
  @override
  String get name => '分享链接';

  String? linkIn(String value) => ShareLink.inText(value);

  bool isUrl(String value) => ShareLink.isUrl(value);

  @override
  Future<ConversationDraft> parse(
    String text,
    List<ImportedAttachment> files,
    ImportCancellation cancel,
  ) async {
    cancel.check();
    final link = linkIn(text);
    if (link == null) throw const ImportFailure('分享链接格式无效。');
    return ConversationDraft(
      title: '分享链接 · ${Uri.parse(link).host}',
      messages: [
        ImportedMessage(
          id: '0',
          role: 'unknown',
          content: text,
          rawJson: jsonEncode({'url': link, 'sharedText': text}),
        ),
      ],
      attachments: files,
      sourceUrl: link,
      warnings: const ['尚未取得完整聊天内容。仅收到链接，尚未读取网页；请分享完整文本或导出 ZIP。'],
      canSave: false,
    );
  }
}

class MarkdownParser extends PlainTextParser {
  @override
  String get name => 'Markdown';
  @override
  bool accepts(String mime, String filename) =>
      mime == 'text/markdown' || filename.toLowerCase().endsWith('.md');
}

class JsonConversationParser implements ConversationParser {
  @override
  String get name => '已识别 JSON';
  @override
  bool accepts(String mime, String filename) =>
      mime == 'application/json' || filename.toLowerCase().endsWith('.json');
  @override
  Future<ConversationDraft> parse(
    String text,
    List<ImportedAttachment> files,
    ImportCancellation cancel,
  ) async {
    cancel.check();
    try {
      if (text.isEmpty && files.length == 1) {
        if (await File(files.single.path).length() > 16 * 1024 * 1024) {
          throw const ImportFailure('JSON 文件过大。');
        }
        text = await File(files.single.path).readAsString();
      }
      final data = jsonDecode(text);
      if (data is Map &&
          data['data'] is Map &&
          (data['data'] as Map).containsKey('biz_data')) {
        return DeepSeekShareImportService.parse(text);
      }
      if (data is Map<String, dynamic> &&
          DeepSeekArchiveParser.isSession(data)) {
        return DeepSeekArchiveParser().session(data, attachments: files);
      }
    } on ImportFailure {
      rethrow;
    } catch (_) {}
    return ConversationDraft(
      title: 'JSON 文件已暂存',
      messages: const [],
      attachments: files,
      canSave: false,
      warnings: const ['JSON 格式尚未识别或损坏；保留原文件，不转换为对话。'],
    );
  }
}

class DeepSeekZipParser extends JsonConversationParser {
  @override
  String get name => 'DeepSeek V3 ZIP';
  @override
  bool accepts(String mime, String filename) =>
      mime.contains('zip') || filename.toLowerCase().endsWith('.zip');
  @override
  Future<ConversationDraft> parse(
    String text,
    List<ImportedAttachment> files,
    ImportCancellation cancel,
  ) async {
    if (files.length != 1) throw const ImportFailure('请选择一个 DeepSeek ZIP。');
    return DeepSeekArchiveParser().parseFile(files.single, cancel);
  }
}

class ImageAttachmentParser extends JsonConversationParser {
  @override
  String get name => '图片附件';
  @override
  bool accepts(String mime, String filename) => mime.startsWith('image/');
  @override
  Future<ConversationDraft> parse(
    String text,
    List<ImportedAttachment> files,
    ImportCancellation cancel,
  ) async {
    final checked = <ImportedAttachment>[];
    for (final file in files) {
      cancel.check();
      final handle = await File(file.path).open();
      late List<int> header;
      try {
        header = await handle.read(16);
      } finally {
        await handle.close();
      }
      final png =
          header.length >= 8 &&
          header.take(8).join(',') == '137,80,78,71,13,10,26,10';
      final jpeg =
          header.length >= 3 &&
          header[0] == 255 &&
          header[1] == 216 &&
          header[2] == 255;
      final gif =
          header.length >= 6 &&
          [
            'GIF87a',
            'GIF89a',
          ].contains(ascii.decode(header.take(6).toList(), allowInvalid: true));
      final webp =
          header.length >= 12 &&
          ascii.decode(header.take(4).toList(), allowInvalid: true) == 'RIFF' &&
          ascii.decode(header.sublist(8, 12), allowInvalid: true) == 'WEBP';
      final actual = png
          ? 'image/png'
          : jpeg
          ? 'image/jpeg'
          : gif
          ? 'image/gif'
          : webp
          ? 'image/webp'
          : null;
      if (actual == null ||
          (file.mime != 'image/*' &&
              file.mime != actual &&
              !(file.mime == 'image/jpg' && jpeg))) {
        throw const ImportFailure('图片格式与内容不匹配，或暂不支持此图片格式。');
      }
      checked.add(
        ImportedAttachment(
          path: file.path,
          name: file.name,
          mime: actual,
          size: file.size,
          sha256: file.sha256,
          isImage: true,
        ),
      );
    }
    return ConversationDraft(
      title: '分享图片',
      messages: const [],
      attachments: checked,
      warnings: const ['仅保存图片附件；没有执行 OCR，也没有读取图片中的对话。'],
    );
  }
}

bool _isSessionJson(String text) {
  try {
    final d = jsonDecode(text);
    return d is Map &&
        (DeepSeekArchiveParser.isSession(d) ||
            d['data'] is Map && (d['data'] as Map).containsKey('biz_data'));
  } catch (_) {
    return false;
  }
}

class ImportParserRegistry {
  const ImportParserRegistry({this.limits = const ImportLimits()});
  final ImportLimits limits;
  Future<ConversationDraft> parse(
    IncomingShare share,
    ImportCancellation cancel,
    void Function(double) progress,
  ) async {
    cancel.check();
    if (share.error != null) throw const ImportFailure('系统分享读取失败或超过限制，请重新分享。');
    if (utf8.encode(share.text).length > limits.textBytes ||
        share.files.length > limits.fileCount) {
      throw const ImportFailure('内容超过导入限制，请分批分享。');
    }
    final zip = share.files
        .where((file) => DeepSeekZipParser().accepts(file.mime, file.name))
        .toList();
    if (zip.isNotEmpty) {
      if (zip.length != 1 || share.files.length != 1) {
        throw const ImportFailure('请选择一份 DeepSeek 官方 ZIP，再选择其中一个会话。');
      }
      final result = await DeepSeekArchiveParser().parseFile(
        zip.single,
        cancel,
        catalogOnly: share.archiveSession == null,
        selectedSession: share.archiveSession,
      );
      progress(1);
      return result;
    }
    final messages = <ImportedMessage>[];
    final attachments = <ImportedAttachment>[];
    final warnings = <String>[];
    var allowed = true, uncertain = false;
    int? branches;
    var title = '导入记录';
    final rawDocuments = <String>[];
    String? sourceUrl;
    var total = 0;
    String? currentMessageId;
    Future<void> add(ConversationDraft d) async {
      if (d.rawDocument != null) rawDocuments.add(d.rawDocument!);
      sourceUrl ??= d.sourceUrl;
      uncertain = uncertain || d.nodeUncertain;
      branches = (branches ?? 0) + (d.branches ?? 0);
      if (messages.isEmpty) title = d.title;
      final prefix = messages.length;
      currentMessageId ??= d.currentMessageId == null
          ? null
          : '$prefix:${d.currentMessageId}';
      messages.addAll(
        d.messages.map(
          (m) => ImportedMessage(
            id: '$prefix:${m.id}',
            role: m.role,
            content: m.content,
            rawJson: m.rawJson,
            parentId: m.parentId == null ? null : '$prefix:${m.parentId}',
          ),
        ),
      );
      attachments.addAll(d.attachments);
      warnings.addAll(d.warnings);
      allowed = allowed && d.canSave;
    }

    if (share.text.trim().isNotEmpty) {
      final links = DeepSeekShareParser();
      final visible = share.mime == 'text/html'
          ? (html.parse(share.text).body?.text ?? '')
          : share.text;
      final draft =
          await (share.mime == 'application/json' || _isSessionJson(visible)
                  ? JsonConversationParser()
                  : links.linkIn(visible) != null
                  ? links
                  : PlainTextParser())
              .parse(visible, const [], cancel);
      await add(draft);
      if (share.mime == 'text/html' && messages.isNotEmpty) {
        final previous = messages.removeLast();
        messages.add(
          ImportedMessage(
            id: previous.id,
            parentId: previous.parentId,
            role: previous.role,
            content: previous.content,
            rawJson: jsonEncode({'html': share.text}),
          ),
        );
        warnings.add('HTML 只提取文本，原始 HTML 已保留；未执行脚本或加载外部资源。');
      }
    }
    for (final entry in share.files.indexed) {
      cancel.check();
      final file = entry.$2;
      final size = await File(file.path).length();
      total += size;
      if (size > limits.fileBytes || total > limits.eventBytes) {
        throw const ImportFailure('文件超过导入限制。');
      }
      final candidates = <ConversationParser>[
        DeepSeekZipParser(),
        JsonConversationParser(),
        ImageAttachmentParser(),
        MarkdownParser(),
        PlainTextParser(),
      ];
      final parser = candidates
          .where((p) => p.accepts(file.mime, file.name))
          .firstOrNull;
      if (parser == null) {
        allowed = false;
        warnings.add('存在尚不支持转换的文件，已暂存。');
        attachments.add(file);
        continue;
      }
      var text = '';
      if (parser is PlainTextParser) {
        if (size > limits.textBytes) throw const ImportFailure('文本文件过大，请分批导入。');
        text = await File(file.path).readAsString();
      }
      await add(await parser.parse(text, [file], cancel));
      progress((entry.$1 + 1) / (share.files.length + 1));
      await Future<void>.delayed(Duration.zero);
    }
    cancel.check();
    if (messages.isEmpty && attachments.isEmpty) {
      throw const ImportFailure('没有可导入的内容。');
    }
    progress(1);
    return ConversationDraft(
      title: title,
      messages: messages,
      attachments: attachments,
      warnings: warnings.toSet().toList(),
      canSave: allowed,
      currentMessageId: currentMessageId,
      rawDocument: rawDocuments.isEmpty
          ? null
          : rawDocuments.length == 1
          ? rawDocuments.single
          : jsonEncode(rawDocuments),
      sourceUrl: sourceUrl,
      nodeUncertain: uncertain,
      branches: branches,
    );
  }
}
