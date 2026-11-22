import 'dart:typed_data';

import 'local_files_native.dart'
    if (dart.library.js_interop) 'local_files_web.dart' as impl;

/// Reads staged import files without leaking the storage mechanism into the
/// shared import/backup code.
///
/// Native builds stage files as absolute paths owned by the platform share
/// inbox. Web builds have no filesystem; the browser picker hands the bytes to
/// an in-memory vault and addressability is expressed as a `webfile:` handle.
/// Handles are validated by the vault, never treated as paths.
abstract final class LocalFiles {
  static bool isMemoryRef(String ref) => ref.startsWith(memoryPrefix);

  static const memoryPrefix = 'webfile:';

  static Future<int> length(String ref) => impl.length(ref);

  static Future<Uint8List> readBytes(String ref) => impl.readBytes(ref);

  /// Reads at most [count] leading bytes (format sniffing without loading a
  /// potentially large attachment into memory).
  static Future<Uint8List> readHead(String ref, int count) =>
      impl.readHead(ref, count);

  static Future<String> readText(String ref) => impl.readText(ref);
}
