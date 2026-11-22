import 'dart:typed_data';

import 'web_file_picker_stub.dart'
    if (dart.library.js_interop) 'web_file_picker_web.dart' as impl;

class WebPickedFile {
  const WebPickedFile({
    required this.name,
    required this.mime,
    required this.bytes,
    required this.handle,
  });
  final String name, mime, handle;
  final Uint8List bytes;
}

/// Whether this build can show a browser file picker.
bool get webFilePickerAvailable => impl.available;

/// Opens the browser's file picker and stages the selection in [WebFileVault].
/// Returns an empty list when the user cancels.
Future<List<WebPickedFile>> pickWebFiles({
  bool multiple = true,
  bool yuzheOnly = false,
}) => impl.pickWebFiles(multiple: multiple, yuzheOnly: yuzheOnly);
