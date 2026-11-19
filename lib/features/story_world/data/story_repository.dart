import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../import_center/data/pending_share_repository.dart';
import '../../import_center/data/story_parsers.dart';
import '../../import_center/domain/import_models.dart';
import '../../roleplay/data/roleplay_repository.dart';
import '../../roleplay/domain/models.dart';
import '../../world_creator/data/world_definition_repository.dart';
import '../../world_creator/application/definition_state_builder.dart';
import '../../world_creator/domain/world_definition.dart';
import '../domain/story_models.dart';

class WorldDraftRepository {
  WorldDraftRepository(this.db);
  final AppDatabase db;
  Future<WorldDraft?> load(String id) async {
    final data = await WorldDefinitionRepository(db).draft('story-$id');
    return data == null ? null : WorldDraft(data);
  }

  Future<void> save(WorldDraft draft) =>
      WorldDefinitionRepository(db).saveDraft('story-${draft.id}', draft.data);
}

class ConversationImportService {
  ConversationImportService(this.db);
  final AppDatabase db;
  Future<List<ImportedMessageRow>> branch(
    String conversation,
    String node,
  ) async {
    final messages = await PendingShareRepository(db).messages(conversation);
    return ConversationNormalizer().branch(
      messages,
      node,
      (m) => m.messageId,
      (m) => m.parentId,
    );
  }

