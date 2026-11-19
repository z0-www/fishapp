import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/world_definition.dart';

class DefinitionVersion {
  const DefinitionVersion(this.definition, this.version);
  final WorldDefinition definition;
  final int version;
}

class WorldDefinitionRepository {
  WorldDefinitionRepository(this.db);
  final AppDatabase db;
  Future<DefinitionVersion?> latest(String id) async {
    final rows =
        await (db.select(db.worldDefinitions)
              ..where((t) => t.worldId.equals(id))
              ..orderBy([(t) => OrderingTerm.desc(t.version)])
              ..limit(1))
            .get();
    return rows.isEmpty
        ? null
        : DefinitionVersion(
            WorldDefinition(
              jsonDecode(rows.single.payload) as Map<String, dynamic>,
            ),
            rows.single.version,
          );
  }

  Future<DefinitionVersion?> editable(String id) async {
    final existing = await latest(id);
    if (existing != null) return existing;
    final old = await (db.select(
      db.worlds,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (old == null) return null;
    final d = WorldDefinition.empty(id);
    d.data.addAll({
      'title': old.title,
      'description': old.summary,
      'genreTags': old.genre.isEmpty ? null : [old.genre],
      'createdAt': old.createdAt.toIso8601String(),
    });
    return DefinitionVersion(d, 0);
  }

  Future<List<DefinitionVersion>> versions(String id) async =>
      (await (db.select(db.worldDefinitions)
                ..where((t) => t.worldId.equals(id))
                ..orderBy([(t) => OrderingTerm.desc(t.version)]))
              .get())
          .map(
            (r) => DefinitionVersion(
              WorldDefinition(jsonDecode(r.payload) as Map<String, dynamic>),
              r.version,
            ),
          )
          .toList();
  Future<void> saveDraft(String id, Map<String, dynamic> payload) async {
    if (WorldDefinitionExchange.containsCredential(payload)) {
      throw const DefinitionFailure('草稿未保存：请移除 API Key 或授权信息。');
    }
    if (utf8.encode(jsonEncode(payload)).length > 512 * 1024) {
      throw const DefinitionFailure('草稿过大。');
    }
    await db
        .into(db.worldDrafts)
        .insertOnConflictUpdate(
          WorldDraftsCompanion.insert(
            id: id,
            payload: jsonEncode(payload),
            updatedAt: DateTime.now(),
          ),
        );
  }

  Future<void> clearDraft(String id) =>
      (db.delete(db.worldDrafts)..where((t) => t.id.equals(id))).go();
  Future<Map<String, dynamic>?> draft(String id) async {
    final row = await (db.select(
      db.worldDrafts,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : jsonDecode(row.payload) as Map<String, dynamic>;
  }

  Future<DefinitionVersion> save(
    WorldDefinition definition, {
    required int expectedVersion,
    String? draftId,
  }) => db.transaction(() async {
    definition.validate();
    final old = await latest(definition.id);
    if ((old?.version ?? 0) != expectedVersion) {
      throw const DefinitionFailure('设定已有新版本，请重新打开后编辑，避免覆盖另一份修改。');
    }
    final d = definition.copy();
    final now = DateTime.now();
    d.data['createdAt'] ??= now.toIso8601String();
    d.data['updatedAt'] = now.toIso8601String();
    final world = await (db.select(
      db.worlds,
    )..where((t) => t.id.equals(d.id))).getSingleOrNull();
    if (world == null) {
      await db
          .into(db.worlds)
          .insert(
            WorldsCompanion.insert(
              id: d.id,
              title: d.title.isEmpty ? '未命名世界' : d.title,
              genre: (d.data['genreTags'] as List? ?? []).join(' · '),
              summary: d.text('description') ?? '',
              createdAt: now,
            ),
          );
    } else {
      await (db.update(db.worlds)..where((t) => t.id.equals(d.id))).write(
        WorldsCompanion(
          title: Value(d.title.isEmpty ? '未命名世界' : d.title),
          genre: Value((d.data['genreTags'] as List? ?? []).join(' · ')),
          summary: Value(d.text('description') ?? ''),
        ),
      );
    }
    final version = (old?.version ?? 0) + 1;
    await db
        .into(db.worldDefinitions)
        .insert(
          WorldDefinitionsCompanion.insert(
            worldId: d.id,
            version: version,
            payload: jsonEncode(d.toJson()),
            savedAt: now,
          ),
        );
    if (draftId != null) {
      await (db.delete(
        db.worldDrafts,
      )..where((t) => t.id.equals(draftId))).go();
    }
    return DefinitionVersion(d, version);
  });
  Future<DefinitionVersion> importDefinition(
    WorldDefinition d, {
    String? jobId,
  }) => db.transaction(() async {
    if (jobId != null) {
      final job = await (db.select(
        db.pendingImports,
      )..where((t) => t.id.equals(jobId))).getSingleOrNull();
      if (job == null || job.state == 'saved') {
        throw const DefinitionFailure('分享不存在或已导入。');
      }
    }
    final result = await save(d, expectedVersion: 0);
    if (jobId != null) {
      await (db.update(db.pendingImports)..where((t) => t.id.equals(jobId)))
          .write(const PendingImportsCompanion(state: Value('saved')));
    }
    return result;
  });
  Future<DefinitionVersion> duplicate(WorldDefinition definition) async {
    final d = definition.copy();
    d.data['id'] = 'world-${DateTime.now().microsecondsSinceEpoch}';
    d.data['title'] = d.title.isEmpty ? '' : '${d.title}（副本）';
    d.data['createdAt'] = null;
    d.data['updatedAt'] = null;
    return save(d, expectedVersion: 0);
  }

  Future<void> deleteWorld(String id) => db.transaction(() async {
    final running = await (db.select(
      db.roleplayTurns,
    )..where((t) => t.worldId.equals(id) & t.state.equals('running'))).get();
    if (running.isNotEmpty) {
      throw const DefinitionFailure('此世界正在生成，请先停止并等待回合结束。');
    }
    await (db.update(db.importedConversations)
          ..where((t) => t.worldId.equals(id)))
        .write(const ImportedConversationsCompanion(worldId: Value(null)));
    await (db.delete(
      db.storyCheckpoints,
    )..where((t) => t.worldId.equals(id))).go();
    await (db.delete(
      db.storyBranches,
    )..where((t) => t.worldId.equals(id))).go();
    await (db.delete(
      db.timelineEntries,
    )..where((t) => t.worldId.equals(id))).go();
    await (db.delete(
      db.contextSummaries,
    )..where((t) => t.worldId.equals(id))).go();
    await (db.delete(
      db.roleplayMemories,
    )..where((t) => t.worldId.equals(id))).go();
    await (db.delete(
      db.roleplayTurns,
    )..where((t) => t.worldId.equals(id))).go();
    await (db.delete(
      db.roleplaySaves,
    )..where((t) => t.worldId.equals(id))).go();
    await (db.delete(
      db.worldDefinitions,
    )..where((t) => t.worldId.equals(id))).go();
    await (db.delete(db.worldDrafts)..where(
          (t) => t.id.equals('edit-$id') | t.id.equals('input-play-$id'),
        ))
        .go();
    await (db.delete(db.worlds)..where((t) => t.id.equals(id))).go();
  });
}
