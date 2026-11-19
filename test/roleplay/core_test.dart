import '../support/scripted_dialogue.dart';

import 'package:sqlite3/sqlite3.dart';
import 'package:fishtextadventure/features/import_center/data/pending_share_repository.dart';
import 'package:fishtextadventure/features/import_center/domain/import_models.dart';

import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/features/roleplay/domain/models.dart';
import 'package:fishtextadventure/features/roleplay/domain/character_engine.dart';
import 'package:fishtextadventure/features/roleplay/domain/memory_engine.dart';
import 'package:fishtextadventure/features/roleplay/domain/world_context_builder.dart';
import 'package:fishtextadventure/features/roleplay/domain/world_state_validator.dart';

import '../support/scenario_fixtures.dart';

import 'package:fishtextadventure/features/roleplay/data/roleplay_repository.dart';
import 'package:fishtextadventure/features/roleplay/application/dialogue_engine.dart';
import 'package:fishtextadventure/features/roleplay/application/turn_coordinator.dart';
import 'package:fishtextadventure/features/usage/usage_repository.dart';

DialoguePacket packet({
  String speaker = 'npc-0',
  String text = '先说清楚依据。',
  Map<String, dynamic>? proposal,
}) => DialoguePacket(
  narration: '',
  replies: [
    {'speaker': speaker, 'text': text},
  ],
  proposal: proposal ?? {'minutes': 1},
);

class FailingEngine implements DialogueEngine {
  @override
  Future<DialogueOutput> generate(TurnPlan p, TurnCancellation c) async =>
      throw const RoleplayFailure('测试网络失败');
}

