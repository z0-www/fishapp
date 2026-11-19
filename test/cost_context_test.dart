import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_http_protocol.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_config.dart';
import 'package:fishtextadventure/features/roleplay/application/dialogue_engine.dart';
import 'package:fishtextadventure/features/roleplay/application/turn_coordinator.dart';
import 'package:fishtextadventure/features/roleplay/data/roleplay_repository.dart';
import 'package:fishtextadventure/features/roleplay/domain/models.dart';
import 'package:fishtextadventure/features/roleplay/domain/memory_engine.dart';
import 'package:fishtextadventure/features/roleplay/domain/world_context_builder.dart';

import 'support/scenario_fixtures.dart';

import 'package:fishtextadventure/features/usage/usage_repository.dart';
import 'package:fishtextadventure/features/usage/deepseek_prices.dart';

import 'ai/deepseek_connection_test.dart'
    show FakeAdapter, TestKeyStorage, syntheticKey, databaseWithWorld;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'model discovery and configurable thinking have distinct contracts',
    () async {
      final models = DeepSeekHttpProtocol(
        adapter: FakeAdapter((options) async {
          expect(options.method, 'GET');
          expect(options.uri.path, '/models');
          return ResponseBody.fromString(
            jsonEncode({
              'data': [
                {'id': 'deepseek-flash'},
                {'id': 'deepseek-v4-pro'},
                {'id': 'invalid key-like value'},
              ],
            }),
            200,
            headers: {
              'content-type': ['application/json'],
            },
          );
        }),
      );
      addTearDown(models.close);
      expect(await models.listModels(syntheticKey), [
        'deepseek-flash',
        'deepseek-v4-pro',
      ]);
      final thinking = DeepSeekHttpProtocol(
        thinking: true,
        adapter: FakeAdapter((options) async {
          expect((options.data as Map)['thinking'], {'type': 'enabled'});
          return ResponseBody.fromString(
            'data: {"choices":[{"delta":{},"finish_reason":"stop"}]}\n\ndata: [DONE]\n\n',
            200,
            headers: {
              'content-type': ['text/event-stream'],
            },
          );
        }),
      );
      addTearDown(thinking.close);
      expect(
        await thinking.streamMessages(syntheticKey, [
          {'role': 'user', 'content': 'JSON'},
        ], cancelToken: CancelToken()).length,
        1,
      );
    },
  );
  test(
    'bounded local relevance recalls old promises; secrets stay owner scoped',
    () {
      final memories = List.generate(
        500,
        (i) => PersonalMemory(
          id: 'm$i',
          owner: i == 0 ? 'other' : 'npc-0',
          text: i == 1 ? '我答应带来一封回信' : '第$i次谈论天气和茶水',
          source: '亲历',
          turn: i,
          importance: 5,
        ),
      );
      final selected = MemoryEngine().retrieve(
        memories,
        'npc-0',
        '约定的书信怎么样了',
        501,
      );
      expect(selected.any((m) => m.id == 'm1'), true);
      expect(selected.every((m) => m.owner == 'npc-0'), true);
      final state = RoleplayScenarios.create('w');
      final history = List.generate(
        220,
        (i) => {
          'role': i.isEven ? 'user' : 'assistant',
          'content': '历史第$i轮：${'长期不相关故事。' * 40}',
        },
      );
      final builder = WorldContextBuilder();
      final prompt = builder.build(
        state,
        state.characters.first,
        '约定的书信',
        selected,
        history,
      );
      final before = builder.estimate(history),
          after = builder.estimate(prompt);
      expect(after, lessThan(before));
      expect(after, lessThan(12000));
      expect(prompt.last['content'], '约定的书信');
      expect(jsonEncode(prompt), isNot(contains('历史第0轮：')));
      expect(jsonEncode(prompt), contains('回信'));
    },
  );
  test('HTTP contract -> real dialogue engine -> validation -> SQLite; usage never claims actual billed money', () async {
    final db = await databaseWithWorld();
    addTearDown(db.close);
    var requests = 0;
    final protocol = DeepSeekHttpProtocol(
      adapter: FakeAdapter((options) async {
        requests++;
        final messages = (options.data as Map)['messages'];
        expect(jsonEncode(messages), contains('npc-0'));
        expect(jsonEncode(messages), contains('你好'));
        final packet = jsonEncode({
          'narration': '风停在窗边。',
          'replies': [
            {'speaker': 'npc-0', 'text': '回信还在这里。'},
          ],
          'proposal': {'minutes': 1.0},
        });
        return ResponseBody.fromString(
          'data: ${jsonEncode({
            'model': 'deepseek-flash',
            'choices': [
              {
                'delta': {'content': packet},
                'finish_reason': 'stop',
              },
            ],
          })}\n\ndata: ${jsonEncode({
            'choices': [],
            'usage': {'prompt_tokens': 40, 'completion_tokens': 12, 'prompt_cache_hit_tokens': 10},
          })}\n\ndata: [DONE]\n\n',
          200,
          headers: {
            'content-type': ['text/event-stream'],
          },
        );
      }),
    );
    final engine = DeepSeekDialogueEngine(
      const DeepSeekConfig(),
      TestKeyStorage(),
      transport: protocol,
    );
    addTearDown(engine.dispose);
    final repo = RoleplayRepository(db), usage = UsageRepository(db);
    final core = TurnCoordinator(repo, engine, usage);
    final plan = await core.prepare('w', '你好', addressed: 'npc-0');
    await core.execute(plan, TurnCancellation(), confirmed: true);
    expect((await repo.load('w')).revision, 1);
    expect((await repo.history('w')).single.responseJson, contains('回信还在这里'));
    final m = (await usage.metrics()).single;
    expect(m['estimatedInput'], plan.tokens);
    expect(m['inputTokens'], 40);
    expect(m['actualBilledUsd'], null);
    expect(m['estimatedUsd'], isNotNull);
    await expectLater(
      core.execute(plan, TurnCancellation(), confirmed: true),
      throwsA(isA<RoleplayFailure>()),
    );
    expect(requests, 1);
    expect(DeepSeekPrices.estimate('unknown-new-model', 40, 12), null);
  });
}
