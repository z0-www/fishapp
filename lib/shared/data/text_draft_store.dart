import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/worlds/application/world_providers.dart';
import '../../features/world_creator/data/world_definition_repository.dart';

abstract class TextDraftStore {
  Future<String?> read(String id);
  Future<void> write(String id, String text);
  Future<void> clear(String id);
}

class LocalTextDraftStore implements TextDraftStore {
  LocalTextDraftStore(this.repository);
  final WorldDefinitionRepository repository;
  @override
  Future<String?> read(String id) async =>
      (await repository.draft('input-$id'))?['text'] as String?;
  @override
  Future<void> write(String id, String text) =>
      repository.saveDraft('input-$id', {'text': text});
  @override
  Future<void> clear(String id) => repository.clearDraft('input-$id');
}

class MemoryTextDraftStore implements TextDraftStore {
  final values = <String, String>{};
  @override
  Future<String?> read(String id) async => values[id];
  @override
  Future<void> write(String id, String text) async {
    values[id] = text;
  }

  @override
  Future<void> clear(String id) async {
    values.remove(id);
  }
}

final textDraftStoreProvider = Provider<TextDraftStore>(
  (ref) => LocalTextDraftStore(
    WorldDefinitionRepository(ref.watch(databaseProvider)),
  ),
);
