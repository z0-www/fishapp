import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../wallet/application/wallet_limits.dart';
import '../application/ai_providers.dart';

/// Called before retrieving a saved key or sending any real test request.
Future<bool> confirmConnectionTest(
  BuildContext context,
  WidgetRef ref,
  WalletQuote quote,
) async {
  final config = ref.read(deepSeekConfigProvider);
  if (!config.permitsDirectCalls) {
    return false;
  }
  final estimated = quote.estimated?.toStringAsFixed(6);
  return await showDialog<bool>(
        context: context,
        builder: (dialog) => AlertDialog(
          title: const Text('确认真实连接测试？'),
          content: Text(
            '将向 DeepSeek 发送一次简短请求。模型：${config.model}。'
            '\n预计输入约 256 Token，输出上限 8 Token。'
            '${estimated == null ? '费用暂无法估算。' : '费用参考约 USD $estimated。'}'
            '\n费用仅为估算，以官方实际用量为准。取消不会发出请求。\n${quote.notice ?? ''}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialog, false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialog, true),
              child: const Text('同意费用并测试'),
            ),
          ],
        ),
      ) ==
      true;
}
