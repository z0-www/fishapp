import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/features/world_backup/data/backup_format.dart';
import 'package:fishtextadventure/features/world_backup/data/story_backup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory temp;
  late AppDatabase source;
  late AppDatabase restored;
  late StoryBackup from;
  late StoryBackup target;
  late File archive;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('fish-backup-test-');
    source = AppDatabase.forTesting(NativeDatabase.memory());
    restored = AppDatabase.forTesting(NativeDatabase.memory());
    from = StoryBackup(source, Directory('${temp.path}/source-attachments'));
    target = StoryBackup(
      restored,
      Directory('${temp.path}/target-attachments'),
    );
    archive = File('${temp.path}/story.yuzhe');
  });
  tearDown(() async {
    await source.close();
    await restored.close();
    await temp.delete(recursive: true);
  });

  test(
    'full story restores NPCs, secrets, branches, history, memory and bytes',
    () async {
      await _seed(source, from.attachmentsDirectory);
      await from.export(archive, 'main');
      final preview = await target.inspect(archive);
      expect(preview.titles, containsAll(['茶馆', '支线甲', '支线乙']));
      expect(preview.missingFiles, 0);
      expect(preview.counts['roleplay_turns'], 8);
      expect(preview.counts['imported_messages'], 3);
      final newWorld = await target.restore(archive, preview);
      expect(newWorld, isNot('main'));
      final branches = await restored.select(restored.storyBranches).get();
      expect(branches.map((r) => r.parentWorldId), everyElement(newWorld));
      final checkpoint = await restored
          .select(restored.storyCheckpoints)
          .getSingle();
      expect(branches.map((r) => r.checkpointId), everyElement(checkpoint.id));
      final world = await restored.select(restored.roleplaySaves).getSingle();
      expect(world.worldId, newWorld);
      final state = jsonDecode(world.payload) as Map;
      expect(state['worldId'], newWorld);
      expect(state['relationships'], {'梁砚': '旧友'});
      expect((state['characters'] as List).length, 2);
      expect((state['characters'] as List).first['secret'], '只告诉周巡');
      expect(state['revision'], 8);
      final definition = await restored
          .select(restored.worldDefinitions)
          .getSingle();
      expect((jsonDecode(definition.payload) as Map)['id'], newWorld);
      final turns = await restored.select(restored.roleplayTurns).get();
      expect(turns.length, 8);
      expect(turns.last.responseJson, '{"narration":"雨落在窗边"}');
      final conversation = await restored
          .select(restored.importedConversations)
          .getSingle();
      expect(checkpoint.sourceConversation, conversation.id);
      final messages = await restored.select(restored.importedMessages).get();
      expect(messages.last.parentId, 'original-0');
      expect(messages.last.body, '旧故事的原文 2');
      final attachment = await restored
          .select(restored.importedAttachments)
          .getSingle();
      expect(await File(attachment.privatePath).readAsBytes(), [1, 3, 7, 9]);
      expect(
        await restored.select(restored.roleplayMemories).get(),
        hasLength(1),
      );
      final summary = await restored
          .select(restored.contextSummaries)
          .getSingle();
      final memory = await restored
          .select(restored.roleplayMemories)
          .getSingle();
      expect(
        (jsonDecode(summary.payload) as Map)['entries'].first['id'],
        memory.id,
      );
      expect((state['recovery'] as Map)['conversationId'], conversation.id);
      expect(
        await restored.select(restored.timelineEntries).get(),
        hasLength(1),
      );
      expect(await restored.select(restored.usageRecords).get(), isEmpty);
      final bytes = await archive.readAsString(encoding: latin1);
      expect(bytes, isNot(contains('不要导出这条设备记录')));
      expect(bytes, isNot(contains('source-attachments')));
      expect(bytes, isNot(contains('private-header-value')));
      await expectLater(
        target.restore(archive, preview),
        throwsA(isA<BackupFailure>()),
      );
      expect(await restored.select(restored.worlds).get(), hasLength(3));
    },
  );

  test(
    'corruption after preview rolls back rows and staged attachment files',
    () async {
      await _seed(source, from.attachmentsDirectory);
      await _world(restored, 'original', '保留的存档');
      await from.export(archive, 'main');
      final preview = await target.inspect(archive);
      final bytes = await archive.readAsBytes();
      bytes[bytes.length - 3] ^= 1;
      await archive.writeAsBytes(bytes);
      await expectLater(
        target.restore(archive, preview),
        throwsA(isA<BackupFailure>()),
      );
      expect(
        (await restored.select(restored.worlds).getSingle()).id,
        'original',
      );
      expect(await restored.select(restored.roleplaySaves).get(), isEmpty);
      expect(await target.attachmentsDirectory.list().toList(), isEmpty);
    },
  );

  test(
    'authenticated encryption rejects wrong password and hides story text',
    () async {
      await _world(source, 'main', '不要显示在密文里的标题');
      await from.export(archive, 'main', password: '归档密码示例');
      expect(await StoryBackupFormat.isEncrypted(archive), isTrue);
      expect(
        await archive.readAsString(encoding: latin1),
        isNot(contains('不要显示')),
      );
      await expectLater(
        target.inspect(archive, password: '错误密码'),
        throwsA(isA<BackupFailure>()),
      );
      final review = await target.inspect(archive, password: '归档密码示例');
      await target.restore(archive, review, password: '归档密码示例');
      expect(
        (await restored.select(restored.worlds).getSingle()).title,
        '不要显示在密文里的标题',
      );
    },
  );
}

