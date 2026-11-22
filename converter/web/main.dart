import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:fish_converter/fish_converter.dart';
import 'package:web/web.dart' as web;

ParseResult? _result;
var _previewIndex = 0;
final _selected = <int>{};
var _busy = false;
Uint8List? _generatedBytes;
String? _generatedName;
String? _generatedMime;
const _swCache = 'fish-converter-v1.2.1-mobile';
const _guideKey = 'fish_converter_guide_v1';

web.HTMLElement? _q(String selector) => web.document.querySelector(selector) as web.HTMLElement?;

void main() {
  final input = _q('#file') as web.HTMLInputElement?;
  final drop = _q('#drop');
  if (input == null || drop == null) return;

  input.addEventListener(
    'change',
    ((web.Event _) {
      final files = input.files;
      if (files != null && files.length > 0) {
        unawaited(_load(files.item(0)!));
      }
    }).toJS,
  );

  drop.addEventListener(
    'dragover',
    ((web.Event event) {
      event.preventDefault();
      drop.className = 'drop drag';
    }).toJS,
  );
  drop.addEventListener(
    'dragleave',
    ((web.Event _) {
      drop.className = 'drop';
    }).toJS,
  );
  drop.addEventListener(
    'drop',
    ((web.Event event) {
      event.preventDefault();
      drop.className = 'drop';
      final data = (event as web.DragEvent).dataTransfer;
      final files = data?.files;
      if (files != null && files.length > 0) {
        unawaited(_load(files.item(0)!));
      }
    }).toJS,
  );

  (_q('#exportOne') as web.HTMLButtonElement?)?.addEventListener(
    'click',
    ((web.Event _) => unawaited(_export(single: true))).toJS,
  );
  (_q('#exportZip') as web.HTMLButtonElement?)?.addEventListener(
    'click',
    ((web.Event _) => unawaited(_export(single: false))).toJS,
  );
  (_q('#exportBundle') as web.HTMLButtonElement?)?.addEventListener(
    'click',
    ((web.Event _) => unawaited(_export(single: false, bundle: true))).toJS,
  );
  (_q('#saveResult') as web.HTMLButtonElement?)?.addEventListener(
    'click',
    ((web.Event _) => unawaited(_saveGenerated())).toJS,
  );
  (_q('#openYuzhe') as web.HTMLButtonElement?)?.addEventListener(
    'click',
    ((web.Event _) => _openYuzhe()).toJS,
  );
  (_q('#showGuide') as web.HTMLButtonElement?)?.addEventListener(
    'click',
    ((web.Event _) => _openGuide()).toJS,
  );
  (_q('#guideDone') as web.HTMLButtonElement?)?.addEventListener(
    'click',
    ((web.Event _) => _closeGuide()).toJS,
  );
  (_q('#guideClose') as web.HTMLButtonElement?)?.addEventListener(
    'click',
    ((web.Event _) => _closeGuide()).toJS,
  );

  web.window.addEventListener('online', ((web.Event _) => unawaited(_updateOfflineState())).toJS);
  web.window.addEventListener('offline', ((web.Event _) => unawaited(_updateOfflineState())).toJS);

  _registerServiceWorker();
  _showGuideOnFirstVisit();
  unawaited(_updateOfflineState());
}

bool get _isIOS {
  final ua = web.window.navigator.userAgent;
  return RegExp(r'iPhone|iPad|iPod').hasMatch(ua) ||
      (ua.contains('Macintosh') && web.window.navigator.maxTouchPoints > 1);
}

JSObject? get _androidBridge {
  try {
    return globalContext.getProperty<JSObject?>('FishAndroid'.toJS);
  } catch (_) {
    return null;
  }
}

bool get _isAndroidApp => _androidBridge != null;

void _openYuzhe() {
  final bridge = _androidBridge;
  if (bridge == null) {
    _setExportStatus(
      '请手动打开鱼者文游 → 完整故事备份 → 从 .yuzhe 备份恢复。'
      '不要使用「DeepSeek 对话导入」。',
      bad: false,
    );
    return;
  }
  try {
    final opened = bridge
        .callMethod<JSBoolean>('openYuzhe'.toJS)
        .toDart;
    if (!opened) {
      _setExportStatus(
        '没有找到已安装的鱼者文游。请先安装原版客户端，再手动打开并恢复。',
        bad: true,
      );
    }
  } catch (_) {
    _setExportStatus('打开鱼者文游失败，请手动打开并恢复。', bad: true);
  }
}

void _showGuideOnFirstVisit() {
  var seen = false;
  try {
    seen = web.window.localStorage.getItem(_guideKey) == '1';
  } catch (_) {}
  if (!seen) _openGuide();
}

