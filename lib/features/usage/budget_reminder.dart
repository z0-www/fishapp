import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../worlds/application/world_providers.dart';
import '../world_creator/data/world_definition_repository.dart';
import '../story_world/application/context_engine.dart';

class BudgetReminder extends ConsumerStatefulWidget {
  const BudgetReminder({super.key});
  @override
  ConsumerState<BudgetReminder> createState() => _BudgetReminderState();
}

class _BudgetReminderState extends ConsumerState<BudgetReminder> {
  final amount = TextEditingController();
  String? status;
  bool busy = false;
  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    amount.dispose();
    super.dispose();
  }

  Future<void> load() async {
    try {
      final value = await WorldDefinitionRepository(ref.read(databaseProvider))
          .draft('usage-budget');
      if (mounted) {
        setState(() => amount.text = value?['monthlyUsd']?.toString() ?? '');
      }
    } catch (_) {
      if (mounted) setState(() => status = '预算提醒读取失败。');
    }
  }

  Future<void> save() async {
    final parsed = double.tryParse(amount.text);
    if (amount.text.trim().isNotEmpty &&
        (parsed == null || !parsed.isFinite || parsed <= 0)) {
      setState(() => status = '请输入大于0的美元预算，或留空关闭提醒。');
      return;
    }
    setState(() => busy = true);
    try {
      await WorldDefinitionRepository(ref.read(databaseProvider))
          .saveDraft('usage-budget', {'monthlyUsd': parsed});
      final notice = await UsageTracker(ref.read(databaseProvider)).notice();
      if (mounted) setState(() => status = notice ?? '提醒已保存到本机；它不是服务商额度限制。');
    } catch (_) {
      if (mounted) setState(() => status = '提醒保存失败，请重试。');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 20),
      TextField(
        controller: amount,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(labelText: '每月使用预算提醒（USD，可留空）'),
      ),
      TextButton(onPressed: busy ? null : save, child: const Text('保存本机预算提醒')),
      const Text('按本机已记录且可估价的请求提醒；未返回用量、未估价和其他设备费用无法计入，不代表实际账单。'),
      if (status != null) Text(status!),
    ],
  );
}
