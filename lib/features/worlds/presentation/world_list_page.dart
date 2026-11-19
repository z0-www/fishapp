import '../../../shared/widgets/back_home_button.dart';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/world_providers.dart';
import '../../../shared/widgets/content_frame.dart';

class WorldListPage extends ConsumerStatefulWidget {
  const WorldListPage({super.key});
  @override
  ConsumerState<WorldListPage> createState() => _WorldListPageState();
}

class _WorldListPageState extends ConsumerState<WorldListPage> {
  String query = '';
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(leading: const BackHomeButton(), title: const Text('全部世界')),
    body: SafeArea(
      child: ContentFrame(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (v) => setState(() => query = v),
                decoration: const InputDecoration(
                  hintText: '搜索世界',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ref
                  .watch(worldsProvider)
                  .when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, _) => TextButton(
                      onPressed: () => ref.invalidate(worldsProvider),
                      child: const Text('重新加载'),
                    ),
                    data: (worlds) {
                      final matches = worlds
                          .where(
                            (w) =>
                                w.title.contains(query) ||
                                w.summary.contains(query),
                          )
                          .toList();
                      return ListView.builder(
                        itemCount: matches.length,
                        itemBuilder: (context, index) {
                          final w = matches[index];
                          return ListTile(
                            title: Text(w.title),
                            subtitle: Text(
                              w.summary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () => context.push('/play/${w.id}'),
                            trailing: IconButton(
                              tooltip: '世界设定',
                              icon: const Icon(Icons.more_horiz),
                              onPressed: () =>
                                  context.push('/definition/view/${w.id}'),
                            ),
                          );
                        },
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    ),
  );
}