void _openGuide() {
  final modal = _q('#onboarding');
  if (modal != null) _setHidden(modal, false);
}

void _closeGuide() {
  try {
    web.window.localStorage.setItem(_guideKey, '1');
  } catch (_) {}
  final modal = _q('#onboarding');
  if (modal != null) _setHidden(modal, true);
}

Future<void> _updateOfflineState() async {
  final box = _q('#offlineState');
  if (box == null) return;
  if (web.window.location.protocol == 'file:') {
    box.textContent = '本地文件模式：无需缓存，断网也可以直接转换和保存。';
    box.className = 'offline-state';
    _setHidden(box, false);
    return;
  }
  var cached = false;
  bool? persisted;
  try {
    cached = (await web.window.caches.has(_swCache).toDart).toDart;
  } catch (_) {}
  try {
    persisted = (await web.window.navigator.storage.persisted().toDart).toDart;
  } catch (_) {}
  final online = web.window.navigator.onLine;
  final String message;
  var warn = false;
  if (!online) {
    if (cached) {
      message = '当前离线：文件选择、转换和保存都在本机完成。';
    } else {
      message = '当前离线，且没有找到完整缓存。请联网重新打开一次转换器，再断网使用。';
      warn = true;
    }
  } else if (!cached) {
    message = '正在准备离线缓存；首次加载完成后即可断网转换。';
  } else if (persisted == false) {
    message = '离线资源已缓存。浏览器可能在空间不足时清理缓存；若断网打不开，请联网重新打开一次。';
    warn = true;
  } else {
    message = '离线资源已缓存，可以断网转换和保存。';
  }
  box.textContent = message;
  box.className = warn ? 'offline-state warn' : 'offline-state';
  _setHidden(box, false);
}

Future<void> _registerServiceWorker() async {
  try {
    final sw = web.window.navigator.serviceWorker;
    final registration = await sw.register('service_worker.js'.toJS).toDart;
    await registration.update().toDart.catchError((Object _) => registration);
    unawaited(_updateOfflineState());
  } catch (_) {
    // file:// and older iOS Safari may not expose service workers.
  }
}

Future<void> _load(web.File file) async {
  _setError(null);
  _setExportStatus(null, bad: false);
  _clearGenerated();
  try {
    if (web.window.navigator.storage case final storage) {
      // Best effort; a denied persistence request does not block conversion.
      storage.persist().toDart.then((_) {}, onError: (Object _) {});
    }
  } catch (_) {}
  if (file.size > 64 * 1024 * 1024) {
    _setError('文件超过 64 MiB，转换器不支持这么大的单文件。');
    _resetFileInput();
    return;
  }
  final info = _q('#fileInfo');
  if (info != null) {
    info.textContent = '正在读取：${file.name}（${_size(file.size)}）…';
    _setHidden(info, false);
  }
  try {
    final bytes = await _readFileBytes(file);
    final parsed = parseConversationFile(file.name, bytes);
    _result = parsed;
    _selected
      ..clear()
      ..addAll(List.generate(parsed.sessions.length, (i) => i));
    _previewIndex = 0;
    if (info != null) {
      info.textContent =
          '已识别：${file.name} · ${_size(file.size)} · ${parsed.format} · '
          '${parsed.sessions.length} 个会话 · '
          '${parsed.sessions.fold<int>(0, (n, s) => n + s.messages.length)} 条消息';
    }
    _renderPreviewSection(parsed);
    _renderSessions(parsed);
    _renderPreview(parsed);
    _renderExport(parsed);
    _show('#step-preview', true);
    _show('#step-export', true);
    unawaited(_updateOfflineState());
  } on ConversionException catch (error) {
    _fail(error.message, info);
  } catch (error) {
    _fail('转换器无法读取这个文件：$error', info);
  } finally {
    _resetFileInput();
  }
}

void _resetFileInput() {
  final input = _q('#file') as web.HTMLInputElement?;
  if (input != null) input.value = '';
}

/// Android WebView file inputs do not always expose Blob.arrayBuffer().
/// FileReader is the portable path (and works in older WebView builds too).
Future<Uint8List> _readFileBytes(web.File file) async {
  final reader = web.FileReader();
  final done = Completer<Uint8List>();
  reader.onload = ((web.Event _) {
    try {
      final result = reader.result;
      if (result == null) {
        done.completeError(const ConversionException('文件读取结果为空。'));
        return;
      }
      final buffer = result as JSArrayBuffer;
      done.complete(buffer.toDart.asUint8List());
    } catch (error) {
      done.completeError(error);
    }
  }).toJS;
  reader.onerror = ((web.Event _) {
    if (!done.isCompleted) {
      done.completeError(const ConversionException('文件读取失败，请重新选择。'));
    }
  }).toJS;
  reader.readAsArrayBuffer(file);
  return done.future;
}

