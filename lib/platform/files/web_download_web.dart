import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

Future<bool> saveBytesToUser({
  required String suggestedName,
  required Uint8List bytes,
  required String mime,
}) async {
  // iOS Safari handles file sharing better than an <a download> click: the
  // system share sheet offers "存储到文件"/"Save to Files" directly. Desktop
  // browsers can expose `canShare` too but their share attempt may fail (or
  // silently open an OS dialog), so only iOS/iPadOS uses this path.
  final ua = web.window.navigator.userAgent;
  final isIOS =
      RegExp(r'iPhone|iPad|iPod').hasMatch(ua) ||
      (ua.contains('Macintosh') && web.window.navigator.maxTouchPoints > 1);
  if (isIOS) {
    try {
      final file = web.File(
        <JSAny>[bytes.toJS].toJS,
        suggestedName,
        web.FilePropertyBag(type: mime),
      );
      final data = web.ShareData(
        files: <web.File>[file].toJS,
        title: suggestedName,
      );
      if (web.window.navigator.canShare(data)) {
        try {
          await web.window.navigator.share(data).toDart;
          return true;
        } catch (_) {
          // The user cancelled the system share sheet; do not start a surprise
          // second download. The export can simply be retried.
          return false;
        }
      }
    } catch (_) {
      // Share API unavailable: fall through to a normal download.
    }
  }
  try {
    final parts = <JSAny>[bytes.toJS].toJS;
    final blob = web.Blob(parts, web.BlobPropertyBag(type: mime));
    final url = web.URL.createObjectURL(blob);
    final anchor = web.HTMLAnchorElement()
      ..href = url
      ..download = suggestedName
      ..style.display = 'none';
    web.document.body?.appendChild(anchor);
    anchor.click();
    anchor.remove();
    // Revoke after the click has been handled so Safari can start the download.
    Future<void>.delayed(
      const Duration(seconds: 20),
      () => web.URL.revokeObjectURL(url),
    );
    return true;
  } catch (_) {
    return false;
  }
}
