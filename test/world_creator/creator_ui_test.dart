import 'package:fishtextadventure/features/ai/application/ai_providers.dart';

import 'dart:io';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
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
import 'package:fishtextadventure/features/world_creator/application/world_suggestion_engine.dart';
import 'package:fishtextadventure/features/world_creator/presentation/world_creator_page.dart';
import 'package:fishtextadventure/features/world_creator/presentation/editors.dart';
import 'package:fishtextadventure/features/world_creator/data/world_definition_repository.dart';

import 'package:fishtextadventure/features/ai/data/deepseek_config.dart';
import 'package:fishtextadventure/features/usage/usage_repository.dart';

import 'world_creator_test.dart' show NoKeyStorage;

class CountingSuggestions extends WorldSuggestionEngine {
  CountingSuggestions(AppDatabase db)
    : super(const DeepSeekConfig(), NoKeyStorage(), UsageRepository(db));
  int calls = 0;
  @override
  Future<List<WorldSuggestion>> generate(
    SuggestionRequest request, {
    required bool confirmed,
    CancelToken? cancellation,
  }) async {
    if (!confirmed) throw StateError('confirmation required');
    calls++;
    return [
      const WorldSuggestion('narrativePreferences', '叙事风格建议', {
        'style': '短段落、自然对话；不替玩家决定行动与感情。',
      }),
    ];
  }
}

void main() {
  testWidgets(
    'mobile creator saves drafts, requires budget and per-item review before applying',
    (tester) async {
      late AppDatabase db;
      await tester.runAsync(() async {
        db = AppDatabase.forTesting(NativeDatabase.memory());
        await db.customSelect('SELECT 1').get();
      });
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final engine = CountingSuggestions(db),
          router = GoRouter(
            initialLocation: '/create',
            routes: [
              GoRoute(
                path: '/create',
                builder: (_, _) => const WorldCreatorPage(),
              ),
            ],
          );
      final boundary = GlobalKey();
      if (Platform.isWindows &&
          const bool.fromEnvironment('FISH_CREATOR_CAPTURE')) {
        await tester.runAsync(() async {
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
        });
      }
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            aiActionUnavailableProvider.overrideWithValue(null),
            routerProvider.overrideWithValue(router),
            worldSuggestionEngineProvider.overrideWithValue(engine),
          ],
          child: RepaintBoundary(key: boundary, child: const FishApp()),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('world-title')),
        '1927 · 初到上海',
      );
      await tester.enterText(
        find.byKey(const Key('world-description')),
        '我是一名年轻记者，世界里没有超自然力量。故事从我刚下火车开始。',
      );
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      final repo = WorldDefinitionRepository(db);
      expect(
        (await repo.draft('creator-new'))!['definition']['description'],
        contains('年轻记者'),
      );
      if (Platform.isWindows &&
          const bool.fromEnvironment('FISH_CREATOR_CAPTURE')) {
        final render =
            boundary.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        await tester.runAsync(() async {
          final image = await render.toImage(pixelRatio: 2);
          final data = await image.toByteData(format: ui.ImageByteFormat.png);
          await Directory('reports').create(recursive: true);
          await File('reports/world-creator-v03.png')
              .writeAsBytes(data!.buffer.asUint8List());
          image.dispose();
        });
      }
      Future<void> showBudget() async {
        await tester.scrollUntilVisible(
          find.text('AI 帮我完善世界'),
          250,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.text('AI 帮我完善世界'));
        await tester.pumpAndSettle();
        expect(find.text('完善世界前确认'), findsOneWidget);
      }

      await showBudget();
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(engine.calls, 0);
      await showBudget();
      await tester.tap(find.text('确认获取建议'));
      await tester.pumpAndSettle();
      expect(engine.calls, 1);
      expect(find.byType(CheckboxListTile), findsOneWidget);
      expect(
        tester.widget<CheckboxListTile>(find.byType(CheckboxListTile)).value,
        false,
      );
      await tester.tap(find.text('应用选中建议到草稿'));
      await tester.pumpAndSettle();
      expect(
        (await repo.draft(
          'creator-new',
        ))!['definition']['narrativePreferences'],
        isNull,
      );
      await showBudget();
      await tester.tap(find.text('确认获取建议'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CheckboxListTile));
      await tester.tap(find.text('应用选中建议到草稿'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(
        (await repo.draft(
          'creator-new',
        ))!['definition']['narrativePreferences']['style'],
        contains('不替玩家'),
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      router.dispose();
      await tester.runAsync(db.close);
    },
  );
  testWidgets(
    'NPC editor creates and edits the same roleplay profile without required fields',
    (tester) async {
      Map<String, dynamic>? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: FilledButton(
                onPressed: () async {
                  result = (await CharacterEditor.open(context))?.toJson();
                },
                child: const Text('添加人物'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('添加人物'));
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextField, '姓名'), '阿潮');
      await tester.tap(find.text('保存设定'));
      await tester.pumpAndSettle();
      expect(result?['name'], '阿潮');
      expect(result?['occupation'], isNull);
    },
  );
}
