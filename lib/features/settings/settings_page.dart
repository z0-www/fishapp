import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/app_version.dart';
import '../../shared/widgets/back_home_button.dart';
import '../../shared/widgets/content_frame.dart';
import '../ai/application/ai_providers.dart';
import '../wallet/application/wallet_controller.dart';
import 'presentation/product_statement_dialog.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletVisibleProvider);
    final keyMissing = ref.watch(apiKeyStatusProvider).asData?.value == false;
    return Scaffold(
      appBar: AppBar(leading: const BackHomeButton(), title: const Text('设置')),
      body: SafeArea(
        child: ContentFrame(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              const _SectionTitle('AI 与模型'),
              _entry(
                context,
                'AI 服务设置',
                '/ai-settings',
                subtitle: keyMissing
                    ? '尚未配置 DeepSeek API Key'
                    : 'API Key 与模型选择',
              ),
              _entry(context, '叙事偏好', '/narrative-settings'),
              const _SectionTitle('故事与数据'),
              _entry(context, '导入故事', '/imports'),
              _entry(context, '导入世界设定', '/definition/import'),
              _entry(context, '完整故事备份', '/backup'),
              _entry(context, '隐私说明', '/privacy'),
              const _SectionTitle('费用与消费'),
              _entry(context, '消费计划', '/wallet-plan'),
              _entry(context, '消费记录', '/usage'),
              SwitchListTile(
                title: const Text('文游消费悬浮球'),
                value: wallet.asData?.value ?? false,
                onChanged: wallet.hasValue
                    ? (enabled) => _setWallet(context, ref, enabled)
                    : null,
              ),
              const SizedBox(height: 16),
              ExpansionTile(
                leading: Image.asset(
                  'assets/branding/fish_logo.png',
                  width: 40,
                  height: 40,
                  cacheWidth: 120,
                  cacheHeight: 120,
                  fit: BoxFit.contain,
                  semanticLabel: '鱼者文游 Logo',
                ),
                title: const Text('关于鱼者'),
                subtitle: const Text('鱼者文游 · V$appVersion'),
                children: [
                  ListTile(
                    title: const Text('查看产品声明'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      if (await showProductStatement(context) &&
                          context.mounted) {
                        context.go('/');
                      }
                    },
                  ),
                  _entry(context, '意见反馈', '/feedback'),
                  ListTile(
                    title: const Text('开源许可'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => showLicensePage(
                      context: context,
                      applicationName: '鱼者文游',
                      applicationVersion: appVersion,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('开发者 · B站 UP 主 z0-www'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _entry(
    BuildContext context,
    String label,
    String path, {
    String? subtitle,
  }) => ListTile(
    title: Text(label),
    subtitle: subtitle == null ? null : Text(subtitle),
    trailing: const Icon(Icons.chevron_right),
    onTap: () => context.push(path),
  );

  Future<void> _setWallet(
    BuildContext context,
    WidgetRef ref,
    bool enabled,
  ) async {
    try {
      await ref.read(walletPreferencesProvider).setVisible(enabled);
      if (context.mounted) ref.invalidate(walletVisibleProvider);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('悬浮球设置未保存，请重试。')));
      }
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
    child: Text(label, style: Theme.of(context).textTheme.titleMedium),
  );
}
