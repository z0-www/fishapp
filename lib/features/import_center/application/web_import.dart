import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../platform/files/web_file_picker.dart';
import '../domain/import_models.dart';
import 'import_providers.dart';

/// Browser replacement for the native share-inbox picker.
///
/// The selected bytes are staged in the session vault and registered through
/// the same durable import queue as native picks, so previews, deduplication
/// and `.yuzhe` handling stay identical.
Future<String?> stageWebPickedFiles(
  WidgetRef ref, {
  bool multiple = true,
  bool yuzheOnly = false,
}) async {
  if (!webFilePickerAvailable) {
    throw const ImportFailure('当前构建不支持浏览器文件选择。');
  }
  final picked = await pickWebFiles(multiple: multiple, yuzheOnly: yuzheOnly);
  if (picked.isEmpty) return null;
  if (picked.length == 1 && picked.single.bytes.isEmpty) {
    throw const ImportFailure('文件为空，未暂存。');
  }
  // The queue id must match `^[A-Za-z0-9-]+$` and stay under 80 characters.
  final id = 'web-${DateTime.now().microsecondsSinceEpoch}';
  final share = IncomingShare(
    id: id,
    source: ImportSource.picker,
    receivedAt: DateTime.now(),
    files: [
      for (final file in picked)
        ImportedAttachment(
          path: file.handle,
          name: file.name,
          mime: file.mime,
          size: file.bytes.length,
          sha256: sha256.convert(file.bytes).toString(),
        ),
    ],
  );
  final stored = await ref
      .read(pendingShareRepositoryProvider)
      .receive(share);
  ref.invalidate(pendingImportsProvider);
  return stored;
}