void _fail(String message, web.HTMLElement? info) {
  _result = null;
  _selected.clear();
  _clearGenerated();
  if (info != null) _setHidden(info, true);
  _setError(message);
  _show('#step-preview', false);
  _show('#step-export', false);
}

void _renderPreviewSection(ParseResult parsed) {
  final summary = _q('#summary');
  if (summary == null) return;
  summary.textContent = '';
  summary.append(_textBlock('识别格式：${parsed.format}'));
  summary.append(
    _textBlock(
      '共 ${parsed.sessions.length} 个会话，'
      '${parsed.sessions.fold<int>(0, (n, s) => n + s.messages.length)} 条消息。'
      '勾选要导出的会话；默认全选。',
    ),
  );
  if (parsed.warnings.isNotEmpty) {
    summary.append(_warnings(parsed.warnings));
  }
}

void _renderSessions(ParseResult parsed) {
  final box = _q('#sessions');
  if (box == null) return;
  box.textContent = '';
  for (var i = 0; i < parsed.sessions.length; i++) {
    final session = parsed.sessions[i];
    final card = _div('session${i == _previewIndex ? ' active' : ''}');
    final check = web.HTMLInputElement()
      ..type = 'checkbox'
      ..checked = _selected.contains(i);
    check.addEventListener(
      'change',
      ((web.Event _) {
        if (check.checked) {
          _selected.add(i);
        } else {
          _selected.remove(i);
        }
        _clearGenerated();
        _setExportStatus(null);
        _renderExport(parsed);
      }).toJS,
    );
    check.addEventListener(
      'click',
      ((web.Event event) => event.stopPropagation()).toJS,
    );
    final main = _div('session-main');
    main.append(_div('session-title').alsoText(session.title));
    main.append(
      _div('session-meta').alsoText(
        '${session.messages.length} 条 · 用户 ${session.userCount} · '
        'AI ${session.assistantCount} · 系统 ${session.systemCount}'
        '${session.otherCount > 0 ? ' · 其他 ${session.otherCount}' : ''}'
        '${session.model == null ? '' : ' · ${session.model}'}',
      ),
    );
    if (session.warnings.isNotEmpty) {
      main.append(
        _div('session-warn').alsoText(
          '${session.warnings.length} 条提示：${session.warnings.first}',
        ),
      );
    }
    card.append(check);
    card.append(main);
    card.addEventListener(
      'click',
      ((web.Event _) {
        _previewIndex = i;
        _renderSessions(parsed);
        _renderPreview(parsed);
      }).toJS,
    );
    box.append(card);
  }
}

void _renderPreview(ParseResult parsed) {
  final box = _q('#preview');
  if (box == null || parsed.sessions.isEmpty) return;
  box.textContent = '';
  final session = parsed.sessions[_previewIndex];
  final head = _div('preview-head');
  head.append(_strong(session.title));
  head.append(
    _span(
      '预览前 ${session.messages.length > 200 ? 200 : session.messages.length}/${session.messages.length} 条 · '
      '全部消息都会导出',
    ),
  );
  box.append(head);

  final list = _div('messages');
  final limit = session.messages.length > 200 ? 200 : session.messages.length;
  for (var i = 0; i < limit; i++) {
    final message = session.messages[i];
    final row = _div('msg');
    final msgHead = _div('msg-head');
    msgHead.append(_span(_roleLabel(message.role), 'role ${message.role}'));
    msgHead.append(_span('#${i + 1}', 'msg-no'));
    row.append(msgHead);
    if (message.content.trim().isEmpty) {
      row.append(_div('msg-body empty-body').alsoText('（空正文；请查看提示）'));
    } else {
      row.append(_div('msg-body').alsoText(message.content));
    }
    list.append(row);
  }
  box.append(list);
  if (session.messages.length > 200) {
    box.append(
      _textBlock('仅预览前 200 条；导出会包含全部 ${session.messages.length} 条。'),
    );
  }
  if (session.warnings.isNotEmpty) {
    box.append(_warnings(session.warnings));
  }
}

