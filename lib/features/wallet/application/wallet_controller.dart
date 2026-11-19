import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ai/application/ai_providers.dart';
import '../../ai/data/deepseek_api_client.dart';
import '../../ai/data/deepseek_balance.dart';
import '../../ai/data/deepseek_error_handler.dart';
import '../../usage/price_schedule.dart';
import '../../usage/price_schedule_provider.dart';
import '../../usage/usage_repository.dart';
import '../../world_creator/data/world_definition_repository.dart';
import '../../worlds/application/world_providers.dart';
import 'wallet_limits.dart';

class WalletPreferences {
  WalletPreferences(this.repository);
  final WorldDefinitionRepository repository;

  Future<WalletPlan> readPlan() async =>
      WalletPlan.fromJson(await repository.draft('wallet-plan-v1'));
  Future<void> savePlan(WalletPlan plan) =>
      repository.saveDraft('wallet-plan-v1', plan.toJson());
  Future<bool> visible() async =>
      (await repository.draft('wallet-ball-visible-v1'))?['enabled'] != false;
  Future<void> setVisible(bool enabled) =>
      repository.saveDraft('wallet-ball-visible-v1', {'enabled': enabled});

  Future<({bool left, double height})> position() async {
    final data = await repository.draft('wallet-ball-position-v1');
    final height = data?['height'];
    return (
      left: data?['left'] == true,
      height: height is num && height.isFinite
          ? height.clamp(0, 1).toDouble()
          : .78,
    );
  }

  Future<void> setPosition({required bool left, required double height}) =>
      repository.saveDraft('wallet-ball-position-v1', {
        'left': left,
        'height': height,
      });
}

final walletPreferencesProvider = Provider(
  (ref) =>
      WalletPreferences(WorldDefinitionRepository(ref.watch(databaseProvider))),
);
final walletVisibleProvider = FutureProvider(
  (ref) => ref.watch(walletPreferencesProvider).visible(),
);
final walletPlanProvider = FutureProvider(
  (ref) => ref.watch(walletPreferencesProvider).readPlan(),
);
final walletClockProvider = StreamProvider.autoDispose<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(const Duration(seconds: 30), (_) => DateTime.now());
});

final walletTodayProvider = FutureProvider.autoDispose<WalletSpending>((ref) {
  final now = ref.watch(walletClockProvider).asData?.value ?? DateTime.now();
  return ref
      .watch(usageRepositoryProvider)
      .spendingSince(WalletPriceSchedule.dayStart(now));
});

class WalletGuard {
  WalletGuard(
    this.preferences,
    this.usage,
    this.price, {
    this.now = DateTime.now,
    this.onChanged,
  });
  final WalletPreferences preferences;
  final UsageRepository usage;
  final Future<WalletPriceSchedule?> Function() price;
  final DateTime Function() now;
  final void Function()? onChanged;
  bool _active = false;

  Future<WalletQuote> quote(String model, int input, int maxOutput) async {
    final time = now();
    final day = WalletPriceSchedule.dayStart(time);
    final plan = await preferences.readPlan();
    final spending = await usage.spendingSince(day);
    final config = await price();
    final table = config?.priceAt(time, model, conservative: true);
    return WalletQuote(
      plan,
      spending,
      table?.estimate(
        requestedAt: time,
        input: input,
        output: maxOutput,
        cached: 0,
      ),
      day.toIso8601String(),
      table == null ? null : config?.version,
      model,
      input,
      maxOutput,
    );
  }

  Future<T> dispatch<T>(
    String model,
    int input,
    int maxOutput,
    Future<T> Function() request, {
    WalletQuote? approval,
    bool automatic = false,
  }) async {
    if (_active) throw const WalletRequestBlocked('已有付费请求在处理，请等它结束后再试。');
    _active = true;
    try {
      final current = await quote(model, input, maxOutput);
      if (current.blocked) throw WalletRequestBlocked(current.notice!);
      if (automatic && !current.automaticAllowed) {
        throw const WalletRequestBlocked('消费授权已变化，请重新发送并确认费用。');
      }
      if (!automatic) {
        if (approval == null ||
            approval.model != model ||
            approval.input != input ||
            approval.maxOutput != maxOutput) {
          throw const WalletRequestBlocked('请先确认本次请求的费用。');
        }
        final expected = approval.estimated;
        final latest = current.estimated;
        if (current.day != approval.day ||
            current.version != approval.version ||
            current.spending.unknown > approval.spending.unknown ||
            (latest == null) != (expected == null) ||
            (latest != null && expected != null && latest - expected > 1e-12)) {
          throw const WalletRequestBlocked('费用估算已变化，请重新发送并确认。');
        }
        if (!approval.consume()) {
          throw const WalletRequestBlocked('本次费用确认已使用，请重新确认后再发送。');
        }
      }
      return await request();
    } finally {
      _active = false;
      onChanged?.call();
    }
  }
}

final walletGuardProvider = Provider((ref) {
  final price = ref.watch(walletPriceProvider.future);
  return WalletGuard(
    ref.watch(walletPreferencesProvider),
    ref.watch(usageRepositoryProvider),
    () => price,
    onChanged: () {
      if (ref.mounted) ref.invalidate(walletTodayProvider);
    },
  );
});

final walletBalanceLoaderProvider =
    Provider<Future<DeepSeekBalance> Function()>((ref) {
      final config = ref.watch(deepSeekConfigProvider);
      final storage = ref.watch(apiKeyStorageProvider);
      return () async {
        if (!config.permitsDirectCalls) {
          throw const DeepSeekFailure('当前构建无法查询余额。');
        }
        final key = await storage.readApiKey();
        if (key == null) throw const DeepSeekFailure(missingDeepSeekKeyMessage);
        final client = DeepSeekApiClient(config);
        try {
          return await client.balance(key);
        } finally {
          client.close();
        }
      };
    });

final walletBalanceProvider =
    NotifierProvider<WalletBalanceController, AsyncValue<DeepSeekBalance?>>(
      WalletBalanceController.new,
    );

class WalletBalanceController extends Notifier<AsyncValue<DeepSeekBalance?>> {
  int _epoch = 0;
  @override
  AsyncValue<DeepSeekBalance?> build() {
    ref.watch(apiKeyStatusProvider);
    ref.watch(deepSeekConfigProvider);
    _epoch++;
    return const AsyncData(null);
  }

  Future<void> refresh() async {
    if (state.isLoading) return;
    final epoch = _epoch;
    state = const AsyncLoading();
    try {
      final result = await ref.read(walletBalanceLoaderProvider)();
      if (ref.mounted && epoch == _epoch) state = AsyncData(result);
    } catch (_) {
      if (ref.mounted && epoch == _epoch) {
        state = const AsyncError(DeepSeekFailure('暂不可用'), StackTrace.empty);
      }
    }
  }
}
