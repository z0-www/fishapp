import 'share_link.dart';

import 'dart:convert';

import 'package:dio/dio.dart';

import '../domain/import_models.dart';

/// Anonymous, bounded, single-request adapter for the undocumented share route.
/// Production permission is supplied only by the application composition root.
class DeepSeekShareImportService {
  DeepSeekShareImportService({
    this.accessPermitted = false,
    HttpClientAdapter? adapter,
  }) : _dio = Dio(
         BaseOptions(
           connectTimeout: const Duration(seconds: 15),
           receiveTimeout: const Duration(seconds: 20),
           followRedirects: false,
         ),
       ) {
    if (adapter != null) _dio.httpClientAdapter = adapter;
  }
  final bool accessPermitted;
  final Dio _dio;
  static const maxBytes = 8 * 1024 * 1024;
  static String shareId(String text) {
    final canonical = ShareLink.canonicalDeepSeek(text);
    if (canonical == null) {
      throw const ImportFailure('只接受 DeepSeek 官方 HTTPS 公开分享链接。');
    }
    return Uri.parse(canonical).pathSegments.last;
  }

  static bool accepts(String text) {
    try {
      shareId(text);
      return true;
    } on ImportFailure {
      return false;
    }
  }

  Future<ConversationDraft> fetch(
    String link, {
    required bool confirmed,
    CancelToken? cancellation,
  }) async {
    final id = shareId(link);
    if (!confirmed) throw const ImportFailure('取消读取，未访问分享接口。');
    if (!accessPermitted) {
      throw const ImportFailure('公开分享自动读取尚未获准；请使用官方 ZIP、JSON 或粘贴正文。');
    }
    final token = cancellation ?? CancelToken();
    try {
      final response = await _dio.get<ResponseBody>(
        'https://chat.deepseek.com/api/v0/share/content',
        queryParameters: {'share_id': id},
        cancelToken: token,
        options: Options(
          responseType: ResponseType.stream,
          headers: {'Accept': 'application/json'},
        ),
      );
      final body = response.data;
      if (body == null ||
          !(response.headers.value('content-type') ?? '')
              .toLowerCase()
              .contains('application/json')) {
        throw const ImportFailure('分享接口格式已变化，请改用文件导入。');
      }
      if (body.contentLength > maxBytes) {
        token.cancel();
        throw const ImportFailure('分享内容超过 8 MB，已停止读取。');
      }
      final bytes = <int>[];
      final watch = Stopwatch()..start();
      await for (final chunk in body.stream.timeout(
        const Duration(seconds: 20),
      )) {
        if (watch.elapsed > const Duration(seconds: 30) ||
            bytes.length + chunk.length > maxBytes) {
          token.cancel();
          throw const ImportFailure('分享内容过大或读取超时，已停止。');
        }
        bytes.addAll(chunk);
      }
      return parse(utf8.decode(bytes), sourceUrl: link.trim());
    } on ImportFailure {
      rethrow;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      throw ImportFailure(switch (status) {
        401 || 403 => '分享需要登录或无访问权限；不会尝试登录或绕过限制。',
        301 || 302 || 303 || 307 || 308 => '分享接口发生跳转，已停止读取，请打开官方页面或导入文件。',
        429 => 'DeepSeek 正在限制公开分享访问（HTTP 429）。请稍后重试，或复制正文导入。',
        404 || 410 => '分享已失效或被删除，请重新导出正文。',
        _ =>
          e.type == DioExceptionType.cancel
              ? '已停止读取；原有档案保留。'
              : '分享读取失败，请检查网络或改用文件导入。',
      });
    } catch (_) {
      throw const ImportFailure('分享响应无法识别或读取超时，请改用文件导入。');
    }
  }

