import 'support/scripted_dialogue.dart';

import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/features/import_center/data/pending_share_repository.dart';
import 'package:fishtextadventure/features/import_center/data/story_parsers.dart';
import 'package:fishtextadventure/features/import_center/domain/import_models.dart';
import 'package:fishtextadventure/features/story_world/application/story_world_engine.dart';
import 'package:fishtextadventure/features/story_world/domain/story_models.dart';
import 'package:fishtextadventure/features/story_world/data/story_repository.dart';
import 'package:fishtextadventure/features/roleplay/data/roleplay_repository.dart';
import 'package:fishtextadventure/features/roleplay/application/turn_coordinator.dart';
import 'package:fishtextadventure/features/roleplay/domain/models.dart';
import 'package:fishtextadventure/features/usage/usage_repository.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_config.dart';

import 'world_creator/story_world_test.dart'
    show sessionFixture, fact, PlanningFixtureConfig;
import 'world_creator/world_creator_test.dart' show NoKeyStorage;

void main() {
  test('110-round original archive -> reviewed independent world -> continuation; failure leaves source intact', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = PendingShareRepository(db);
    final id = await repo.receive(
      IncomingShare(
        id: 'long-source',
        source: ImportSource.paste,
        receivedAt: DateTime(2026),
        text: '原始故事',
      ),
    );
    final data = sessionFixture(110, fork: true);
    final draft = DeepSeekArchiveParser().session(data);
    final result = await repo.save(id, draft, ImportDestination.history);
    final branch = await ConversationImportService(db)
        .branch(result.conversationId, '219');
    expect(branch, hasLength(220));
    final converter = ConversationToWorldEngine(
      const DeepSeekConfig(),
      NoKeyStorage(),
      UsageRepository(db),
    );
    final planner = ConversationToWorldEngine(
      const PlanningFixtureConfig(),
      NoKeyStorage(),
      UsageRepository(db),
    );
    final plan = planner.prepare(
      result.conversationId,
      '219',
      '从第110轮继续',
      branch,
    );
    await expectLater(
      converter.convert(plan, branch, confirmed: false),
      throwsA(isA<RoleplayFailure>()),
    );
    await expectLater(
      converter.convert(plan, branch, confirmed: true),
      throwsA(isA<RoleplayFailure>()),
    );
    final style = StyleDNAExtractor().extract(branch);
    final candidate = WorldDraft({
      'id': 'manual-restore',
      'conversationId': result.conversationId,
      'nodeId': '219',
      'title': '从第110轮继续',
      'styleDNA': style,
      'styleConfirmed': false,
    });
    expect(style['apiRequests'], 0);
    expect(style['assistantMessagesMeasured'], 110);
    expect(jsonEncode(style), isNot(contains('角色说过的话')));
    candidate.data['facts'] = [
      fact('b', 'background', '1927年上海，无超自然', '0'),
      fact('p', 'player', '年轻记者', '0'),
      fact('t', 'time', '1927年初夏夜晚', '219'),
      fact('l', 'location', '上海火车站', '0'),
      fact('s', 'scene', '第110轮之后，记者正在等待回信。', '219'),
      fact('e', 'event', '此前已经收到线索', '200'),
      fact('n', 'npc', '陈编辑', '0')
        ..['profile'] = {'speechStyle': '克制、反问', 'presentAtOpening': true},
    ];
    candidate.data['styleConfirmed'] = true;
    final world = await WorldRecoveryService(db)
        .recover(candidate, confirmed: true);
    final state = await RoleplayRepository(db).load(world);
    expect(state.data['worldDateTimeLabel'], '1927年初夏夜晚');
    expect(state.data['openingScene'], contains('第110轮之后'));
    expect(state.characters.single.data['speechStyle'], '克制、反问');
    final core = TurnCoordinator(
      RoleplayRepository(db),
      ScriptedDialogueEngine(latency: Duration.zero),
      UsageRepository(db),
    );
    final next = await core.prepare(world, '接下来有什么消息？', addressed: 'n');
    expect(jsonEncode(next.messages), contains('记者正在等待回信'));
    expect(jsonEncode(next.messages), contains('年轻记者'));
    expect(jsonEncode(next.messages), isNot(contains('另一条没有发生')));
    expect(next.messages.length, lessThan(15));
    final before = (await repo.messages(result.conversationId))
        .map((m) => m.rawJson)
        .toList();
    final bad = candidate.copy();
    bad.data['facts'] = [fact('bad', 'player', '错误覆盖', '0', kind: 'conflict')];
    await expectLater(
      WorldRecoveryService(db).recover(bad, confirmed: true),
      throwsA(isA<RoleplayFailure>()),
    );
    expect((await db.select(db.worlds).get()).length, 1);
    expect(
      (await repo.messages(result.conversationId))
          .map((m) => m.rawJson)
          .toList(),
      before,
    );
    expect(await UsageRepository(db).load(), isEmpty);
    final exported = await ConversationImportService(db).fromWorld(world);
    expect(await repo.messages(exported), isNotEmpty);
  });
}
