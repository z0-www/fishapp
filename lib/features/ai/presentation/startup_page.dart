import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _open());
  }

  Future<void> _open() async {
    if (!mounted) return;
    var seen = false;
    try {
      seen = await ref.read(productStatementSeenProvider.future);
    } catch (_) {
      // The statement can still be read when local storage is unavailable.
    }
    if (!mounted) return;
    var saved = true;
    if (!seen) {
      if (!await showProductStatement(context, firstLaunch: true) || !mounted) {
        return;
      }
      try {
        await ref.read(worldDefinitionRepositoryProvider).saveDraft(
          productStatementPreferenceKey,
          {'seen': true},
        );
      } catch (_) {
        saved = false;
      }
      if (!mounted) return;
      if (saved) ref.invalidate(productStatementSeenProvider);
    }
    final intake = ref.read(shareIntakeProvider);
    final messenger = ScaffoldMessenger.of(context);
    context.go('/');
    intake.refresh();
    if (!saved) {
      messenger.showSnackBar(
        const SnackBar(content: Text('本机未保存声明查看状态，下次打开时可能再次显示。')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: Color(0xFFF8F9FB),
    body: SizedBox.expand(),
  );
}
