import '../support/scripted_dialogue.dart';

import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/features/import_center/data/story_parsers.dart';
import 'package:fishtextadventure/features/import_center/data/conversation_parsers.dart';
import 'package:fishtextadventure/features/import_center/data/pending_share_repository.dart';
import 'package:fishtextadventure/features/import_center/domain/import_models.dart';
import 'package:fishtextadventure/features/story_world/domain/story_models.dart';
import 'package:fishtextadventure/features/story_world/data/story_repository.dart';
import 'package:fishtextadventure/features/story_world/application/context_engine.dart';
import 'package:fishtextadventure/features/story_world/application/extraction_pipeline.dart';
import 'package:fishtextadventure/features/world_creator/data/world_definition_repository.dart';
import 'package:fishtextadventure/features/roleplay/data/roleplay_repository.dart';
import 'package:fishtextadventure/features/roleplay/application/turn_coordinator.dart';
import 'package:fishtextadventure/features/roleplay/domain/models.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_config.dart';
import 'package:fishtextadventure/features/usage/usage_repository.dart';

import 'world_creator_test.dart' show NoKeyStorage;

Map<String, dynamic> sessionFixture(int rounds, {bool fork = false}) {
  final messages = <Map<String, dynamic>>[];
  for (var i = 0; i < rounds * 2; i++) {
    messages.add({
      'id': i,
      'parent_id': i == 0 ? null : i - 1,
      'role': i.isEven ? 'USER' : 'ASSISTANT',
      'status': i == rounds * 2 - 1 ? 'INCOMPLETE' : 'FINISHED',
      'thinking_enabled': false,
      'search_enabled': false,
      'accumulated_token_usage': 0,
      'inserted_at': '2026-11-17T00:00:00Z',
      'fragments': [
        {
          'type': i.isEven ? 'REQUEST' : 'RESPONSE',
          'content': i == 0
              ? '世界背景：1927年的上海\n玩家身份：年轻记者\n地点：上海火车站\n人物：陈编辑'
              : '第$i条对话，角色说过的话不一定是真相。',
        },
      ],
      'unknown_preserved': i,
    });
  }
  if (fork) {
    messages.add({
      'id': rounds * 2,
      'parent_id': 0,
      'role': 'ASSISTANT',
      'status': 'FINISHED',
      'fragments': [
        {'type': 'RESPONSE', 'content': '另一条没有发生在当前分支的回复'},
      ],
    });
  }
  return {
    'id': 'story',
    'title': '原始上海故事',
    'pinned': false,
    'current_message_id': rounds * 2 - 1,
    'inserted_at': '2026-11-17T00:00:00Z',
    'updated_at': '2026-11-17T00:00:00Z',
    'messages': messages,
  };
}

List<int> zipFixture(
  Map<String, dynamic> session, {
  int version = 3,
  String? extraPath,
}) {
  final archive = Archive()
    ..add(
      ArchiveFile.string(
        'manifest.json',
        jsonEncode({'export_format_version': version}),
      ),
    )
    ..add(ArchiveFile.string('chat_sessions/story.json', jsonEncode(session)))
    ..add(
      ArchiveFile.string(
        'chat_session_index.json',
        jsonEncode([
          {
            'id': 'story',
            'title': session['title'],
            'message_count': (session['messages'] as List).length,
          },
        ]),
      ),
    );
  if (extraPath != null) archive.add(ArchiveFile.string(extraPath, 'no'));
  return ZipEncoder().encode(archive);
}

Map<String, dynamic> fact(
  String id,
  String category,
  String text,
  String source, {
  String kind = 'fact',
  String visibility = 'public',
  List<String> owners = const [],
}) => {
  'id': id,
  'category': category,
  'text': text,
  'kind': kind,
  'visibility': visibility,
  'owners': owners,
  'sourceMessageIds': [source],
  'confidence': .8,
  'accepted': true,
};

