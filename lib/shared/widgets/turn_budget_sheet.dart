import 'package:material_ui/material_ui.dart';

import '../../features/roleplay/domain/models.dart';
import '../../features/ai/data/deepseek_models.dart';

Future<bool?> showTurnBudget(
  BuildContext context,
  TurnPlan plan, {
  String? notice,
  required double? estimatedUsd,
  String model = DeepSeekModels.defaultModel,
}) {
  final estimate = estimatedUsd;
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheet) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '生成前确认',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              '预计费用（非严格上限） ${estimate == null ? '未知' : 'USD ${estimate.toStringAsFixed(6)}'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              '模型 $model · 预估输入 ${plan.tokens} Token · 最大输出 ${plan.maxOutputTokens} Token',
            ),
            const SizedBox(height: 8),
            Text(
              plan.action,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF858A93)),
            ),
            if (notice != null && notice.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(notice),
              ),
            ExpansionTile(
              title: const Text('查看处理范围与估算'),
              tilePadding: EdgeInsets.zero,
              children: [
                Text(
                  '仅发送当前世界设定、当前角色可知资料、相关记忆和最多三轮原文。输入保守估算 ${plan.tokens} Token，输出最多 ${plan.maxOutputTokens} Token；每轮最多一次请求。',
                  style: const TextStyle(fontSize: 13),
                ),
                Text(
                  '使用已核验峰时单价估算，实际费用以 DeepSeek 为准。停止或失败也可能已消耗 Token。',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => Navigator.pop(sheet, true),
              child: const Text('确认生成'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(sheet, false),
              child: const Text('取消'),
            ),
          ],
        ),
      ),
    ),
  );
}
