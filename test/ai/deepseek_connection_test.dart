import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart' show MaterialApp, SizedBox;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/core/release_access.dart';
import 'package:fishtextadventure/core/security/api_key_storage.dart';
import 'package:fishtextadventure/features/ai/application/ai_providers.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_api_client.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_config.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_repository.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_error_handler.dart';
import 'package:fishtextadventure/features/ai/data/deepseek_http_protocol.dart';
import 'package:fishtextadventure/features/ai/presentation/ai_settings_page.dart';
import 'package:fishtextadventure/features/ai/presentation/ai_developer_diagnostics_page.dart';
import 'package:fishtextadventure/features/roleplay/application/dialogue_engine.dart';
import 'package:fishtextadventure/features/roleplay/application/providers.dart';
import 'package:fishtextadventure/features/roleplay/application/turn_coordinator.dart';
import 'package:fishtextadventure/features/roleplay/data/roleplay_repository.dart';

import '../support/scenario_fixtures.dart';

import 'package:fishtextadventure/features/roleplay/domain/models.dart';
import 'package:fishtextadventure/features/usage/usage_repository.dart';
import 'package:fishtextadventure/features/world_creator/data/world_definition_repository.dart';
import 'package:fishtextadventure/features/world_creator/domain/world_definition.dart';
import 'package:fishtextadventure/features/worlds/application/world_providers.dart';

// Synthetic only. Never a real credential.
final syntheticKey = 'sk-${List.filled(32, 'A').join()}';

class TestKeyStorage extends ApiKeyStorage {
  TestKeyStorage({String? key}) : key = key ?? syntheticKey;
  final String? key;
  int reads = 0;
  @override
  Future<String?> readApiKey() async {
    reads++;
    return key;
  }

  @override
  Future<bool> hasApiKey() async => key != null;
}

class NoKeyStorage extends ApiKeyStorage {
  @override
  Future<String?> readApiKey() async => null;
  @override
  Future<bool> hasApiKey() async => false;
}

class FakeTransport implements DeepSeekTransport {
  FakeTransport({this.events = const [], this.error, this.receipt});
  final List<Map<String, dynamic>> events;
  final Object? error;
  final ConnectionReceipt? receipt;
  int streamCalls = 0, testCalls = 0;

  @override
  Future<ConnectionReceipt> testConnection(String key) async {
    testCalls++;
    if (error != null) throw error!;
    return receipt ??
        const ConnectionReceipt('deepseek-flash', Duration(milliseconds: 12), {
          'prompt_tokens': 3,
          'completion_tokens': 1,
        });
  }

  @override
  Stream<Map<String, dynamic>> streamMessages(
    String key,
    List<Map<String, String>> messages, {
    required CancelToken cancelToken,
    int maxOutput = 1200,
  }) async* {
    streamCalls++;
    for (final event in events) {
      yield event;
    }
    if (error != null) throw error!;
  }

  @override
  void close() {}
}

class CountingEngine implements DialogueEngine {
  CountingEngine(this.body, {this.input = 10, this.output = 5});
  final String body;
  final int input, output;
  int calls = 0;
  @override
  Future<DialogueOutput> generate(
    TurnPlan plan,
    TurnCancellation cancellation,
  ) async {
    calls++;
    return DialogueOutput(
      body,
      inputTokens: input,
      outputTokens: output,
      cacheTokens: 0,
      model: 'deepseek-flash',
    );
  }
}

Map<String, dynamic> stopEvent(String content, {Map<String, int>? usage}) {
  final event = <String, dynamic>{
    'model': 'deepseek-flash',
    'choices': [
      {
        'delta': {'content': content},
        'finish_reason': null,
      },
    ],
  };
  if (usage != null) event['usage'] = usage;
  return event;
}

Map<String, dynamic> doneEvent({
  String? finish = 'stop',
  Map<String, int>? usage,
}) {
  final event = <String, dynamic>{
    'model': 'deepseek-flash',
    'choices': [
      {'delta': <String, dynamic>{}, 'finish_reason': finish},
    ],
  };
  if (usage != null) event['usage'] = usage;
  return event;
}

DioException httpError(int status) {
  final options = RequestOptions(
    path: '/chat/completions',
    headers: {'Authorization': 'Bearer $syntheticKey'},
  );
  return DioException(
    requestOptions: options,
    response: Response(
      requestOptions: options,
      statusCode: status,
      data: syntheticKey,
    ),
    message: syntheticKey,
  );
}

class ProbeConfig extends DeepSeekConfig {
  const ProbeConfig();
  @override
  bool get permitsDirectCalls => true;
}

class AndroidReleaseTestConfig extends DeepSeekConfig {
  const AndroidReleaseTestConfig({
    super.baseUrl,
    super.model,
    super.androidReleaseValidationEnabled = false,
    super.androidReleaseByokEnabled = false,
  });

  @override
  bool get isAndroidReleaseValidation => DeepSeekConfig.permitsAndroidRelease(
    release: true,
    web: false,
    platform: TargetPlatform.android,
    enabled: androidReleaseValidationEnabled,
  );

  @override
  bool get androidReleaseByokAllowed => DeepSeekConfig.permitsAndroidRelease(
    release: true,
    web: false,
    platform: TargetPlatform.android,
    enabled: androidReleaseByokEnabled,
  );
}

class ProbeClient extends DeepSeekApiClient {
  ProbeClient(this.transport) : super(const ProbeConfig());
  final FakeTransport transport;

  @override
  Future<ConnectionReceipt> testConnection(String key) =>
      transport.testConnection(key);
}

class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.handler);
  final Future<ResponseBody> Function(RequestOptions options) handler;
  RequestOptions? last;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    last = options;
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

Future<AppDatabase> databaseWithWorld() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await db.customSelect('SELECT 1').get();
  await db
      .into(db.worlds)
      .insert(
        WorldsCompanion.insert(
          id: 'w',
          title: '雾港',
          genre: '悬疑',
          summary: '海雾中的港口',
          createdAt: DateTime(2026),
        ),
      );
  await insertScenario(db, 'w');
  return db;
}

