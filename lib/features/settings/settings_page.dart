import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/app_version.dart';
import '../../platform/web/web_storage_guard.dart';
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
              if (kIsWeb) const _WebDataSection(),
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

/// Browser-specific data safety: explain Home Screen install, request
/// persistent storage, and keep the export reminder visible.
class _WebDataSection extends StatefulWidget {
  const _WebDataSection();

  @override
  State<_WebDataSection> createState() => _WebDataSectionState();
}

class _WebDataSectionState extends State<_WebDataSection> {
  bool? persisted;
  int? usage, quota;
  bool busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final stored = await isStoragePersisted();
    final used = await webStorageUsageBytes();
    final total = await webStorageQuotaBytes();
    if (!mounted) return;
    setState(() {
      persisted = stored;
      usage = used;
      quota = total;
    });
  }

  Future<void> _request() async {
    setState(() => busy = true);
    await requestPersistentStorage();
    await _load();
    if (mounted) setState(() => busy = false);
  }

  String _mb(int? bytes) =>
      bytes == null ? '—' : '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';

  @override
  Widget build(BuildContext context) {
    final secure = isSecureBrowserContext;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle('网页版与数据'),
        const ListTile(
          title: Text('添加到 iPhone 主屏幕'),
          subtitle: Text(
            '用 Safari 打开本页 → 分享按钮 → “添加到主屏幕”。之后可像应用一样全屏打开，已缓存资源在断网时仍能启动。',
          ),
        ),
        ListTile(
          title: const Text('浏览器存储'),
          subtitle: Text(
            persisted == true
                ? '已获得持久化存储。仍建议定期导出 .yuzhe 备份。'
                : '未获得持久化存储：浏览器在空间不足或清理网站数据时可能删除本地故事。',
          ),
          trailing: persisted == true
              ? const Icon(Icons.check_circle_outline, color: Color(0xFF3176C6))
              : null,
        ),
        if (persisted != true)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton(
              onPressed: busy ? null : _request,
              child: Text(busy ? '正在请求…' : '请求持久化存储'),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            '已用 ${_mb(usage)} / 可用配额 ${_mb(quota)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        ListTile(
          title: const Text('立即导出故事备份'),
          subtitle: const Text('换浏览器、清理数据或换手机前，先保存 .yuzhe 文件。'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/backup'),
        ),
        if (!secure)
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Text(
              '当前页面不是 HTTPS 或 localhost：浏览器会拒绝 WebCrypto，API Key 无法安全保存。请使用 HTTPS 地址。',
              style: TextStyle(color: Color(0xFFB3261E), fontSize: 13),
            ),
          ),
      ],
    );
  }
}
