import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/native.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:fishtextadventure/app/app.dart';
import 'package:fishtextadventure/app/router.dart';
import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/core/security/api_key_storage.dart';
import 'package:fishtextadventure/features/ai/application/ai_providers.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_repository.dart';
import 'package:fishtextadventure/features/settings/application/product_statement_preference.dart';
import 'package:fishtextadventure/features/settings/presentation/product_statement_dialog.dart';
import 'package:fishtextadventure/features/world_creator/data/world_definition_repository.dart';
import 'package:fishtextadventure/features/worlds/application/world_providers.dart';
import 'package:fishtextadventure/shared/data/text_draft_store.dart';

class StartupStorage extends ApiKeyStorage {
  int checks = 0;
  @override
  Future<bool> hasApiKey() async {
    checks++;
    throw const ApiKeyStorageException();
  }
}

class StartupApiSpy implements DeepSeekRepository {
  int calls = 0;
  @override
  Future<ConnectionTestResult> testConnection(String key) async {
    calls++;
    throw StateError('Startup must not request model output');
  }
}

const captureStatement = bool.fromEnvironment('FISH_STATEMENT_CAPTURE');
const enter = '进入鱼者';

void main() {
  Future<GlobalKey> launch(
    WidgetTester tester,
    AppDatabase db,
    StartupStorage storage,
    StartupApiSpy api,
  ) async {
    final boundary = GlobalKey();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          apiKeyStorageProvider.overrideWithValue(storage),
          deepSeekRepositoryProvider.overrideWithValue(api),
          textDraftStoreProvider.overrideWithValue(MemoryTextDraftStore()),
        ],
        child: RepaintBoundary(key: boundary, child: const FishApp()),
      ),
    );
    await tester.pumpAndSettle();
    return boundary;
  }

  Future<void> capture(
    WidgetTester tester,
    GlobalKey boundary,
    String name,
  ) async {
    if (!captureStatement) return;
    for (final element in find.byType(Image).evaluate()) {
      await tester.runAsync(
        () => precacheImage((element.widget as Image).image, element),
      );
    }
    await tester.pumpAndSettle();
    final render =
        boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await render.toImage(pixelRatio: 2);
      try {
        final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
        await Directory('reports/product-statement').create(recursive: true);
        await File('reports/product-statement/$name.png').writeAsBytes(
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
        );
      } finally {
        image.dispose();
      }
    });
  }

  testWidgets(
    'first launch shows one statement with a fixed button at large text sizes',
    (tester) async {
      if (Platform.isWindows && captureStatement) {
        await tester.runAsync(() async {
          final loader = FontLoader('Microsoft YaHei')
            ..addFont(
              File('C:/Windows/Fonts/msyh.ttc')
                  .readAsBytes()
                  .then(ByteData.sublistView),
            );
          await loader.load();
        });
      }
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewPadding);
      addTearDown(tester.view.resetPadding);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      await tester.runAsync(() => db.select(db.worldDrafts).get());
      final storage = StartupStorage(), api = StartupApiSpy();
      final boundary = await launch(tester, db, storage, api);
      expect(find.byType(ProductStatementDialog), findsOneWidget);
      expect(find.text('欢迎来到鱼者文游'), findsOneWidget);
      expect(find.text('一个由热爱创造的免费作品。'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.byKey(const Key('api-key-input')), findsNothing);
      expect(storage.checks, 0);
      expect(api.calls, 0);
      await tester.tapAt(const Offset(4, 4));
      await tester.pumpAndSettle();
      expect(find.text(enter), findsOneWidget);
      await capture(tester, boundary, 'first-launch');

      tester.view.physicalSize = const Size(320, 530);
      tester.view.viewPadding = const FakeViewPadding(top: 28, bottom: 24);
      tester.view.padding = tester.view.viewPadding;
      tester.platformDispatcher.textScaleFactorTestValue = 1.8;
      await tester.pumpAndSettle();
      expect(tester.getBottomRight(find.text(enter)).dy, lessThan(506));
      final scroll = find.byKey(const Key('product-statement-scroll'));
      await tester.drag(scroll, const Offset(0, -540));
      await tester.pumpAndSettle();
      final position = tester
          .state<ScrollableState>(
            find.descendant(of: scroll, matching: find.byType(Scrollable)),
          )
          .position;
      expect(position.pixels, greaterThan(0));
      expect(find.text(enter).hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
      await capture(tester, boundary, 'small-large-text');

      await tester.tap(find.text(enter));
      await tester.pumpAndSettle();
      expect(find.byType(ProductStatementDialog), findsNothing);
      expect(find.byKey(const Key('home-input')), findsOneWidget);
      expect(api.calls, 0);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(db.close);
    },
  );

  testWidgets(
    'confirmation survives a real database reopen and preserves an older story',
    (tester) async {
      final dir = Directory.systemTemp.createTempSync('fish_statement_');
      addTearDown(() => dir.deleteSync(recursive: true));
      final file = File('${dir.path}/preferences.sqlite');
      final first = AppDatabase.forTesting(NativeDatabase(file));
      final storage = StartupStorage(), api = StartupApiSpy();
      await tester.runAsync(() async {
        await first
            .into(first.worlds)
            .insert(
              WorldsCompanion.insert(
                id: 'old-world',
                title: '旧世界',
                genre: '日常',
                summary: '',
                createdAt: DateTime(2026),
              ),
            );
        await first
            .into(first.roleplayTurns)
            .insert(
              RoleplayTurnsCompanion.insert(
                id: 'old-turn',
                worldId: 'old-world',
                baseRevision: 0,
                action: '从车站回家。',
                speaker: 'narrator',
                contextJson: '[]',
                state: 'completed',
                mock: false,
                createdAt: DateTime(2026),
              ),
            );
      });
      await launch(tester, first, storage, api);
      expect(find.text(enter), findsOneWidget);
      expect(
        await WorldDefinitionRepository(first)
            .draft(productStatementPreferenceKey),
        isNull,
      );
      await tester.tap(find.text(enter));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('home-input')), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(first.close);
      final reopened = AppDatabase.forTesting(NativeDatabase(file));
      await tester.runAsync(() => reopened.select(reopened.worldDrafts).get());
      await launch(tester, reopened, storage, api);
      expect(find.text(enter), findsNothing);
      expect(find.byKey(const Key('home-input')), findsOneWidget);
      expect(
        (await reopened.select(reopened.worlds).get()).single.title,
        '旧世界',
      );
      expect(
        (await reopened.select(reopened.roleplayTurns).get()).single.action,
        '从车站回家。',
      );
      expect(api.calls, 0);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(reopened.close);
    },
  );

  testWidgets('settings can reopen the same statement', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await tester.runAsync(
      () =>
          WorldDefinitionRepository(db)
              .saveDraft(productStatementPreferenceKey, {'seen': true}),
    );
    await launch(tester, db, StartupStorage(), StartupApiSpy());
    final router = ProviderScope.containerOf(
      tester.element(find.byType(FishApp)),
    ).read(routerProvider);
    router.push('/settings');
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('关于鱼者').hitTestable(), 180);
    await tester.tap(find.text('关于鱼者'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('查看产品声明').hitTestable(), 120);
    await tester.tap(find.text('查看产品声明'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductStatementDialog), findsOneWidget);
    await tester.tap(find.text(enter));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home-input')), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.runAsync(db.close);
  });
}
