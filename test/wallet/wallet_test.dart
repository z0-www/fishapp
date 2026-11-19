import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/features/ai/application/ai_providers.dart';
import 'package:fishtextadventure/features/usage/price_schedule.dart';
import 'package:fishtextadventure/features/usage/usage_repository.dart';
import 'package:fishtextadventure/features/wallet/application/wallet_controller.dart';
import 'package:fishtextadventure/features/wallet/application/wallet_limits.dart';
import 'package:fishtextadventure/features/wallet/presentation/floating_wallet_ball.dart';
import 'package:fishtextadventure/features/world_creator/data/world_definition_repository.dart';
import 'package:fishtextadventure/features/worlds/application/world_providers.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late WalletPreferences preferences;
  late UsageRepository usage;
  late WalletPriceSchedule pricing;
  final noon = DateTime.utc(2026, 11, 18, 2);
  const model = 'deepseek-flash';

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    preferences = WalletPreferences(WorldDefinitionRepository(db));
    pricing = WalletPriceSchedule.parse(
      File('assets/pricing/deepseek_wallet_prices.json').readAsStringSync(),
    );
    usage = UsageRepository(db, priceSchedule: () async => pricing);
  });
  tearDown(() async {
    await db.close();
  });

  test(
    'official Beijing peak/valley schedule observes boundaries and expiry',
    () {
      expect(
        pricing.period(DateTime.parse('2026-11-18T08:59:00+08:00')),
        PricePeriod.offPeak,
      );
      expect(
        pricing.period(DateTime.parse('2026-11-17T20:00:00-05:00')),
        PricePeriod.peak,
      );
      expect(
        pricing.period(DateTime.parse('2026-11-18T12:00:00+08:00')),
        PricePeriod.offPeak,
      );
      expect(
        pricing.period(DateTime.parse('2026-11-18T14:00:00+08:00')),
        PricePeriod.peak,
      );
      expect(
        pricing.period(DateTime.parse('2026-11-18T18:00:00+08:00')),
        PricePeriod.offPeak,
      );
      expect(
        pricing.period(DateTime.parse('2026-11-21T10:00:00+08:00')),
        PricePeriod.offPeak,
      );
      expect(
        pricing.period(DateTime.parse('2026-12-19T00:00:00+08:00')),
        PricePeriod.unknown,
      );
      final extended = WalletPriceSchedule.parse(
        File('assets/pricing/deepseek_wallet_prices.json')
            .readAsStringSync()
            .replaceFirst('2026-11-17T', '2026-01-01T'),
      );
      expect(
        extended.period(DateTime.parse('2026-10-01T10:00:00+08:00')),
        PricePeriod.offPeak,
      );
      expect(
        WalletPriceSchedule.dayStart(DateTime.parse('2026-11-18T16:00:00Z')),
        DateTime.parse('2026-11-18T16:00:00Z'),
      );
    },
  );

  test(
    'spending aggregates actual usage only on requested Beijing day',
    () async {
      final day = WalletPriceSchedule.dayStart(noon);
      await usage.record(
        requestedAt: day.subtract(const Duration(seconds: 1)),
        model: model,
        inputTokens: 100000,
        outputTokens: 50000,
        cacheTokens: 0,
      );
      await usage.record(
        requestedAt: noon,
        model: model,
        inputTokens: 1000,
        outputTokens: 1000,
        cacheTokens: 100,
      );
      await usage.record(
        requestedAt: noon,
        model: model,
        inputTokens: 1000,
        outputTokens: 2000,
      );
      await usage.record(
        requestedAt: day.add(const Duration(days: 1)),
        model: model,
        inputTokens: 1000,
        outputTokens: 1000,
        cacheTokens: 100,
      );
      final tally = await usage.spendingSince(day);
      expect(tally.usd, closeTo(.0014706, 1e-10));
      expect(tally.unknown, 1);
      final actualDay = WalletPriceSchedule.dayStart(DateTime.now());
      final before = await usage.spendingSince(actualDay);
      await usage.markAwaitingUsage(
        requestId: 'interrupted-test',
        model: model,
      );
      expect(
        (await usage.spendingSince(actualDay)).unknown,
        before.unknown + 1,
      );
      await usage.discardAwaitingUsage('interrupted-test');
      expect((await usage.spendingSince(actualDay)).unknown, before.unknown);
    },
  );

  test('budget blocks before dispatch and checks expiry, manual fallback and concurrency', () async {
    var now = noon;
    final guard = WalletGuard(
      preferences,
      usage,
      () async => pricing,
      now: () => now,
    );
    final day = WalletPriceSchedule.dayStart(now).toIso8601String();
    var calls = 0;
    Future<void> request() async {
      calls++;
    }

    expect((await guard.quote(model, 1000, 1000)).automaticAllowed, isFalse);
    await preferences.savePlan(
      WalletPlan(
        daily: .002,
        warning: .0018,
        automatic: .0019,
        authorizedDay: day,
        authorizedVersion: pricing.version,
      ),
    );
    expect((await guard.quote(model, 1000, 1000)).automaticAllowed, isTrue);
    expect((await guard.quote(model, 2500, 1000)).automaticAllowed, isFalse);
    expect((await guard.quote(model, 10000, 1000)).blocked, isTrue);
    await expectLater(
      guard.dispatch(model, 10000, 1000, request),
      throwsA(isA<WalletRequestBlocked>()),
    );
    expect(calls, 0);
    final inProgress = Completer<void>();
    final first = guard.dispatch(
      model,
      1000,
      1000,
      () => inProgress.future,
      automatic: true,
    );
    await expectLater(
      guard.dispatch(model, 1000, 1000, request),
      throwsA(isA<WalletRequestBlocked>()),
    );
    inProgress.complete();
    await first;
    await usage.record(
      requestedAt: now,
      model: model,
      inputTokens: 2000,
      outputTokens: 2000,
    );
    expect((await guard.quote(model, 1000, 1000)).automaticAllowed, isFalse);
    final uncertain = await guard.quote(model, 1000, 1000);
    expect(uncertain.blocked, isTrue);
    await expectLater(
      guard.dispatch(model, 1000, 1000, request, approval: uncertain),
      throwsA(isA<WalletRequestBlocked>()),
    );
    expect(calls, 0);
    now = now.add(const Duration(days: 1));
    expect((await guard.quote(model, 1000, 1000)).automaticAllowed, isFalse);
    await usage.record(
      requestedAt: now,
      model: model,
      inputTokens: 2000,
      outputTokens: 2000,
      cacheTokens: 0,
    );
    expect((await guard.quote(model, 1000, 1000)).exhausted, isTrue);
    now = pricing.expiresAt;
    expect((await guard.quote(model, 1000, 1000)).estimated, isNull);
    await expectLater(
      guard.dispatch(model, 1000, 1000, request, automatic: true),
      throwsA(isA<WalletRequestBlocked>()),
    );
    expect(calls, 0);
  });

  test(
    'manual consent is single-use and bound to the quoted request',
    () async {
      final guard = WalletGuard(
        preferences,
        usage,
        () async => pricing,
        now: () => noon,
      );
      var requests = 0;
      Future<int> request() async => ++requests;
      final quote = await guard.quote(model, 1000, 1000);
      await expectLater(
        guard.dispatch(model, 1000, 1000, request),
        throwsA(isA<WalletRequestBlocked>()),
      );
      await expectLater(
        guard.dispatch(model, 1000, 2000, request, approval: quote),
        throwsA(isA<WalletRequestBlocked>()),
      );
      expect(
        await guard.dispatch(model, 1000, 1000, request, approval: quote),
        1,
      );
      await expectLater(
        guard.dispatch(model, 1000, 1000, request, approval: quote),
        throwsA(isA<WalletRequestBlocked>()),
      );
      expect(requests, 1);
    },
  );

  testWidgets(
    'official icon, tap, outside dismissal, drag and restore above composer',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 540));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          apiKeyStatusProvider.overrideWith((ref) async => false),
        ],
      );
      addTearDown(container.dispose);
      const dragKey = Key('wallet-ball-drag');
      const composer = Key('test-composer');
      const reading = Key('test-reading');
      Widget host({
        double keyboardHeight = 0,
        double scale = 1,
        bool show = true,
      }) => UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              viewInsets: EdgeInsets.only(bottom: keyboardHeight),
              textScaler: TextScaler.linear(scale),
            ),
            child: child!,
          ),
          home: Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: show
                      ? const FloatingWalletBall(
                          child: Center(key: reading, child: Text('这一行是普通剧情。')),
                        )
                      : const SizedBox(),
                ),
                const SizedBox(key: composer, height: 70, child: Text('测试输入框')),
              ],
            ),
          ),
        ),
      );
      Future<void> waitForBall() async {
        for (var i = 0; i < 30 && find.byKey(dragKey).evaluate().isEmpty; i++) {
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 20)),
          );
          await tester.pump(const Duration(milliseconds: 16));
        }
        expect(find.byKey(dragKey), findsOneWidget);
      }

      await tester.pumpWidget(host());
      await waitForBall();
      expect(tester.getSize(find.byKey(dragKey)), const Size(52, 52));
      expect(tester.getSize(find.byKey(reading)).width, 320);
      expect(
        tester.widget<Image>(find.byType(Image)).image,
        isA<ResizeImage>().having(
          (image) => (image.imageProvider as AssetImage).assetName,
          'asset',
          'assets/branding/fish_logo.png',
        ),
      );
      expect(tester.getCenter(find.byKey(dragKey)).dx, greaterThan(260));
      await tester.tap(find.byKey(dragKey));
      await tester.pumpAndSettle();
      expect(find.text('大肥鱼消费管家'), findsOneWidget);
      expect(find.textContaining('暂不可用', findRichText: true), findsWidgets);
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text('大肥鱼消费管家'), findsNothing);
      await tester.drag(find.byKey(dragKey), const Offset(-260, -160));
      await tester.pump();
      final docked = tester.getCenter(find.byKey(dragKey));
      expect(docked.dx, lessThan(60));
      for (var i = 0; i < 15; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 12)),
        );
        final persisted = await tester.runAsync(preferences.position);
        if (persisted?.left == true) break;
        await tester.pump();
      }
      await tester.pumpWidget(host(show: false));
      await tester.pumpWidget(host(keyboardHeight: 170, scale: 1.7));
      await waitForBall();
      expect(tester.getCenter(find.byKey(dragKey)).dx, lessThan(60));
      expect(
        tester.getBottomLeft(find.byKey(dragKey)).dy,
        lessThan(tester.getTopLeft(find.byKey(composer)).dy),
      );
      await tester.tap(find.byKey(dragKey));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tapAt(const Offset(3, 3));
      await tester.pumpAndSettle();
      await tester.runAsync(() => preferences.setVisible(false));
      container.invalidate(walletVisibleProvider);
      await tester.pumpAndSettle();
      expect(find.byKey(dragKey), findsNothing);
      expect(tester.getSize(find.byKey(reading)).width, 320);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
