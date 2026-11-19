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
import 'package:fishtextadventure/features/import_center/data/pending_share_repository.dart';
import 'package:fishtextadventure/features/import_center/data/story_parsers.dart';
import 'package:fishtextadventure/features/import_center/domain/import_models.dart';
import 'package:fishtextadventure/features/story_world/domain/story_models.dart';
import 'package:fishtextadventure/features/story_world/data/story_repository.dart';
import 'package:fishtextadventure/features/story_world/presentation/recovery_page.dart';
import 'package:fishtextadventure/features/roleplay/presentation/roleplay_page.dart';

import 'story_world_test.dart' show sessionFixture, fact;

void main() {
  testWidgets(
    'mobile recovery previews provenance and only creates world after confirmation',
    (tester) async {
      late AppDatabase db;
      late String conversation;
      await tester.runAsync(() async {
        db = AppDatabase.forTesting(NativeDatabase.memory());
        final repo = PendingShareRepository(db);
        await repo.receive(
          IncomingShare(
            id: 'recovery-ui',
            source: ImportSource.paste,
            receivedAt: DateTime.now(),
            text: '纯本机上海故事',
          ),
        );
        conversation = (await repo.save(
          'recovery-ui',
          DeepSeekArchiveParser().session(sessionFixture(20)),
          ImportDestination.history,
        )).conversationId;
        await WorldDraftRepository(db).save(
          WorldDraft({
            'id': 'recovery-$conversation-39',
            'conversationId': conversation,
            'nodeId': '39',
            'title': '1927 · 上海旧故事',
            'facts': [
              fact('identity', 'player', '年轻记者', '0'),
              fact('location', 'location', '上海火车站', '0'),
              fact('scene', 'scene', '我刚下火车，站前响起汽笛。', '0'),
            ],
          }),
        );
        if (Platform.isWindows &&
            const bool.fromEnvironment('FISH_CREATOR_CAPTURE')) {
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
      final key = GlobalKey();
      final router = GoRouter(
        initialLocation: '/recover',
        routes: [
          GoRoute(
            path: '/recover',
            builder: (_, _) =>
                WorldRecoveryPreviewPage(conversationId: conversation),
          ),
          GoRoute(
            path: '/play/:id',
            builder: (_, s) => RoleplayPage(worldId: s.pathParameters['id']!),
          ),
        ],
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            routerProvider.overrideWithValue(router),
            worldsProvider.overrideWith(
              (ref) => ref.watch(repositoryProvider).load(),
            ),
          ],
          child: RepaintBoundary(key: key, child: const FishApp()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('旧故事恢复预览'), findsOneWidget);
      expect(await db.select(db.worlds).get(), isEmpty);
      if (Platform.isWindows &&
          const bool.fromEnvironment('FISH_CREATOR_CAPTURE')) {
        final render =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        await tester.runAsync(() async {
          final image = await render.toImage(pixelRatio: 2);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          await Directory('reports').create(recursive: true);
          await File('reports/story-recovery-v03.png')
              .writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }
      await tester.scrollUntilVisible(
        find.text('从这里继续游玩'),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('从这里继续游玩'));
      await tester.pumpAndSettle();
      expect(find.text('从这里继续游玩？'), findsOneWidget);
      expect(await db.select(db.worlds).get(), isEmpty);
      await tester.tap(find.text('确认创建独立世界'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('roleplay-input')), findsOneWidget);
      expect(find.text('我刚下火车，站前响起汽笛。'), findsOneWidget);
      expect((await db.select(db.worlds).get()).length, 1);
      expect((await db.select(db.importedMessages).get()).length, 40);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      router.dispose();
      await tester.runAsync(db.close);
    },
  );
}