void _renderExport(ParseResult parsed) {
  final info = _q('#exportInfo');
  if (info == null) return;
  final count = _selected.length;
  final messages = _selected.fold<int>(
    0,
    (n, i) => n + parsed.sessions[i].messages.length,
  );
  info.textContent = count == 0
      ? '请至少勾选一个会话。'
      : '将导出 $count 个会话，共 $messages 条消息。'
            '${count == 1 ? '生成一个 .yuzhe 文件。' : '可合并为一个 .yuzhe，或生成包含多个 .yuzhe 的 ZIP。'}';
  final one = _q('#exportOne') as web.HTMLButtonElement?;
  final zip = _q('#exportZip') as web.HTMLButtonElement?;
  final bundle = _q('#exportBundle') as web.HTMLButtonElement?;
  if (one != null) {
    _setHidden(one, count != 1);
    one.disabled = _busy || count != 1;
  }
  if (zip != null) {
    _setHidden(zip, count <= 1);
    zip.disabled = _busy || count <= 1;
  }
  if (bundle != null) {
    _setHidden(bundle, count <= 1);
    bundle.disabled = _busy || count <= 1;
  }
}

Future<void> _export({required bool single, bool bundle = false}) async {
  final parsed = _result;
  if (parsed == null || _busy) return;
  final indexes = _selected.toList()..sort();
  if (indexes.isEmpty) {
    _setError('请至少勾选一个会话。');
    return;
  }
  if (single && indexes.length != 1) {
    _setError('请只勾选一个会话，或使用“生成多会话 ZIP”。');
    return;
  }
  _busy = true;
  _clearGenerated();
  _renderExport(parsed);
  _setExportStatus('正在本地生成归档…', bad: false);
  try {
    if (indexes.length == 1) {
      final output = await buildYuzhe(parsed.sessions[indexes.single]);
      _stageGenerated(
        output.bytes,
        output.fileName,
        'application/vnd.yuzhe.story',
        output.messageCount,
        output.warnings,
      );
    } else if (bundle) {
      final output = await buildYuzheBundle(
        [for (final i in indexes) parsed.sessions[i]],
      );
      _stageGenerated(
        output.bytes,
        output.fileName,
        'application/vnd.yuzhe.story',
        output.messageCount,
        output.warnings,
      );
    } else {
      final output = await buildYuzheZip(
        [for (final i in indexes) parsed.sessions[i]],
      );
      _stageGenerated(
        output.bytes,
        output.fileName,
        'application/zip',
        null,
        const [],
        count: output.count,
      );
    }
  } on ConversionException catch (error) {
    _setExportStatus('未生成归档：${error.message}', bad: true);
  } catch (error) {
    _setExportStatus('生成失败，原始文件未修改：$error', bad: true);
  } finally {
    _busy = false;
    _renderExport(parsed);
  }
}

void _stageGenerated(
  Uint8List bytes,
  String name,
  String mime,
  int? messageCount,
  List<String> warnings, {
  int count = 1,
}) {
  _generatedBytes = bytes;
  _generatedName = name;
  _generatedMime = mime;
  final panel = _q('#resultPanel');
  final title = _q('#resultTitle');
  final meta = _q('#resultMeta');
  final hint = _q('#saveHint');
  if (title != null) {
    title.textContent = count == 1 ? '已生成 1 个 .yuzhe' : '已生成 $count 个 .yuzhe';
  }
  if (meta != null) {
    meta.textContent =
        '$name · ${_size(bytes.length)}'
        '${messageCount == null ? '' : ' · $messageCount 条消息'} · 尚未保存';
  }
  if (hint != null) {
    hint.textContent = _isIOS
        ? '点下面按钮 → 在分享面板选择“存储到文件”。不要关闭页面，文件还在内存中。'
        : '点下面按钮保存到手机的下载目录，然后到鱼者文游中恢复。';
  }
  if (panel != null) _setHidden(panel, false);
  final open = _q('#openYuzhe');
  if (open != null) _setHidden(open, false);
  _setExportStatus(
    '归档已生成，请点“保存 / 分享文件”。'
    '${warnings.isEmpty ? '' : ' 预览中有 ${warnings.length} 条提示。'}',
    bad: false,
  );
}

