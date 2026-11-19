import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../features/worlds/application/world_providers.dart';

class WorldDrawer extends ConsumerWidget {
  const WorldDrawer({super.key});
  void go(BuildContext context, String route) {
    Navigator.pop(context);
    context.push(route);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Drawer(
    child: SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        children: [
          const ListTile(
            title: Text(
              '鱼者文游',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit_square),
            title: const Text('新建世界'),
            onTap: () {
              Navigator.pop(context);
              context.go('/');
            },
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              '最近世界',
              style: TextStyle(fontSize: 13, color: Color(0xFF858A93)),
            ),
          ),
          ref
              .watch(worldsProvider)
              .when(
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => TextButton(
                  onPressed: () => ref.invalidate(worldsProvider),
                  child: const Text('重新加载'),
                ),
                data: (worlds) => Column(
                  children: [
                    if (worlds.isEmpty) const ListTile(title: Text('还没有世界')),
                    for (final world in worlds.take(6))
                      ListTile(
                        title: Text(
                          world.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => go(context, '/play/${world.id}'),
                      ),
                  ],
                ),
              ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.format_list_bulleted_rounded),
            title: const Text('全部世界'),
            onTap: () => go(context, '/worlds'),
          ),
          ListTile(
            leading: const Icon(Icons.file_open_outlined),
            title: const Text('导入旧故事'),
            onTap: () => go(context, '/imports'),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('设置'),
            onTap: () => go(context, '/settings'),
          ),
        ],
      ),
    ),
  );
}