  Future<String> fromWorld(String worldId) => db.transaction(() async {
    final state = await RoleplayRepository(db).load(worldId);
    final world = await (db.select(
      db.worlds,
    )..where((t) => t.id.equals(worldId))).getSingle();
    final turns =
        await (db.select(db.roleplayTurns)
              ..where(
                (t) => t.worldId.equals(worldId) & t.state.equals('completed'),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
            .get();
    final job =
        'local-story-${sha256.convert(utf8.encode(worldId)).toString().substring(0, 24)}-r${state.revision}';
    final repo = PendingShareRepository(db);
    // Snapshot once: later changes to the original world cannot modify this archive.
    await repo.receive(
      IncomingShare(
        id: job,
        source: ImportSource.paste,
        receivedAt: DateTime.now(),
        text: '鱼者本地故事：${world.title}；存档修订 ${state.revision}',
      ),
    );
    final messages = <ImportedMessage>[];
    String? parent;
    for (final t in turns) {
      final user = '${t.id}-user', assistant = '${t.id}-assistant';
      messages.add(
        ImportedMessage(
          id: user,
          parentId: parent,
          role: 'user',
          content: t.action,
          rawJson: jsonEncode({'turnId': t.id, 'revision': t.baseRevision}),
        ),
      );
      final packet = DialoguePacket.parse(t.responseJson!);
      messages.add(
        ImportedMessage(
          id: assistant,
          parentId: user,
          role: 'assistant',
          content: [
            packet.narration,
            ...packet.replies.map((r) => '${r['speaker']}：${r['text']}'),
          ].where((s) => s.isNotEmpty).join('\n'),
          rawJson: t.responseJson!,
        ),
      );
      parent = assistant;
    }
    if (messages.isEmpty) {
      messages.add(
        ImportedMessage(
          id: 'opening',
          role: 'unknown',
          content: state.data['openingScene'] as String? ?? '初始场景未设定',
          rawJson: jsonEncode({'worldId': worldId, 'revision': 0}),
        ),
      );
      parent = 'opening';
    }
    final result = await repo.save(
      job,
      ConversationDraft(
        title: world.title,
        messages: messages,
        currentMessageId: parent,
      ),
      ImportDestination.history,
    );
    return result.conversationId;
  });
}

class WorldRecoveryService {
  WorldRecoveryService(this.db);
  final AppDatabase db;

  static List<Map<String, String>> storyExcerpt(
    List<ImportedMessageRow> branch,
  ) => branch.reversed
      .where(
        (m) =>
            m.body.trim().isNotEmpty &&
            !WorldDefinitionExchange.containsCredential(m.body),
      )
      .take(4)
      .toList()
      .reversed
      .map((m) {
        final runes = m.body.trim().runes;
        final tail = runes.length > 160
            ? '…${String.fromCharCodes(runes.skip(runes.length - 160))}'
            : m.body.trim();
        return {'id': m.messageId, 'role': m.role, 'text': tail};
      })
      .toList();

  Future<String> recover(
    WorldDraft draft, {
    required bool confirmed,
    bool includeMessageTimeline = false,
  }) => db.transaction(() async {
    if (!confirmed) throw const RoleplayFailure('请先确认恢复内容。');
    final branch = await ConversationImportService(db)
        .branch(draft.conversationId, draft.nodeId);
    draft.validate(branch.map((m) => m.messageId).toSet());
    final selected = draft.facts.where((f) => f['accepted'] == true).toList();
    if (selected.any(
      (f) =>
          f['kind'] == 'conflict' ||
          f['kind'] == 'unconfirmed' ||
          f['kind'] == 'inference' ||
          f['kind'] == 'rumor',
    )) {
      throw const RoleplayFailure('请先核实候选内容，或将其保留为未确认。');
    }
    final id = 'world-${DateTime.now().microsecondsSinceEpoch}';
    final d = WorldDefinition.empty(id);
    d.data['title'] = draft.data['title'] as String? ?? '恢复的故事';
    String? one(String category) {
      final f = selected
          .where((f) => f['category'] == category && f['kind'] == 'fact')
          .toList();
      if (f.length > 1) {
        throw const RoleplayFailure('时间、地点、身份或场景存在多项设定，请先解决冲突。');
      }
      return f.firstOrNull?['text'] as String?;
    }

    d.data['description'] = selected
        .where((f) => f['category'] == 'background' && f['kind'] == 'fact')
        .map((f) => f['text'])
        .join('\n');
    final identity = one('player');
    d.data['playerProfile'] = identity == null ? null : {'identity': identity};
    d.data['worldDateTime'] = one('time');
    d.data['startingLocation'] = one('location');
    d.data['openingScene'] = one('scene');
    d.data['worldRules'] = selected
        .where((f) => f['category'] == 'rule' && f['kind'] == 'fact')
        .map((f) => {'id': f['id'], 'kind': 'fact', 'text': f['text']})
        .toList();
    final npcs = selected
        .where((f) => f['category'] == 'npc' && f['kind'] == 'fact')
        .map(
          (f) => {...?f['profile'] as Map?, 'id': f['id'], 'name': f['text']},
        )
        .toList();
    d.data['characterProfiles'] = npcs;
    final style = draft.data['styleDNA'];
    if (draft.data['styleConfirmed'] == true &&
        style is Map &&
        style['sourceMessageIds'] is List &&
        (style['sourceMessageIds'] as List).every(
          (id) => branch.any((m) => m.messageId == id),
        )) {
      // Derived instructions contain metrics only, never private quotes.
      final lengths = branch
          .where((m) => m.role == 'assistant')
          .expand((m) => m.body.split('\n'))
          .where((p) => p.trim().isNotEmpty)
          .map((p) => p.runes.length)
          .toList();
      final average = lengths.isEmpty
          ? 0
          : lengths.reduce((a, b) => a + b) / lengths.length;
      d.data['narrativePreferences'] = {
        'style': average == 0
            ? '原文节奏未确定'
            : average <= 90
            ? '短段落，自然停顿'
            : '连贯长段落',
        'styleSource': 'user-reviewed-local-metrics',
      };
    }
    d.data['relationships'] = selected
        .where(
          (f) =>
              f['category'] == 'relationship' &&
              f['kind'] == 'fact' &&
              f['visibility'] == 'public',
        )
        .map((f) => {'id': f['id'], 'description': f['text']})
        .toList();
    // Provenance remains local story state, not automatically public world lore.
    final v = await WorldDefinitionRepository(db).save(d, expectedVersion: 0);
    final state = DefinitionStateBuilder().build(v);
    state.data['recovery'] = {
      'conversationId': draft.conversationId,
      'nodeId': draft.nodeId,
      'factCount': selected.length,
      'unknownCount': draft.facts.length - selected.length,
    };
    state.data['recoveredFacts'] = selected;
    if (includeMessageTimeline) {
      await db.batch((batch) {
        batch.insertAll(db.timelineEntries, [
          for (final (index, message) in branch.indexed)
            if (message.body.trim().isNotEmpty)
              TimelineEntriesCompanion.insert(
                id: '$id-import-${index.toString().padLeft(6, '0')}',
                worldId: id,
                revision: 0,
                payload: jsonEncode({
                  'category': 'source',
                  'kind': 'record',
                  'sourceRole': message.role,
                  'text': String.fromCharCodes(message.body.runes.take(180)),
                  'sourceMessageIds': [message.messageId],
                  'sourceOrdinal': index,
                }),
              ),
        ]);
      });
    }
    if (draft.data['includeSourceExcerpt'] == true) {
      state.data['importedStoryExcerpt'] = storyExcerpt(branch);
    }
    state.data['activePlotThreads'] = selected
        .where((f) => f['category'] == 'thread' && f['kind'] == 'fact')
        .map((f) => f['text'])
        .toList();
    state.data['knownItems'] = {
      for (final f in selected.where(
        (f) => f['category'] == 'item' && f['kind'] == 'fact',
      ))
        f['id']: f['text'],
    };
    state.data['importantEvents'] = selected
        .where((f) => f['category'] == 'event' && f['kind'] == 'fact')
        .map((f) => f['text'])
        .toList();
    state.data['importedRecent'] = branch.reversed
        .where((m) => ['user', 'assistant'].contains(m.role))
        .take(6)
        .toList()
        .reversed
        .map((m) => {'id': m.messageId, 'role': m.role, 'content': m.body})
        .toList();
    await db
        .into(db.roleplaySaves)
        .insert(
          RoleplaySavesCompanion.insert(
            worldId: id,
            revision: 0,
            payload: jsonEncode(state.data),
          ),
        );
    await db
        .into(db.storyBranches)
        .insert(
          StoryBranchesCompanion.insert(
            worldId: id,
            sourceConversation: Value(draft.conversationId),
            sourceMessageId: Value(draft.nodeId),
          ),
        );
    for (final f in selected.where(
      (f) => [
        'event',
        'promise',
        'secret',
        'relationship',
      ].contains(f['category']),
    )) {
      await db
          .into(db.timelineEntries)
          .insert(
            TimelineEntriesCompanion.insert(
              id: '$id-${f['id']}',
              worldId: id,
              revision: 0,
              payload: jsonEncode(f),
            ),
          );
    }
    await RecoveryCoordinator(db).checkpoint(
      id,
      sourceConversation: draft.conversationId,
      sourceMessageId: draft.nodeId,
    );
    await WorldDraftRepository(db).save(draft);
    return id;
  });
}

class RecoveryCoordinator {
  RecoveryCoordinator(this.db);
  final AppDatabase db;
  Future<String> checkpoint(
    String worldId, {
    String? sourceConversation,
    String? sourceMessageId,
  }) => db.transaction(() async {
    final repo = RoleplayRepository(db);
    final state = await repo.load(worldId),
        memories = await repo.memories(worldId);
    final id = 'checkpoint-${DateTime.now().microsecondsSinceEpoch}';
    await db
        .into(db.storyCheckpoints)
        .insert(
          StoryCheckpointsCompanion.insert(
            id: id,
            worldId: worldId,
            revision: state.revision,
            payload: jsonEncode({
              'state': state.data,
              'memories': memories.map((m) => m.toJson()).toList(),
            }),
            sourceConversation: Value(sourceConversation),
            sourceMessageId: Value(sourceMessageId),
            createdAt: DateTime.now(),
          ),
        );
    return id;
  });
  Future<List<StoryCheckpoint>> checkpoints(String worldId) async =>
      (await (db.select(db.storyCheckpoints)
                ..where((t) => t.worldId.equals(worldId))
                ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
              .get())
          .map((r) {
            final d = jsonDecode(r.payload) as Map;
            return StoryCheckpoint(
              r.id,
              WorldState(Map<String, dynamic>.from(d['state'] as Map)),
              (d['memories'] as List)
                  .map((v) => Map<String, dynamic>.from(v as Map))
                  .toList(),
              r.sourceConversation,
              r.sourceMessageId,
            );
          })
          .toList();
  Future<String> fork(String checkpointId, {required bool confirmed}) =>
      db.transaction(() async {
        if (!confirmed) throw const RoleplayFailure('请确认创建独立分支。');
        final row = await (db.select(
          db.storyCheckpoints,
        )..where((t) => t.id.equals(checkpointId))).getSingle();
        final data = jsonDecode(row.payload) as Map;
        final old = WorldState(Map<String, dynamic>.from(data['state'] as Map));
        final base = await WorldDefinitionRepository(db).editable(row.worldId);
        if (base == null) throw const RoleplayFailure('原世界不可读。');
        final definition = old.data['definitionSnapshot'] is Map
            ? WorldDefinition(
                Map<String, dynamic>.from(
                  old.data['definitionSnapshot'] as Map,
                ),
              )
            : base.definition;
        final copy = await WorldDefinitionRepository(db).duplicate(definition);
        final id = copy.definition.id;
        old.data['worldId'] = id;
        if (old.data['definitionVersion'] != null) {
          old.data['definitionVersion'] = 1;
          old.data['definitionSnapshot'] = copy.definition.toJson();
        }
        await db
            .into(db.roleplaySaves)
            .insert(
              RoleplaySavesCompanion.insert(
                worldId: id,
                revision: old.revision,
                payload: jsonEncode(old.data),
              ),
            );
        for (final raw in data['memories'] as List) {
          final m = Map<String, dynamic>.from(raw as Map);
          m['id'] = '$id-${m['id']}';
          await db
              .into(db.roleplayMemories)
              .insert(
                RoleplayMemoriesCompanion.insert(
                  id: m['id'] as String,
                  worldId: id,
                  owner: m['owner'] as String,
                  payload: jsonEncode(m),
                ),
              );
        }
        final turns =
            await (db.select(db.roleplayTurns)..where(
                  (t) =>
                      t.worldId.equals(row.worldId) &
                      t.state.equals('completed') &
                      t.baseRevision.isSmallerThanValue(old.revision),
                ))
                .get();
        for (final t in turns) {
          await db
              .into(db.roleplayTurns)
              .insert(
                RoleplayTurnsCompanion.insert(
                  id: '$id-${t.id}',
                  worldId: id,
                  baseRevision: t.baseRevision,
                  action: t.action,
                  speaker: t.speaker,
                  contextJson: t.contextJson,
                  state: t.state,
                  responseJson: Value(t.responseJson),
                  mock: t.mock,
                  createdAt: t.createdAt,
                ),
              );
        }
        final timeline =
            await (db.select(db.timelineEntries)..where(
                  (t) =>
                      t.worldId.equals(row.worldId) &
                      t.revision.isSmallerOrEqualValue(old.revision),
                ))
                .get();
        for (final t in timeline) {
          await db
              .into(db.timelineEntries)
              .insert(
                TimelineEntriesCompanion.insert(
                  id: '$id-${t.id}',
                  worldId: id,
                  revision: t.revision,
                  payload: t.payload,
                ),
              );
        }
        await db
            .into(db.storyBranches)
            .insert(
              StoryBranchesCompanion.insert(
                worldId: id,
                parentWorldId: Value(row.worldId),
                checkpointId: Value(checkpointId),
                sourceConversation: Value(row.sourceConversation),
                sourceMessageId: Value(row.sourceMessageId),
              ),
            );
        await checkpoint(
          id,
          sourceConversation: row.sourceConversation,
          sourceMessageId: row.sourceMessageId,
        );
        return id;
      });
}

class EventTimeline {
  EventTimeline(this.db);
  final AppDatabase db;
  Future<List<Map<String, dynamic>>> entries(String worldId) async =>
      (await (db.select(db.timelineEntries)
                ..where((t) => t.worldId.equals(worldId))
                ..orderBy([
                  (t) => OrderingTerm.asc(t.revision),
                  (t) => OrderingTerm.asc(t.id),
                ]))
              .get())
          .map((r) => jsonDecode(r.payload) as Map<String, dynamic>)
          .toList();
}
