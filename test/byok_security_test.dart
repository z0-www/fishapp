import 'package:fishtextadventure/features/usage/price_schedule_provider.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_http_protocol.dart';
import 'package:fishtextadventure/shared/data/text_draft_store.dart';
import 'package:fishtextadventure/app/router.dart';
import 'package:fishtextadventure/features/ai/presentation/api_key_reminder.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:fishtextadventure/app/app.dart';
import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/core/security/api_key_storage.dart';
import 'package:fishtextadventure/features/ai/application/ai_providers.dart';
import 'package:fishtextadventure/features/settings/application/product_statement_preference.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_api_client.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_config.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_error_handler.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_repository.dart';
import 'package:fishtextadventure/features/usage/price_table.dart';
import 'package:fishtextadventure/features/usage/usage_repository.dart';
import 'package:fishtextadventure/features/worlds/application/world_providers.dart';
import 'package:fishtextadventure/features/worlds/data/world_repository.dart';
import 'package:fishtextadventure/features/worlds/data/world_export_service.dart';

import 'widget_test.dart' as legacy;

// Deliberately synthetic fixtures, never real credentials.
final synthetic = 'sk-${List.filled(32, 'A').join()}';
final replacement = 'sk-${List.filled(32, 'B').join()}';

class ConnectionTestConfig extends DeepSeekConfig {
  const ConnectionTestConfig();
  @override
  bool get permitsDirectCalls => true;
}

