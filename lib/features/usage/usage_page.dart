import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/content_frame.dart';
import 'usage_repository.dart';
import 'budget_reminder.dart';

class UsagePage extends ConsumerWidget {
  const UsagePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('本地费用统计')),
    body: ContentFrame(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            '仅展示本机记录。估算不是实际账单，实际费用请以 DeepSeek 官方平台为准。未配置已核验价格表时不估价。',
            style: TextStyle(height: 1.7),
          ),
          const BudgetReminder(),
          ref
              .watch(usageMetricsProvider)
              .when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const Text('上下文统计暂时无法读取'),
                data: (metrics) {
                  final unconfirmed = metrics.where(
                    (m) => m['type'] == UsageRepository.awaitingUsage,
                  );
                  return ExpansionTile(
                    title: const Text('请求 Token 与上下文差异'),
                    subtitle: unconfirmed.isEmpty
                        ? null
                        : Text('最近记录有 ${unconfirmed.length} 次用量未知，可能已产生费用。'),
                    children: [
                      for (final m in metrics.take(20))
                        if (m['type'] == UsageRepository.awaitingUsage)
                          ListTile(
                            title: const Text('用量未知，可能已产生费用'),
                            subtitle: Text(
                              "${m['model']} · ${m['requestedAt']}",
                            ),
                          )
                        else
                          ListTile(
                            title: Text(
                              '请求 ${m['usageId']}${m['httpStatus'] == null ? '' : ' · HTTP ${m['httpStatus']}'}',
                            ),
                            subtitle: Text(
                              m['estimatedInput'] == null
                                  ? '连接测试 · 输入 ${m['inputTokens']} · 输出 ${m['outputTokens']} Token'
                                  : '输入估算 ${m['estimatedInput']} / 实际 ${m['inputTokens']}；输出 ${m['outputTokens']}；缓存 ${m['cacheTokens']?.toString() ?? '未知'}\n完整历史字节参考 ${m['fullHistoryBytesEstimate']}。字节估算不是模型 Token；账单金额未返回。',
                            ),
                          ),
                    ],
                  );
                },
              ),
          const SizedBox(height: 24),
          ref
              .watch(usageProvider)
              .when(
                loading: () => const CircularProgressIndicator(),
                error: (_, _) => TextButton(
                  onPressed: () => ref.invalidate(usageProvider),
                  child: const Text('读取失败，点击重试'),
                ),
                data: (rows) => rows.isEmpty
                    ? const Text('暂无已确认的 Token 用量。')
                    : Column(
                        children: [
                          Text(
                            '可估价请求合计约 USD ${rows.fold<double>(0, (n, r) => n + (r.estimatedUsd ?? 0)).toStringAsFixed(6)}；未估价 ${rows.where((r) => r.estimatedUsd == null).length} 次。非实际账单。',
                          ),
                          ...rows.map(
                            (r) => ListTile(
                              title: Text(r.model),
                              subtitle: Text(
                                '${r.requestedAt.toLocal()}\n输入 ${r.inputTokens} · 输出 ${r.outputTokens} · 缓存命中 ${r.cacheTokens ?? "未返回"} · 未命中 ${r.cacheTokens == null ? "未知" : (r.inputTokens - r.cacheTokens!).clamp(0, r.inputTokens)}\n'
                                '${r.estimatedUsd == null ? "未估价" : "估算 USD ${r.estimatedUsd!.toStringAsFixed(6)}"} · 价格版本 ${r.priceVersion ?? "未配置"}',
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
        ],
      ),
    ),
  );
}
