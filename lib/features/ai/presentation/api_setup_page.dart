import 'package:material_ui/material_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/security/api_key_storage.dart';
import '../../../platform/web/web_storage_guard.dart';
import '../../../shared/widgets/content_frame.dart';
import '../application/ai_providers.dart';
import 'api_key_guide_page.dart';

class ApiSetupPage extends ConsumerStatefulWidget {
  const ApiSetupPage({
    super.key,
    this.replacing = false,
    this.showGuide = false,
  });
  final bool replacing, showGuide;
  @override
  ConsumerState<ApiSetupPage> createState() => _ApiSetupPageState();
}

class _ApiSetupPageState extends ConsumerState<ApiSetupPage>
    with WidgetsBindingObserver {
  final controller = TextEditingController();
  bool visible = false, busy = false;
  int revision = 0;
  String? message;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.showGuide) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) openGuide();
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      controller.clear();
      revision++;
      if (mounted) setState(() => visible = false);
    }
  }

  @override
  void dispose() {
    revision++;
    WidgetsBinding.instance.removeObserver(this);
    controller.clear();
    controller.dispose();
    super.dispose();
  }

  Future<void> openGuide() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final openBrowser = await Navigator.of(context)
        .push<bool>(MaterialPageRoute(builder: (_) => const ApiKeyGuidePage()));
    // The guide has already closed. App resume therefore reveals the
    // configuration screen and never reads the clipboard.
    if (openBrowser != true || !mounted) return;
    try {
      if (await launchUrl(
        ApiKeyGuidePage.keyPage,
        mode: LaunchMode.externalApplication,
      )) {
        return;
      }
    } catch (_) {}
    if (mounted) {
      setState(
        () => message = kIsWeb
            ? '请在浏览器新标签页打开 platform.deepseek.com/api_keys。'
            : '请在手机浏览器打开 platform.deepseek.com/api_keys。',
      );
    }
  }

  Future<void> paste() async {
    final attempt = revision;
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      if (!mounted || busy || revision != attempt) return;
      controller.text = (data?.text ?? '').trim();
      setState(() {
        message = null;
        visible = false;
      });
    } catch (_) {
      if (mounted) setState(() => message = '无法读取剪贴板，请手动输入。');
    }
  }

  Future<void> saveKey() async {
    if (!ApiKeyStorage.isValidInput(controller.text)) {
      setState(() => message = '请输入 8–512 位、不含空格的 API Key');
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    final attempt = ++revision;
    String? temporary = controller.text.trim();
    setState(() {
      busy = true;
      message = null;
      visible = false;
    });
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialog) => AlertDialog(
          title: Text(kIsWeb ? '保存到浏览器加密存储？' : '保存到本机安全存储？'),
          content: Text(
            kIsWeb
                ? '网页版用浏览器 WebCrypto 加密后保存在本站点存储中，不会上传到鱼者服务器。清除网站数据会同时删除密钥。请勿在公共电脑上保存。'
                : '保存后可在 AI 服务设置中查看连接状态。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialog, false),
              child: const Text('暂不保存'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialog, true),
              child: const Text('确认保存'),
            ),
          ],
        ),
      );
      if (!mounted || revision != attempt) return;
      controller.clear();
      if (confirmed != true) {
        setState(() => message = '未保存，临时输入已清理。');
        return;
      }
      final storage = ref.read(apiKeyStorageProvider);
      if (widget.replacing) {
        await storage.updateApiKey(temporary);
      } else {
        await storage.saveApiKey(temporary);
      }
      if (!mounted) return;
      ref.invalidate(apiKeyStatusProvider);
      ref.read(apiDiagnosticsProvider.notifier).reset();
      ref.read(connectionStatusProvider.notifier).setStatus('');
      if (context.canPop()) {
        context.pop();
      } else {
        final router = GoRouter.of(context);
        final messenger = ScaffoldMessenger.of(context);
        final canTest = ref.read(deepSeekConfigProvider).permitsDirectCalls;
        router.go('/');
        if (canTest) {
          messenger.showSnackBar(
            SnackBar(
              content: const Text('密钥已保存。'),
              action: SnackBarAction(
                label: '测试连接',
                onPressed: () => router.push('/ai-settings'),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted && revision == attempt) {
        controller.clear();
        final safe = e is ApiKeyStorageException ? e.toString() : '无法保存密钥，请重试。';
        setState(() => message = safe);
      }
    } finally {
      temporary = null;
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final saved = ref.watch(apiKeyStatusProvider).asData?.value ?? false;
    final config = ref.watch(deepSeekConfigProvider);
    return Scaffold(
      appBar: AppBar(title: Text(widget.replacing ? '更换 API Key' : 'AI 服务配置')),
      body: SafeArea(
        child: ContentFrame(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/branding/fish_logo.png',
                    width: 44,
                    height: 44,
                    cacheWidth: 132,
                    cacheHeight: 132,
                    semanticLabel: '鱼者文游 Logo',
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.replacing ? '更换你的 API Key' : '欢迎来到鱼者文游',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('用你自己的 DeepSeek 密钥连接 AI。'),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: busy ? null : openGuide,
                icon: const Icon(Icons.help_outline_rounded, size: 20),
                label: const Text('图解获取 API Key'),
              ),
              const SizedBox(height: 12),
              if (!config.permitsDirectCalls)
                const Text('当前版本暂时无法测试 AI 连接。你仍可使用本地世界和故事档案。'),
              if (kIsWeb && !isSecureBrowserContext)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    '当前页面不是 HTTPS 或 localhost，浏览器会拒绝加密存储。请改用 HTTPS 地址再保存密钥。',
                    style: TextStyle(color: Color(0xFFB3261E), fontSize: 13),
                  ),
                ),
              const SizedBox(height: 20),
              if (saved && !widget.replacing) ...[
                const ListTile(
                  leading: Icon(Icons.lock_outline),
                  title: Text('API Key 已保存：••••••••'),
                  subtitle: Text('不展示或回填已保存的密钥'),
                ),
                OutlinedButton(
                  onPressed: busy
                      ? null
                      : () => context.push('/api/setup?replace=true'),
                  child: const Text('更换 API Key'),
                ),
              ] else ...[
                TextField(
                  key: const Key('api-key-input'),
                  controller: controller,
                  enabled: !busy,
                  obscureText: !visible,
                  enableInteractiveSelection: false,
                  autocorrect: false,
                  enableSuggestions: false,
                  enableIMEPersonalizedLearning: false,
                  autofillHints: const [],
                  keyboardType: TextInputType.visiblePassword,
                  maxLength: 512,
                  decoration: InputDecoration(
                    labelText: 'DeepSeek API Key',
                    suffixIcon: IconButton(
                      tooltip: visible ? '隐藏密钥' : '显示密钥',
                      onPressed: busy
                          ? null
                          : () => setState(() => visible = !visible),
                      icon: Icon(
                        visible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: busy ? null : paste,
                    icon: const Icon(Icons.content_paste),
                    label: const Text('粘贴'),
                  ),
                ),
                FilledButton(
                  onPressed: busy ? null : saveKey,
                  child: Text(busy ? '正在处理…' : '保存 API Key'),
                ),
              ],
              if (message != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(message!),
                ),
              const SizedBox(height: 16),
              Text(
                kIsWeb
                    ? '密钥保存在浏览器加密存储中，只发送给 api.deepseek.com。'
                    : '密钥仅保存在设备安全存储中。',
                style: const TextStyle(fontSize: 13, color: Color(0xFF858A93)),
              ),
              const ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text('API 服务与本地隐私说明'),
                children: [
                  Text(
                    'DeepSeek 提供独立计费的 AI API 服务。密钥由你在官方平台申请和管理；鱼者文游不代管账户或余额。密钥不会写入游戏数据库或上传鱼者服务器。没有密钥也可以创建、编辑和阅读本地世界。',
                    style: TextStyle(fontSize: 13, height: 1.7),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.push('/privacy'),
                child: const Text('隐私说明'),
              ),
              TextButton(
                onPressed: busy ? null : () => context.go('/'),
                child: const Text('先体验本地世界'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
