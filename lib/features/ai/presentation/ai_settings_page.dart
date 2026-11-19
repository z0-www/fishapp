import '../../wallet/application/wallet_controller.dart';
import '../../wallet/application/wallet_limits.dart';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/security/api_key_storage.dart';
import '../../../shared/widgets/content_frame.dart';
import '../../usage/usage_repository.dart';
import '../../world_creator/application/providers.dart';
import '../application/ai_providers.dart';
import '../data/deepseek_config.dart';
import '../data/deepseek_error_handler.dart';
import '../data/deepseek_models.dart';
import 'api_key_guide_page.dart';
import 'connection_consent.dart';

class AiSettingsPage extends ConsumerStatefulWidget {
  const AiSettingsPage({super.key});
  @override
  ConsumerState<AiSettingsPage> createState() => _AiSettingsPageState();
}

class _AiSettingsPageState extends ConsumerState<AiSettingsPage> {
  bool busy = false, confirmingTest = false;

  Future<void> _setModel(String? model) async {
    if (busy || confirmingTest || !DeepSeekModels.supported.contains(model)) {
      return;
    }
    setState(() => busy = true);
    try {
      await ref.read(worldDefinitionRepositoryProvider).saveDraft(
        deepSeekModelPreferenceKey,
        {'model': model},
      );
      if (!mounted) return;
      ref.invalidate(deepSeekModelPreferenceProvider);
      ref.read(apiDiagnosticsProvider.notifier).reset();
      ref.read(connectionStatusProvider.notifier).setStatus('模型已保存，下轮生效。');
    } catch (_) {
      if (mounted) {
        ref.read(connectionStatusProvider.notifier).setStatus('模型未保存，请重试。');
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> testSaved() async {
    if (busy ||
        confirmingTest ||
        !ref.read(deepSeekConfigProvider).permitsDirectCalls) {
      return;
    }
    confirmingTest = true;
    final model = ref.read(deepSeekConfigProvider).model;
    final wallet = ref.read(walletGuardProvider);
    final WalletQuote quote;
    try {
      quote = await wallet.quote(model, 256, 8);
      if (!mounted) return;
      if (quote.blocked) throw WalletRequestBlocked(quote.notice!);
      if (!await confirmConnectionTest(context, ref, quote) || !mounted) return;
    } catch (e) {
      if (mounted) {
        ref
            .read(connectionStatusProvider.notifier)
            .setStatus(e is WalletRequestBlocked ? e.message : '消费计划暂无法读取。');
      }
      return;
    } finally {
      confirmingTest = false;
    }
    setState(() => busy = true);
    String? temporary;
    try {
      temporary = await ref.read(apiKeyStorageProvider).readApiKey();
      if (!mounted) return;
      if (temporary == null) {
        ref.invalidate(apiKeyStatusProvider);
        throw const DeepSeekFailure('尚未保存密钥，请先配置。');
      }
      final api = ref.read(deepSeekRepositoryProvider);
      final result = await wallet.dispatch(
        model,
        256,
        8,
        () => api.testConnection(temporary!),
        approval: quote,
      );
      if (mounted) {
        ref.read(connectionStatusProvider.notifier).setStatus('');
        ref.read(apiDiagnosticsProvider.notifier).connected(result.receipt);
      }
    } catch (e) {
      if (mounted) {
        if (e is WalletRequestBlocked) {
          ref.read(connectionStatusProvider.notifier).setStatus(e.message);
          return;
        }
        ref.read(connectionStatusProvider.notifier).setStatus('');
        final diagnostics = ref.read(apiDiagnosticsProvider.notifier);
        if (e is ApiKeyStorageException) {
          diagnostics.requestFailedMessage(e.toString());
        } else {
          diagnostics.requestFailed(e);
        }
      }
    } finally {
      temporary = null;
      if (mounted) {
        ref.invalidate(usageProvider);
        ref.invalidate(usageMetricsProvider);
        setState(() => busy = false);
      }
    }
  }

  Future<void> delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('删除本机 API Key？'),
        content: const Text('只删除密钥，世界和游戏存档会保留。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text('确认删除'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => busy = true);
    try {
      await ref.read(apiKeyStorageProvider).deleteApiKey();
      if (!mounted) return;
      ref.invalidate(apiKeyStatusProvider);
      ref.read(apiDiagnosticsProvider.notifier).reset();
      ref.read(connectionStatusProvider.notifier).setStatus('密钥已删除；本地世界已保留');
    } catch (_) {
      if (mounted) {
        ref.read(connectionStatusProvider.notifier).setStatus('删除失败，请解锁设备后重试。');
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(deepSeekConfigProvider);
    final diagnostics = ref.watch(apiDiagnosticsProvider);
    final status = ref.watch(connectionStatusProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('AI 服务设置')),
      body: SafeArea(
        child: ContentFrame(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                ref.watch(aiConnectionStateProvider).label,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (!config.permitsDirectCalls)
                const Text(DeepSeekConfig.blockedMessage),
              const SizedBox(height: 8),
              const Text(ApiKeyGuidePage.feeNote),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                key: ValueKey(config.model),
                decoration: const InputDecoration(labelText: '当前模型'),
                initialValue: DeepSeekModels.supported.contains(config.model)
                    ? config.model
                    : null,
                isExpanded: true,
                items: [
                  for (final model in DeepSeekModels.supported)
                    DropdownMenuItem(value: model, child: Text(model)),
                ],
                onChanged: busy || confirmingTest ? null : _setModel,
              ),
              const SizedBox(height: 16),

              if (status.isNotEmpty) Text(status),
              if (diagnostics.receipt case final receipt?)
                Text(
                  '最近验证：${receipt.model} · ${receipt.elapsed.inMilliseconds} ms'
                  '${receipt.httpStatus == null ? '' : ' · HTTP ${receipt.httpStatus}'}',
                ),

              if (diagnostics.lastError != null &&
                  diagnostics.lastError != status)
                Text('最近一次错误：${diagnostics.lastError}'),
              const SizedBox(height: 16),
              ref
                  .watch(apiKeyStatusProvider)
                  .when(
                    loading: () => const LinearProgressIndicator(),
                    error: (_, _) => TextButton(
                      onPressed: () => ref.invalidate(apiKeyStatusProvider),
                      child: const Text('无法读取安全存储，点击重试'),
                    ),
                    data: (saved) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(saved ? 'API Key 已保存：••••••••' : '尚未保存 API Key'),
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: busy
                              ? null
                              : () => context.push('/api/setup?replace=$saved'),
                          child: Text(saved ? '更换 API Key' : '配置 API Key'),
                        ),
                        TextButton(
                          onPressed: busy
                              ? null
                              : () => context.push(
                                  '/api/setup?replace=$saved&guide=true',
                                ),
                          child: const Text('如何获取 API Key？'),
                        ),
                        if (saved && config.permitsDirectCalls)
                          TextButton(
                            onPressed: busy ? null : testSaved,
                            child: const Text('手动测试连接'),
                          ),
                        if (saved)
                          TextButton(
                            onPressed: busy ? null : delete,
                            child: const Text('删除 API Key'),
                          ),
                      ],
                    ),
                  ),
              if (busy) const LinearProgressIndicator(),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('本地费用统计'),
                subtitle: const Text('请求前确认预计费用，实际费用以 DeepSeek 为准。'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/usage'),
              ),
              if (DeepSeekConfig.applicationBuild.showsConnectionDiagnostics)
                ListTile(
                  title: Text(
                    config.isAndroidReleaseValidation ? '接入验收记录' : '开发诊断',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/ai-diagnostics'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
