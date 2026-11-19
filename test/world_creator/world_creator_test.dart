import '../support/scripted_dialogue.dart';

import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/core/security/api_key_storage.dart';
import 'package:fishtextadventure/features/world_creator/domain/world_definition.dart';
import 'package:fishtextadventure/features/world_creator/data/world_definition_repository.dart';
import 'package:fishtextadventure/features/world_creator/application/world_suggestion_engine.dart';
import 'package:fishtextadventure/features/roleplay/data/roleplay_repository.dart';
import 'package:fishtextadventure/features/roleplay/application/turn_coordinator.dart';
import 'package:fishtextadventure/features/roleplay/domain/models.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_config.dart';
import 'package:fishtextadventure/features/usage/usage_repository.dart';

WorldDefinition example(String id) {
  final d = WorldDefinition.empty(id);
  d.data.addAll(switch (id) {
    'shanghai' => {
      'title': '1927年的上海',
      'description': '没有超自然力量，年轻记者刚下火车。',
      'era': '1927年民国上海',
      'genreTags': ['历史日常', '原创记者故事'],
      'playerProfile': {'identity': '年轻记者', 'name': '林舟'},
      'startingLocation': '上海火车站',
      'openingScene': '我刚下火车。',
      'worldRules': [
        {'id': 'r', 'kind': 'fact', 'text': '不存在超自然力量'},
      ],
    },
    'modern' => {
      'title': '自由都市',
      'description': '现代都市，自由生活。',
      'era': '现代',
      'genreTags': ['自由生活', '我自己的分类'],
    },
    _ => {
      'title': '浮潮群岛',
      'description': '完全原创世界。',
      'genreTags': ['珊瑚梦织传说'],
      'era': '第三潮纪',
      'calendarSystem': '每年九潮，每潮四十日',
      'worldDateTime': '潮历172年·第八潮·双月日',
      'startingLocation': '悬海港',
      'worldRules': [
        {'id': 'magic', 'kind': 'fact', 'text': '魔法需消耗记忆'},
        {'id': 'tone', 'kind': 'preference', 'text': '偏好温柔叙事'},
        {'id': 'unknown', 'kind': 'open', 'text': '天外是否有人尚未确定'},
      ],
      'locationProfiles': [
        {
          'id': 'port',
          'name': '悬海港',
          'description': '浮在天空的港口',
          'connections': ['回音林'],
        },
        {
          'id': 'forest',
          'name': '回音林',
          'connections': ['悬海港'],
        },
      ],
      'customFields': {'社会制度': '由潮汐议会轮值'},
    },
  });
  return d;
}

