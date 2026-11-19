import 'package:fishtextadventure/features/usage/price_schedule_provider.dart';
import 'package:fishtextadventure/features/ai/application/ai_providers.dart';
import 'package:fishtextadventure/features/ai/presentation/api_key_reminder.dart';
import 'package:fishtextadventure/shared/data/text_draft_store.dart';

import '../support/scenario_fixtures.dart';
import '../support/scripted_dialogue.dart';

import 'dart:async';
import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:fishtextadventure/app/app.dart';
import 'package:fishtextadventure/app/router.dart';
import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/features/worlds/application/world_providers.dart';
import 'package:fishtextadventure/features/roleplay/application/providers.dart';
import 'package:fishtextadventure/features/roleplay/application/dialogue_engine.dart';
import 'package:fishtextadventure/features/roleplay/application/turn_coordinator.dart';
import 'package:fishtextadventure/features/roleplay/data/roleplay_repository.dart';
import 'package:fishtextadventure/features/roleplay/domain/models.dart';
import 'package:fishtextadventure/features/usage/usage_repository.dart';

class ControlledMock implements DialogueEngine {
  final result = Completer<DialogueOutput>();
  int calls = 0;
  TurnCancellation? cancellation;
  @override
  Future<DialogueOutput> generate(TurnPlan plan, TurnCancellation token) {
    calls++;
    cancellation = token;
    return result.future;
  }
}

void main() {
  Future<AppDatabase> database(WidgetTester tester) async {
    late AppDatabase db;
    await tester.runAsync(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      await db
          .into(db.worlds)
          .insert(
            WorldsCompanion.insert(
              id: 'a',
              title: '街角旧故事',
              genre: '日常',
              summary: '独立的本地剧情',
              createdAt: DateTime(2026),
            ),
          );
      await insertScenario(db, 'a');
    });
    return db;
  }

  testWidgets('missing Key explains what to do and saves the unsent draft', (
    tester,
  ) async {
    final db = await database(tester);
    final engine = ControlledMock();
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        apiKeyStatusProvider.overrideWith((ref) async => false),
        dialogueEngineProvider.overrideWithValue(engine),
      ],
    );
    final router = container.read(routerProvider);
    router.go('/play/a');
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const FishApp()),
    );
    await tester.pumpAndSettle();
    final reminder = find.text(ApiKeyReminder.label);
    expect(reminder, findsOneWidget);
    final input = find.byKey(const Key('roleplay-input'));
    const action = '我走到窗边听外面的脚步。';
    await tester.enterText(input, action);
    await tester.tap(find.byTooltip('发送'));
    await tester.pumpAndSettle();
    expect(reminder, findsOneWidget);
    expect(find.text('生成前确认'), findsNothing);
    expect(engine.calls, 0);
    expect(await container.read(textDraftStoreProvider).read('play-a'), action);
    expect(await RoleplayRepository(db).history('a'), isEmpty);
    router.go('/');
    await tester.pumpAndSettle();
    router.go('/play/a');
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(input).controller!.text, action);
    await tester.tap(reminder);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('api-key-input')), findsOneWidget);
    router.pop();
    await tester.pumpAndSettle();
    expect(reminder, findsOneWidget);
    expect(tester.widget<TextField>(input).controller!.text, action);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    container.dispose();
    await tester.runAsync(db.close);
  });

  testWidgets(
    'cancelled budget makes no request; stop retains input and committed state',
    (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      final db = await database(tester), engine = ControlledMock();
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          aiActionUnavailableProvider.overrideWithValue(null),
          walletPriceProvider.overrideWith((ref) async => null),
          dialogueEngineProvider.overrideWithValue(engine),
        ],
      );
      container.read(routerProvider).go('/play/a');
      await tester.pumpWidget(
        UncontrolledProviderScope(container: container, child: const FishApp()),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('roleplay-input')),
        '我想问问今天的天气。',
      );
      await tester.tap(find.byTooltip('发送'));
      await tester.pumpAndSettle();
      expect(find.text('生成前确认'), findsOneWidget);
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(engine.calls, 0);
      await tester.tap(find.byTooltip('发送'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('确认生成'));
      await tester.pumpAndSettle();
      expect(engine.calls, 1);
      await tester.tap(find.byTooltip('停止生成'));
      expect(engine.cancellation!.cancelled, true);
      engine.result.complete(
        DialogueOutput(
          jsonEncode({
            'narration': '',
            'replies': [
              {'speaker': 'npc-0', 'text': '今天还不错。'},
            ],
            'proposal': {'minutes': 1},
          }),
        ),
      );
      await tester.pumpAndSettle();
      expect((await RoleplayRepository(db).load('a')).revision, 0);
      expect(await RoleplayRepository(db).history('a'), isEmpty);
      expect(
        tester
            .widget<TextField>(find.byKey(const Key('roleplay-input')))
            .controller!
            .text,
        '我想问问今天的天气。',
      );
      expect(await UsageRepository(db).load(), isEmpty);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      container.dispose();
      await tester.runAsync(db.close);
    },
  );
  testWidgets(
    'regenerate forks an existing checkpoint and asks budget without overwriting reply',
    (tester) async {
      final db = await database(tester);
      final rp = RoleplayRepository(db);
      final core = FishRoleplayCore(
        rp,
        ScriptedDialogueEngine(latency: Duration.zero),
        UsageRepository(db),
      );
      await tester.runAsync(() async {
        await core.execute(
          await core.prepare('a', '你好，今天忙吗？', addressed: 'npc-0'),
          TurnCancellation(),
          confirmed: true,
        );
      });
      final original = (await rp.history('a')).single.responseJson;
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          aiActionUnavailableProvider.overrideWithValue(null),
          walletPriceProvider.overrideWith((ref) async => null),
          dialogueEngineProvider.overrideWithValue(
            ScriptedDialogueEngine(latency: Duration.zero),
          ),
        ],
      );
      container.read(routerProvider).go('/play/a');
      await tester.pumpWidget(
        UncontrolledProviderScope(container: container, child: const FishApp()),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('添加与更多'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('重新生成'));
      await tester.pumpAndSettle();
      expect(find.text('在新分支中重新生成？'), findsOneWidget);
      await tester.tap(find.text('创建分支'));
      await tester.pumpAndSettle();
      expect(find.text('生成前确认'), findsOneWidget);
      expect((await rp.load('a')).revision, 1);
      expect((await rp.history('a')).single.responseJson, original);
      expect((await db.select(db.worlds).get()).length, 2);
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(await UsageRepository(db).load(), isEmpty);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      container.dispose();
      await tester.runAsync(db.close);
    },
  );
}
