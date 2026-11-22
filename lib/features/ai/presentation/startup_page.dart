import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../platform/web/boot_trace_stub.dart'
    if (dart.library.js_interop) '../../../platform/web/boot_trace_web.dart';
import '../../import_center/application/import_providers.dart';
import '../../settings/application/product_statement_preference.dart';
import '../../settings/presentation/product_statement_dialog.dart';
import '../../world_creator/application/providers.dart';

class StartupPage extends ConsumerStatefulWidget {
  const StartupPage({super.key});

  @override
  ConsumerState<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends ConsumerState<StartupPage> {
  static const _startupTimeout = Duration(seconds: 12);
  String? _error;
  bool _opening = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _open());
  }

  void _fail(String message, Object error) {
    bootStage('startup-failed', message);
    if (!mounted) return;
    setState(() {
      _error = message;
      _opening = false;
    });
  }

  Future<void> _open() async {
    if (!mounted || _opening) return;
    _opening = true;
    bootStage('startup-read-statement');
    var seen = false;
    try {
      seen = await ref
          .read(productStatementSeenProvider.future)
          .timeout(_startupTimeout);
      bootStage('startup-read-statement-done');
    } on TimeoutException {
      _fail(
        '本地数据库在 ${_startupTimeout.inSeconds} 秒内没有完成初始化。'
        '存档没有被删除；请先不要清除网站数据。',
        TimeoutException('startup'),
      );
      return;
    } catch (error) {
      _fail(
        '本地故事数据库启动失败。存档没有被删除；请先不要清除网站数据。',
        error,
      );
      return;
    }
    if (!mounted) return;

    var saved = true;
    if (!seen) {
      if (!await showProductStatement(context, firstLaunch: true) || !mounted) {
        _opening = false;
        return;
      }
      try {
        await ref
            .read(worldDefinitionRepositoryProvider)
            .saveDraft(productStatementPreferenceKey, {'seen': true})
            .timeout(_startupTimeout);
      } on TimeoutException {
        _fail(
          '保存首次使用状态超时。存档没有被删除；请先不要清除网站数据。',
          TimeoutException('save-statement'),
        );
        return;
      } catch (error) {
        saved = false;
        bootStage('startup-save-statement-failed', error.runtimeType.toString());
      }
      if (!mounted) return;
      if (saved) ref.invalidate(productStatementSeenProvider);
    }
    final intake = ref.read(shareIntakeProvider);
    final messenger = ScaffoldMessenger.of(context);
    bootStage('startup-navigate-home');
    context.go('/');
    intake.refresh();
    _opening = false;
    if (!saved) {
      messenger.showSnackBar(
        const SnackBar(content: Text('本机未保存声明查看状态，下次打开时可能再次显示。')),
      );
    }
  }

  Future<void> _retry() async {
    bootStage('startup-retry');
    if (!mounted) return;
    setState(() {
      _error = null;
      _opening = false;
    });
    ref.invalidate(productStatementSeenProvider);
    await _open();
  }

  Future<void> _openDiagnostics() async {
    if (!kIsWeb) return;
    final uri = Uri.base.resolve('diagnostics.html');
    await launchUrl(uri, webOnlyWindowName: '_blank');
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    if (error == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8F9FB),
        body: SizedBox.expand(),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.storage_rounded,
                  size: 42,
                  color: Color(0xFF3176C6),
                ),
                const SizedBox(height: 14),
                const Text(
                  '本地故事启动失败',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.55,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '原存档仍然保留。不要点击清除网站数据或重装浏览器；'
                  '如持续失败，请打开启动诊断。',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.55,
                    color: Color(0xFF8A5A00),
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: _retry,
                  child: const Text('重试初始化'),
                ),
                if (kIsWeb) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _openDiagnostics,
                    child: const Text('打开启动诊断'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
