import '../features/import_center/application/share_coordinator.dart';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';

class FishApp extends ConsumerWidget {
  const FishApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    title: '鱼者文游',
    debugShowCheckedModeBanner: false,
    theme: FishTheme.light,
    locale: const Locale('zh', 'CN'),
    supportedLocales: const [Locale('zh', 'CN')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    builder: (context, child) =>
        ShareCoordinator(child: child ?? const SizedBox.shrink()),
    routerConfig: ref.watch(routerProvider),
  );
}