class PlanningFixtureConfig extends DeepSeekConfig {
  const PlanningFixtureConfig();
  @override
  bool get permitsDirectCalls => true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late PendingShareRepository imports;
  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    imports = PendingShareRepository(db);
  });
  tearDown(() async {
    await db.close();
  });
  Future<String> archive({int rounds = 20, bool fork = true}) async {
    final raw = sessionFixture(rounds, fork: fork);
    final job = 'raw-$rounds';
    await imports.receive(
      IncomingShare(
        id: job,
        source: ImportSource.paste,
        receivedAt: DateTime.now(),
        text: jsonEncode(raw),
        mime: 'application/json',
      ),
    );
    final parsed = DeepSeekArchiveParser().session(raw);
    return (await imports.save(
      job,
      parsed,
      ImportDestination.history,
    )).conversationId;
  }

  Future<WorldDraft> reviewed(String c, {String node = '39'}) async =>
      WorldDraft({
        'id': 'review',
        'conversationId': c,
        'nodeId': node,
        'title': '审核后的故事',
        'facts': [
          fact('bg', 'background', '1927年的上海', '0'),
          fact('identity', 'player', '年轻记者', '0'),
          fact('where', 'location', '上海火车站', '0'),
          fact('npc-editor', 'npc', '陈编辑', '0'),
          fact('event', 'event', '记者已经下火车', '0'),
          fact('promise', 'promise', '我承诺送信', '0', kind: 'utterance'),
          fact(
            'hidden',
            'secret',
            '口令是夜雨',
            '0',
            visibility: 'private',
            owners: ['npc-editor'],
          ),
          fact('rumor', 'unknown', '传闻有人失踪', '0', kind: 'rumor')
            ..['accepted'] = false,
        ],
      });
  for (final n in [20, 200, 500]) {
    test(
      '$n rounds ZIP preserves full message tree, current branch and raw unknowns',
      () async {
        final raw = sessionFixture(n, fork: true);
        final parsed = DeepSeekArchiveParser().parseBytes(
          zipFixture(raw),
          ImportCancellation(),
        );
        expect(parsed.messages.length, n * 2 + 1);
        expect(parsed.currentMessageId, 'story:${n * 2 - 1}');
        expect(parsed.messages.first.rawJson, contains('unknown_preserved'));
        final branch = ConversationNormalizer().branch(
          parsed.messages,
          parsed.currentMessageId!,
          (m) => m.id,
          (m) => m.parentId,
        );
        expect(branch.length, n * 2);
        expect(branch.any((m) => m.content.contains('另一条')), false);
        expect(parsed.warnings.join(), contains('中断'));
      },
    );
  }
  test('ZIP rejects traversal, unknown versions, corruption and inconsistent index', () {
    expect(DeepSeekArchiveParser.safePath(r'folder\escape'), false);
    for (final name in ['../escape', 'C:/escape']) {
      expect(
        () => DeepSeekArchiveParser().parseBytes(
          zipFixture(sessionFixture(2), extraPath: name),
          ImportCancellation(),
        ),
        throwsA(isA<ImportFailure>()),
      );
    }
    expect(
      () => DeepSeekArchiveParser().parseBytes(
        zipFixture(sessionFixture(2), version: 99),
        ImportCancellation(),
      ),
      throwsA(isA<ImportFailure>()),
    );
    final bytes = zipFixture(sessionFixture(2));
    expect(
      () => DeepSeekArchiveParser().parseBytes(
        bytes.sublist(0, bytes.length ~/ 2),
        ImportCancellation(),
      ),
      throwsA(isA<ImportFailure>()),
    );
  });
  test('labelled text identifies speakers and retains exact source, unlabeled remains unknown', () async {
    const text = '用户：我到了。\n助手：陈编辑挥手。\n用户：你好。';
    final parsed = await PlainTextParser().parse(
      text,
      [],
      ImportCancellation(),
    );
    expect(parsed.messages.map((m) => m.role), ['user', 'assistant', 'user']);
    expect(parsed.messages.last.parentId, '1');
    expect(
      parsed.messages
          .map((m) => (jsonDecode(m.rawJson) as Map)['segment'])
          .join(),
      text,
    );
    final unknown = await PlainTextParser().parse(
      '没有角色标签',
      [],
      ImportCancellation(),
    );
    expect(unknown.messages.single.role, 'unknown');
  });
  test(
    'registry prefixes parents and selected tip consistently for JSON text',
    () async {
      final raw = jsonEncode(sessionFixture(3, fork: true));
      final parsed = await const ImportParserRegistry().parse(
        IncomingShare(
          id: 'json',
          source: ImportSource.paste,
          receivedAt: DateTime.now(),
          text: raw,
          mime: 'application/json',
        ),
        ImportCancellation(),
        (_) {},
      );
      final branch = ConversationNormalizer().branch(
        parsed.messages,
        parsed.currentMessageId!,
        (m) => m.id,
        (m) => m.parentId,
      );
      expect(branch.length, 6);
      expect(parsed.messages.length, 7);
    },
  );
  test(
    'raw archives stay immutable and duplicate import is idempotent',
    () async {
      final c = await archive();
      final before = await imports.messages(c);
      expect(before.length, 41);
      expect(await archive(), c);
      expect(
        (await imports.messages(c)).map((m) => m.rawJson),
        before.map((m) => m.rawJson),
      );
      expect((await imports.history()).length, 1);
    },
  );
  test(
    'extraction plans are bounded and blocked calls require no key or usage',
    () async {
      final c = await archive(rounds: 500);
      final branch = await ConversationImportService(db).branch(c, '999');
      final key = NoKeyStorage();
      final pipeline = WorldExtractionPipeline(
        const DeepSeekConfig(),
        key,
        UsageRepository(db),
      );
      expect(
        () => pipeline.prepare(c, '999', '长故事', branch),
        throwsA(isA<RoleplayFailure>()),
      );
      // Exercise planning with a test double. The restricted pipeline handles all execution attempts.
      final planner = WorldExtractionPipeline(
        const PlanningFixtureConfig(),
        key,
        UsageRepository(db),
      );
      final plan = planner.prepare(c, '999', '长故事', branch);
      expect(plan.chunks.length, greaterThan(1));
      expect(
        plan.chunks.every(
          (chunk) => utf8.encode(jsonEncode(chunk)).length < 6500,
        ),
        true,
      );
      await expectLater(
        pipeline.extract(plan, confirmed: false),
        throwsA(isA<RoleplayFailure>()),
      );
      expect(key.reads, 0);
      expect(await UsageRepository(db).load(), isEmpty);
      await expectLater(
        pipeline.extract(plan, confirmed: true),
        throwsA(isA<RoleplayFailure>()),
      );
    },
  );
  test('unsupported provenance and unresolved conflict roll back all new world state', () async {
    final c = await archive();
    final draft = await reviewed(c);
    draft.data['facts'] = [fact('bad', 'event', '猜测发生了爆炸', 'missing')];
    await expectLater(
      WorldRecoveryService(db).recover(draft, confirmed: true),
      throwsA(isA<RoleplayFailure>()),
    );
    expect(await db.select(db.worlds).get(), isEmpty);
    draft.data['facts'] = [fact('bad', 'event', '矛盾事件', '0', kind: 'conflict')];
    await expectLater(
      WorldRecoveryService(db).recover(draft, confirmed: true),
      throwsA(isA<RoleplayFailure>()),
    );
    expect(await db.select(db.worlds).get(), isEmpty);
    expect((await imports.messages(c)).length, 41);
  });
  test('reviewed recovery restores node, identity, relationships, events and owner-scoped secrets', () async {
    final c = await archive();
    final d = await reviewed(c);
    (d.data['facts'] as List).add(fact('rel', 'relationship', '陈编辑认识记者', '0'));
    final id = await WorldRecoveryService(db).recover(d, confirmed: true);
    final state = await RoleplayRepository(db).load(id);
    expect(state.data['recovery']['nodeId'], '39');
    expect(state.playerLocation, '上海火车站');
    expect(state.data['playerProfile']['identity'], '年轻记者');
    expect(state.characters.single.name, '陈编辑');
    expect(state.data['importantEvents'], ['记者已经下火车']);
    expect(state.data['knownItems'], isEmpty);
    expect(
      KnowledgeBoundary()
          .visibleFacts(state, 'other')
          .any((f) => f['category'] == 'secret'),
      false,
    );
    expect(
      KnowledgeBoundary()
          .visibleFacts(state, 'npc-editor')
          .any((f) => f['text'] == '口令是夜雨'),
      true,
    );
    expect(
      (await EventTimeline(db).entries(id))
          .any((f) => f['category'] == 'relationship'),
      true,
    );
    expect((await imports.messages(c)).length, 41);
  });
  test('story excerpt is opt-in and bounded to the selected branch', () async {
    final c = await archive();
    final d = await reviewed(c, node: '1');
    final service = WorldRecoveryService(db);
    final first = await service.recover(d, confirmed: true);
    final without = await RoleplayRepository(db).load(first);
    expect(without.data['importedStoryExcerpt'], isNull);

    d.data['includeSourceExcerpt'] = true;
    final second = await service.recover(d, confirmed: true);
    final withExcerpt = await RoleplayRepository(db).load(second);
    final branch = await ConversationImportService(db).branch(c, '1');
    final excerpt = WorldRecoveryService.storyExcerpt(branch);
    expect(excerpt, hasLength(2));
    expect(withExcerpt.data['importedStoryExcerpt'], excerpt);
    expect((await imports.messages(c)).length, 41);
  });

  test('narrator receives approved excerpts and narration memory within its knowledge boundary', () async {
    final c = await archive();
    final d = await reviewed(c, node: '4');
    d.data['includeSourceExcerpt'] = true;
    d.data['facts'] = d.facts.where((f) => f['category'] != 'npc').map((f) {
      if (f['category'] == 'secret') {
        return {
          ...f,
          'sourceMessageIds': ['3'],
        };
      }
      return f;
    }).toList();
    final world = await WorldRecoveryService(db).recover(d, confirmed: true);
    final repo = RoleplayRepository(db);
    for (final (owner, text) in [
      ('narrator', '旁白亲历的码头事件'),
      ('npc-editor', '旁白不能获知的暗号'),
    ]) {
      await db
          .into(db.roleplayMemories)
          .insert(
            RoleplayMemoriesCompanion.insert(
              id: 'private-$owner',
              worldId: world,
              owner: owner,
              payload: jsonEncode(
                PersonalMemory(
                  id: 'private-$owner',
                  owner: owner,
                  text: text,
                  source: '亲历',
                  turn: 0,
                  importance: 9,
                ).toJson(),
              ),
            ),
          );
    }
    final core = TurnCoordinator(
      repo,
      ScriptedDialogueEngine(),
      UsageRepository(db),
    );
    final plan = await core.prepare(world, '我回想在码头看到的线索。');
    expect(plan.speaker, 'narrator');
    final context = jsonEncode(plan.messages);
    expect(context, contains('第4条对话'));
    expect(context, contains('旁白亲历的码头事件'));
    expect(context, isNot(contains('第3条对话')));
    expect(context, isNot(contains('旁白不能获知的暗号')));
  });

  test('official JSON accepts numeric string ids and keeps foreign fragments out of prose', () async {
    final fixture = sessionFixture(2, fork: true);
    fixture['current_message_id'] = '3';
    final rows = fixture['messages'] as List<Map<String, dynamic>>;
    for (final row in rows) {
      row['message_id'] = row['id'].toString();
      row['parent_id'] = row['parent_id']?.toString();
    }
    (rows[1]['fragments'] as List).add({'type': 'REQUEST', 'content': '错角色片段'});
    final draft = await JsonConversationParser().parse(
      jsonEncode(fixture),
      [],
      ImportCancellation(),
    );
    expect(draft.currentMessageId, '3');
    expect(draft.branches, 1);
    expect(draft.messages[1].parentId, '0');
    expect(draft.messages[1].content, isNot(contains('错角色片段')));
    expect(draft.messages[1].rawJson, contains('错角色片段'));
  });

  test('recovering a selected old node excludes later evidence and keeps original archive', () async {
    final c = await archive();
    final d = await reviewed(c, node: '1');
    final id = await WorldRecoveryService(db).recover(d, confirmed: true);
    expect(
      (await RoleplayRepository(db).load(id)).data['importedRecent'].length,
      2,
    );
    expect((await imports.messages(c)).length, 41);
    final bad = await reviewed(c, node: '1');
    bad.data['facts'] = [fact('late', 'event', '之后的事', '39')];
    await expectLater(
      WorldRecoveryService(db).recover(bad, confirmed: true),
      throwsA(isA<RoleplayFailure>()),
    );
  });
  test('checkpoint fork copies only checkpoint-era history and memories without replacing parent', () async {
    final c = await archive();
    final d = await reviewed(c);
    final id = await WorldRecoveryService(db).recover(d, confirmed: true);
    final rp = RoleplayRepository(db);
    final core = FishRoleplayCore(
      rp,
      ScriptedDialogueEngine(latency: Duration.zero),
      UsageRepository(db),
    );
    final initial = (await RecoveryCoordinator(db).checkpoints(id)).single;
    await core.execute(
      await core.prepare(id, '我向车站外望去。'),
      TurnCancellation(),
      confirmed: true,
    );
    final fork = await RecoveryCoordinator(db)
        .fork(initial.id, confirmed: true);
    expect((await rp.load(fork)).revision, 0);
    expect(await rp.history(fork), isEmpty);
    expect((await rp.load(id)).revision, 1);
    expect(await rp.memories(fork), isEmpty);
    expect((await db.select(db.storyBranches).get()).length, 2);
  });
  test('incremental memory index preserves exact promises and rejects lossy rewrite', () async {
    final c = await archive();
    final d = await reviewed(c);
    final id = await WorldRecoveryService(db).recover(d, confirmed: true);
    final rp = RoleplayRepository(db);
    final core = FishRoleplayCore(
      rp,
      ScriptedDialogueEngine(latency: Duration.zero),
      UsageRepository(db),
    );
    await core.execute(
      await core.prepare(id, '我承诺明天再来。'),
      TurnCancellation(),
      confirmed: true,
    );
    final compressor = ContextCompressor(db);
    final preview = await compressor.preview(id, 'narrator');
    await expectLater(
      compressor.commit(preview, confirmed: false),
      throwsA(isA<RoleplayFailure>()),
    );
    await compressor.commit(preview, confirmed: true);
    expect((await compressor.preview(id, 'narrator'))['newEntries'], 0);
    expect((await rp.memories(id)).single.text, contains('承诺'));
    final broken = await compressor.preview(id, 'narrator');
    (broken['candidate'] as Map)['entries'] = [];
    await expectLater(
      compressor.commit(broken, confirmed: true),
      throwsA(isA<RoleplayFailure>()),
    );
    expect((await db.select(db.contextSummaries).get()).length, 1);
    expect(await compressor.retrieve(id, 'other', '承诺'), isEmpty);
  });
  test(
    'baseline/enhanced comparison reports estimates only and keeps hard facts',
    () async {
      final c = await archive(rounds: 200);
      final d = await reviewed(c, node: '399');
      final id = await WorldRecoveryService(db).recover(d, confirmed: true);
      final state = await RoleplayRepository(db).load(id);
      final history = (await imports.messages(c))
          .map((m) => {'role': m.role, 'content': m.body})
          .toList();
      final assembler = PromptAssembler();
      final baseline = assembler.baseline(state.data, history, '你好');
      final enhanced = assembler.assemble(
        state: state,
        owner: 'narrator',
        scene: {'time': state.displayTime, 'location': state.displayLocation},
        instruction: '只控制世界，不控制玩家。',
        action: '你好',
        recent: history.reversed.take(6).toList().reversed.toList(),
      );
      expect(
        const ContextBudgetManager().estimate(enhanced),
        lessThan(const ContextBudgetManager().estimate(baseline)),
      );
      expect(jsonEncode(enhanced), contains('年轻记者'));
      expect(jsonEncode(enhanced), isNot(contains('口令是夜雨')));
      expect(await UsageRepository(db).load(), isEmpty);
    },
  );
  test(
    'database restart retains review, source tree and recovered checkpoint',
    () async {
      final c = await archive();
      final d = await reviewed(c);
      final id = await WorldRecoveryService(db).recover(d, confirmed: true);
      final snapshot = (await RoleplayRepository(db).load(id)).data;
      await WorldDraftRepository(db).save(d);
      final directory = Directory.systemTemp.createTempSync(
        'fish_story_reopen_',
      );
      final file = File('${directory.path}/story.sqlite');
      await db.customStatement('VACUUM INTO ?', [file.path]);
      await db.close();
      db = AppDatabase.forTesting(NativeDatabase(file));
      imports = PendingShareRepository(db);
      addTearDown(() async {
        await db.close();
        db = AppDatabase.forTesting(NativeDatabase.memory());
        directory.deleteSync(recursive: true);
      });
      expect((await WorldDraftRepository(db).load(d.id))!.facts, d.facts);
      expect(
        (await RecoveryCoordinator(db).checkpoints(id)).single.state.data,
        snapshot,
      );
      expect(
        (await imports.messages(c)).first.rawJson,
        contains('unknown_preserved'),
      );
    },
  );
  test(
    'deleting a world leaves archived source and unrelated worlds intact',
    () async {
      final c = await archive();
      final one = await WorldRecoveryService(db)
          .recover(await reviewed(c), confirmed: true);
      final two = await WorldRecoveryService(db)
          .recover(await reviewed(c), confirmed: true);
      await WorldDefinitionRepository(db).deleteWorld(one);
      expect((await RoleplayRepository(db).load(two)).revision, 0);
      expect((await imports.messages(c)).length, 41);
      expect((await db.select(db.storyCheckpoints).get()).single.worldId, two);
    },
  );
}