class NoKeyStorage extends ApiKeyStorage {
  int reads = 0;
  @override
  Future<String?> readApiKey() async {
    reads++;
    throw StateError('should not read keys');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late WorldDefinitionRepository repo;
  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = WorldDefinitionRepository(db);
  });
  tearDown(() async {
    await db.close();
  });
  for (final id in ['shanghai', 'modern', 'fantasy']) {
    test(
      '$id definition saves, arbitrary era/calendar survives export',
      () async {
        final d = example(id);
        await repo.save(d, expectedVersion: 0);
        final read = (await repo.latest(id))!.definition;
        expect(read.data['era'], d.data['era']);
        expect(read.data['worldRules'], d.data['worldRules']);
        expect(
          WorldDefinitionExchange.decode(WorldDefinitionExchange.encode(read))
              .toJson(),
          read.toJson(),
        );
      },
    );
  }
  test('missing fields and absent NPCs are not invented', () async {
    await repo.save(example('modern'), expectedVersion: 0);
    final s = await RoleplayRepository(db).initialize('modern');
    expect(s.characters, isEmpty);
    expect(s.playerLocation, '');
    expect(s.displayTime, '时间未设定');
    expect(s.data['playerProfile'], isNull);
    expect(jsonEncode(s.data['definitionSnapshot']), isNot(contains('1970')));
  });
  test(
    'NPC uses V0.2 profile, supports editing secrets and optional fields',
    () async {
      final d = example('fantasy');
      d.data['characterProfiles'] = [
        {
          'id': 'captain-any-id',
          'name': '阿潮',
          'speechStyle': '简短',
          'privateKnowledge': ['只属于他的秘密'],
          'presentAtOpening': true,
        },
      ];
      final saved = await repo.save(d, expectedVersion: 0);
      expect(
        saved.definition.characterProfiles.single,
        isA<CharacterProfile>(),
      );
      final s = await RoleplayRepository(db).initialize(d.id);
      expect(s.presentCharacters.single.name, '阿潮');
      final edit = saved.definition.copy();
      (edit.data['characterProfiles'] as List).single['speechStyle'] = '缓慢';
      await repo.save(edit, expectedVersion: 1);
      expect(
        (await repo.latest(d.id))!
            .definition
            .characterProfiles
            .single
            .data['speechStyle'],
        '缓慢',
      );
      expect(
        (await RoleplayRepository(db).load(d.id))
            .characters
            .single
            .data['speechStyle'],
        '简短',
      );
    },
  );
  test(
    'definition rules and identity reach dialogue without another NPC secrets',
    () async {
      final d = example('shanghai');
      d.data['characterProfiles'] = [
        {'id': 'npc-manual', 'name': '编辑', 'presentAtOpening': true},
        {
          'id': 'hidden',
          'name': '其他人',
          'privateKnowledge': ['绝密口令青石桥'],
        },
      ];
      await repo.save(d, expectedVersion: 0);
      final rp = RoleplayRepository(db);
      await rp.initialize(d.id);
      final core = FishRoleplayCore(
        rp,
        ScriptedDialogueEngine(latency: Duration.zero),
        UsageRepository(db),
      );
      final plan = await core.prepare(d.id, '你好', addressed: 'npc-manual');
      expect(jsonEncode(plan.messages), contains('不存在超自然力量'));
      expect(jsonEncode(plan.messages), contains('年轻记者'));
      expect(jsonEncode(plan.messages), isNot(contains('绝密口令青石桥')));
      await core.execute(plan, TurnCancellation(), confirmed: true);
      expect((await rp.load(d.id)).revision, 1);
    },
  );
  test('rules revision, optimistic conflicts and restoring never rewrite old state', () async {
    final first = await repo.save(example('shanghai'), expectedVersion: 0);
    final rp = RoleplayRepository(db);
    await rp.initialize('shanghai');
    final old = jsonEncode((await rp.load('shanghai')).data);
    final change = first.definition.copy();
    change.data['worldRules'] = [
      {'id': 'new', 'kind': 'preference', 'text': '允许普通创作补充'},
    ];
    await repo.save(change, expectedVersion: 1);
    await expectLater(
      repo.save(first.definition, expectedVersion: 1),
      throwsA(isA<DefinitionFailure>()),
    );
    await repo.save(first.definition, expectedVersion: 2);
    expect((await repo.versions('shanghai')).length, 3);
    expect(jsonEncode((await rp.load('shanghai')).data), old);
  });
  test(
    'two worlds memories and characters stay isolated; copy has no history',
    () async {
      final a = example('shanghai');
      a.data['characterProfiles'] = [
        {'id': 'same-id', 'name': '甲', 'presentAtOpening': true},
      ];
      await repo.save(a, expectedVersion: 0);
      final b = example('modern');
      b.data['characterProfiles'] = [
        {'id': 'same-id', 'name': '乙', 'presentAtOpening': true},
      ];
      await repo.save(b, expectedVersion: 0);
      final rp = RoleplayRepository(db);
      await rp.initialize(a.id);
      await rp.initialize(b.id);
      final core = FishRoleplayCore(
        rp,
        ScriptedDialogueEngine(latency: Duration.zero),
        UsageRepository(db),
      );
      await core.execute(
        await core.prepare(a.id, '我承诺送信。', addressed: 'same-id'),
        TurnCancellation(),
        confirmed: true,
      );
      expect(await rp.memories(b.id), isEmpty);
      expect((await rp.load(b.id)).characters.single.name, '乙');
      final copy = await repo.duplicate(a);
      await rp.initialize(copy.definition.id);
      expect(await rp.history(copy.definition.id), isEmpty);
      expect(await rp.memories(copy.definition.id), isEmpty);
      await repo.deleteWorld(a.id);
      expect((await repo.latest(b.id))!.definition.title, b.title);
      expect((await rp.load(b.id)).revision, 0);
    },
  );
  test(
    'SQLite close/reopen restores full definitions, draft and world snapshot',
    () async {
      final dir = Directory.systemTemp.createTempSync('fish_creator_restart_');
      final file = File('${dir.path}/data.sqlite');
      final first = AppDatabase.forTesting(NativeDatabase(file));
      final r = WorldDefinitionRepository(first);
      final saved = await r.save(example('fantasy'), expectedVersion: 0);
      await r.saveDraft('creator-new', {
        'definition': example('modern').toJson(),
        'baseVersion': 0,
      });
      await RoleplayRepository(first).initialize('fantasy');
      await first.close();
      final second = AppDatabase.forTesting(NativeDatabase(file));
      try {
        expect(
          (await WorldDefinitionRepository(second).latest('fantasy'))!
              .definition
              .toJson(),
          saved.definition.toJson(),
        );
        expect(
          (await WorldDefinitionRepository(second)
              .draft('creator-new'))!['baseVersion'],
          0,
        );
        expect(
          (await RoleplayRepository(second).load('fantasy')).displayTime,
          contains('潮历172年'),
        );
      } finally {
        await second.close();
        dir.deleteSync(recursive: true);
      }
    },
  );
  test('local create and draft work while unavailable AI suggestions fail without reading a key', () async {
    final key = NoKeyStorage();
    final engine = WorldSuggestionEngine(
      const DeepSeekConfig(),
      key,
      UsageRepository(db),
    );
    final d = example('modern');
    await repo.save(d, expectedVersion: 0);
    await repo.saveDraft('draft', {'definition': d.toJson()});
    final plan = engine.prepare(d);
    await expectLater(
      engine.generate(plan, confirmed: false),
      throwsA(isA<DefinitionFailure>()),
    );
    await expectLater(
      engine.generate(plan, confirmed: true),
      throwsA(isA<DefinitionFailure>()),
    );
    expect(key.reads, 0);
    expect(await UsageRepository(db).load(), isEmpty);
    expect(
      (await repo.latest(d.id))!.definition.data['narrativePreferences'],
      isNull,
    );
    await expectLater(
      engine.generate(plan, confirmed: true),
      throwsA(isA<DefinitionFailure>()),
    );
  });
  test(
    'credentials refused in definitions, drafts, import and exports',
    () async {
      final d = example('modern');
      d.data['customFields'] = {'api_key': 'not-a-real-key'};
      await expectLater(
        repo.save(d, expectedVersion: 0),
        throwsA(isA<DefinitionFailure>()),
      );
      await expectLater(
        repo.saveDraft('bad', {'definition': d.toJson()}),
        throwsA(isA<DefinitionFailure>()),
      );
      expect(
        () => WorldDefinitionExchange.encode(d),
        throwsA(isA<DefinitionFailure>()),
      );
      expect(await db.select(db.worlds).get(), isEmpty);
    },
  );
  test(
    'unknown import format and malformed relationship do not write data',
    () async {
      expect(
        () => WorldDefinitionExchange.decode('{"format":"unknown"}'),
        throwsA(isA<DefinitionFailure>()),
      );
      final d = example('modern');
      d.data['characterProfiles'] = [
        {
          'id': 'npc',
          'relationshipToPlayer': {'trust': 'wrong'},
        },
      ];
      await expectLater(
        repo.save(d, expectedVersion: 0),
        throwsA(isA<DefinitionFailure>()),
      );
      expect(await db.select(db.worlds).get(), isEmpty);
    },
  );
  test('schema4 migration preserves worlds and exact roleplay save', () async {
    final dir = Directory.systemTemp.createTempSync('fish_creator_migration_');
    final file = File('${dir.path}/v4.sqlite');
    final first = AppDatabase.forTesting(NativeDatabase(file));
    await first
        .into(first.worlds)
        .insert(
          WorldsCompanion.insert(
            id: 'legacy',
            title: '旧世界',
            genre: '旧类型',
            summary: '旧设定',
            createdAt: DateTime(2026),
          ),
        );
    await RoleplayRepository(first).initialize('legacy');
    final payload =
        (await first.select(first.roleplaySaves).get()).single.payload;
    await first.close();
    final v4 = sqlite3.open(file.path);
    for (final name in [
      'world_definitions',
      'world_drafts',
      'story_checkpoints',
      'story_branches',
      'timeline_entries',
      'context_summaries',
    ]) {
      v4.execute('DROP TABLE $name');
    }
    v4.execute('PRAGMA user_version=4');
    v4.close();
    final upgraded = AppDatabase.forTesting(NativeDatabase(file));
    try {
      expect(
        (await upgraded.select(upgraded.worlds).get()).single.title,
        '旧世界',
      );
      expect(
        (await upgraded.select(upgraded.roleplaySaves).get()).single.payload,
        payload,
      );
      expect(
        (await upgraded.customSelect('PRAGMA user_version').getSingle())
            .read<int>('user_version'),
        6,
      );
      expect(await upgraded.select(upgraded.worldDefinitions).get(), isEmpty);
    } finally {
      await upgraded.close();
      dir.deleteSync(recursive: true);
    }
  });
}