Future<void> _saveGenerated() async {
  final bytes = _generatedBytes;
  final name = _generatedName;
  final mime = _generatedMime;
  if (bytes == null || name == null || mime == null) {
    _setExportStatus('请先生成归档。', bad: true);
    return;
  }
  _setExportStatus('正在打开保存/分享面板…', bad: false);
  final saved = await _saveBytes(bytes, name, mime);
  if (!saved) {
    _setExportStatus(
      _isIOS
          ? '没有完成保存。可以再点一次“保存 / 分享文件”，或选择“存储到文件”。'
          : '浏览器没有完成下载。请再点一次保存，或检查下载权限。',
      bad: true,
    );
    return;
  }
  if (_isAndroidApp) {
    _setExportStatus(
      '已打开 Android 系统保存界面。选择位置并确认后，文件才会真正写入。'
      '完成后可点“打开鱼者文游”。',
      bad: false,
    );
    return;
  }
  final title = _q('#resultTitle');
  if (title != null) title.textContent = '已保存';
  final meta = _q('#resultMeta');
  if (meta != null) meta.textContent = '$name · ${_size(bytes.length)}';
  _setExportStatus(
    '已保存 $name。现在打开鱼者文游 → 完整故事备份 → 从 .yuzhe 备份恢复。'
    '不要使用「DeepSeek 对话导入」。',
    bad: false,
  );
}

void _clearGenerated() {
  _generatedBytes = null;
  _generatedName = null;
  _generatedMime = null;
  final panel = _q('#resultPanel');
  if (panel != null) _setHidden(panel, true);
  final open = _q('#openYuzhe');
  if (open != null) _setHidden(open, true);
}

Future<bool> _saveBytes(Uint8List bytes, String name, String mime) async {
  final bridge = _androidBridge;
  if (bridge != null) {
    try {
      final encoded = base64Encode(bytes);
      final saved = bridge.callMethod<JSBoolean>(
        'saveFile'.toJS,
        name.toJS,
        mime.toJS,
        encoded.toJS,
      );
      return saved.toDart;
    } catch (_) {
      return false;
    }
  }
  if (_isIOS) {
    try {
      final file = web.File(
        <JSAny>[bytes.toJS].toJS,
        name,
        web.FilePropertyBag(type: mime),
      );
      final data = web.ShareData(
        files: <web.File>[file].toJS,
        title: name,
        text: '鱼者文游 .yuzhe 备份',
      );
      if (web.window.navigator.canShare(data)) {
        try {
          await web.window.navigator.share(data).toDart;
          return true;
        } catch (_) {
          return false;
        }
      }
    } catch (_) {
      // Fall back to a normal download.
    }
  }
  try {
    final blob = web.Blob(
      <JSAny>[bytes.toJS].toJS,
      web.BlobPropertyBag(type: mime),
    );
    final url = web.URL.createObjectURL(blob);
    final anchor = web.HTMLAnchorElement()
      ..href = url
      ..download = name
      ..rel = 'noopener'
      ..style.display = 'none';
    web.document.body?.appendChild(anchor);
    anchor.click();
    anchor.remove();
    Future<void>.delayed(
      const Duration(seconds: 20),
      () => web.URL.revokeObjectURL(url),
    );
    return true;
  } catch (_) {
    return false;
  }
}

void _setError(String? message) {
  final box = _q('#error');
  if (box == null) return;
  if (message == null) {
    _setHidden(box, true);
    box.textContent = '';
  } else {
    _setHidden(box, false);
    box.textContent = message;
  }
}

void _setExportStatus(String? message, {bool bad = false}) {
  final box = _q('#exportStatus');
  if (box == null) return;
  if (message == null) {
    _setHidden(box, true);
    box.textContent = '';
    box.className = 'status';
  } else {
    _setHidden(box, false);
    box.textContent = message;
    box.className = bad ? 'status bad' : 'status';
  }
}

void _setHidden(web.HTMLElement element, bool hidden) {
  if (hidden) {
    element.setAttribute('hidden', '');
  } else {
    element.removeAttribute('hidden');
  }
}

void _show(String selector, bool visible) {
  final element = _q(selector);
  if (element != null) _setHidden(element, !visible);
}

String _size(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

String _roleLabel(String role) => switch (role) {
  'user' => '用户',
  'assistant' => 'AI',
  'system' => '系统',
  'tool' => '工具',
  _ => '未知',
};

web.HTMLDivElement _div(String className) =>
    web.HTMLDivElement()..className = className;

web.HTMLSpanElement _span(String text, [String? className]) {
  final span = web.HTMLSpanElement()..textContent = text;
  if (className != null) span.className = className;
  return span;
}

web.HTMLElement _strong(String text) => _span(text, 'strong');

web.HTMLParagraphElement _textBlock(String text) =>
    web.HTMLParagraphElement()..textContent = text;

web.HTMLDivElement _warnings(List<String> warnings) {
  final box = _div('warn-list');
  final list = web.HTMLUListElement();
  for (final warning in warnings) {
    list.append(web.HTMLLIElement()..textContent = warning);
  }
  box.append(list);
  return box;
}

extension _TextSetter on web.HTMLElement {
  web.HTMLElement alsoText(String text) {
    textContent = text;
    return this;
  }
}
