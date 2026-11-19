import 'package:fishtextadventure/features/ai/application/ai_providers.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/native.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:material_ui/material_ui.dart';
import 'package:fishtextadventure/app/app.dart';
import 'package:fishtextadventure/app/router.dart';
import 'package:fishtextadventure/core/database/app_database.dart';

import 'package:fishtextadventure/features/worlds/application/world_providers.dart';
import 'package:fishtextadventure/features/world_creator/data/world_definition_repository.dart';
import 'package:fishtextadventure/features/world_creator/domain/world_definition.dart';
import 'package:fishtextadventure/features/roleplay/data/roleplay_repository.dart';
import 'package:fishtextadventure/features/roleplay/domain/models.dart';
import 'package:fishtextadventure/features/import_center/data/pending_share_repository.dart';
import 'package:fishtextadventure/features/import_center/domain/import_models.dart';

const _captureV056 = bool.fromEnvironment('FISH_V056_CAPTURE');

void main() {
  testWidgets(
    'ten mobile acceptance states render without overflow and preserve local content',
    (tester) async {
      late AppDatabase db;
      await tester.runAsync(() async {
        db = AppDatabase.forTesting(NativeDatabase.memory());
        await db.customSelect('SELECT 1').get();
        if (Platform.isWindows &&
            (const bool.fromEnvironment('FISH_UI_CAPTURE') ||
                const bool.fromEnvironment('FISH_KEY_GUIDE_CAPTURE') ||
                _captureV056)) {
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
      addTearDown(tester.view.resetViewInsets);
      ProviderContainer? container;
      GlobalKey boundary = GlobalKey();
      Future<void> open(String route, {bool keyboard = false}) async {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
        container?.dispose();
        container = ProviderContainer(
          overrides: [
            databaseProvider.overrideWithValue(db),
            aiActionUnavailableProvider.overrideWithValue(null),
          ],
        );
        final router = container!.read(routerProvider);
        router.go(route);
        boundary = GlobalKey();
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container!,
            child: RepaintBoundary(
              key: boundary,
              child: Stack(
                textDirection: TextDirection.ltr,
                children: [
                  const FishApp(),
                  if (keyboard)
                    const Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 280,
                      child: ColoredBox(
                        color: Color(0xFFE9EBEF),
                        child: Center(
                          child: Text(
                            '键盘区域示意 · 非真机键盘',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              fontFamily: 'Microsoft YaHei',
                              fontSize: 14,
                              color: Color(0xFF858A93),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
      }

      Future<void> capture(String name) async {
        expect(tester.takeException(), isNull);
        if (const bool.fromEnvironment('FISH_UI_CAPTURE') ||
            const bool.fromEnvironment('FISH_KEY_GUIDE_CAPTURE') &&
                name.startsWith('12-api-key-guide') ||
            _captureV056 && name.startsWith('v056-')) {
          for (final element in find.byType(Image).evaluate()) {
            final widget = element.widget as Image;
            await tester.runAsync(() => precacheImage(widget.image, element));
          }
          await tester.pumpAndSettle();
          final render =
              boundary.currentContext!.findRenderObject()!
                  as RenderRepaintBoundary;
          await tester.runAsync(() async {
            final image = await render.toImage(pixelRatio: 2);
            final bytes = await image.toByteData(
              format: ui.ImageByteFormat.png,
            );
            final folder = name.startsWith('v056-')
                ? 'reports/ui-v056'
                : 'reports/ui-v04';
            await Directory(folder).create(recursive: true);
            await File('$folder/$name.png')
                .writeAsBytes(bytes!.buffer.asUint8List());
            image.dispose();
          });
        }
      }

      Future<void> world(
        String id,
        String title, {
        int turns = 1,
        bool long = false,
      }) async {
        await tester.runAsync(() async {
          final d = WorldDefinition.empty(id);
          d.data.addAll({
            'title': title,
            'description': '1927年的上海，没有超自然力量。',
            'playerProfile': {'identity': '年轻记者'},
            'startingLocation': '上海火车站',
            'worldDateTime': '1927年4月的傍晚',
            'openingScene': '汽笛渐渐远去，站前的人群汇进暮色。',
            'characterProfiles': [
              {
                'id': 'editor',
                'name': '陈禾',
                'occupation': '报社编辑',
                'presentAtOpening': true,
              },
            ],
          });
          final v = await WorldDefinitionRepository(db)
              .save(d, expectedVersion: 0);
          final state = await RoleplayRepository(db)
              .initialize(v.definition.id);
          for (var i = 0; i < turns; i++) {
            final narration = long
                ? List.generate(
                    10,
                    (j) =>
                        '站台外的雨落在石板路上，报童从檐下穿过。远处的电车响起铃声，黄昏的上海依旧忙碌，街灯一点一点亮了起来。',
                  ).join('\n\n')
                : '陈禾把报纸折好，站在屋檐下。街边的电车缓缓驶过，留下几声清脆的铃响。';
            final packet = DialoguePacket(
              narration: narration,
              replies: [
                {
                  'speaker': 'editor',
                  'text': long
                      ? '你先看看这封信。\n\n来上海的人各有来处，不必急着把自己的故事讲完。等雨小一点，我们再去报社。'
                      : '刚到上海？报社就在前面。先避避雨，路还长。',
                },
              ],
              proposal: {'minutes': 1, 'npcMoves': []},
            );
            await db
                .into(db.roleplayTurns)
                .insert(
                  RoleplayTurnsCompanion.insert(
                    id: '$id-turn-$i',
                    worldId: id,
                    baseRevision: i,
                    action: i == 0
                        ? '我拿着行李走到屋檐下：“请问，去报社该怎么走？”'
                        : '我读完信，抬头看向街口。',
                    speaker: 'editor',
                    contextJson: '[]',
                    state: 'completed',
                    responseJson: Value(jsonEncode(packet.toJson())),
                    mock: true,
                    createdAt: DateTime(2026, 11, 17).add(Duration(minutes: i)),
                  ),
                );
          }
          state.data['revision'] = turns;
          await (db.update(
            db.roleplaySaves,
          )..where((t) => t.worldId.equals(id))).write(
            RoleplaySavesCompanion(
              revision: Value(turns),
              payload: Value(jsonEncode(state.data)),
            ),
          );
        });
      }

      await open('/');
      expect(await db.select(db.worlds).get(), isEmpty);
      expect(find.byType(Card), findsNothing);
      await capture('01-empty-home');
      await world('shanghai', '1927 · 上海来信');
      await open('/');
      expect(find.text('继续 · 1927 · 上海来信'), findsOneWidget);
      await capture('02-existing-home');
      await tester.enterText(
        find.byKey(const Key('home-input')),
        '我想进入1927年的上海，扮演一名年轻记者。世界没有超自然力量，故事从我刚下火车开始。',
      );
      await tester.pumpAndSettle();
      await capture('03-world-input');
      await open('/play/shanghai');
      expect(find.byType(Card), findsNothing);
      expect(find.text('陈禾'), findsOneWidget);
      expect(find.text('旧版离线记录'), findsOneWidget);
      await capture('04-chat');
      await tester.tap(find.byTooltip('世界更多操作'));
      await tester.pumpAndSettle();
      expect(find.text('剧情与记忆'), findsOneWidget);
      expect(find.text('记忆管理'), findsNothing);
      expect(find.text('剧情时间线'), findsNothing);
      await tester.tap(find.text('剧情与记忆'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('时间线、记忆与历史节点'));
      await tester.pumpAndSettle();
      expect(find.text('页面不存在'), findsNothing);
      await open('/play/shanghai');
      await tester.tap(find.byTooltip('快速调整叙事'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('1500 字'));
      await tester.pumpAndSettle();
      expect(find.text('目标字数 · 1500 字'), findsOneWidget);
      await capture('v056-narration');
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('本次聊天的叙事偏好'), findsNothing);
      await open('/world/shanghai');
      expect(find.text('最近节点 · 第 1 轮'), findsOneWidget);
      expect(find.text('继续故事'), findsOneWidget);
      await capture('v056-world-preview');
      await world('long', '雨中的上海', turns: 60, long: true);
      await open('/play/long');
      expect(find.byType(SelectableText).evaluate().length, lessThan(60));
      await tester.drag(
        find.byKey(const Key('story-scroll')),
        const Offset(0, 260),
      );
      await tester.pumpAndSettle();
      await capture('05-long-story');
      await capture('v056-reading');
      await tester.runAsync(() async {
        await PendingShareRepository(db).receive(
          IncomingShare(
            id: 'system-ui',
            source: ImportSource.system,
            receivedAt: DateTime(2026, 11, 17),
            text: '用户：我想创造一个1927年的上海世界，我是一名年轻记者。\nDeepSeek：汽笛声渐远。你站在上海火车站前，抬头望见屋檐下的一位报社编辑。',
          ),
        );
      });
      await open('/imports/preview/system-ui');
      expect(find.text('导入并继续故事'), findsOneWidget);
      expect(find.text('仅保存历史'), findsOneWidget);
      await capture('06-system-share-preview');
      await open('/');
      await tester.tap(find.byTooltip('打开世界菜单'));
      await tester.pumpAndSettle();
      expect(find.text('最近世界'), findsOneWidget);
      await capture('07-world-drawer');
      await open('/settings');
      expect(find.text('AI 服务设置'), findsOneWidget);
      await capture('08-settings');
      await capture('v056-settings');
      if (_captureV056) {
        await open('/narrative-settings');
        await capture('v056-global-narration');
        await tester.runAsync(
          () => PendingShareRepository(db).save(
            'system-ui',
            const ConversationDraft(
              title: '上海来信 · 历史记录',
              messages: [
                ImportedMessage(
                  id: 'player',
                  role: 'user',
                  content: '我刚从火车站出来，想找一家能避雨的茶馆。',
                  rawJson: '{}',
                ),
                ImportedMessage(
                  id: 'scene',
                  role: 'assistant',
                  content:
                      '街灯刚刚亮起。雨落在石板上，溅起一小片雾。\n\n茶馆门边有一张湿漉漉的旧报纸，头版上还留着手写的日期。',
                  rawJson: '{}',
                ),
              ],
            ),
            ImportDestination.history,
          ),
        );
        await open('/imports/result/system-ui');
        await capture('v056-import-reading');
        await open('/feedback');
        await capture('v056-feedback');
      }
      tester.view.viewInsets = const FakeViewPadding(bottom: 280);
      await open('/play/shanghai', keyboard: true);
      await tester.showKeyboard(find.byKey(const Key('roleplay-input')));
      await tester.enterText(
        find.byKey(const Key('roleplay-input')),
        '我想问问陈禾今天报社发生了什么。',
      );
      await tester.pumpAndSettle();
      expect(
        tester.getBottomRight(find.byTooltip('发送')).dy,
        lessThanOrEqualTo(844 - 280),
      );
      await capture('09-keyboard-layout-simulation');
      tester.view.resetViewInsets();
      tester.view.physicalSize = const Size(320, 640);
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      await open('/play/shanghai');
      expect(
        tester
            .widget<TextField>(find.byKey(const Key('roleplay-input')))
            .controller!
            .text,
        '我想问问陈禾今天报社发生了什么。',
      );
      await capture('10-small-screen');
      tester.view.physicalSize = const Size(640, 360);
      tester.view.viewPadding = const FakeViewPadding(left: 30, right: 30);
      tester.view.padding = tester.view.viewPadding;
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      await open('/play/shanghai');
      expect(
        Theme.of(tester.element(find.byType(Scaffold))).brightness,
        Brightness.light,
      );
      await tester.tap(find.byTooltip('快速调整叙事'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      tester.view.resetViewPadding();
      tester.view.resetPadding();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
      if (const bool.fromEnvironment('FISH_KEY_GUIDE_CAPTURE')) {
        tester.view.physicalSize = const Size(390, 1050);
        await open('/api/setup');
        await tester.tap(find.text('图解获取 API Key'));
        await tester.pumpAndSettle();
        await capture('12-api-key-guide-1');
        await tester.scrollUntilVisible(find.text('4. 回鱼者粘贴并保存'), 300);
        await capture('12-api-key-guide-2');
      }
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      container?.dispose();
      await tester.runAsync(db.close);
    },
  );

  testWidgets(
    'import reader lazily renders message bodies and jumps to exact ends',
    (tester) async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final repo = PendingShareRepository(db);
      await tester.runAsync(() async {
        await repo.receive(
          IncomingShare(
            id: 'long-reading',
            source: ImportSource.paste,
            receivedAt: DateTime(2026, 11, 19),
            text: '用户：原始记录',
          ),
        );
        await repo.save(
          'long-reading',
          ConversationDraft(
            title: '海风与旧信',
            messages: [
              for (var i = 1; i <= 600; i++)
                ImportedMessage(
                  id: 'message-$i',
                  role: i.isOdd ? 'user' : 'assistant',
                  content: '原始正文第 $i 条',
                  rawJson: '{}',
                ),
            ],
          ),
          ImportDestination.history,
        );
      });
      final container = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(db)],
      );
      container.read(routerProvider).go('/imports/result/long-reading');
      await tester.pumpWidget(
        UncontrolledProviderScope(container: container, child: const FishApp()),
      );
      await tester.pumpAndSettle();
      expect(find.text('已保存到本机 · 共 600 条原始消息'), findsOneWidget);
      expect(find.byType(Card), findsNothing);
      expect(find.byType(SelectableText).evaluate().length, lessThan(40));
      await tester.tap(find.byTooltip('跳到结尾'));
      await tester.pumpAndSettle();
      expect(find.text('原始正文第 600 条', findRichText: true), findsOneWidget);
      await tester.tap(find.byTooltip('跳到开头'));
      await tester.pumpAndSettle();
      expect(find.text('海风与旧信'), findsOneWidget);
      await tester.tap(find.text('来源与导入完整性'));
      await tester.pumpAndSettle();
      expect(find.text('来源 · 粘贴导入'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      container.dispose();
      await tester.runAsync(db.close);
    },
  );
}
