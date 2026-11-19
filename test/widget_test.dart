import 'package:fishtextadventure/features/ai/application/ai_providers.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_config.dart';
import 'package:fishtextadventure/features/settings/application/product_statement_preference.dart';
import 'package:fishtextadventure/features/roleplay/data/roleplay_repository.dart';
import 'package:fishtextadventure/shared/data/text_draft_store.dart';

import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:fishtextadventure/app/app.dart';
import 'package:fishtextadventure/app/router.dart';
import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/features/worlds/data/world_repository.dart';
import 'package:fishtextadventure/features/worlds/application/world_providers.dart';
import 'package:fishtextadventure/features/worlds/domain/world.dart';

class MemoryRepository implements WorldRepository {
  final List<World> worlds = [];
  bool fail = false;
  @override
  Future<List<World>> load() async {
    if (fail) throw StateError('read failed');
    return List.of(worlds);
  }

  @override
  Future<World> create(String prompt) async {
    final w = World(
      id: 'new',
      title: prompt,
      genre: '自定义世界',
      summary: prompt,
      createdAt: DateTime(2026, 11, 16),
    );
    worlds.insert(0, w);
    return w;
  }
}

void main() {
  test('SQLite world survives database close and reopen', () async {
    final dir = Directory.systemTemp.createTempSync('fish_database_test_');
    final file = File('${dir.path}/worlds.sqlite');
    final first = AppDatabase.forTesting(NativeDatabase(file));
    final created = await SqliteWorldRepository(first).create('重新打开后的世界');
    await first.close();
    final second = AppDatabase.forTesting(NativeDatabase(file));
    try {
      final worlds = await SqliteWorldRepository(second).load();
      expect(worlds.single.id, created.id);
      expect(worlds.single.title, '重新打开后的世界');
    } finally {
      await second.close();
      dir.deleteSync(recursive: true);
    }
  });
  test(
    'SQLite starts empty, persists writes and rejects blank input',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final repository = SqliteWorldRepository(db);
      expect(await repository.load(), isEmpty);
      final world = await repository.create('  我的海上城市  ');
      expect(world.title, '我的海上城市');
      final reloaded = await SqliteWorldRepository(db).load();
      expect(reloaded.first.id, world.id);
      expect(reloaded.length, 1);
      await expectLater(repository.create('  '), throwsArgumentError);
      await expectLater(repository.create('字' * 501), throwsArgumentError);
    },
  );

  testWidgets('minimal home validates inspiration and confirms a local world', (
    tester,
  ) async {
    late AppDatabase db;
    await tester.runAsync(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      await db.customSelect('SELECT 1').get();
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deepSeekConfigProvider.overrideWithValue(const DeepSeekConfig()),
          apiKeyStatusProvider.overrideWith((ref) async => true),
          productStatementSeenProvider.overrideWith((ref) async => true),
          databaseProvider.overrideWithValue(db),
          textDraftStoreProvider.overrideWithValue(MemoryTextDraftStore()),
        ],
        child: const FishApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('今天，想进入怎样的世界？'), findsOneWidget);
    expect(find.byType(Card), findsNothing);
    await tester.tap(find.byTooltip('创建世界'));
    await tester.pumpAndSettle();
    expect(find.text('先写下你想进入的世界。'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('home-input')),
      '我想进入1927年的上海，扮演年轻记者。',
    );
    await tester.tap(find.byTooltip('创建世界'));
    await tester.pumpAndSettle();
    expect(find.text('开始这个世界'), findsOneWidget);
    expect(await db.select(db.worlds).get(), isEmpty);
    await tester.enterText(
      find.widgetWithText(TextField, '世界名称（可稍后填写）'),
      '初到上海',
    );
    await tester.tap(find.text('进入世界'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('roleplay-input')), findsOneWidget);
    expect(
      tester
          .widget<IconButton>(
            find.byWidgetPredicate(
              (widget) => widget is IconButton && widget.tooltip == '发送',
            ),
          )
          .onPressed,
      isNull,
    );
    expect(await db.select(db.roleplayTurns).get(), isEmpty);

    expect((await db.select(db.worldDefinitions).get()).length, 1);
    await tester.tap(find.byTooltip('返回首页'));
    await tester.pumpAndSettle();
    expect(find.text('继续 · 初到上海'), findsOneWidget);
    await tester.tap(find.byTooltip('更多操作'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('设置'));
    await tester.pumpAndSettle();
    expect(find.text('叙事偏好'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.runAsync(db.close);
  });
  testWidgets('read error offers a working retry', (tester) async {
    final repository = MemoryRepository()..fail = true;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiKeyStatusProvider.overrideWith((ref) async => true),
          productStatementSeenProvider.overrideWith((ref) async => true),
          repositoryProvider.overrideWithValue(repository),
          textDraftStoreProvider.overrideWithValue(MemoryTextDraftStore()),
        ],
        child: const FishApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('世界暂时无法读取，请重试。'), findsOneWidget);
    repository.fail = false;
    await tester.tap(find.text('重新加载'));
    await tester.pumpAndSettle();
    expect(find.text('今天，想进入怎样的世界？'), findsOneWidget);
  });
  testWidgets('drawer keeps worlds independent and opens the chosen story', (
    tester,
  ) async {
    late AppDatabase db;
    await tester.runAsync(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      for (final id in ['first', 'second']) {
        await db
            .into(db.worlds)
            .insert(
              WorldsCompanion.insert(
                id: id,
                title: id == 'first' ? '第一座世界' : '第二座世界',
                genre: '故事',
                summary: '独立的故事',
                createdAt: DateTime(2026),
              ),
            );
        await RoleplayRepository(db).initialize(id);
      }
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiKeyStatusProvider.overrideWith((ref) async => true),
          productStatementSeenProvider.overrideWith((ref) async => true),
          databaseProvider.overrideWithValue(db),
          textDraftStoreProvider.overrideWithValue(MemoryTextDraftStore()),
        ],
        child: const FishApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('打开世界菜单'));
    await tester.pumpAndSettle();
    expect(find.text('第一座世界'), findsOneWidget);
    expect(find.text('第二座世界'), findsOneWidget);
    await tester.tap(find.text('第二座世界'));
    await tester.pumpAndSettle();
    expect(find.text('第二座世界'), findsOneWidget);
    expect(find.byKey(const Key('roleplay-input')), findsOneWidget);
    expect(find.text('第一座世界'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.runAsync(db.close);
  });
  testWidgets('About feedback copies the email only when asked', (
    tester,
  ) async {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    final copied = <String?>[];
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') {
        final data = call.arguments as Map;
        copied.add(data['text'] as String?);
      }
      return null;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        apiKeyStatusProvider.overrideWith((ref) async => true),
      ],
    );
    addTearDown(container.dispose);
    final router = container.read(routerProvider);
    router.go('/settings');
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const FishApp()),
    );
    await tester.pumpAndSettle();
    expect(find.text('意见反馈'), findsNothing);
    await tester.scrollUntilVisible(find.text('关于鱼者').hitTestable(), 180);
    await tester.tap(find.text('关于鱼者'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('意见反馈').hitTestable(), 120);
    await tester.tap(find.text('意见反馈'));
    await tester.pumpAndSettle();

    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpAndSettle();

    expect(find.text('意见反馈'), findsOneWidget);
    expect(find.text('如果你在使用鱼者文游时遇到问题，或有任何建议，欢迎通过以下邮箱联系开发者。'), findsOneWidget);
    expect(find.text('开发者：B站 UP 主 z0-www'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    final email = find.text('开发者邮箱：z0www1234@163.com');
    await tester.tap(email);
    await tester.pumpAndSettle();
    expect(copied, isEmpty);
    expect(find.text('邮箱已复制'), findsNothing);

    await tester.tap(find.byTooltip('复制邮箱'));
    await tester.pumpAndSettle();
    expect(copied, ['z0www1234@163.com']);
    expect(find.text('邮箱已复制'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets('large text fits a narrow home', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiKeyStatusProvider.overrideWith((ref) async => true),
          productStatementSeenProvider.overrideWith((ref) async => true),
          repositoryProvider.overrideWithValue(MemoryRepository()),
          textDraftStoreProvider.overrideWithValue(MemoryTextDraftStore()),
        ],
        child: const FishApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('home-input')), findsOneWidget);
  });
}
