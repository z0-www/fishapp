import 'dart:typed_data';

import 'web_download_stub.dart'
    if (dart.library.js_interop) 'web_download_web.dart' as impl;

/// Saves bytes through the platform's user-visible save path.
/// Native builds use a share/save picker; ordinary web builds download.
Future<bool> saveBytesToUser({
  required String suggestedName,
  required Uint8List bytes,
  required String mime,
}) => impl.saveBytesToUser(
  suggestedName: suggestedName,
  bytes: bytes,
  mime: mime,
);
