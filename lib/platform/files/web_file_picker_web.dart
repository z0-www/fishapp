import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'web_file_picker.dart';
import 'web_file_vault.dart';

bool get available => true;

String _mimeFor(String name, String reported) {
  if (reported.isNotEmpty && reported != 'application/octet-stream') {
    return reported;
  }
  final lower = name.toLowerCase();
  if (lower.endsWith('.yuzhe')) return 'application/vnd.yuzhe.story';
  if (lower.endsWith('.zip')) return 'application/zip';
  if (lower.endsWith('.json')) return 'application/json';
  if (lower.endsWith('.md')) return 'text/markdown';
  if (lower.endsWith('.txt')) return 'text/plain';
  if (lower.endsWith('.png')) return 'image/png';
  if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
  if (lower.endsWith('.gif')) return 'image/gif';
  if (lower.endsWith('.webp')) return 'image/webp';
  return 'application/octet-stream';
}

Future<List<WebPickedFile>> pickWebFiles({
  bool multiple = true,
  bool yuzheOnly = false,
}) async {
  final completer = Completer<List<WebPickedFile>>();
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..multiple = multiple
    ..accept = yuzheOnly
        ? '.yuzhe,application/vnd.yuzhe.story'
        : '.yuzhe,.zip,.json,.txt,.md,image/*,application/json,application/zip,application/vnd.yuzhe.story';
  input.style.display = 'none';
  web.document.body?.appendChild(input);

  var settled = false;
  void finish(List<WebPickedFile> files) {
    if (settled) return;
    settled = true;
    input.remove();
    if (!completer.isCompleted) completer.complete(files);
  }

  input.onchange = ((web.Event _) async {
    final selection = input.files;
    if (selection == null || selection.length == 0) {
      finish(const []);
      return;
    }
    final output = <WebPickedFile>[];
    try {
      for (var index = 0; index < selection.length; index++) {
        final file = selection.item(index);
        if (file == null) continue;
        final buffer = await file.arrayBuffer().toDart;
        final bytes = buffer.toDart.asUint8List();
        final handle = WebFileVault.instance.put(bytes);
        output.add(
          WebPickedFile(
            name: file.name,
            mime: _mimeFor(file.name, file.type),
            bytes: bytes,
            handle: handle,
          ),
        );
      }
      finish(output);
    } catch (error) {
      settled = true;
      input.remove();
      if (!completer.isCompleted) completer.completeError(error);
    }
  }).toJS;
  input.oncancel = ((web.Event _) => finish(const [])).toJS;

  // Browsers that do not emit `cancel` (older Safari) require a fallback: when
  // the window regains focus after the dialog closes, wait briefly and treat a
  // still-empty selection as cancelled so the UI never stays busy forever.
  var sawFocus = false;
  void onFocus(web.Event _) {
    if (sawFocus || settled) return;
    sawFocus = true;
    Timer(const Duration(milliseconds: 900), () {
      if (!settled && (input.files?.length ?? 0) == 0) finish(const []);
    });
  }

  web.window.addEventListener('focus', onFocus.toJS);
  input.click();
  try {
    return await completer.future;
  } finally {
    web.window.removeEventListener('focus', onFocus.toJS);
  }
}
