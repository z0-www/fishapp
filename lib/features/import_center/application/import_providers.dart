import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../../core/release_access.dart';
import '../data/deepseek_share_import_service.dart';

import '../../../platform/share_intake/share_intake_service.dart';
import '../../../platform/file_access/file_access_service.dart';
import '../../worlds/application/world_providers.dart';
import '../data/pending_share_repository.dart';
import '../data/conversation_parsers.dart';

final shareIntakeProvider = Provider<ShareIntakeService>((ref) {
  final s = ShareIntakeService();
  ref.onDispose(s.dispose);
  return s;
});
final fileAccessProvider = Provider<FileAccessService>(
  (ref) => const FileAccessService(),
);
final pendingShareRepositoryProvider = Provider<PendingShareRepository>(
  (ref) => PendingShareRepository(ref.watch(databaseProvider)),
);
final importParserProvider = Provider<ImportParserRegistry>(
  (ref) => const ImportParserRegistry(),
);
final pendingImportsProvider = FutureProvider(
  (ref) => ref.watch(pendingShareRepositoryProvider).pending(),
);
final importHistoryProvider = FutureProvider(
  (ref) => ref.watch(pendingShareRepositoryProvider).history(),
);
final worldImportHistoryProvider = FutureProvider.family(
  (ref, String worldId) =>
      ref.watch(pendingShareRepositoryProvider).history(worldId: worldId),
);

class IntakeIssue extends Notifier<String?> {
  @override
  String? build() => null;
  void setIssue(String? message) => state = message;
}

final intakeIssueProvider = NotifierProvider<IntakeIssue, String?>(
  IntakeIssue.new,
);

final deepSeekShareImportProvider = Provider<DeepSeekShareImportService>((ref) {
  final service = DeepSeekShareImportService(
    accessPermitted:
        ReleaseAccess.current.permits(ReleaseService.deepSeekPublicShare) ||
        (kDebugMode &&
            const bool.fromEnvironment(
              'DEEPSEEK_SHARE_ACCESS_PERMISSION_CONFIRMED',
            )),
  );
  ref.onDispose(service.close);
  return service;
});