Future<void> writeDefinitionContext(AppDatabase db) async {
  final state = RoleplayScenarios.create('w');
  state.data['definitionVersion'] = 1;
  state.data['definitionSnapshot'] = {
    'title': '雾港',
    'description': '海雾笼罩的港口小城，灯塔在夜里明灭。',
    'era': '近代',
    'playerProfile': {'name': '阿岚'},
    'worldRules': [
      {'text': '夜里不要独自靠近旧码头', 'kind': 'fact'},
    ],
    'narrativePreferences': {'style': '短段落'},
  };
  await (db.update(db.roleplaySaves)..where((t) => t.worldId.equals('w')))
      .write(RoleplaySavesCompanion(payload: Value(jsonEncode(state.data))));
  await db
      .into(db.roleplayMemories)
      .insert(
        RoleplayMemoriesCompanion.insert(
          id: 'memory-secret',
          worldId: 'w',
          owner: 'npc-0',
          payload: jsonEncode(
            const PersonalMemory(
              id: 'memory-secret',
              owner: 'npc-0',
              text: '灯塔旧信藏在柜台下的铁盒里',
              source: '亲历',
              turn: 1,
              importance: 10,
            ).toJson(),
          ),
        ),
      );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  test(
    'connection probe records returned usage and keeps timeout cost unknown',
    () async {
      final db = await databaseWithWorld();
      final usage = UsageRepository(db);
      final success = ProbeClient(FakeTransport());
      final timeoutTransport = FakeTransport(error: httpError(504));
      final timeout = ProbeClient(timeoutTransport);
      final disabled = DeepSeekApiClient(const DeepSeekConfig());
      try {
        await expectLater(
          ExperimentalDeepSeekRepository(
            disabled,
            usage,
          ).testConnection(syntheticKey),
          throwsA(isA<DeepSeekFailure>()),
        );
        expect(await usage.metrics(), isEmpty);
        final result = await ExperimentalDeepSeekRepository(
          success,
          usage,
        ).testConnection(syntheticKey);
        expect(result.receipt.usage['prompt_tokens'], 3);
        expect((await usage.load()).single.outputTokens, 1);
        await expectLater(
          ExperimentalDeepSeekRepository(
            timeout,
            usage,
          ).testConnection(syntheticKey),
          throwsA(
            isA<DeepSeekFailure>().having((e) => e.status, 'status', 504),
          ),
        );
        expect(timeoutTransport.testCalls, 1);
        expect((await usage.load()), hasLength(1));
        final unknown = (await usage.metrics()).singleWhere(
          (m) => m['type'] == UsageRepository.awaitingUsage,
        );
        expect(unknown.containsKey('inputTokens'), isFalse);
      } finally {
        success.close();
        timeout.close();
        disabled.close();
        await db.close();
      }
    },
  );

  group('policy truth table', () {
    test('reviewed distribution is scoped to platform and service', () {
      const review = ReleaseAccess(
        iosByok: 'test-scope-only',
        androidPublicShare: 'test-share-only',
        iosPublicShare: ' ',
      );
      bool allowed(
        TargetPlatform platform, {
        bool release = true,
        bool web = false,
        ReleaseService service = ReleaseService.deepSeekByok,
      }) => review.permitsBuild(
        service,
        release: release,
        web: web,
        platform: platform,
      );
      expect(allowed(TargetPlatform.iOS), true);
      expect(allowed(TargetPlatform.android), false);
      expect(allowed(TargetPlatform.iOS, release: false), false);
      expect(allowed(TargetPlatform.iOS, web: true), false);
      expect(
        allowed(
          TargetPlatform.android,
          service: ReleaseService.deepSeekPublicShare,
        ),
        true,
      );
      expect(
        allowed(
          TargetPlatform.iOS,
          service: ReleaseService.deepSeekPublicShare,
        ),
        false,
      );
      for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
        for (final service in ReleaseService.values) {
          expect(
            ReleaseAccess.current.permitsBuild(
              service,
              release: true,
              web: false,
              platform: platform,
            ),
            false,
          );
        }
      }
    });
    test('native Debug flags cannot enable Release or web calls', () {
      expect(
        DeepSeekConfig.policyAllows(
          debug: false,
          web: false,
          nativeMobile: true,
          experimental: true,
          devTestEnabled: true,
        ),
        false,
      );
      expect(
        DeepSeekConfig.policyAllows(
          debug: true,
          web: true,
          nativeMobile: true,
          experimental: true,
          devTestEnabled: true,
        ),
        false,
      );
      expect(
        DeepSeekConfig.policyAllows(
          debug: true,
          web: false,
          nativeMobile: true,
          experimental: false,
          devTestEnabled: true,
        ),
        false,
      );
      expect(
        DeepSeekConfig.policyAllows(
          debug: true,
          web: false,
          nativeMobile: true,
          experimental: true,
          devTestEnabled: false,
        ),
        false,
      );
      expect(
        DeepSeekConfig.policyAllows(
          debug: true,
          web: false,
          nativeMobile: true,
          experimental: true,
          devTestEnabled: true,
        ),
        true,
      );
    });

    test('local acceptance is limited to opt-in Android Release builds', () {
      for (final platform in TargetPlatform.values) {
        for (final release in [false, true]) {
          for (final web in [false, true]) {
            for (final enabled in [false, true]) {
              expect(
                DeepSeekConfig.permitsAndroidRelease(
                  release: release,
                  web: web,
                  platform: platform,
                  enabled: enabled,
                ),
                platform == TargetPlatform.android &&
                    release &&
                    !web &&
                    enabled,
              );
            }
          }
        }
      }
      const config = AndroidReleaseTestConfig(
        androidReleaseValidationEnabled: true,
      );
      expect(
        config.withModel('deepseek-v4-pro').androidReleaseValidationEnabled,
        isTrue,
      );
      expect(config.releaseAllowed, isFalse);
      expect(config.permitsDirectCalls, isTrue);
      expect(
        const AndroidReleaseTestConfig(
          baseUrl: 'https://example.com',
          androidReleaseValidationEnabled: true,
        ).permitsDirectCalls,
        isFalse,
      );
      expect(
        const AndroidReleaseTestConfig(
          model: 'unknown',
          androidReleaseValidationEnabled: true,
        ).permitsDirectCalls,
        isFalse,
      );
    });

    test(
      'original Android Release package opts in without validation mode',
      () {
        const release = AndroidReleaseTestConfig(
          androidReleaseByokEnabled: true,
        );
        expect(release.permitsDirectCalls, isTrue);
        expect(release.isAndroidReleaseValidation, isFalse);
        expect(
          release.withModel('deepseek-v4-pro').androidReleaseByokEnabled,
          isTrue,
        );
        expect(const AndroidReleaseTestConfig().permitsDirectCalls, isFalse);
        expect(
          const AndroidReleaseTestConfig(
            androidReleaseByokEnabled: true,
            baseUrl: 'https://example.com',
          ).permitsDirectCalls,
          isFalse,
        );
      },
    );

    test(
      'no permission marker is required for the private native dev test',
      () {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        const dev = DeepSeekConfig(
          enableExperimental: true,
          devRealApiTestEnabled: true,
        );

        expect(dev.permitsDirectCalls, true);

        const noToggle = DeepSeekConfig(enableExperimental: true);

        expect(noToggle.permitsDirectCalls, false);

        const mock = DeepSeekConfig();

        expect(mock.permitsDirectCalls, false);
      },
    );

    test('unsafe endpoint blocks the dev test mode', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      const config = DeepSeekConfig(
        baseUrl: 'https://example.com',
        enableExperimental: true,
        devRealApiTestEnabled: true,
      );
      expect(config.permitsDirectCalls, false);
    });
    test('application defaults allow both native Debug targets only', () {
      for (final platform in [
        TargetPlatform.android,
        TargetPlatform.iOS,
        TargetPlatform.windows,
      ]) {
        debugDefaultTargetPlatformOverride = platform;
        expect(
          DeepSeekConfig.applicationBuild.permitsDirectCalls,
          platform != TargetPlatform.windows,
        );
      }
    });

    test('provider selects the right engine for each mode', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      ProviderContainer containerFor(DeepSeekConfig config) {
        final db = AppDatabase.forTesting(NativeDatabase.memory());
        addTearDown(db.close);
        return ProviderContainer(
          overrides: [
            deepSeekConfigProvider.overrideWithValue(config),
            apiKeyStorageProvider.overrideWithValue(TestKeyStorage()),
            databaseProvider.overrideWithValue(db),
          ],
        );
      }

      final mock = containerFor(const DeepSeekConfig());
      addTearDown(mock.dispose);
      expect(mock.read(dialogueEngineProvider), isA<BlockedDialogueEngine>());

      final blocked = containerFor(
        const DeepSeekConfig(enableExperimental: true),
      );
      addTearDown(blocked.dispose);
      expect(
        blocked.read(dialogueEngineProvider),
        isA<BlockedDialogueEngine>(),
      );

      final dev = containerFor(
        const DeepSeekConfig(
          enableExperimental: true,
          devRealApiTestEnabled: true,
        ),
      );
      addTearDown(dev.dispose);
      final engine = dev.read(dialogueEngineProvider);
      expect(engine, isA<DeepSeekDialogueEngine>());

      final release = containerFor(
        const AndroidReleaseTestConfig(androidReleaseByokEnabled: true),
      );
      addTearDown(release.dispose);
      expect(
        release.read(dialogueEngineProvider),
        isA<DeepSeekDialogueEngine>(),
      );
    });
  });

  group('DeepSeek HTTP contract', () {
    test('original Android Release sends one approved turn and saves SSE usage', () async {
      final db = await databaseWithWorld();
      addTearDown(db.close);
      await writeDefinitionContext(db);
      final repo = RoleplayRepository(db);
      final usage = UsageRepository(db);
      final storage = TestKeyStorage();
      const config = AndroidReleaseTestConfig(androidReleaseByokEnabled: true);
      const action = '你还记得灯塔旧信吗？';
      const narration = '海雾漫过窗沿。';
      var calls = 0;
      final adapter = FakeAdapter((options) async {
        calls++;
        expect(options.method, 'POST');
        expect(
          options.uri,
          Uri.parse('https://api.deepseek.com/chat/completions'),
        );
        expect(options.headers['Authorization'], 'Bearer $syntheticKey');
        expect(options.followRedirects, isFalse);
        final body = options.data as Map;
        expect(body['model'], 'deepseek-flash');
        expect(body['stream'], isTrue);
        expect(body['stream_options'], {'include_usage': true});
        expect(body['response_format'], {'type': 'json_object'});
        final prompt = (body['messages'] as List)
            .map((message) => (message as Map)['content'])
            .join('\n');
        for (final fragment in [action, '海雾笼罩的港口小城', '陈禾', '灯塔旧信藏在柜台下的铁盒里']) {
          expect(prompt, contains(fragment));
        }
        final events = [
          stopEvent(
            jsonEncode({
              'narration': narration,
              'replies': [
                {'speaker': 'npc-0', 'text': '这封信还在。'},
              ],
              'proposal': {'minutes': 1},
            }),
          ),
          doneEvent(),
          {
            'model': 'deepseek-flash',
            'choices': [],
            'usage': {
              'prompt_tokens': 43,
              'completion_tokens': 12,
              'prompt_cache_hit_tokens': 5,
              'prompt_cache_miss_tokens': 38,
              'total_tokens': 55,
            },
          },
        ];
        return ResponseBody.fromString(
          '${events.map((event) => 'data: ${jsonEncode(event)}\n\n').join()}data: [DONE]\n\n',
          200,
          headers: {
            Headers.contentTypeHeader: ['text/event-stream'],
          },
        );
      });
      final client = DeepSeekApiClient.withAdapter(config, adapter);
      addTearDown(client.close);
      final core = TurnCoordinator(
        repo,
        DeepSeekDialogueEngine(
          config,
          storage,
          transport: client,
          usageRepository: usage,
        ),
        usage,
      );
      final cancelled = await core.prepare('w', action, addressed: 'npc-0');
      await expectLater(
        core.execute(cancelled, TurnCancellation(), confirmed: false),
        throwsA(isA<RoleplayFailure>()),
      );
      expect(calls, 0);
      expect(storage.reads, 0);
      expect(await repo.history('w'), isEmpty);

      final confirmed = await core.prepare('w', action, addressed: 'npc-0');
      await core.execute(confirmed, TurnCancellation(), confirmed: true);
      expect(calls, 1);
      expect(storage.reads, 1);
      expect(
        (await repo.history('w')).single.responseJson,
        contains(narration),
      );
      expect((await repo.load('w')).revision, 1);
      final recorded = (await usage.load()).single;
      expect(
        (recorded.inputTokens, recorded.outputTokens, recorded.cacheTokens),
        (43, 12, 5),
      );
      final evidence = (await usage.metrics()).single;
      expect(evidence['httpStatus'], 200);
      expect(evidence['model'], 'deepseek-flash');
      expect(jsonEncode(evidence), isNot(contains(syntheticKey)));
    });

    test('official balance uses one authenticated GET and retains currency strings', () async {
      var count = 0;
      final adapter = FakeAdapter((options) async {
        count++;
        expect(options.uri, Uri.parse('https://api.deepseek.com/user/balance'));
        expect(options.method, 'GET');
        expect(options.followRedirects, isFalse);
        expect(options.headers['Authorization'], 'Bearer $syntheticKey');
        return ResponseBody.fromString(
          '{"is_available":true,"balance_infos":[{"currency":"CNY","total_balance":"1.20"},{"currency":"USD","total_balance":"0.48"}]}',
          200,
          headers: {
            Headers.contentTypeHeader: ['application/json'],
          },
        );
      });
      final protocol = DeepSeekHttpProtocol(adapter: adapter);
      addTearDown(protocol.close);
      final balance = await protocol.balance(syntheticKey);
      expect(balance.totals, {'CNY': '1.20', 'USD': '0.48'});
      expect(balance.low, isTrue);
      expect(count, 1);
    });

    test(
      'balance errors and malformed response do not produce values',
      () async {
        for (final status in [200, 401, 503]) {
          final protocol = DeepSeekHttpProtocol(
            adapter: FakeAdapter(
              (_) async => ResponseBody.fromString(
                '{"invalid":"private"}',
                status,
                headers: {
                  Headers.contentTypeHeader: ['application/json'],
                },
              ),
            ),
          );
          addTearDown(protocol.close);
          await expectLater(
            protocol.balance(syntheticKey),
            throwsA(isA<DeepSeekFailure>()),
          );
        }
      },
    );

    test(
      'non-stream probe uses official model, thinking disabled and safe auth',
      () async {
        final adapter = FakeAdapter((options) async {
          final data = options.data as Map;
          expect(data['model'], 'deepseek-flash');
          expect(data['stream'], false);
          expect(data['thinking'], {'type': 'disabled'});
          expect(data['max_tokens'], 8);
          expect(options.headers['Authorization'], 'Bearer $syntheticKey');
          return ResponseBody.fromString(
            jsonEncode({
              'model': 'deepseek-flash',
              'choices': [
                {
                  'message': {'content': 'OK'},
                  'finish_reason': 'length',
                },
              ],
              'usage': {
                'prompt_tokens': 8,
                'completion_tokens': 1,
                'prompt_cache_hit_tokens': 0,
                'prompt_cache_miss_tokens': 8,
                'total_tokens': 9,
              },
            }),
            200,
            headers: {
              Headers.contentTypeHeader: ['application/json'],
            },
          );
        });
        final protocol = DeepSeekHttpProtocol(adapter: adapter);
        addTearDown(protocol.close);
        final receipt = await protocol.testConnection(syntheticKey);
        expect(receipt.model, 'deepseek-flash');
        expect(receipt.httpStatus, 200);
        expect(receipt.usage['prompt_tokens'], 8);
        expect(receipt.usage['completion_tokens'], 1);
      },
    );

    test(
      'stream request sends JSON mode, usage and SSE accept header',
      () async {
        final adapter = FakeAdapter((options) async {
          final data = options.data as Map;
          expect(data['model'], 'deepseek-flash');
          expect(data['stream'], true);
          expect(data['response_format'], {'type': 'json_object'});
          expect(data['thinking'], {'type': 'disabled'});
          expect(data['stream_options'], {'include_usage': true});
          expect(data['max_tokens'], 1200);
          return ResponseBody(
            Stream.value(
              Uint8List.fromList(
                utf8.encode(
                  'data: {"choices":[{"delta":{"content":"{}"},"finish_reason":"stop"}],"usage":{"prompt_tokens":4,"completion_tokens":2}}\n\n'
                  'data: [DONE]\n\n',
                ),
              ),
            ),
            200,
            headers: {
              Headers.contentTypeHeader: ['text/event-stream'],
            },
          );
        });
        final protocol = DeepSeekHttpProtocol(adapter: adapter);
        addTearDown(protocol.close);
        final rows = await protocol.streamMessages(syntheticKey, [
          {'role': 'system', 'content': 'Return JSON only.'},
          {'role': 'user', 'content': '你好'},
        ], cancelToken: CancelToken()).toList();
        expect(rows.single['choices'], isA<List>());
        expect(rows.single['usage'], isA<Map>());
      },
    );

    test(
      'HTTP statuses map to fixed safe Chinese errors without credentials',
      () async {
        for (final status in [401, 402, 408, 413, 422, 429, 500, 503, 504]) {
          final safe = DeepSeekErrorHandler.sanitize(httpError(status)).message;
          expect(safe, DeepSeekErrorHandler.fromStatus(status).message);
          expect(safe, isNot(contains(syntheticKey)));
          expect(safe, isNot(contains('Bearer')));
        }
        final network = DeepSeekErrorHandler.sanitize(
          DioException(
            requestOptions: RequestOptions(path: '/'),
            type: DioExceptionType.connectionError,
            message: syntheticKey,
          ),
        ).message;
        expect(network, '连接失败，请检查网络后重试。');
        expect(network, isNot(contains(syntheticKey)));
      },
    );

    test(
      'stream errors after HTTP 200 stay explicit and may still be billed',
      () async {
        final statuses = <int>[];
        final protocol = DeepSeekHttpProtocol(
          onHttpStatus: statuses.add,
          adapter: FakeAdapter(
            (_) async => ResponseBody.fromString(
              'data: {"choices":[{"delta":{"content":"partial"}}]}\n\n'
              'data: {"error":{"code":429,"message":"$syntheticKey"}}\n\n',
              200,
              headers: {
                Headers.contentTypeHeader: ['text/event-stream'],
              },
            ),
          ),
        );
        addTearDown(protocol.close);
        await expectLater(
          protocol.streamMessages(syntheticKey, [
            {'role': 'user', 'content': 'Continue.'},
          ], cancelToken: CancelToken()),
          emitsInOrder([
            isA<Map<String, dynamic>>(),
            emitsError(
              isA<DeepSeekFailure>()
                  .having(
                    (e) => e.message,
                    'message',
                    DeepSeekErrorHandler.streamServiceErrorMessage,
                  )
                  .having((e) => e.status, 'HTTP error status', isNull)
                  .having(
                    (e) => e.rejectedBeforeGeneration,
                    'definitive rejection',
                    false,
                  ),
            ),
          ]),
        );
        expect(statuses, [200]);
      },
    );

    test('rejects redirected API URLs without a second request', () async {
      var calls = 0;
      final statuses = <int>[];
      final protocol = DeepSeekHttpProtocol(
        onHttpStatus: statuses.add,
        adapter: FakeAdapter((options) async {
          calls++;
          expect(options.followRedirects, false);
          return ResponseBody.fromString(
            '',
            307,
            headers: {
              'location': ['https://example.invalid/chat/completions'],
            },
          );
        }),
      );
      addTearDown(protocol.close);
      await expectLater(
        protocol.listModels(syntheticKey),
        throwsA(
          isA<DeepSeekFailure>().having(
            (e) => e.message,
            'message',
            DeepSeekErrorHandler.redirectMessage,
          ),
        ),
      );
      expect(calls, 1);
      expect(statuses, [307]);
    });

    test('malformed successful probe keeps observed HTTP status without claiming success', () async {
      final protocol = DeepSeekHttpProtocol(
        adapter: FakeAdapter(
          (_) async => ResponseBody.fromString(
            '{}',
            200,
            headers: {
              Headers.contentTypeHeader: ['application/json'],
            },
          ),
        ),
      );
      addTearDown(protocol.close);
      await expectLater(
        protocol.testConnection(syntheticKey),
        throwsA(
          isA<DeepSeekFailure>().having((e) => e.status, 'HTTP status', 200),
        ),
      );
    });

    test('SSE byte splits, CRLF, usage and DONE are parsed', () async {
      final body =
          ': keep-alive\r\n'
          'data: {"choices":[{"delta":{"content":"{\\"narration\\":"}}]}\r\n\r\n'
          'data: {"choices":[{"delta":{},"finish_reason":"stop"}],"usage":{"prompt_tokens":10,"completion_tokens":4,"prompt_cache_hit_tokens":6,"prompt_cache_miss_tokens":4,"total_tokens":14}}\n\n'
          'data: [DONE]\n\n';
      final bytes = utf8.encode(body);
      final rows = await DeepSeekHttpProtocol.decodeSse(
        Stream.fromIterable(bytes.map((b) => [b])),
      ).toList();
      expect(rows.length, 2);
      expect(rows.last['usage'], {
        'prompt_tokens': 10,
        'completion_tokens': 4,
        'prompt_cache_hit_tokens': 6,
        'prompt_cache_miss_tokens': 4,
        'total_tokens': 14,
      });
    });
  });

  group('dialogue engine errors', () {
    late AppDatabase db;
    late RoleplayRepository repo;
    late TestKeyStorage storage;

    setUp(() async {
      db = await databaseWithWorld();
      repo = RoleplayRepository(db);
      storage = TestKeyStorage();
    });
    tearDown(() async {
      await db.close();
    });

    Future<TurnPlan> plan(TurnCoordinator core) =>
        core.prepare('w', '你还记得灯塔旧信吗？', addressed: 'npc-0');

    test('missing key fails before any network request', () async {
      final transport = FakeTransport();
      final engine = DeepSeekDialogueEngine(
        const DeepSeekConfig(),
        NoKeyStorage(),
        transport: transport,
      );
      final core = TurnCoordinator(repo, engine, UsageRepository(db));
      final p = await plan(core);
      await expectLater(
        core.execute(p, TurnCancellation(), confirmed: true),
        throwsA(
          isA<RoleplayFailure>().having(
            (e) => e.message,
            'message',
            missingDeepSeekKeyMessage,
          ),
        ),
      );
      expect(transport.streamCalls, 0);
      expect((await repo.load('w')).revision, 0);
      expect(await repo.history('w'), isEmpty);
    });

    test(
      '401, 402, timeout and network errors stay explicit and sanitized',
      () async {
        for (final pair in [
          (401, 'API Key 无效'),
          (402, '账户余额不足'),
          (408, '请求超时'),
        ]) {
          final engine = DeepSeekDialogueEngine(
            const DeepSeekConfig(),
            storage,
            transport: FakeTransport(error: httpError(pair.$1)),
          );
          final core = TurnCoordinator(repo, engine, UsageRepository(db));
          final p = await plan(core);
          await expectLater(
            core.execute(p, TurnCancellation(), confirmed: true),
            throwsA(
              isA<RoleplayFailure>()
                  .having((e) => e.message, 'message', contains(pair.$2))
                  .having(
                    (e) => e.message,
                    'no key',
                    isNot(contains(syntheticKey)),
                  ),
            ),
          );
          expect((await repo.load('w')).revision, 0);
        }
        final network = DeepSeekDialogueEngine(
          const DeepSeekConfig(),
          storage,
          transport: FakeTransport(
            error: DioException(
              requestOptions: RequestOptions(path: '/'),
              type: DioExceptionType.connectionError,
              message: syntheticKey,
            ),
          ),
        );
        final core = TurnCoordinator(repo, network, UsageRepository(db));
        final p = await plan(core);
        await expectLater(
          core.execute(p, TurnCancellation(), confirmed: true),
          throwsA(
            isA<RoleplayFailure>().having(
              (e) => e.message,
              'message',
              '连接失败，请检查网络后重试。',
            ),
          ),
        );
      },
    );

    test('ambiguous failure is saved locally, with no generated reply or invented usage', () async {
      final usage = UsageRepository(db);
      final transport = FakeTransport(error: httpError(504));
      final core = TurnCoordinator(
        repo,
        DeepSeekDialogueEngine(
          const DeepSeekConfig(),
          storage,
          transport: transport,
          usageRepository: usage,
        ),
        usage,
      );
      final p = await plan(core);
      await expectLater(
        core.execute(p, TurnCancellation(), confirmed: true),
        throwsA(isA<RoleplayFailure>()),
      );
      expect(transport.streamCalls, 1);
      expect(await repo.history('w'), isEmpty);
      expect(await usage.load(), isEmpty);
      final row = (await UsageRepository(db).metrics()).single;
      expect(row['type'], UsageRepository.awaitingUsage);
      expect(row['worldId'], 'w');
      expect(row.containsKey('estimatedUsd'), isFalse);
    });

    test('explicit auth rejection clears pending usage; successful usage replaces it', () async {
      final usage = UsageRepository(db);
      final rejected = FakeTransport(error: httpError(401));
      final rejectedCore = TurnCoordinator(
        repo,
        DeepSeekDialogueEngine(
          const DeepSeekConfig(),
          storage,
          transport: rejected,
          usageRepository: usage,
        ),
        usage,
      );
      final before = await plan(rejectedCore);
      await expectLater(
        rejectedCore.execute(before, TurnCancellation(), confirmed: true),
        throwsA(isA<RoleplayFailure>()),
      );
      expect(await usage.metrics(), isEmpty);
      final success = FakeTransport(
        events: [
          stopEvent(
            '{"narration":"窗外下起雨。","replies":[{"speaker":"npc-0","text":"雨势变大了。"}],"proposal":{"minutes":1}}',
          ),
          doneEvent(
            usage: {
              'prompt_tokens': 43,
              'completion_tokens': 12,
              'prompt_cache_hit_tokens': 5,
            },
          ),
        ],
      );
      final successCore = TurnCoordinator(
        repo,
        DeepSeekDialogueEngine(
          const DeepSeekConfig(),
          storage,
          transport: success,
          usageRepository: usage,
        ),
        usage,
      );
      final after = await plan(successCore);
      await successCore.execute(after, TurnCancellation(), confirmed: true);
      expect((await repo.history('w')).single.responseJson, contains('窗外下起雨'));
      expect((await usage.metrics()).single['inputTokens'], 43);
      final recorded = (await usage.load()).single;
      expect(
        (recorded.inputTokens, recorded.outputTokens, recorded.cacheTokens),
        (43, 12, 5),
      );
    });

    test('a lost SSE completion marker keeps reported usage and rejects partial prose', () async {
      final usage = UsageRepository(db);
      final transport = FakeTransport(
        events: [
          stopEvent('{"narration":"不应保存这段文字"}'),
          doneEvent(usage: {'prompt_tokens': 31, 'completion_tokens': 9}),
        ],
        error: const DeepSeekFailure('流式连接中断，请重试。'),
      );
      final core = TurnCoordinator(
        repo,
        DeepSeekDialogueEngine(
          const DeepSeekConfig(),
          storage,
          transport: transport,
          usageRepository: usage,
        ),
        usage,
      );
      await expectLater(
        core.execute(await plan(core), TurnCancellation(), confirmed: true),
        throwsA(isA<RoleplayFailure>()),
      );
      expect(transport.streamCalls, 1);
      expect(await repo.history('w'), isEmpty);
      expect((await usage.load()).single.outputTokens, 9);
      expect((await usage.metrics()).single['type'], 'usage-metrics-v1');
    });

    test(
      'length finish records usage and fails without saving state',
      () async {
        final transport = FakeTransport(
          events: [
            stopEvent('{"narration":"未完'),
            doneEvent(
              finish: 'length',
              usage: {
                'prompt_tokens': 30,
                'completion_tokens': 12,
                'prompt_cache_hit_tokens': 5,
              },
            ),
          ],
        );
        final engine = DeepSeekDialogueEngine(
          const DeepSeekConfig(),
          storage,
          transport: transport,
        );
        final core = TurnCoordinator(repo, engine, UsageRepository(db));
        final p = await plan(core);
        await expectLater(
          core.execute(p, TurnCancellation(), confirmed: true),
          throwsA(
            isA<RoleplayFailure>().having(
              (e) => e.message,
              'message',
              contains('输出达到上限'),
            ),
          ),
        );
        expect((await repo.load('w')).revision, 0);
        expect(await repo.history('w'), isEmpty);
        final usage = await UsageRepository(db).load();
        expect(usage.length, 1);
        expect(usage.single.inputTokens, 30);
        expect(usage.single.outputTokens, 12);
        expect(usage.single.cacheTokens, 5);
      },
    );

    test('empty content is explicit, never a fabricated Mock reply', () async {
      final engine = DeepSeekDialogueEngine(
        const DeepSeekConfig(),
        storage,
        transport: FakeTransport(
          events: [
            doneEvent(usage: {'prompt_tokens': 9, 'completion_tokens': 0}),
          ],
        ),
      );
      final core = TurnCoordinator(repo, engine, UsageRepository(db));
      final p = await plan(core);
      await expectLater(
        core.execute(p, TurnCancellation(), confirmed: true),
        throwsA(
          isA<RoleplayFailure>().having(
            (e) => e.message,
            'message',
            contains('空内容'),
          ),
        ),
      );
      expect((await repo.load('w')).revision, 0);
      expect(await UsageRepository(db).load(), hasLength(1));
    });

    test('invalid JSON is rejected after usage is recorded', () async {
      final engine = DeepSeekDialogueEngine(
        const DeepSeekConfig(),
        storage,
        transport: FakeTransport(
          events: [
            stopEvent('不是 JSON'),
            doneEvent(usage: {'prompt_tokens': 7, 'completion_tokens': 3}),
          ],
        ),
      );
      final core = TurnCoordinator(repo, engine, UsageRepository(db));
      final p = await plan(core);
      await expectLater(
        core.execute(p, TurnCancellation(), confirmed: true),
        throwsA(
          isA<RoleplayFailure>().having(
            (e) => e.message,
            'message',
            contains('有效 JSON'),
          ),
        ),
      );
      expect((await repo.load('w')).revision, 0);
      expect(await repo.history('w'), isEmpty);
      expect(await UsageRepository(db).load(), hasLength(1));
    });

    test('cancelling a transport stream leaves the save unchanged', () async {
      final transport = FakeTransport(
        events: [
          stopEvent('{"narration":"海雾'),
          doneEvent(usage: {'prompt_tokens': 8, 'completion_tokens': 2}),
        ],
      );
      final engine = DeepSeekDialogueEngine(
        const DeepSeekConfig(),
        storage,
        transport: transport,
      );
      final core = TurnCoordinator(repo, engine, UsageRepository(db));
      final p = await plan(core);
      final token = TurnCancellation();
      final future = core.execute(p, token, confirmed: true);
      token.cancel();
      await expectLater(future, throwsA(isA<RoleplayFailure>()));
      expect((await repo.load('w')).revision, 0);
      expect(await repo.history('w'), isEmpty);
    });
  });

  group('roleplay connection chain', () {
    late AppDatabase db;
    late RoleplayRepository repo;
    late TurnCoordinator core;
    late CountingEngine engine;

    final valid =
        '{"narration":"海雾漫过窗沿。","replies":[{"speaker":"npc-0","text":"先进来坐。"}],"proposal":{"minutes":1,"npcMoves":[]}}';

    setUp(() async {
      db = await databaseWithWorld();
      repo = RoleplayRepository(db);
      engine = CountingEngine(valid);
      core = TurnCoordinator(repo, engine, UsageRepository(db));
    });
    tearDown(() async {
      await db.close();
    });

    test(
      'failed usage insert rolls back validated replies and world changes',
      () async {
        final plan = await core.prepare('w', '我把湿外套搭到椅背上。', addressed: 'npc-0');
        final before = (await repo.load('w')).revision;
        await db.customStatement(
          "CREATE TEMP TRIGGER reject_verified_usage BEFORE INSERT ON usage_records "
          "BEGIN SELECT RAISE(ABORT, 'test write failure'); END",
        );
        await expectLater(
          core.execute(plan, TurnCancellation(), confirmed: true),
          throwsA(anything),
        );
        expect(engine.calls, 1);
        expect((await repo.load('w')).revision, before);
        expect(await repo.history('w'), isEmpty);
        expect(await UsageRepository(db).load(), isEmpty);
      },
    );

    test('budget cancellation makes no request', () async {
      final p = await core.prepare('w', '你好', addressed: 'npc-0');
      await expectLater(
        core.execute(p, TurnCancellation(), confirmed: false),
        throwsA(isA<RoleplayFailure>()),
      );
      expect(engine.calls, 0);
      expect(await repo.history('w'), isEmpty);
      expect(await UsageRepository(db).load(), isEmpty);
    });

    test(
      'world background, NPC persona, memory and action reach the prompt',
      () async {
        await writeDefinitionContext(db);
        final p = await core.prepare('w', '你还记得灯塔旧信吗？', addressed: 'npc-0');
        final prompt = p.messages.map((m) => m['content']).join('\n');
        expect(prompt, contains('雾港'));
        expect(prompt, contains('海雾笼罩的港口小城'));
        expect(prompt, contains('陈禾'));
        expect(prompt, contains('审慎'));
        expect(prompt, contains('灯塔旧信藏在柜台下的铁盒里'));
        expect(prompt, contains('你还记得灯塔旧信吗？'));
        expect(p.speaker, 'npc-0');
      },
    );

    test(
      'NPC edits apply next turn without changing old snapshots or scene',
      () async {
        await writeDefinitionContext(db);
        final old = await core.prepare('w', '你怎么看？', addressed: 'npc-0');
        final defs = WorldDefinitionRepository(db);
        final latest = WorldDefinition.empty('w');
        latest.data.addAll({
          'title': '雾港',
          'characterProfiles': [
            {
              'id': 'npc-0',
              'name': '陈禾',
              'speechStyle': '先问一句谜语再开口',
              'currentLocation': '编辑器的初始地点',
              'privateKnowledge': ['暗格里没有信件'],
            },
          ],
        });
        await defs.save(latest, expectedVersion: 0);
        await defs.save(latest, expectedVersion: 1);

        await expectLater(
          core.execute(old, TurnCancellation(), confirmed: true),
          throwsA(
            isA<RoleplayFailure>().having(
              (e) => e.message,
              'message',
              contains('设定有更新'),
            ),
          ),
        );
        expect(engine.calls, 0);
        final next = await core.prepare('w', '你还记得灯塔旧信吗？', addressed: 'npc-0');
        final prompt = next.messages.map((m) => m['content']).join('\n');
        expect(prompt, contains('先问一句谜语再开口'));
        expect(prompt, contains('暗格里没有信件'));
        expect(prompt, contains('灯塔旧信藏在柜台下的铁盒里'));
        expect(prompt, contains('夜里不要独自靠近旧码头'));
        expect(prompt, isNot(contains('编辑器的初始地点')));
        expect(next.state.playerLocation, old.state.playerLocation);
        expect(
          next.state.data['definitionSnapshot'],
          old.state.data['definitionSnapshot'],
        );
        expect(
          (await repo.load('w')).characters.first.data['speechStyle'],
          isNot('先问一句谜语再开口'),
        );
      },
    );

    test('speaker display names are normalized to ids before validation', () async {
      final response =
          '```json\n{"narration":"","replies":[{"speaker":"陈禾","text":"我记得。"}],"proposal":{"minutes":1}}\n```';
      final named = CountingEngine(response);
      final namedCore = TurnCoordinator(repo, named, UsageRepository(db));
      final p = await namedCore.prepare('w', '你好', addressed: 'npc-0');
      final next = await namedCore.execute(
        p,
        TurnCancellation(),
        confirmed: true,
      );
      expect(next.revision, 1);
      final history = await repo.history('w');
      final packet = DialoguePacket.parse(history.single.responseJson!);
      expect(packet.replies.single['speaker'], 'npc-0');
    });

    test('ten narrator turns pass the last three completed replies across database reopen', () async {
      final dir = Directory.systemTemp.createTempSync('fish_narrator_');
      addTearDown(() => dir.deleteSync(recursive: true));
      final file = File('${dir.path}/world.sqlite');
      var current = AppDatabase.forTesting(NativeDatabase(file));
      addTearDown(() => current.close());
      await WorldDefinitionRepository(current).save(
        WorldDefinition.empty('narrator-demo')..data['title'] = '夜雨茶馆',
        expectedVersion: 0,
      );
      await RoleplayRepository(current).initialize('narrator-demo');
      for (var round = 1; round <= 10; round++) {
        final localRepo = RoleplayRepository(current);
        final runner = TurnCoordinator(
          localRepo,
          CountingEngine(
            '{"narration":"旁白第$round轮","replies":[],"proposal":{"minutes":1}}',
          ),
          UsageRepository(current),
        );
        final p = await runner.prepare('narrator-demo', '查看第$round张纸条。');
        final prompt = p.messages.map((m) => m['content']).join('\n');
        expect(p.speaker, 'narrator');
        if (round > 1) expect(prompt, contains('旁白第${round - 1}轮'));
        if (round > 4) expect(prompt, isNot(contains('旁白第${round - 4}轮')));
        await runner.execute(p, TurnCancellation(), confirmed: true);
        if (round == 5) {
          final unfinished = await runner.prepare('narrator-demo', '中断操作');
          await localRepo.reserve(unfinished);
          await current.close();
          current = AppDatabase.forTesting(NativeDatabase(file));
          await RoleplayRepository(current).recoverInterrupted();
          expect(
            (await RoleplayRepository(current).history('narrator-demo')).length,
            5,
          );
        }
      }
      expect(
        (await RoleplayRepository(current).history('narrator-demo')),
        hasLength(10),
      );
      expect(
        (await RoleplayRepository(current).load('narrator-demo')).revision,
        10,
      );
    });

    test(
      'a completed transport reply persists across close and reopen',
      () async {
        final dir = Directory.systemTemp.createTempSync('fish_real_save_');
        final file = File('${dir.path}/save.sqlite');
        final first = AppDatabase.forTesting(NativeDatabase(file));
        try {
          await first
              .into(first.worlds)
              .insert(
                WorldsCompanion.insert(
                  id: 'w',
                  title: '雾港',
                  genre: '悬疑',
                  summary: '',
                  createdAt: DateTime(2026),
                ),
              );
          final firstRepo = RoleplayRepository(first);
          await insertScenario(first, 'w');
          final runner = TurnCoordinator(
            firstRepo,
            CountingEngine(valid),
            UsageRepository(first),
          );
          await runner.execute(
            await runner.prepare('w', '你好', addressed: 'npc-0'),
            TurnCancellation(),
            confirmed: true,
          );
          expect((await firstRepo.load('w')).revision, 1);
          await first.close();
          final second = AppDatabase.forTesting(NativeDatabase(file));
          try {
            final restored = RoleplayRepository(second);
            expect((await restored.load('w')).revision, 1);
            final history = await restored.history('w');
            expect(history, hasLength(1));
            expect(history.single.responseJson, contains('海雾漫过窗沿'));
          } finally {
            await second.close();
          }
        } finally {
          dir.deleteSync(recursive: true);
        }
      },
    );

    test('the same confirmed plan cannot bill twice', () async {
      final p = await core.prepare('w', '你好', addressed: 'npc-0');
      await core.execute(p, TurnCancellation(), confirmed: true);
      await expectLater(
        core.execute(p, TurnCancellation(), confirmed: true),
        throwsA(isA<RoleplayFailure>()),
      );
      expect(engine.calls, 1);
      expect(await repo.history('w'), hasLength(1));
      expect(await UsageRepository(db).load(), hasLength(1));
    });
  });

  group('JSON compatibility', () {
    test('fenced JSON and speaker names are accepted', () {
      final packet = DialoguePacket.parse(
        '```json\n{"narration":"","replies":[{"speaker":"陈禾","text":"好。"}],"proposal":{"minutes":1}}\n```',
        speakerAliases: {'陈禾': 'npc-0'},
      );
      expect(packet.replies.single['speaker'], 'npc-0');
    });

    test('invalid JSON and protocol shape stay distinct and explicit', () {
      expect(
        () => DialoguePacket.parse('not json'),
        throwsA(
          isA<RoleplayFailure>().having(
            (e) => e.message,
            'message',
            contains('不是有效 JSON'),
          ),
        ),
      );
      expect(
        () => DialoguePacket.parse(
          '{"narration":"正文","replies":[],"proposal":{},"control":"leak"}',
        ),
        throwsA(
          isA<RoleplayFailure>().having(
            (e) => e.message,
            'message',
            contains('协议无效'),
          ),
        ),
      );
      expect(
        () => DialoguePacket.parse('   '),
        throwsA(
          isA<RoleplayFailure>().having(
            (e) => e.message,
            'message',
            contains('空内容'),
          ),
        ),
      );
    });
  });

  group('connection test status', () {
    test('API failure resets previously successful connection state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final controller = container.read(apiDiagnosticsProvider.notifier);
      expect(container.read(apiDiagnosticsProvider).state, isNull);
      controller.connected(
        const ConnectionReceipt('deepseek-flash', Duration.zero, {}),
      );
      expect(
        container.read(apiDiagnosticsProvider).state,
        AiConnectionState.connected,
      );
      controller.requestFailed(DeepSeekErrorHandler.fromStatus(401));
      final state = container.read(apiDiagnosticsProvider);
      expect(state.state, AiConnectionState.invalidKey);
      expect(state.receipt, isNull);
    });

    test('timeouts identify the failing phase', () {
      DeepSeekFailure map(DioExceptionType type) =>
          DeepSeekErrorHandler.sanitize(
            DioException(
              requestOptions: RequestOptions(path: '/chat/completions'),
              type: type,
            ),
          );

      expect(
        map(DioExceptionType.connectionTimeout).message,
        DeepSeekErrorHandler.connectTimeoutMessage,
      );
      expect(
        map(DioExceptionType.sendTimeout).message,
        DeepSeekErrorHandler.sendTimeoutMessage,
      );
      expect(
        map(DioExceptionType.receiveTimeout).message,
        DeepSeekErrorHandler.receiveTimeoutMessage,
      );
      expect(map(DioExceptionType.receiveTimeout).status, isNull);
      expect(DeepSeekErrorHandler.sanitize(httpError(504)).status, 504);
    });

    testWidgets(
      'diagnostic copy contains observed HTTP and usage, never raw secrets',
      (tester) async {
        final db = AppDatabase.forTesting(NativeDatabase.memory());
        final container = ProviderContainer(
          overrides: [
            databaseProvider.overrideWithValue(db),
            usageMetricsProvider.overrideWith(
              (ref) async => [
                {
                  'model': 'deepseek-flash',
                  'httpStatus': 200,
                  'inputTokens': 83,
                  'outputTokens': 56,
                  'cacheTokens': 0,
                  'worldId': 'private-world-id',
                },
                {
                  'type': UsageRepository.awaitingUsage,
                  'model': syntheticKey,
                  'httpStatus': syntheticKey,
                },
              ],
            ),
          ],
        );
        final messenger =
            TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
        String? copied;
        messenger.setMockMethodCallHandler(SystemChannels.platform, (
          call,
        ) async {
          if (call.method == 'Clipboard.setData') {
            copied = (call.arguments as Map)['text'] as String;
          }
          return null;
        });
        addTearDown(
          () =>
              messenger.setMockMethodCallHandler(SystemChannels.platform, null),
        );
        final state = container.read(apiDiagnosticsProvider.notifier);
        state.requestFailed(httpError(401));
        state.requestFailedMessage(
          DeepSeekErrorHandler.fromStatus(401).message,
        );
        expect(
          container.read(apiDiagnosticsProvider).lastFailureHttpStatus,
          401,
        );
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(home: AiDeveloperDiagnosticsPage()),
          ),
        );
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('复制脱敏诊断'));
        await tester.tap(find.text('复制脱敏诊断'));
        await tester.pumpAndSettle();
        expect(copied, contains('HTTP 401'));
        expect(copied, contains('HTTP 200'));
        expect(copied, contains('HTTP 状态未取得'));
        expect(copied, contains('输入 83 · 输出 56 · 缓存命中 0'));
        expect(copied, isNot(contains(syntheticKey)));
        expect(copied, isNot(contains('private-world-id')));
        await tester.pumpWidget(const SizedBox.shrink());
        container.dispose();
        await tester.runAsync(db.close);
      },
    );

    testWidgets('settings shows mode, model and real-test state', (
      tester,
    ) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          apiKeyStatusProvider.overrideWith((ref) async => true),
        ],
      );
      try {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(home: AiSettingsPage()),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('已配置，等待连接'), findsOneWidget);
        expect(find.text('使用许可或发布配置限制'), findsNothing);
        expect(find.text('当前模型'), findsOneWidget);
        await tester.tap(find.text('deepseek-flash'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('deepseek-v4-pro').last);
        await tester.pumpAndSettle();
        expect(container.read(deepSeekConfigProvider).model, 'deepseek-v4-pro');
        container.invalidate(deepSeekModelPreferenceProvider);
        expect(
          await container.read(deepSeekModelPreferenceProvider.future),
          'deepseek-v4-pro',
        );
        expect(find.text('手动测试连接'), findsOneWidget);
        await tester.ensureVisible(find.text('开发诊断'));
        expect(find.text('开发诊断'), findsOneWidget);
      } finally {
        await tester.pumpWidget(const SizedBox.shrink());
        container.dispose();
        await tester.runAsync(db.close);
        debugDefaultTargetPlatformOverride = null;
      }
    });
  });
}
