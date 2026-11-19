import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../application/ai_providers.dart';

class ApiKeyReminder extends ConsumerWidget {
  const ApiKeyReminder({super.key});

  static const label = '尚未配置 DeepSeek API Key，去配置';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(apiKeyStatusProvider).asData?.value != false) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextButton(
        onPressed: () => context.push('/api/setup'),
        child: const Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}
