import '../features/wallet/presentation/wallet_plan_page.dart';
import '../features/world_backup/presentation/backup_pages.dart';
import '../features/story_world/presentation/story_tools_page.dart';
import '../features/story_world/presentation/recovery_page.dart';
import '../features/world_creator/presentation/world_creator_page.dart';
import '../features/world_creator/presentation/world_definition_page.dart';
import '../features/world_creator/presentation/world_definition_import_page.dart';
import '../features/roleplay/presentation/roleplay_page.dart';
import '../features/roleplay/presentation/narrative_settings_page.dart';
import '../features/import_center/presentation/import_center_page.dart';
import '../features/import_center/presentation/import_preview_page.dart';
import '../features/import_center/presentation/import_result_page.dart';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/worlds/presentation/home_page.dart';
import '../features/worlds/presentation/world_list_page.dart';
import '../features/roleplay/presentation/chat_history_page.dart';

import '../features/worlds/presentation/world_page.dart';
import '../features/settings/settings_page.dart';
import '../features/settings/feedback_page.dart';
import '../features/ai/data/deepseek_config.dart';
import '../features/ai/presentation/startup_page.dart';
import '../features/ai/presentation/api_setup_page.dart';
import '../features/ai/presentation/ai_settings_page.dart';
import '../features/ai/presentation/ai_developer_diagnostics_page.dart';
import '../features/ai/presentation/privacy_page.dart';
import '../features/usage/usage_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/startup',
    routes: [
      GoRoute(path: '/worlds', builder: (_, _) => const WorldListPage()),
      GoRoute(
        path: '/history/:id',
        builder: (_, s) => ChatHistoryPage(
          key: ValueKey(s.pathParameters['id']),
          worldId: s.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: "/story/tools/:id",
        builder: (_, s) => StoryToolsPage(
          key: ValueKey(s.pathParameters["id"]),
          worldId: s.pathParameters["id"]!,
        ),
      ),
      GoRoute(path: '/startup', builder: (_, _) => const StartupPage()),
      GoRoute(
        path: '/backup',
        builder: (_, _) => const StoryBackupLibraryPage(),
      ),
      GoRoute(
        path: '/backup/restore/:id',
        builder: (_, state) =>
            StoryBackupRestorePage(state.pathParameters['id']!),
      ),
      GoRoute(path: '/', builder: (_, _) => const HomePage()),
      GoRoute(path: '/imports', builder: (_, _) => const ImportCenterPage()),
      GoRoute(
        path: '/imports/preview/:id',
        builder: (_, state) => ImportPreviewPage(
          key: ValueKey(state.pathParameters['id']),
          id: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/imports/result/:id',
        builder: (_, state) => ImportResultPage(
          key: ValueKey(state.pathParameters['id']),
          id: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/story/recover/:id',
        builder: (_, s) => WorldRecoveryPreviewPage(
          key: ValueKey(s.pathParameters['id']),
          conversationId: s.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/create',
        builder: (_, s) => WorldCreatorPage(
          key: ValueKey(s.uri.queryParameters['prompt'] ?? 'create'),
          initialDescription: s.uri.queryParameters['prompt'],
        ),
      ),
      GoRoute(
        path: '/definition/edit/:id',
        builder: (_, state) => WorldCreatorPage(
          key: ValueKey(state.pathParameters['id']),
          worldId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/definition/view/:id',
        builder: (_, state) => WorldDefinitionPage(
          key: ValueKey(state.pathParameters['id']),
          worldId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/definition/import',
        builder: (_, _) => const WorldDefinitionImportPage(),
      ),
      GoRoute(
        path: '/definition/import/:id',
        builder: (_, state) => WorldDefinitionImportPage(
          key: ValueKey(state.pathParameters['id']),
          jobId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/play/:id',
        builder: (_, state) => RoleplayPage(
          key: ValueKey(state.pathParameters['id']),
          worldId: state.pathParameters['id']!,
          initialAction: state.uri.queryParameters['retry'],
        ),
      ),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsPage()),
      GoRoute(
        path: '/narrative-settings',
        builder: (_, _) => const NarrativeSettingsPage(),
      ),
      GoRoute(path: '/feedback', builder: (_, _) => const FeedbackPage()),
      GoRoute(path: '/ai-settings', builder: (_, _) => const AiSettingsPage()),
      if (DeepSeekConfig.applicationBuild.showsConnectionDiagnostics)
        GoRoute(
          path: '/ai-diagnostics',
          builder: (_, _) => const AiDeveloperDiagnosticsPage(),
        ),
      GoRoute(
        path: '/api/setup',
        builder: (_, state) => ApiSetupPage(
          replacing: state.uri.queryParameters['replace'] == 'true',
          showGuide: state.uri.queryParameters['guide'] == 'true',
        ),
      ),
      GoRoute(path: '/privacy', builder: (_, _) => const PrivacyPage()),
      GoRoute(path: '/usage', builder: (_, _) => const UsagePage()),
      GoRoute(path: '/wallet-plan', builder: (_, _) => const WalletPlanPage()),
      GoRoute(
        path: '/world/:id',
        builder: (_, state) => WorldPage(id: state.pathParameters['id']!),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('页面不存在')),
      body: Center(
        child: TextButton(
          onPressed: () => context.go('/'),
          child: const Text('返回首页'),
        ),
      ),
    ),
  );
  ref.onDispose(router.dispose);
  return router;
});
