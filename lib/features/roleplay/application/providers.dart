import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../worlds/application/world_providers.dart';
import '../../ai/application/ai_providers.dart';
import '../../usage/usage_repository.dart';
import '../data/roleplay_repository.dart';
import 'dialogue_engine.dart';
import 'turn_coordinator.dart';

final roleplayRepositoryProvider = Provider(
  (ref) => RoleplayRepository(ref.watch(databaseProvider)),
);
// This runs once per app session. A previous process can leave a running
// reservation behind, which must never trigger an automatic retry.
final interruptedTurnRecoveryProvider = FutureProvider<void>(
  (ref) => ref.watch(roleplayRepositoryProvider).recoverInterrupted(),
);
final dialogueEngineProvider = Provider<DialogueEngine>((ref) {
  final config = ref.watch(deepSeekConfigProvider);
  if (!config.permitsDirectCalls) return const BlockedDialogueEngine();
  final adapter = DeepSeekDialogueEngine(
    config,
    ref.watch(apiKeyStorageProvider),
    usageRepository: ref.watch(usageRepositoryProvider),
    onError: (error) {
      if (ref.mounted) {
        ref.read(apiDiagnosticsProvider.notifier).requestFailed(error);
      }
    },
  );
  ref.onDispose(adapter.dispose);
  return adapter;
});
final fishRoleplayCoreProvider = Provider(
  (ref) => FishRoleplayCore(
    ref.watch(roleplayRepositoryProvider),
    ref.watch(dialogueEngineProvider),
    ref.watch(usageRepositoryProvider),
  ),
);