Future<void> _world(AppDatabase db, String id, String title) => db
    .into(db.worlds)
    .insert(
      WorldsCompanion.insert(
        id: id,
        title: title,
        genre: '悬疑',
        summary: '雨夜',
        createdAt: DateTime.utc(2026),
      ),
    );

Future<void> _seed(AppDatabase db, Directory attachments) async {
  final stamp = DateTime.utc(2026);
  await _world(db, 'main', '茶馆');
  await _world(db, 'fork-a', '支线甲');
  await _world(db, 'fork-b', '支线乙');
  final state = {
    'worldId': 'main',
    'revision': 8,
    'recovery': {'conversationId': 'conversation', 'nodeId': 'original-2'},
    'relationships': {'梁砚': '旧友'},
    'characters': [
      {'id': 'npc-a', 'name': '梁砚', 'secret': '只告诉周巡'},
      {'id': 'npc-b', 'name': '周巡'},
    ],
  };
  await db
      .into(db.roleplaySaves)
      .insert(
        RoleplaySavesCompanion.insert(
          worldId: 'main',
          revision: 8,
          payload: jsonEncode(state),
        ),
      );
  await db
      .into(db.worldDefinitions)
      .insert(
        WorldDefinitionsCompanion.insert(
          worldId: 'main',
          version: 2,
          payload: '{"id":"main","title":"茶馆"}',
          savedAt: stamp,
        ),
      );
  await db
      .into(db.pendingImports)
      .insert(
        PendingImportsCompanion.insert(
          id: 'job',
          fingerprint: 'privacy',
          payload: '{"id":"job","receivedAt":0,"source":"picker","files":[]}',
          state: 'saved',
          receivedAt: stamp,
        ),
      );
  await db
      .into(db.importedConversations)
      .insert(
        ImportedConversationsCompanion.insert(
          id: 'conversation',
          jobId: 'job',
          title: '茶馆原文',
          source: 'picker',
          worldId: const Value('main'),
          currentMessageId: const Value('original-2'),
          createdAt: stamp,
        ),
      );
  for (var i = 0; i < 3; i++) {
    await db
        .into(db.importedMessages)
        .insert(
          ImportedMessagesCompanion.insert(
            conversationId: 'conversation',
            messageId: 'original-$i',
            parentId: Value(i == 0 ? null : 'original-0'),
            role: i == 0 ? 'user' : 'assistant',
            body: '旧故事的原文 $i',
            rawJson: '{"authorization":"private-header-value","other":true}',
            ordinal: i,
          ),
        );
  }
  final local = File('${attachments.path}/notes.bin');
  await local.create(recursive: true);
  await local.writeAsBytes([1, 3, 7, 9]);
  await db
      .into(db.importedAttachments)
      .insert(
        ImportedAttachmentsCompanion.insert(
          conversationId: 'conversation',
          privatePath: local.path,
          displayName: 'notes.bin',
          mime: 'application/octet-stream',
          byteSize: 4,
          digest: '',
        ),
      );
  await db
      .into(db.storyCheckpoints)
      .insert(
        StoryCheckpointsCompanion.insert(
          id: 'parent-point',
          worldId: 'main',
          revision: 8,
          payload: jsonEncode({'state': state, 'memories': []}),
          sourceConversation: const Value('conversation'),
          sourceMessageId: const Value('original-2'),
          createdAt: stamp,
        ),
      );
  for (final branch in ['fork-a', 'fork-b']) {
    await db
        .into(db.storyBranches)
        .insert(
          StoryBranchesCompanion.insert(
            worldId: branch,
            parentWorldId: const Value('main'),
            checkpointId: const Value('parent-point'),
          ),
        );
  }
  for (var i = 0; i < 8; i++) {
    await db
        .into(db.roleplayTurns)
        .insert(
          RoleplayTurnsCompanion.insert(
            id: 'turn-$i',
            worldId: 'main',
            baseRevision: i,
            action: '敲门',
            speaker: 'npc-a',
            contextJson: '[]',
            state: 'completed',
            responseJson: const Value('{"narration":"雨落在窗边"}'),
            mock: false,
            createdAt: stamp,
          ),
        );
  }
  await db
      .into(db.roleplayMemories)
      .insert(
        RoleplayMemoriesCompanion.insert(
          id: 'memory-a',
          worldId: 'main',
          owner: 'npc-a',
          payload: '{"id":"memory-a","text":"钟楼往事"}',
        ),
      );
  await db
      .into(db.contextSummaries)
      .insert(
        ContextSummariesCompanion.insert(
          worldId: 'main',
          owner: 'npc-a',
          version: 1,
          throughRevision: 6,
          payload:
              '{"entries":[{"id":"memory-a","owner":"npc-a","text":"钟楼往事"}]}',
        ),
      );
  await db
      .into(db.timelineEntries)
      .insert(
        TimelineEntriesCompanion.insert(
          id: 'event-a',
          worldId: 'main',
          revision: 3,
          payload: '{"event":"茶馆开门"}',
        ),
      );
  await db
      .into(db.worldDrafts)
      .insert(
        WorldDraftsCompanion.insert(
          id: 'device-only',
          payload: '不要导出这条设备记录',
          updatedAt: stamp,
        ),
      );
}
