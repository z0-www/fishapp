import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_config.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_http_protocol.dart';
import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/features/roleplay/application/narrative_settings.dart';
import 'package:fishtextadventure/features/roleplay/application/dialogue_engine.dart';
import 'package:fishtextadventure/features/roleplay/application/turn_coordinator.dart';
import 'package:fishtextadventure/features/roleplay/data/roleplay_repository.dart';
import 'package:fishtextadventure/features/roleplay/domain/models.dart';
import 'package:fishtextadventure/features/roleplay/domain/narrative_preferences.dart';
import 'package:fishtextadventure/features/usage/usage_repository.dart';
import 'package:fishtextadventure/features/world_creator/data/world_definition_repository.dart';
import 'package:fishtextadventure/features/world_creator/domain/world_definition.dart';
import 'package:fishtextadventure/features/worlds/application/world_story_preview.dart';
import 'package:flutter_test/flutter_test.dart';

import '../ai/deepseek_connection_test.dart' show FakeAdapter, TestKeyStorage;
import '../support/scenario_fixtures.dart';
import '../support/scripted_dialogue.dart';

void main() {
  test('mixed-language length counts words, punctuation and whitespace', () {
    expect(NarrativePreferences.countWords('上海，hello café!\n 42'), 7);
    expect(NarrativePreferences.countWords('I’m here.\n'), 3);
    expect(
      DialoguePacket.parse(jsonEncode({'narration': '长' * 3000})).narration,
      hasLength(3000),
    );
    final english = List.filled(3000, 'shore').join(' ');
    expect(NarrativePreferences.countWords(english), 3000);
    expect(
      DialoguePacket.parse(jsonEncode({'narration': english})).narration,
      english,
    );
  });

  test(
    'draft defaults, world and session apply to next requests only',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final definitions = WorldDefinitionRepository(db);
      final world = WorldDefinition.empty('narrative')..data['title'] = '叙事测试';
      await definitions.save(world, expectedVersion: 0);
      await insertScenario(db, world.id);
      final stories = RoleplayRepository(db);
      final coordinator = TurnCoordinator(
        stories,
        ScriptedDialogueEngine(),
        UsageRepository(db),
      );
      final defaultPlan = await coordinator.prepare(world.id, '我走到窗边。');
      expect(defaultPlan.messages.first['content'], contains('约 800 字'));
      var expectedWords = 0;
      var requests = 0;
      final transport = DeepSeekHttpProtocol(
        adapter: FakeAdapter((options) async {
          requests++;
          final data = options.data as Map;
          expect(data['max_tokens'], expectedWords * 2 + 512);
          expect(
            (data['messages'] as List).first['content'],
            contains('约 $expectedWords 字'),
          );
          return ResponseBody.fromString(
            'data: {"choices":[{"delta":{"content":"{}"},"finish_reason":"stop"}]}\n\n'
            'data: [DONE]\n\n',
            200,
            headers: {
              Headers.contentTypeHeader: ['text/event-stream'],
            },
          );
        }),
      );
      final engine = DeepSeekDialogueEngine(
        const DeepSeekConfig(),
        TestKeyStorage(),
        transport: transport,
      );
      addTearDown(engine.dispose);
      for (final words in [100, 800, 1500, 3000]) {
        await definitions.saveDraft(globalNarrativePreferenceKey, {
          'targetWords': words,
          'pointOfView': 'first',
        });
        final plan = await coordinator.prepare(world.id, '我走到窗边。');
        expect(plan.messages.first['content'], contains('约 $words 字'));
        expect(plan.messages.first['content'], contains('用“我”'));
        expect(plan.maxOutputTokens, words * 2 + 512);
        expectedWords = words;
        expect((await engine.generate(plan, TurnCancellation())).issue, isNull);
      }
      expect(requests, 4);
      world.data['narrativePreferences'] = {
        'pointOfView': 'third',
        'narrationStyle': 'immersive',
        'emotionIntensity': 1,
      };
      await definitions.save(world, expectedVersion: 1);
      final permanent = await coordinator.prepare(world.id, '我走到窗边。');
      expect(permanent.messages.first['content'], contains('玩家角色名称'));
      expect(permanent.messages.first['content'], contains('当下可见'));
      final temporary = await coordinator.prepare(
        world.id,
        '我走到窗边。',
        sessionNarration: {'pointOfView': 'second', 'narrationStyle': 'brisk'},
      );
      expect(temporary.messages.first['content'], contains('用“你”'));
      expect(temporary.messages.first['content'], contains('主要进展写在前面'));
      expect(temporary.messages.first['content'], contains('NPC 台词沿用自身说话习惯'));
      expect(
        temporary.messages.map((row) => row['content']).join(),
        contains('emotionIntensity'),
      );
      expect(
        (await definitions.latest(world.id))!
            .definition
            .data['narrativePreferences'],
        world.data['narrativePreferences'],
      );
      expect(await stories.history(world.id), isEmpty);
    },
  );

  test(
    'preview uses the saved completed event and current recovery marker',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final worlds = WorldDefinitionRepository(db);
      final definition = WorldDefinition.empty('preview')..data['title'] = '海港';
      await worlds.save(definition, expectedVersion: 0);
      final repository = RoleplayRepository(db);
      expect(
        (await WorldStoryPreview.load(repository, definition.id)).hasStory,
        false,
      );
      await repository.initialize(definition.id);
      expect(
        (await WorldStoryPreview.load(repository, definition.id)).hasStory,
        false,
      );
      final timestamp = DateTime(2026, 11, 19, 15);
      await db
          .into(db.roleplayTurns)
          .insert(
            RoleplayTurnsCompanion.insert(
              id: 'preview-1',
              worldId: definition.id,
              baseRevision: 0,
              action: '我走到岸边',
              speaker: 'narrator',
              contextJson: '{}',
              state: 'completed',
              mock: false,
              createdAt: timestamp,
              responseJson: const Value('{"narration":"风把盐味带进码头。"}'),
            ),
          );
      final story = await WorldStoryPreview.load(repository, definition.id);
      expect(story.node, '第 1 轮');
      expect(story.playedAt, timestamp);
      expect(story.excerpt, '风把盐味带进码头。');
    },
  );
}