  /// Parses a user-provided file as well as a permitted anonymous response.
  /// THINK/SEARCH/unknown fragments remain raw metadata, never story prose.
  static ConversationDraft parse(String text, {String? sourceUrl}) {
    if (utf8.encode(text).length > maxBytes) {
      throw const ImportFailure('分享内容超过 8 MB。');
    }
    try {
      final root = jsonDecode(text);
      if (root is! Map || root['code'] != 0 || root['data'] is! Map) {
        throw const FormatException();
      }
      final envelope = root['data'] as Map;
      if (envelope['biz_code'] != 0 || envelope['biz_data'] is! Map) {
        throw const ImportFailure('分享不存在、已失效或不可公开访问。');
      }
      final data = envelope['biz_data'] as Map;
      final rows = data['messages'];
      if (rows is! List || rows.isEmpty || rows.length > 10000) {
        throw const FormatException();
      }
      String identifier(Object? v) {
        if (v is! int && v is! String) throw const FormatException();
        final id = v.toString();
        if (!RegExp(r'^[A-Za-z0-9_-]{1,80}$').hasMatch(id)) {
          throw const FormatException();
        }
        return id;
      }

      String messageId(Map row) {
        final primary = row['message_id'];
        final alias = row['id'];
        if (primary != null &&
            alias != null &&
            identifier(primary) != identifier(alias)) {
          throw const FormatException();
        }
        return identifier(primary ?? alias);
      }

      final ids = <String>{};
      for (final r in rows) {
        if (r is! Map || !ids.add(messageId(r))) {
          throw const FormatException();
        }
      }
      final warnings = <String>{'不完整导入：仅保留公开分享快照，不能代表 DeepSeek 全部历史。'};
      final messages = <ImportedMessage>[];
      for (final r in rows.cast<Map>()) {
        final id = messageId(r);
        String? parent;
        final rawParent = r['parent_id'];
        final isRootSentinel =
            (rawParent == 0 ||
                rawParent == '0' ||
                rawParent == -1 ||
                rawParent == '-1') &&
            !ids.contains(rawParent.toString());
        if (rawParent != null && !isRootSentinel) {
          parent = identifier(rawParent);
          if (!ids.contains(parent)) {
            warnings.add('分享从中途开始：缺失父节点仅作为边界，原始关联保留。');
            parent = null;
          }
        }
        final role = switch ((r['role'] as String?)?.toUpperCase()) {
          'USER' => 'user',
          'ASSISTANT' => 'assistant',
          _ => 'unknown',
        };
        if (role == 'unknown') warnings.add('包含未知发言类型，仅保留原始数据。');
        final prose = <String>[];
        final fragments = r['fragments'];
        if (fragments != null && fragments is! List) {
          throw const FormatException();
        }
        if (fragments is List && fragments.isNotEmpty) {
          for (final f in fragments) {
            if (f is! Map) throw const FormatException();
            final type = f['type'];
            if ((role == 'user' && type == 'REQUEST') ||
                (role == 'assistant' && type == 'RESPONSE')) {
              if (f['content'] is! String) throw const FormatException();
              prose.add(f['content'] as String);
            } else {
              warnings.add('推理、搜索及附件片段仅保留为元数据，不拼入剧情，不下载附件。');
            }
          }
        } else if (r['content'] is String && role != 'unknown') {
          prose.add(r['content'] as String);
        }
        messages.add(
          ImportedMessage(
            id: id,
            parentId: parent,
            role: role,
            content: prose.join('\n'),
            rawJson: jsonEncode(safeImportMetadata(r)),
          ),
        );
      }
      if (!messages.any((m) => m.content.trim().isNotEmpty)) {
        throw const ImportFailure('未取得可阅读的对话正文。');
      }
      final byId = {for (final m in messages) m.id: m};
      final ordered = <ImportedMessage>[];
      final done = <String>{};
      for (final message in messages) {
        final ancestry = <String>{};
        String? next = message.id;
        while (next != null && !done.contains(next)) {
          if (!ancestry.add(next)) throw const FormatException();
          next = byId[next]?.parentId;
        }
        for (final id in ancestry.toList().reversed) {
          ordered.add(byId[id]!);
          done.add(id);
        }
      }
      final rawCurrent = data['current_message_id'];
      final current = rawCurrent == null
          ? ordered.last.id
          : identifier(rawCurrent);
      if (!ids.contains(current)) throw const FormatException();
      if (rawCurrent == null) warnings.add('未提供当前节点，暂选最后一条已分享消息；恢复前可改选。');
      final children = <String, int>{};
      for (final m in messages) {
        if (m.parentId != null) {
          children.update(m.parentId!, (n) => n + 1, ifAbsent: () => 1);
        }
      }
      return ConversationDraft(
        title: data['title'] is String
            ? data['title'] as String
            : 'DeepSeek 分享故事',
        messages: ordered,
        nodeUncertain: rawCurrent == null,
        currentMessageId: current,
        branches: children.values.where((n) => n > 1).length,
        warnings: warnings.toList(),
        rawDocument: jsonEncode(safeImportMetadata(root)),
        sourceUrl: sourceUrl,
      );
    } on ImportFailure {
      rethrow;
    } catch (_) {
      throw const ImportFailure('分享消息结构或分支关联异常，未修改存档。');
    }
  }

  void close() => _dio.close(force: true);
}
