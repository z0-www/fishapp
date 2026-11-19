import 'package:fishtextadventure/features/ai/application/ai_providers.dart';

import '../support/scenario_fixtures.dart';
import '../support/scripted_dialogue.dart';

import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/native.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:fishtextadventure/app/app.dart';
import 'package:fishtextadventure/app/router.dart';
import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/features/worlds/application/world_providers.dart';
import 'package:fishtextadventure/features/roleplay/application/providers.dart';
import 'package:fishtextadventure/features/roleplay/data/roleplay_repository.dart';
import 'package:fishtextadventure/features/roleplay/presentation/roleplay_page.dart';

void main() {
  testWidgets(
    'playable mobile action requires budget confirmation and renders validated NPC dialogue',
    (tester) async {
      late AppDatabase db;
      late RoleplayRepository repository;
      await tester.runAsync(() async {
        db = AppDatabase.forTesting(NativeDatabase.memory());
        repository = RoleplayRepository(db);
        await db
            .into(db.worlds)
            .insert(
              WorldsCompanion.insert(
                id: 'ui',
                title: '街角日常',
                genre: '现代',
                summary: '原有设定',
                createdAt: DateTime(2026),
              ),
            );
        await insertScenario(db, 'ui');
        if (Platform.isWindows &&
            const bool.fromEnvironment('FISH_ROLEPLAY_CAPTURE')) {
          final font = FontLoader('Microsoft YaHei')
            ..addFont(
              File('C:/Windows/Fonts/msyh.ttc')
                  .readAsBytes()
                  .then(ByteData.sublistView),
            );
          await font.load();
          final icons = FontLoader('MaterialIcons')
            ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
          await icons.load();
        }
      });
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final router = GoRouter(
        initialLocation: '/play/ui',
        routes: [
          GoRoute(
            path: '/play/:id',
            builder: (_, _) => const RoleplayPage(worldId: 'ui'),
          ),
        ],
      );
      final boundary = GlobalKey();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            aiActionUnavailableProvider.overrideWithValue(null),
            routerProvider.overrideWithValue(router),
            dialogueEngineProvider.overrideWithValue(
              ScriptedDialogueEngine(latency: Duration.zero),
            ),
          ],
          child: RepaintBoundary(key: boundary, child: const FishApp()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('roleplay-input')), findsOneWidget);
      await tester.enterText(
        find.byKey(const Key('roleplay-input')),
        '你好，你在忙什么？',
      );
      await tester.tap(find.byTooltip('发送'));
      await tester.pumpAndSettle();
      expect(find.text('生成前确认'), findsOneWidget);
      expect((await repository.load('ui')).revision, 0);
      await tester.tap(find.text('确认生成'));
      await tester.pumpAndSettle();
      expect((await repository.load('ui')).revision, 1);
      expect(find.text('陈禾'), findsOneWidget);
      expect(find.textContaining('"proposal"'), findsNothing);
      expect(tester.takeException(), isNull);
      if (Platform.isWindows &&
          const bool.fromEnvironment('FISH_ROLEPLAY_CAPTURE')) {
        final render =
            boundary.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        await tester.runAsync(() async {
          final image = await render.toImage(pixelRatio: 2);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          await Directory('reports').create(recursive: true);
          await File('reports/roleplay-v02.png')
              .writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }
      await tester.pumpWidget(const SizedBox.shrink());
      router.dispose();
      await tester.runAsync(db.close);
    },
  );
}
