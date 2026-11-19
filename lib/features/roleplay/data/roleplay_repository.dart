import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/models.dart';
import '../../world_creator/domain/world_definition.dart';
import '../../world_creator/data/world_definition_repository.dart';
import '../../world_creator/application/definition_state_builder.dart';

class RoleplayRepository {
  RoleplayRepository(this.db);
  final AppDatabase db;
  Future<WorldState> load(String worldId) async {
    final existing = await loadIfExists(worldId);
    if (existing == null) {
      throw const RoleplayFailure('世界尚未初始化，请打开世界。');
    }
    return existing;
  }

  Future<WorldState?> loadIfExists(String worldId) async {
    final row = await (db.select(
      db.roleplaySaves,
    )..where((t) => t.worldId.equals(worldId))).getSingleOrNull();
    return row == null
        ? null
        : WorldState(jsonDecode(row.payload) as Map<String, dynamic>);
  }

  Future<WorldState> initialize(String worldId) => db.transaction(() async {
    final world = await (db.select(
      db.worlds,
    )..where((t) => t.id.equals(worldId))).getSingleOrNull();
    if (world == null) throw const RoleplayFailure('世界不存在。');
    final old = await (db.select(
      db.roleplaySaves,
    )..where((t) => t.worldId.equals(worldId))).getSingleOrNull();
    if (old != null) {
      return WorldState(jsonDecode(old.payload) as Map<String, dynamic>);
    }
    final definition = await WorldDefinitionRepository(db).latest(worldId);
    final legacy = WorldDefinition.empty(worldId)
      ..data['title'] = world.title
      ..data['description'] = world.summary;
    final state = DefinitionStateBuilder().build(
      definition ?? DefinitionVersion(legacy, 0),
    );
    await db
        .into(db.roleplaySaves)
        .insert(
          RoleplaySavesCompanion.insert(
            worldId: worldId,
            revision: 0,
            payload: jsonEncode(state.data),
          ),
        );
    return state;
  });
  Future<List<RoleplayTurn>> history(
    String worldId, {
    int limit = 100,
    String? speaker,
  }) =>
      (db.select(db.roleplayTurns)
            ..where(
              (t) =>
                  t.worldId.equals(worldId) &
                  t.state.equals('completed') &
                  (speaker == null
                      ? const Constant(true)
                      : t.speaker.equals(speaker)),
            )
            ..orderBy([
              (t) => OrderingTerm.desc(t.baseRevision),
              (t) => OrderingTerm.desc(t.createdAt),
            ])
            ..limit(limit))
          .get();
  Future<List<PersonalMemory>> memories(String worldId) async =>
      (await (db.select(
            db.roleplayMemories,
          )..where((t) => t.worldId.equals(worldId))).get())
          .map(
            (m) => PersonalMemory.fromJson(
              jsonDecode(m.payload) as Map<String, dynamic>,
            ),
          )
          .toList();
  Future<int> historySizeEstimate(String worldId) async {
    final row = await db
        .customSelect(
          'SELECT COALESCE(SUM(length(CAST(action AS BLOB)) + length(CAST(response_json AS BLOB))),0) AS bytes FROM roleplay_turns WHERE world_id = ? AND state = ?',
          variables: [
            Variable.withString(worldId),
            Variable.withString('completed'),
          ],
          readsFrom: {db.roleplayTurns},
        )
        .getSingle();
    return row.read<int>('bytes') + 128;
  }

  Future<void> reserve(TurnPlan plan) async {
    await db.transaction(() async {
      final current = await load(plan.state.worldId);
      if (current.revision != plan.state.revision) {
        throw const RoleplayFailure('存档已变化，请重新预览预算。');
      }
      final busy =
          await (db.select(db.roleplayTurns)..where(
                (t) =>
                    t.worldId.equals(current.worldId) &
                    t.state.equals('running'),
              ))
              .get();
      if (busy.isNotEmpty) throw const RoleplayFailure('此世界已有回合进行中。');
      if (await (db.select(
            db.roleplayTurns,
          )..where((t) => t.id.equals(plan.id))).getSingleOrNull() !=
          null) {
        throw const RoleplayFailure('该预算已使用，请重新确认新回合。');
      }
      await db
          .into(db.roleplayTurns)
          .insert(
            RoleplayTurnsCompanion.insert(
              id: plan.id,
              worldId: current.worldId,
              baseRevision: current.revision,
              action: plan.action,
              speaker: plan.speaker,
              contextJson: jsonEncode(plan.messages),
              state: 'running',
              mock: false,
              createdAt: DateTime.now(),
            ),
          );
    });
  }

  Future<void> fail(String id) =>
      (db.update(db.roleplayTurns)
            ..where((t) => t.id.equals(id) & t.state.equals('running')))
          .write(const RoleplayTurnsCompanion(state: Value('failed')));
  Future<void> recoverInterrupted([String? worldId]) =>
      (db.update(db.roleplayTurns)..where(
            (t) =>
                t.state.equals('running') &
                (worldId == null
                    ? const Constant(true)
                    : t.worldId.equals(worldId)),
          ))
          .write(const RoleplayTurnsCompanion(state: Value('interrupted')));
  Future<void> commit(
    TurnPlan plan,
    WorldState next,
    DialoguePacket packet,
    TurnCancellation cancel,
  ) => db.transaction(() async {
    cancel.check();
    final current = await load(plan.state.worldId);
    final running =
        await (db.select(db.roleplayTurns)
              ..where((t) => t.id.equals(plan.id) & t.state.equals('running')))
            .getSingleOrNull();
    if (current.revision != plan.state.revision || running == null) {
      throw const RoleplayFailure('回合已失效，未覆盖当前存档。');
    }
    await (db.update(
      db.roleplaySaves,
    )..where((t) => t.worldId.equals(current.worldId))).write(
      RoleplaySavesCompanion(
        revision: Value(next.revision),
        payload: Value(jsonEncode(next.data)),
      ),
    );
    await (db.update(
      db.roleplayTurns,
    )..where((t) => t.id.equals(plan.id))).write(
      RoleplayTurnsCompanion(
        state: const Value('completed'),
        responseJson: Value(jsonEncode(packet.toJson())),
      ),
    );
    // Only the addressed participant gains firsthand knowledge; other NPCs do not receive it.
    final important =
        plan.action.contains('承诺') ||
        plan.action.contains('秘密') ||
        plan.action.contains('答应');
    final memory = PersonalMemory(
      id: '${plan.id}:${plan.speaker}',
      owner: plan.speaker,
      text: '玩家说：${plan.action}',
      source: '亲历',
      turn: next.revision,
      importance: important ? 10 : 2,
    );
    await db
        .into(db.roleplayMemories)
        .insert(
          RoleplayMemoriesCompanion.insert(
            id: memory.id,
            worldId: next.worldId,
            owner: memory.owner,
            payload: jsonEncode(memory.toJson()),
          ),
        );
    for (final id in plan.memoryIds) {
      final old =
          await (db.select(db.roleplayMemories)..where(
                (t) =>
                    t.id.equals(id) &
                    t.worldId.equals(next.worldId) &
                    t.owner.equals(plan.speaker),
              ))
              .getSingleOrNull();
      if (old != null) {
        final data = jsonDecode(old.payload) as Map<String, dynamic>;
        data['lastUsed'] = next.revision;
        await (db.update(db.roleplayMemories)..where((t) => t.id.equals(id)))
            .write(RoleplayMemoriesCompanion(payload: Value(jsonEncode(data))));
      }
    }
    cancel.check();
  });
}