void main() {
  late bool closeSetup;
  late AppDatabase db;
  late RoleplayRepository repo;
  late TurnCoordinator core;
  setUp(() async {
    closeSetup = true;
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = RoleplayRepository(db);
    await db
        .into(db.worlds)
        .insert(
          WorldsCompanion.insert(
            id: 'w',
            title: '试玩',
            genre: '测试',
            summary: '原始世界介绍',
            createdAt: DateTime(2026),
          ),
        );
    await insertScenario(db, 'w');
    core = FishRoleplayCore(
      repo,
      ScriptedDialogueEngine(latency: Duration.zero),
      UsageRepository(db),
    );
  });
  tearDown(() async {
    if (closeSetup) await db.close();
  });
  test(
    'different NPCs respond differently without unconditional obedience',
    () async {
      final replies = <String>[];
      for (final id in ['npc-0', 'npc-1', 'npc-2']) {
        final plan = await core.prepare(
          'w',
          '把全部资料交给我，我保证你的安全。',
          addressed: id,
        );
        final output = await ScriptedDialogueEngine(latency: Duration.zero)
            .generate(plan, TurnCancellation());
        replies.add(
          DialoguePacket.parse(output.body).replies.single['text'] as String,
        );
        expect(
          CharacterDecisionEngine().decide(
            plan.state.characters.firstWhere((c) => c.id == id),
            plan.action,
          ),
          isNot(contains('无条件同意')),
        );
      }
      expect(replies.toSet().length, 3);
    },
  );
  test('important promises are remembered across long conversation, sources stay labelled', () async {
    await core.execute(
      await core.prepare('w', '我承诺明天带来那封回信。', addressed: 'npc-0'),
      TurnCancellation(),
      confirmed: true,
    );
    for (var i = 0; i < 30; i++) {
      await core.execute(
        await core.prepare('w', '聊聊今天的茶 $i', addressed: 'npc-0'),
        TurnCancellation(),
        confirmed: true,
      );
    }
    final plan = await core.prepare('w', '你还记得我答应做什么吗？', addressed: 'npc-0');
    expect(jsonEncode(plan.messages), contains('带来那封回信'));
    final result = await ScriptedDialogueEngine(latency: Duration.zero)
        .generate(plan, TurnCancellation());
    expect(result.body, contains('带来那封回信'));
    final m = PersonalMemory(
      id: 'rumor',
      owner: 'npc-0',
      text: '听说码头停航',
      source: '听说',
      turn: 0,
      importance: 9,
    );
    expect(MemoryEngine().retrieve([m], 'npc-0', '码头', 32).single.source, '听说');
  });
  test('private secret and firsthand history do not reach other NPCs or other worlds', () async {
    await core.execute(
      await core.prepare('w', '只告诉你：钟楼暗号是蓝鸟。', addressed: 'npc-0'),
      TurnCancellation(),
      confirmed: true,
    );
    final b = await core.prepare('w', '钟楼有什么消息？', addressed: 'npc-1');
    expect(jsonEncode(b.messages), isNot(contains('蓝鸟')));
    expect(
      MemoryEngine().retrieve(await repo.memories('w'), 'npc-1', '蓝鸟', 2),
      isEmpty,
    );
    await db
        .into(db.worlds)
        .insert(
          WorldsCompanion.insert(
            id: 'other',
            title: '另一个',
            genre: '测试',
            summary: '',
            createdAt: DateTime(2026),
          ),
        );
    await repo.initialize('other');
    expect(await repo.memories('other'), isEmpty);
  });
  test('absent and dead characters never get speaking rights', () {
    final s = RoleplayScenarios.create('w');
    (s.data['characters'] as List)[1]['currentLocation'] = '街边公园';
    (s.data['characters'] as List)[2]['alive'] = false;
    expect(CharacterDecisionEngine().speakers(s, 'npc-1'), isEmpty);
    expect(s.presentCharacters.map((c) => c.id), ['npc-0']);
    expect(
      () => WorldStateValidator().validate(s, packet(speaker: 'npc-1'), {
        'npc-0',
      }),
      throwsA(isA<RoleplayFailure>()),
    );
  });
  test('NPC teleport, resurrection and inventory fabrication rejected', () {
    final s = RoleplayScenarios.create('w');
    final v = WorldStateValidator();
    for (final p in [
      {
        'minutes': 1,
        'npcMoves': [
          {'id': 'npc-0', 'to': '火星', 'reason': '突然想去旅游'},
        ],
      },
      {'alive': true},
      {
        'inventory': ['凭空宝剑'],
      },
    ]) {
      expect(
        () => v.validate(s, packet(proposal: p), {'npc-0'}),
        throwsA(isA<RoleplayFailure>()),
      );
    }
    expect(s.characters.first.currentLocation, '街角咖啡馆');
  });
  test(
    'time bounds, identity changes and forced player decisions rejected',
    () {
      final s = RoleplayScenarios.create('w');
      final v = WorldStateValidator();
      for (final p in [
        {'minutes': -1},
        {'minutes': 300},
        {'occupation': '医生'},
        {'playerLocation': '街边公园'},
      ]) {
        expect(
          () => v.validate(s, packet(proposal: p), {'npc-0'}),
          throwsA(isA<RoleplayFailure>()),
        );
      }
      expect(
        () => v.validate(s, packet(text: '你决定交出钥匙'), {'npc-0'}),
        throwsA(isA<RoleplayFailure>()),
      );
      expect(
        v
            .validate(s, packet(), {'npc-0'})
            .currentTime
            .difference(s.currentTime)
            .inMinutes,
        1,
      );
    },
  );
  test('explicit player travel works and empty scene can return without inventing NPCs', () async {
    await core.execute(
      await core.prepare('w', '前往公园', destination: '街边公园'),
      TurnCancellation(),
      confirmed: true,
    );
    expect((await repo.load('w')).playerLocation, '街边公园');
    final empty = await core.prepare('w', '我在这里看看');
    expect(empty.speaker, 'narrator');
    await core.execute(empty, TurnCancellation(), confirmed: true);
    await core.execute(
      await core.prepare('w', '回咖啡馆', destination: '街角咖啡馆'),
      TurnCancellation(),
      confirmed: true,
    );
    expect((await repo.load('w')).presentCharacters.length, 3);
  });
  test(
    'one speaker per turn and duplicate or endless dialogue prohibited',
    () async {
      final s = await repo.load('w');
      expect(CharacterDecisionEngine().speakers(s, null).length, 1);
      final repeated = DialoguePacket(
        narration: '',
        replies: [
          {'speaker': 'npc-0', 'text': '一'},
          {'speaker': 'npc-0', 'text': '二'},
        ],
        proposal: {},
      );
      expect(
        () => WorldStateValidator().validate(s, repeated, {'npc-0'}),
        throwsA(isA<RoleplayFailure>()),
      );
    },
  );
  test('API failure does not mutate state or original worlds', () async {
    final failed = TurnCoordinator(repo, FailingEngine(), UsageRepository(db));
    final before = jsonEncode((await repo.load('w')).data);
    await expectLater(
      failed.execute(
        await failed.prepare('w', '你好'),
        TurnCancellation(),
        confirmed: true,
      ),
      throwsA(isA<RoleplayFailure>()),
    );
    expect(jsonEncode((await repo.load('w')).data), before);
    expect(await repo.history('w'), isEmpty);
    expect((await db.select(db.worlds).get()).single.summary, '原始世界介绍');
  });
  test('cancel generation commits no unvalidated state; fresh retry saves exactly once', () async {
    final slow = TurnCoordinator(
      repo,
      ScriptedDialogueEngine(latency: const Duration(milliseconds: 80)),
      UsageRepository(db),
    );
    final plan = await slow.prepare('w', '等等');
    final token = TurnCancellation();
    final future = slow.execute(plan, token, confirmed: true);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    token.cancel();
    await expectLater(future, throwsA(isA<RoleplayFailure>()));
    expect((await repo.load('w')).revision, 0);
    final retry = await core.prepare('w', '重新开始');
    await core.execute(retry, TurnCancellation(), confirmed: true);
    await expectLater(
      core.execute(retry, TurnCancellation(), confirmed: true),
      throwsA(isA<RoleplayFailure>()),
    );
    expect((await repo.history('w')).length, 1);
    expect((await repo.load('w')).revision, 1);
  });
  test(
    'budget confirmation is mandatory and stale plans cannot overwrite saves',
    () async {
      final first = await core.prepare('w', '第一步');
      final stale = await core.prepare('w', '过期行动');
      await expectLater(
        core.execute(first, TurnCancellation(), confirmed: false),
        throwsA(isA<RoleplayFailure>()),
      );
      expect(await repo.history('w'), isEmpty);
      await core.execute(first, TurnCancellation(), confirmed: true);
      await expectLater(
        core.execute(stale, TurnCancellation(), confirmed: true),
        throwsA(isA<RoleplayFailure>()),
      );
      expect((await repo.load('w')).revision, 1);
    },
  );
  test(
    'completed scene persists after SQLite close and process-style recreation',
    () async {
      await db.close();
      closeSetup = false;
      final dir = Directory.systemTemp.createTempSync('fish_roleplay_restart_');
      final file = File('${dir.path}/save.sqlite');
      final first = AppDatabase.forTesting(NativeDatabase(file));
      await first
          .into(first.worlds)
          .insert(
            WorldsCompanion.insert(
              id: 'saved',
              title: '旧世界',
              genre: '',
              summary: '保留',
              createdAt: DateTime(2026),
            ),
          );
      final r = RoleplayRepository(first);
      await insertScenario(first, 'saved');
      final c = TurnCoordinator(
        r,
        ScriptedDialogueEngine(latency: Duration.zero),
        UsageRepository(first),
      );
      await c.execute(
        await c.prepare('saved', '你好'),
        TurnCancellation(),
        confirmed: true,
      );
      final before = jsonEncode((await r.load('saved')).data);
      await first.close();
      final second = AppDatabase.forTesting(NativeDatabase(file));
      try {
        final restored = RoleplayRepository(second);
        expect(jsonEncode((await restored.load('saved')).data), before);
        expect((await restored.history('saved')).length, 1);
      } finally {
        await second.close();
        dir.deleteSync(recursive: true);
      }
    },
  );
  test(
    'interrupted ledger recovery does not automatically resend or change state',
    () async {
      final p = await core.prepare('w', '中断');
      await repo.reserve(p);
      await repo.recoverInterrupted('w');
      expect((await repo.load('w')).revision, 0);
      expect(await repo.history('w'), isEmpty);
      expect(
        (await db.select(db.roleplayTurns).get()).single.state,
        'interrupted',
      );
    },
  );
  test('structured protocol invalid output and narrative-state mismatch are rejected', () {
    for (final body in [
      'not json',
      '{"narration":"正文","replies":[],"proposal":{"minutes":1},"control":"leak"}',
    ]) {
      expect(() => DialoguePacket.parse(body), throwsA(isA<RoleplayFailure>()));
    }
    expect(
      RoleplayEvaluator().severeErrors(
        RoleplayScenarios.create('w'),
        packet(proposal: {'minutes': 999}),
        {'npc-0'},
      ),
      isNotEmpty,
    );
    expect(
      RoleplayEvaluator().humanScore({
        'naturalness': 5,
        'decision': 5,
        'persona': 5,
        'continuity': 5,
        'rhythm': 5,
      }),
      100,
    );
  });
  for (final theme in ['shanghai', 'modern', 'fantasy']) {
    test(
      '$theme: 25-turn scripts across baseline, card and core; deterministic Mock only',
      () async {
        for (final mode in ['baseline', 'card', 'core']) {
          final id = '$theme-$mode';
          await db
              .into(db.worlds)
              .insert(
                WorldsCompanion.insert(
                  id: id,
                  title: id,
                  genre: theme,
                  summary: '',
                  createdAt: DateTime(2026),
                ),
              );
          await insertScenario(db, id, theme: theme);
          expect(
            (await repo.load(id)).characters
                .map((c) => c.occupation)
                .toSet()
                .length,
            3,
          );
          for (final action in RoleplayScenarios.script) {
            await core.execute(
              await core.prepare(id, action, mode: mode),
              TurnCancellation(),
              confirmed: true,
            );
          }
          expect((await repo.load(id)).revision, 25);
          expect((await repo.history(id)).length, 25);
        }
        expect(await UsageRepository(db).load(), isEmpty);
      },
    );
  }
  test(
    'schema 3 upgrade retains world, imported history and pending content',
    () async {
      await db.close();
      closeSetup = false;
      final dir = Directory.systemTemp.createTempSync('fish_rp_v3_upgrade_');
      final path = '${dir.path}/v3.sqlite';
      final first = AppDatabase.forTesting(NativeDatabase(File(path)));
      await first
          .into(first.worlds)
          .insert(
            WorldsCompanion.insert(
              id: 'legacy',
              title: '原有世界',
              genre: '原有',
              summary: '原始内容',
              createdAt: DateTime(2026),
            ),
          );
      final imports = PendingShareRepository(first);
      await imports.receive(
        IncomingShare(
          id: 'old-import',
          source: ImportSource.paste,
          receivedAt: DateTime(2026),
          text: '旧导入原文',
        ),
      );
      await first.close();
      final v3 = sqlite3.open(path);
      // Only the synthetic test file is reduced to the previous schema.
      for (final table in [
        'story_checkpoints',
        'story_branches',
        'timeline_entries',
        'context_summaries',
      ]) {
        v3.execute('DROP TABLE $table');
      }
      v3.execute('DROP TABLE world_definitions');
      v3.execute('DROP TABLE world_drafts');
      v3.execute('DROP TABLE roleplay_memories');
      v3.execute('DROP TABLE roleplay_turns');
      v3.execute('DROP TABLE roleplay_saves');
      v3.execute('PRAGMA user_version=3');
      v3.close();
      final upgraded = AppDatabase.forTesting(NativeDatabase(File(path)));
      try {
        expect(
          (await upgraded.select(upgraded.worlds).get()).single.summary,
          '原始内容',
        );
        expect(
          (await PendingShareRepository(upgraded).get('old-import'))!
              .share
              .text,
          '旧导入原文',
        );
        expect(
          (await RoleplayRepository(upgraded).initialize('legacy')).revision,
          0,
        );
      } finally {
        await upgraded.close();
        dir.deleteSync(recursive: true);
      }
    },
  );
}
