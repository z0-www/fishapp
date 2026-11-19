import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../ai/application/ai_providers.dart';
import '../../usage/price_schedule.dart';
import '../../usage/price_schedule_provider.dart';
import '../application/wallet_controller.dart';
import '../application/wallet_limits.dart';

class WalletOverlayCard extends ConsumerWidget {
  const WalletOverlayCard({
    super.key,
    required this.details,
    required this.plan,
  });
  final VoidCallback details, plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(walletBalanceProvider);
    final account = balance.asData?.value;
    final clock =
        ref.watch(walletClockProvider).asData?.value ?? DateTime.now();
    final config = ref.watch(walletPriceProvider).asData?.value;
    final spending = ref.watch(walletTodayProvider).asData?.value;
    final planState = ref.watch(walletPlanProvider).asData?.value;
    final budget = planState?.daily;
    final canQuery =
        ref.watch(deepSeekConfigProvider).permitsDirectCalls &&
        ref.watch(apiKeyStatusProvider).asData?.value == true;
    final date = account == null
        ? null
        : WalletPriceSchedule.beijing(account.updatedAt);
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 384),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '大肥鱼消费管家',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: '关闭',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, size: 19),
                  ),
                ],
              ),
              _line(
                'DeepSeek 官方余额',
                balance.isLoading
                    ? '正在查询…'
                    : account?.totals.entries
                              .map((row) => '${row.key} ${row.value}')
                              .join(' / ') ??
                          '暂不可用',
              ),
              _line('当前模型', ref.watch(deepSeekConfigProvider).model),
              _line(
                '当前峰谷期（北京时间）',
                config?.period(clock).label ?? PricePeriod.unknown.label,
              ),
              _line('今日鱼者消费（本机估算）', _spending(spending)),
              _line(
                '今日预算剩余',
                planState == null
                    ? '暂不可用'
                    : budget == null
                    ? '未设置'
                    : spending == null || spending.unknown > 0
                    ? '暂无法确定'
                    : _usd((budget - spending.usd).clamp(0, budget).toDouble()),
              ),
              _line(
                '单轮提醒额度',
                planState == null
                    ? '暂不可用'
                    : planState.warning == null
                    ? '未设置'
                    : _usd(planState.warning!),
              ),
              _line(
                '余额更新时间（北京时间）',
                date == null
                    ? '—'
                    : '${date.month}/${date.day} ${_two(date.hour)}:${_two(date.minute)}',
              ),
              if (!canQuery)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text('需配置 API Key 并使用允许直连的版本才能查询官方余额。'),
                ),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.end,
                children: [
                  TextButton(onPressed: details, child: const Text('消费明细')),
                  TextButton(onPressed: plan, child: const Text('消费计划')),
                  TextButton(
                    onPressed: !canQuery || balance.isLoading
                        ? null
                        : ref.read(walletBalanceProvider.notifier).refresh,
                    child: const Text('刷新余额'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _line(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label  ',
            style: const TextStyle(color: Color(0xFF656D79)),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );

  static String _spending(WalletSpending? spending) => spending == null
      ? '暂不可用'
      : spending.unknown > 0
      ? '${_usd(spending.usd)} 已估价，另 ${spending.unknown} 笔未知'
      : _usd(spending.usd);
  static String _usd(double amount) => 'USD ${amount.toStringAsFixed(6)}';
  static String _two(int n) => n.toString().padLeft(2, '0');
}
