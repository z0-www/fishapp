import 'dart:convert';

import '../../../platform/files/local_files.dart';
import '../../import_center/domain/import_models.dart';

Future<bool> isWorldDefinitionShare(IncomingShare share) async {
  try {
    var text = share.text;
    if (text.isEmpty) {
      if (share.files.length != 1) return false;
      if (await LocalFiles.length(share.files.single.path) > 512 * 1024) {
        return false;
      }
      text = await LocalFiles.readText(share.files.single.path);
    }
    if (utf8.encode(text).length > 512 * 1024) return false;
    final data = jsonDecode(text);
    return data is Map && data['format'] == 'fish-world-definition';
  } catch (_) {
    return false;
  }
}
