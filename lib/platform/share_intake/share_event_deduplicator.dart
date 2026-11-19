import '../../features/import_center/data/share_link.dart';

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import '../../features/import_center/domain/import_models.dart';

class ShareEventDeduplicator {
  Future<String> fingerprint(
    IncomingShare share, {
    bool canonical = true,
  }) async {
    final link = canonical && share.files.isEmpty && share.error == null
        ? ShareLink.inText(share.text)
        : null;
    final normalized = link == null ? null : ShareLink.canonicalDeepSeek(link);
    if (normalized != null) {
      return sha256
          .convert(utf8.encode('deepseek-share:$normalized'))
          .toString();
    }
    final hashes = <String>[];
    for (final file in share.files) {
      final hash = file.sha256.isNotEmpty
          ? file.sha256
          : (await sha256.bind(File(file.path).openRead()).first).toString();
      hashes.add('${file.mime}:$hash');
    }
    return sha256
        .convert(
          utf8.encode(
            jsonEncode({
              'text': share.text,
              'mime': share.mime,
              'files': hashes,
              'error': share.error,
            }),
          ),
        )
        .toString();
  }
}
