import 'package:fishtextadventure/shared/data/text_draft_store.dart';

import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:fishtextadventure/app/app.dart';
import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/features/ai/application/ai_providers.dart';
import 'package:fishtextadventure/features/import_center/domain/import_models.dart';
import 'package:fishtextadventure/features/import_center/data/conversation_parsers.dart';
import 'package:fishtextadventure/features/import_center/data/pending_share_repository.dart';
import 'package:fishtextadventure/features/import_center/application/import_providers.dart';
import 'package:fishtextadventure/features/worlds/application/world_providers.dart';
import 'package:fishtextadventure/platform/share_intake/share_intake_service.dart';

import 'widget_test.dart' as legacy;

IncomingShare share(String id, String text) => IncomingShare(
  id: id,
  source: ImportSource.system,
  receivedAt: DateTime(2026, 11, 17),
  text: text,
);
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('PlainTextParser preserves exact text and unknown speaker', () async {
    const text = '原始提问\n\n  原始回复';
    final d = await PlainTextParser().parse(text, [], ImportCancellation());
    expect(d.messages.single.content, text);
    expect(d.messages.single.role, 'unknown');
    expect(jsonDecode(d.messages.single.rawJson), {'text': text});
  });
  test(
    'DeepSeekShareParser stores URL without fetching or claiming conversation',
    () async {
      final d = await DeepSeekShareParser().parse(
        'https://chat.deepseek.com/share/example',
        [],
        ImportCancellation(),
      );
      expect(
        d.messages.single.content,
        'https://chat.deepseek.com/share/example',
      );
      expect(d.warnings.single, contains('尚未读取网页'));
      expect(d.canSave, false);
      expect(DeepSeekShareParser().isUrl('file:///private/secret'), false);
    },
  );
  test('DeepSeek title and share link never become story prose', () async {
    const url = 'https://chat.deepseek.com/share/example123';
    const registry = ImportParserRegistry();
    final link = await registry.parse(
      share('card', '茶馆旧事\r\n$url'),
      ImportCancellation(),
      (_) {},
    );
    expect(link.canSave, false);
    expect(link.sourceUrl, url);
    final conversation = await registry.parse(
      share('dialogue', '用户：推开茶馆的门。\nDeepSeek：雨声落在檐前。\n$url'),
      ImportCancellation(),
      (_) {},
    );
    expect(conversation.canSave, true);
    expect(conversation.messages.map((m) => m.role), ['user', 'assistant']);
  });

  test(
    'MarkdownParser retains raw markdown; HTML raw source remains separate',
    () async {
      final d = await MarkdownParser().parse(
        '# 标题\n**原文**',
        [],
        ImportCancellation(),
      );
      expect(d.messages.single.content, '# 标题\n**原文**');
      final html = await const ImportParserRegistry().parse(
        IncomingShare(
          id: 'html',
          source: ImportSource.paste,
          receivedAt: DateTime(2026),
          mime: 'text/html',
          text: '<p>你好</p><img src="https://example.com/a.png">',
        ),
        ImportCancellation(),
        (_) {},
      );
      expect(html.messages.single.content, contains('你好'));
      expect(html.messages.single.rawJson, contains('<img'));
      expect(html.warnings.join(), contains('未执行脚本'));
    },
  );
  test('JsonConversationParser refuses unknown conversion honestly', () async {
    final d = await JsonConversationParser().parse(
      '{invalid',
      [],
      ImportCancellation(),
    );
    expect(d.canSave, false);
    expect(d.messages, isEmpty);
  });
  test('DeepSeekZipParser rejects absent or unsafe input', () async {
    await expectLater(
      DeepSeekZipParser().parse('../zip-slip', [], ImportCancellation()),
      throwsA(isA<ImportFailure>()),
    );
  });
  test('ImageAttachmentParser checks signatures and mismatch without loading whole image', () async {
    final dir = Directory.systemTemp.createTempSync('fish_image_test_');
    final file = File(p.join(dir.path, 'img'))
      ..writeAsBytesSync([137, 80, 78, 71, 13, 10, 26, 10, 0]);
    try {
      final a = ImportedAttachment(
        path: file.path,
        name: 'a.png',
        mime: 'image/png',
        size: 9,
      );
      final d = await ImageAttachmentParser().parse('', [
        a,
      ], ImportCancellation());
      expect(d.attachments.single.isImage, true);
      expect(d.messages, isEmpty);
      await expectLater(
        ImageAttachmentParser().parse('', [
          ImportedAttachment(
            path: file.path,
            name: 'fake.jpg',
            mime: 'image/jpeg',
            size: 9,
          ),
        ], ImportCancellation()),
        throwsA(isA<ImportFailure>()),
      );
    } finally {
      dir.deleteSync(recursive: true);
    }
  });
  test('dedupe is durable and different events remain separate; confirmation required', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = PendingShareRepository(db);
    expect(await repo.receive(share('event-a', '相同内容')), 'event-a');
    expect(await repo.receive(share('event-b', '相同内容')), 'event-a');
    await repo.receive(share('event-c', '不同内容'));
    expect((await repo.pending()).length, 2);
    expect(await repo.history(), isEmpty);
    expect(await db.select(db.worlds).get(), isEmpty);
  });
  test('confirmation is idempotent, preserves branches/raw fragments and associates worlds', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = PendingShareRepository(db);
    await repo.receive(share('branch', '分支会话'));
    const d = ConversationDraft(
      title: '原始树',
      currentMessageId: 'child-b',
      branches: 2,
      messages: [
        ImportedMessage(
          id: 'root',
          role: 'user',
          content: '问',
          rawJson: '{"fragments":["问"],"unknown":true}',
        ),
        ImportedMessage(
          id: 'child-a',
          parentId: 'root',
          role: 'assistant',
          content: '答 A',
          rawJson: '{"branch":"a"}',
        ),
        ImportedMessage(
          id: 'child-b',
          parentId: 'root',
          role: 'assistant',
          content: '答 B',
          rawJson: '{"branch":"b"}',
        ),
      ],
    );
    final result = await repo.save('branch', d, ImportDestination.newWorld);
    final repeated = await repo.save('branch', d, ImportDestination.newWorld);
    expect(result.conversationId, repeated.conversationId);
    expect((await db.select(db.worlds).get()).length, 1);
    final rows = await repo.messages(result.conversationId);
    expect(rows.length, 3);
    expect(rows[2].parentId, 'root');
    expect(rows.first.rawJson, contains('unknown'));
    expect((await repo.conversation('branch'))!.currentMessageId, 'child-b');
    await repo.receive(share('attach-world', '另一会话'));
    await repo.save(
      'attach-world',
      const ConversationDraft(title: '另一', messages: []),
      ImportDestination.existingWorld,
      worldId: result.worldId,
    );
    expect((await repo.history(worldId: result.worldId)).length, 2);
    expect(await db.select(db.derivedImportResults).get(), isEmpty);
  });
  test(
    'unsupported conversion cannot create a world or a fake result',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = PendingShareRepository(db);
      await repo.receive(share('zip', '待转换'));
      await expectLater(
        repo.save(
          'zip',
          const ConversationDraft(title: 'ZIP', messages: [], canSave: false),
          ImportDestination.newWorld,
        ),
        throwsA(isA<ImportFailure>()),
      );
      expect(await repo.history(), isEmpty);
      expect(await db.select(db.worlds).get(), isEmpty);
    },
  );
  test('pending and cancel state survive SQLite close/reopen', () async {
    final dir = Directory.systemTemp.createTempSync('fish_pending_restart_');
    final file = File(p.join(dir.path, 'db.sqlite'));
    final first = AppDatabase.forTesting(NativeDatabase(file));
    final repo = PendingShareRepository(first);
    await repo.receive(share('pending', '暂存原文'));
    await repo.mark('pending', 'cancelled');
    await first.close();
    final second = AppDatabase.forTesting(NativeDatabase(file));
    try {
      final restored = await PendingShareRepository(second).get('pending');
      expect(restored!.state, 'cancelled');
      expect(restored.share.text, '暂存原文');
    } finally {
      await second.close();
      dir.deleteSync(recursive: true);
    }
  });
  test('path traversal and size limits are rejected before parsing; cancel supported', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = PendingShareRepository(
      db,
      limits: const ImportLimits(textBytes: 4),
    );
    await expectLater(
      repo.receive(share('large', '12345')),
      throwsA(isA<ImportFailure>()),
    );
    final outside = IncomingShare(
      id: 'unsafe',
      source: ImportSource.system,
      receivedAt: DateTime(2026),
      files: [
        const ImportedAttachment(
          path: '/outside/../secret',
          name: 'evil.txt',
          mime: 'text/plain',
          size: 1,
        ),
      ],
    );
    await expectLater(repo.receive(outside), throwsA(isA<ImportFailure>()));
    final token = ImportCancellation()..cancel();
    await expectLater(
      const ImportParserRegistry().parse(
        share('cancel', 'text'),
        token,
        (_) {},
      ),
      throwsA(isA<ImportCancelled>()),
    );
  });
  test('schema 2 to 3 keeps worlds, usage and metadata', () async {
    final dir = Directory.systemTemp.createTempSync('fish_import_v2_');
    final path = p.join(dir.path, 'v2.sqlite');
    final old = sqlite3.open(path);
    old.execute(
      'CREATE TABLE worlds (id TEXT NOT NULL PRIMARY KEY,title TEXT NOT NULL,genre TEXT NOT NULL,summary TEXT NOT NULL,created_at INTEGER NOT NULL)',
    );
    old.execute("INSERT INTO worlds VALUES('old','旧世界','原有','保留',1794820000)");
    old.execute(
      'CREATE TABLE usage_records (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,requested_at INTEGER NOT NULL,model TEXT NOT NULL,input_tokens INTEGER NOT NULL,output_tokens INTEGER NOT NULL,cache_tokens INTEGER,estimated_usd REAL,price_version TEXT)',
    );
    old.execute(
      "INSERT INTO usage_records(requested_at,model,input_tokens,output_tokens) VALUES(1794820000,'old-model',2,1)",
    );
    old.execute('CREATE TABLE app_meta (key TEXT PRIMARY KEY)');
    old.execute("INSERT INTO app_meta VALUES('seeded')");
    old.execute('PRAGMA user_version=2');
    old.close();
    final db = AppDatabase.forTesting(NativeDatabase(File(path)));
    try {
      expect((await db.select(db.worlds).get()).single.id, 'old');
      expect(
        (await db.select(db.usageRecords).get()).single.model,
        'old-model',
      );
      expect(await PendingShareRepository(db).pending(), isEmpty);
      expect((await db.customSelect('SELECT * FROM app_meta').get()).length, 1);
    } finally {
      await db.close();
      dir.deleteSync(recursive: true);
    }
  });
  test('platform channel contract handles initial, ack and errors without leaking URIs', () async {
    const channel = MethodChannel('fish/share_intake');
    final calls = <String>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call.method);
          return call.method == 'pending'
              ? [share('native', '冷启动内容').toJson()]
              : null;
        });
    final service = ShareIntakeService();
    try {
      expect((await service.pending()).single.text, '冷启动内容');
      await service.acknowledge('native');
      expect(calls, ['pending', 'ack']);
    } finally {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
      await service.dispose();
    }
  });
  testWidgets(
    'mobile UI previews before saving and links result to import center',
    (tester) async {
      late AppDatabase db;
      await tester.runAsync(() async {
        db = AppDatabase.forTesting(NativeDatabase.memory());
        await db.select(db.pendingImports).get();
      });
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            textDraftStoreProvider.overrideWithValue(MemoryTextDraftStore()),
            databaseProvider.overrideWithValue(db),
            apiKeyStatusProvider.overrideWith((ref) async => true),
            repositoryProvider.overrideWithValue(legacy.MemoryRepository()),
          ],
          child: const FishApp(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('进入鱼者'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('更多操作'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('导入旧故事'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('import-text')), '待迁移的原始故事');
      await tester.ensureVisible(find.text('暂存并预览'));
      await tester.tap(find.text('暂存并预览'));
      await tester.pumpAndSettle();
      expect(find.text('导入对话'), findsOneWidget);
      expect(find.text('仅保存历史'), findsOneWidget);
      expect(await db.select(db.importedConversations).get(), isEmpty);
      await tester.ensureVisible(find.text('仅保存历史'));
      await tester.tap(find.text('仅保存历史'));
      await tester.pumpAndSettle();
      expect(find.text('已保存的原始记录'), findsOneWidget);
      expect((await db.select(db.importedConversations).get()).length, 1);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(db.close);
    },
  );
  test('iOS extension stays in the app group and inherits the Flutter build version', () {
    final runner = File('ios/Runner/Runner.entitlements').readAsStringSync();
    final extension = File('ios/ShareExtension/ShareExtension.entitlements')
        .readAsStringSync();
    final metadata = File('ios/ShareExtension/Info.plist').readAsStringSync();
    final project = File('ios/Runner.xcodeproj/project.pbxproj')
        .readAsStringSync();
    expect(
      runner,
      contains(r'$(AppIdentifierPrefix)com.yuzhe.fishtextadventure'),
    );
    expect(extension, isNot(contains('keychain-access-groups')));
    expect(metadata, contains(r'$(MARKETING_VERSION)'));
    expect(metadata, contains(r'$(CURRENT_PROJECT_VERSION)'));
    expect(
      project,
      contains(
        r'MARKETING_VERSION = "$(FLUTTER_BUILD_NAME)"; PRODUCT_BUNDLE_IDENTIFIER = com.yuzhe.fishtextadventure.ShareExtension',
      ),
    );
  });

  test('Android manifest and iOS handoff static invariants', () {
    final manifest = File('android/app/src/main/AndroidManifest.xml')
        .readAsStringSync();
    for (final value in [
      'android.intent.action.SEND',
      'android.intent.action.SEND_MULTIPLE',
      'text/plain',
      'text/html',
      'text/uri-list',
      'image/*',
      'application/json',
      'application/zip',
    ]) {
      expect(manifest, contains(value));
    }
    expect(manifest, isNot(contains('READ_EXTERNAL_STORAGE')));
    expect(manifest, isNot(contains('MANAGE_EXTERNAL_STORAGE')));
    final pbx = File('ios/Runner.xcodeproj/project.pbxproj').readAsStringSync();
    expect(pbx, contains('name = ShareExtension;'));
    expect(pbx, contains('Embed App Extensions'));
    for (final path in [
      'ios/Runner/Runner.entitlements',
      'ios/ShareExtension/ShareExtension.entitlements',
    ]) {
      expect(
        File(path).readAsStringSync(),
        contains('group.com.yuzhe.fishtextadventure'),
      );
    }
  });
  testWidgets(
    'cold and hot shares persist before ack, dedupe and auto-preview',
    (tester) async {
      late AppDatabase db;
      await tester.runAsync(() async {
        db = AppDatabase.forTesting(NativeDatabase.memory());
        await db.select(db.pendingImports).get();
      });
      final repository = PendingShareRepository(db);
      final service = FakeNativeIntake(
        repository,
      )..queue.addAll([share('cold-one', '冷启动分享'), share('cold-two', '冷启动分享')]);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            textDraftStoreProvider.overrideWithValue(MemoryTextDraftStore()),
            databaseProvider.overrideWithValue(db),
            shareIntakeProvider.overrideWithValue(service),
            apiKeyStatusProvider.overrideWith((ref) async => true),
            repositoryProvider.overrideWithValue(legacy.MemoryRepository()),
          ],
          child: const FishApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('进入鱼者'), findsOneWidget);
      expect(service.acked, isEmpty);
      await tester.tap(find.text('进入鱼者'));
      await tester.pumpAndSettle();
      expect(service.acked.length, 2);
      expect((await repository.pending()).length, 1);
      expect(find.text('导入对话'), findsOneWidget);
      await tester.tap(find.byTooltip('返回'));
      await tester.pumpAndSettle();
      expect((await repository.get('cold-one'))?.state, 'paused');
      service.queue.add(
        share('hot-one', '运行中分享\nhttps://chat.deepseek.com/share/example123'),
      );
      service.refresh();
      await tester.pumpAndSettle();
      expect(service.acked.length, 3);
      expect((await repository.pending()).length, 2);
      expect(find.text('导入对话'), findsOneWidget);
      expect(find.text('只收到分享链接，尚无对话正文'), findsOneWidget);
      expect(find.text('导入并继续故事'), findsNothing);
      expect(await repository.history(), isEmpty);
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'Clipboard.getData') {
          return {'text': '用户：推开茶馆的门。\nDeepSeek：雨声落在檐前。'};
        }
        return null;
      });
      addTearDown(
        () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
      );
      await tester.tap(find.text('粘贴对话正文'));
      await tester.pumpAndSettle();
      expect(find.text('已接收 2 条消息 · 用户 1 · AI 1'), findsOneWidget);
      await tester.tap(find.text('导入并继续故事'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('roleplay-input')), findsOneWidget);
      expect((await db.select(db.worlds).get()), hasLength(1));
      expect((await repository.history()), hasLength(1));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(db.close);
      await service.dispose();
    },
  );
}

class FakeNativeIntake extends ShareIntakeService {
  FakeNativeIntake(this.repository);
  final PendingShareRepository repository;
  final queue = <IncomingShare>[];
  final acked = <String>[];
  @override
  void start() {}
  @override
  Future<List<IncomingShare>> pending() async => List.of(queue);
  @override
  Future<void> acknowledge(String id, {bool keepFiles = true}) async {
    final record = id == 'hot-one' ? 'hot-one' : 'cold-one';
    if (await repository.get(record) == null) {
      throw StateError('ack before commit');
    }
    acked.add(id);
    queue.removeWhere((s) => s.id == id);
  }
}