class CountingMock implements DeepSeekRepository {
  int calls = 0;
  bool fail = false;
  @override
  Future<ConnectionTestResult> testConnection(String apiKey) async {
    calls++;
    if (fail) {
      throw DioException(
        requestOptions: RequestOptions(
          path: '/',
          headers: {'Authorization': 'Bearer $apiKey'},
        ),
        error: apiKey,
        type: DioExceptionType.connectionError,
      );
    }
    return const ConnectionTestResult(
      ConnectionReceipt('deepseek-flash', Duration.zero, {}),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  late Map<String, String> vault;
  late List<MethodCall> calls;
  late bool failStorage;
  setUp(() {
    debugDefaultTargetPlatformOverride = null;
    vault = {};
    calls = [];
    failStorage = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          if (failStorage) {
            throw PlatformException(code: 'locked', message: synthetic);
          }
          final args = Map<String, dynamic>.from(call.arguments as Map);
          final key = args['key'] as String?;
          switch (call.method) {
            case 'write':
              vault[key!] = args['value'] as String;
              return null;
            case 'read':
              return vault[key];
            case 'containsKey':
              return vault.containsKey(key);
            case 'delete':
              vault.remove(key);
              return null;
            default:
              throw StateError('unexpected credential operation');
          }
        });
  });
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });
  test('secure storage lifecycle survives service recreation and replaces/deletes one item', () async {
    final storage = ApiKeyStorage();
    expect(await storage.hasApiKey(), false);
    await storage.saveApiKey(synthetic);
    expect(await storage.hasApiKey(), true);
    expect(await ApiKeyStorage().readApiKey(), synthetic);
    await storage.updateApiKey(replacement);
    expect(await ApiKeyStorage().readApiKey(), replacement);
    expect(vault.length, 1);
    await storage.deleteApiKey();
    expect(await storage.hasApiKey(), false);
    expect(
      calls.where((c) => c.method == 'deleteAll' || c.method == 'readAll'),
      isEmpty,
    );
  });
  test('Android and iOS security options and failure preservation', () async {
    final storage = ApiKeyStorage();
    await storage.saveApiKey(synthetic);
    final android = Map<String, dynamic>.from(
      (calls.last.arguments as Map)['options'] as Map,
    );
    expect(android['resetOnError'], 'false');
    expect(android['migrateWithBackup'], 'false');
    expect(android['storageNamespace'], 'fish_api_credentials');
    expect(android['storageCipherAlgorithm'], 'AES_GCM_NoPadding');
    expect(
      android['keyCipherAlgorithm'],
      'RSA_ECB_OAEPwithSHA_256andMGF1Padding',
    );
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    await storage.hasApiKey();
    final ios = Map<String, dynamic>.from(
      (calls.last.arguments as Map)['options'] as Map,
    );
    expect(ios['synchronizable'], 'false');
    expect(
      ios['accessibility'],
      KeychainAccessibility.unlocked_this_device.name,
    );
    failStorage = true;
    try {
      await storage.updateApiKey(replacement);
      fail('must fail');
    } catch (e) {
      expect(e, isA<ApiKeyStorageException>());
      expect(e.toString(), isNot(contains(synthetic)));
    }
    failStorage = false;
    expect(await storage.readApiKey(), synthetic);
  });
  test(
    'no credential in SQLite, save export, or logs; deletion preserves worlds',
    () async {
      final dir = Directory.systemTemp.createTempSync('fish_byok_security_');
      final file = File('${dir.path}/data.sqlite');
      final db = AppDatabase.forTesting(NativeDatabase(file));
      try {
        final worlds = SqliteWorldRepository(db);
        final world = await worlds.create('保留的世界');
        final storage = ApiKeyStorage();
        final logs = <String>[];
        final original = debugPrint;
        debugPrint = (String? text, {int? wrapWidth}) {
          logs.add(text ?? '');
        };
        try {
          await runZoned(
            () async {
              await storage.saveApiKey(synthetic);
              final repo = CountingMock()..fail = true;
              try {
                await repo.testConnection((await storage.readApiKey())!);
              } catch (e) {
                logs.add(DeepSeekErrorHandler.sanitize(e).toString());
              }
              expect(await storage.readApiKey(), synthetic);
              await storage.deleteApiKey();
            },
            zoneSpecification: ZoneSpecification(
              print: (self, parent, zone, line) => logs.add(line),
            ),
          );
        } finally {
          debugPrint = original;
        }
        expect(logs.join(), isNot(contains(synthetic)));
        final loaded = await worlds.load();
        expect(loaded.single.id, world.id);
        final exported = WorldExportService.encode(loaded);
        expect(exported, isNot(contains(synthetic)));
        expect(
          (jsonDecode(exported) as Map).keys,
          unorderedEquals(['format', 'worlds']),
        );
        expect((await db.select(db.usageRecords).get()), isEmpty);
        final tables = await db
            .customSelect(
              "SELECT name, sql FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
            )
            .get();
        for (final table in tables) {
          final name = table.read<String>('name');
          final rows = await db.customSelect('SELECT * FROM "$name"').get();
          expect(
            jsonEncode(rows.map((r) => r.data).toList()),
            isNot(contains(synthetic)),
          );
          expect(table.data.toString(), isNot(contains('api_key')));
        }
      } finally {
        await db.close();
      }
      expect(latin1.decode(file.readAsBytesSync()), isNot(contains(synthetic)));
      dir.deleteSync(recursive: true);
    },
  );
  test(
    'schema v1 migrates to current preserving worlds and metadata',
    () async {
      final dir = Directory.systemTemp.createTempSync('fish_byok_migration_');
      final file = File('${dir.path}/v1.sqlite');
      final old = sqlite3.open(file.path);
      old.execute(
        'CREATE TABLE worlds (id TEXT NOT NULL PRIMARY KEY, title TEXT NOT NULL, genre TEXT NOT NULL, summary TEXT NOT NULL, created_at INTEGER NOT NULL)',
      );
      old.execute(
        "INSERT INTO worlds VALUES ('legacy','原有存档','海洋','旧故事',1794820000)",
      );
      old.execute('CREATE TABLE app_meta (key TEXT PRIMARY KEY)');
      old.execute("INSERT INTO app_meta VALUES ('seeded')");
      old.execute('PRAGMA user_version=1');
      old.close();
      final db = AppDatabase.forTesting(NativeDatabase(file));
      try {
        final repo = SqliteWorldRepository(db);
        expect((await repo.load()).single.id, 'legacy');
        expect(await UsageRepository(db).load(), isEmpty);
        expect(
          (await db.customSelect('PRAGMA user_version').getSingle()).read<int>(
            'user_version',
          ),
          6,
        );
      } finally {
        await db.close();
        dir.deleteSync(recursive: true);
      }
    },
  );
  test(
    'default adapter cannot send; unsafe hosts rejected; HTTP errors sanitized',
    () async {
      const config = DeepSeekConfig();
      expect(config.permitsDirectCalls, false);
      expect(config.hasSafeEndpoint, true);
      expect(
        const DeepSeekConfig(baseUrl: 'https://example.com').hasSafeEndpoint,
        false,
      );
      expect(
        const DeepSeekConfig(baseUrl: 'http://api.deepseek.com')
            .hasSafeEndpoint,
        false,
      );
      final client = DeepSeekApiClient(config);
      addTearDown(client.close);
      await expectLater(
        client.testConnection(synthetic),
        throwsA(isA<DeepSeekFailure>()),
      );
      await expectLater(
        client.streamMessages(synthetic, const [
          {'role': 'user', 'content': 'hi'},
        ], cancelToken: CancelToken()).toList(),
        throwsA(isA<DeepSeekFailure>()),
      );
      for (final status in [401, 402, 429, 500, 503, 504]) {
        final options = RequestOptions(
          path: '/',
          headers: {'Authorization': 'Bearer $synthetic'},
        );
        final error = DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: status,
            data: synthetic,
          ),
          message: synthetic,
        );
        final safe = DeepSeekErrorHandler.sanitize(error).message;
        expect(safe, isNot(contains(synthetic)));
        expect(safe, DeepSeekErrorHandler.fromStatus(status).message);
      }
    },
  );
  test('SSE split UTF8, CRLF, comments, usage and DONE; malformed events safe', () async {
    final body =
        ': keepalive\r\ndata: {"text":"鱼者"}\r\n\r\ndata: {"usage":{"prompt_tokens":1}}\n\ndata: [DONE]\n\n';
    final chunks = utf8.encode(body).map((b) => [b]);
    final rows = await DeepSeekApiClient.decodeSse(Stream.fromIterable(chunks))
        .toList();
    expect(rows.length, 2);
    expect(rows.first['text'], '鱼者');
    expect(rows.last['usage'], {'prompt_tokens': 1});
    await expectLater(
      DeepSeekApiClient.decodeSse(
        Stream.value(utf8.encode('data: $synthetic\n\n')),
      ).toList(),
      throwsA(isA<DeepSeekFailure>()),
    );
    await expectLater(
      DeepSeekApiClient.decodeSse(Stream.value(utf8.encode('data: {}')))
          .toList(),
      throwsA(isA<DeepSeekFailure>()),
    );
  });
  test('usage starts empty, unknown price stays null and versioned estimate is local', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = UsageRepository(db);
    expect(await repo.load(), isEmpty);
    await repo.record(
      requestedAt: DateTime(2026, 11, 16),
      model: 'test-fixture',
      inputTokens: 10,
      outputTokens: 2,
    );
    expect((await repo.load()).single.estimatedUsd, isNull);
    final price = PriceTable(
      version: 'unit-test-not-real-price',
      effectiveAt: DateTime(2026),
      model: 'test-fixture',
      inputUsdPerMillion: 1,
      outputUsdPerMillion: 2,
      cachedUsdPerMillion: 0.1,
    );
    expect(
      price.estimate(
        requestedAt: DateTime(2026, 11),
        input: 10,
        output: 2,
        cached: 2,
      ),
      closeTo(0.0000122, 1e-12),
    );
    expect(
      price.estimate(
        requestedAt: DateTime(2025),
        input: 10,
        output: 2,
        cached: 2,
      ),
      isNull,
    );
  });
  Future<void> launch(
    WidgetTester tester,
    CountingMock repo, {
    bool openSetup = true,
  }) async {
    final walletDb = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(walletDb.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          textDraftStoreProvider.overrideWithValue(MemoryTextDraftStore()),
          productStatementSeenProvider.overrideWith((ref) async => true),
          deepSeekRepositoryProvider.overrideWithValue(repo),
          databaseProvider.overrideWithValue(walletDb),
          walletPriceProvider.overrideWith((ref) async => null),
          deepSeekConfigProvider.overrideWithValue(
            const ConnectionTestConfig(),
          ),
          repositoryProvider.overrideWithValue(legacy.MemoryRepository()),
        ],
        child: const FishApp(),
      ),
    );
    await tester.pumpAndSettle();
    if (openSetup && !await ApiKeyStorage().hasApiKey()) {
      ProviderScope.containerOf(tester.element(find.byType(FishApp)))
          .read(routerProvider)
          .go('/api/setup');
      await tester.pumpAndSettle();
    }
  }

  testWidgets(
    'first entry obscured, paste, explicit local save confirmation, clear and save',
    (tester) async {
      final repo = CountingMock();
      await launch(tester, repo);
      expect(find.text('欢迎来到鱼者文游'), findsOneWidget);
      expect(repo.calls, 0);
      final field = find.byKey(const Key('api-key-input'));
      expect(tester.widget<TextField>(field).obscureText, true);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            SystemChannels.platform,
            (call) async =>
                call.method == 'Clipboard.getData' ? {'text': synthetic} : null,
          );
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null),
      );
      await tester.tap(find.text('粘贴'));
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(field).controller!.text, synthetic);
      await tester.tap(find.byTooltip('显示密钥'));
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(field).obscureText, false);
      await tester.ensureVisible(find.text('保存 API Key'));
      await tester.tap(find.text('保存 API Key'));
      await tester.pumpAndSettle();
      expect(repo.calls, 0);
      expect(vault, isEmpty);
      expect(find.text('保存到本机安全存储？'), findsOneWidget);
      await tester.tap(find.text('确认保存'));
      await tester.pumpAndSettle();
      expect(await ApiKeyStorage().hasApiKey(), true);
      expect(find.byKey(const Key('home-input')), findsOneWidget);
      expect(find.byKey(const Key('api-key-input')), findsNothing);
      await tester.tap(find.text('测试连接'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('手动测试连接'));
      expect(find.text('手动测试连接'), findsOneWidget);
      expect(repo.calls, 0);
    },
  );
  testWidgets(
    'home reminder stays visible until save and returns after deletion',
    (tester) async {
      tester.view.physicalSize = const Size(320, 600);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.6;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final repo = CountingMock();
      await launch(tester, repo, openSetup: false);

      final reminder = find.text(ApiKeyReminder.label);
      expect(reminder, findsOneWidget);
      await tester.pump(const Duration(seconds: 20));
      expect(reminder, findsOneWidget);
      await tester.tap(reminder);
      await tester.pumpAndSettle();
      final field = find.byKey(const Key('api-key-input'));
      await tester.enterText(field, synthetic);
      final save = find.text('保存 API Key');
      await tester.ensureVisible(save);
      await tester.tap(save);
      await tester.pumpAndSettle();
      await tester.tap(find.text('确认保存'));
      await tester.pumpAndSettle();
      expect(reminder, findsNothing);
      expect(find.byKey(const Key('home-input')), findsOneWidget);

      final router = ProviderScope.containerOf(
        tester.element(find.byType(FishApp)),
      ).read(routerProvider);
      router.push<void>('/ai-settings');
      await tester.pumpAndSettle();
      final delete = find.text('删除 API Key');
      await tester.scrollUntilVisible(delete, 220);
      await tester.pumpAndSettle();
      await tester.tap(delete);
      await tester.pumpAndSettle();
      await tester.tap(find.text('确认删除'));
      await tester.pumpAndSettle();
      expect(await ApiKeyStorage().hasApiKey(), false);
      router.pop();
      await tester.pumpAndSettle();
      expect(reminder, findsOneWidget);
      expect(repo.calls, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'settings guide opens the browser and returns to setup without clipboard access',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      var clipboardReads = 0;
      final launches = <Map<String, dynamic>>[];
      const launcher = MethodChannel('plugins.flutter.io/url_launcher');
      messenger.setMockMethodCallHandler(launcher, (call) async {
        if (call.method != 'launch') return false;
        launches.add(Map<String, dynamic>.from(call.arguments as Map));
        return true;
      });
      addTearDown(() => messenger.setMockMethodCallHandler(launcher, null));
      messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method != 'Clipboard.getData') return null;
        clipboardReads++;
        return {'text': synthetic};
      });
      addTearDown(
        () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
      );
      final repo = CountingMock();
      await launch(tester, repo);
      final router = ProviderScope.containerOf(
        tester.element(find.byType(FishApp)),
      ).read(routerProvider);
      router.go('/ai-settings');
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('如何获取 API Key？'));
      await tester.tap(find.text('如何获取 API Key？'));
      await tester.pumpAndSettle();
      expect(find.text('打开 DeepSeek 密钥页面'), findsOneWidget);
      expect(clipboardReads, 0);
      await tester.scrollUntilVisible(
        find.text('4. 回鱼者粘贴并保存'),
        240,
        scrollable: find.byType(Scrollable).last,
      );
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('打开 DeepSeek 密钥页面'));
      await tester.pumpAndSettle();
      expect(launches.single['url'], 'https://platform.deepseek.com/api_keys');
      expect(launches.single['useWebView'], false);
      expect(launches.single['useSafariVC'], false);
      for (final state in [
        AppLifecycleState.inactive,
        AppLifecycleState.hidden,
        AppLifecycleState.paused,
        AppLifecycleState.hidden,
        AppLifecycleState.inactive,
        AppLifecycleState.resumed,
      ]) {
        tester.binding.handleAppLifecycleStateChanged(state);
      }
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('api-key-input')), findsOneWidget);
      expect(clipboardReads, 0);
      expect(find.text('打开 DeepSeek 密钥页面'), findsNothing);
      await tester.ensureVisible(find.text('粘贴'));
      await tester.tap(find.text('粘贴'));
      await tester.pumpAndSettle();
      final field = tester.widget<TextField>(
        find.byKey(const Key('api-key-input')),
      );
      expect(field.controller!.text, synthetic);
      expect(field.obscureText, true);
      expect(clipboardReads, 1);
      expect(repo.calls, 0);
      expect(vault, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('cancel does not save; transient input cleared on background', (
    tester,
  ) async {
    await launch(tester, CountingMock());
    final field = find.byKey(const Key('api-key-input'));
    await tester.enterText(field, synthetic);
    await tester.ensureVisible(find.text('保存 API Key'));
    await tester.tap(find.text('保存 API Key'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('暂不保存'));
    await tester.pumpAndSettle();
    expect(vault, isEmpty);
    expect(tester.widget<TextField>(field).controller!.text, isEmpty);
    await tester.enterText(field, synthetic);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(tester.widget<TextField>(field).controller!.text, isEmpty);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
  });
  testWidgets(
    'saved startup makes no request; failed replacement preserves key; delete retains world',
    (tester) async {
      await ApiKeyStorage().saveApiKey(synthetic);
      final repo = CountingMock();
      await launch(tester, repo);
      expect(find.byKey(const Key('home-input')), findsOneWidget);
      expect(repo.calls, 0);
      await tester.tap(find.byTooltip('更多操作'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('设置'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('AI 服务设置'));
      await tester.pumpAndSettle();
      expect(find.text('API Key 已保存：••••••••'), findsOneWidget);
      expect(find.text(synthetic), findsNothing);
      repo.fail = true;
      await tester.ensureVisible(find.text('手动测试连接'));
      await tester.tap(find.text('手动测试连接'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('同意费用并测试'));
      await tester.pumpAndSettle();
      expect(await ApiKeyStorage().readApiKey(), synthetic);
      expect(find.textContaining('连接失败'), findsOneWidget);
      await tester.tap(find.text('更换 API Key'));
      await tester.pumpAndSettle();
      final field = find.byKey(const Key('api-key-input'));
      expect(tester.widget<TextField>(field).controller!.text, isEmpty);
      await tester.enterText(field, replacement);
      await tester.ensureVisible(find.text('保存 API Key'));
      await tester.tap(find.text('保存 API Key'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('暂不保存'));
      await tester.pumpAndSettle();
      expect(await ApiKeyStorage().readApiKey(), synthetic);
      expect(tester.widget<TextField>(field).controller!.text, isEmpty);
      repo.fail = false;
      await tester.enterText(field, replacement);
      await tester.ensureVisible(find.text('保存 API Key'));
      await tester.tap(find.text('保存 API Key'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('确认保存'));
      await tester.pumpAndSettle();
      expect(await ApiKeyStorage().readApiKey(), replacement);
      await tester.tap(find.text('删除 API Key'));
      await tester.pumpAndSettle();
      expect(find.text('只删除密钥，世界和游戏存档会保留。'), findsOneWidget);
      await tester.tap(find.text('确认删除'));
      await tester.pumpAndSettle();
      expect(await ApiKeyStorage().hasApiKey(), false);
      expect(find.text('尚未保存 API Key'), findsOneWidget);
    },
  );
  test('credential imports and log sinks stay isolated; custom errors are sanitized', () {
    expect(
      DeepSeekErrorHandler.sanitize(DeepSeekFailure(synthetic)).message,
      isNot(contains(synthetic)),
    );
    for (final file
        in Directory('lib')
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))) {
      final source = file.readAsStringSync();
      if (!file.path.endsWith('api_key_storage.dart')) {
        expect(
          source,
          isNot(contains("package:flutter_secure_storage/")),
          reason: file.path,
        );
      }
      expect(
        RegExp(r'\b(print|debugPrint|LogInterceptor)\s*\(').hasMatch(source),
        false,
        reason: file.path,
      );
    }
  });
  test('backup policies exclude keys from both backup and device transfer', () {
    final manifest = File('android/app/src/main/AndroidManifest.xml')
        .readAsStringSync();
    expect(manifest, contains('android:allowBackup="false"'));
    expect(
      manifest,
      contains('android:dataExtractionRules="@xml/data_extraction_rules"'),
    );
    final rules = File('android/app/src/main/res/xml/data_extraction_rules.xml')
        .readAsStringSync();
    expect(rules, contains('<device-transfer>'));
    expect(RegExp('domain="sharedpref" path="."').allMatches(rules).length, 2);
  });
}
