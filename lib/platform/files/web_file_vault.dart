import 'dart:typed_data';

/// Session-scoped byte store for files picked in the browser.
///
/// The web platform has no share-inbox file paths. Picked files live only in
/// this vault; reloading the page drops them. Pending imports persisted in the
/// database therefore fail loudly instead of silently substituting content.
class WebFileVault {
  WebFileVault._();
  static final instance = WebFileVault._();

  static const _prefix = 'webfile:';
  final _files = <String, Uint8List>{};
  var _serial = 0;

  /// Sets a hard ceiling so a malicious or accidental multi-gigabyte selection
  /// is rejected before it exhausts the tab's memory.
  static const maxTotalBytes = 192 * 1024 * 1024;

  int get totalBytes =>
      _files.values.fold(0, (sum, bytes) => sum + bytes.length);

  String put(Uint8List bytes) {
    if (bytes.length > maxTotalBytes || totalBytes + bytes.length > maxTotalBytes) {
      throw const WebFileVaultException('文件过大，网页版单次导入不能超过 192 MB。');
    }
    final handle = '$_prefix${++_serial}';
    _files[handle] = bytes;
    return handle;
  }

  Uint8List bytesOf(String handle) {
    if (!handle.startsWith(_prefix)) {
      throw const WebFileVaultException('文件引用无效，请重新选择文件。');
    }
    final bytes = _files[handle];
    if (bytes == null) {
      throw const WebFileVaultException(
        '网页刷新后不会保留已选择文件的原始内容，请重新选择该文件。',
      );
    }
    return bytes;
  }

  bool contains(String handle) => _files.containsKey(handle);

  void clear() => _files.clear();
}

class WebFileVaultException implements Exception {
  const WebFileVaultException(this.message);
  final String message;
  @override
  String toString() => message;
}
