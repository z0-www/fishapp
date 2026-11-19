import 'package:go_router/go_router.dart';

import '../../import_center/application/import_providers.dart';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/world_providers.dart';
import '../application/world_story_preview.dart';
import '../../../shared/widgets/content_frame.dart';

class WorldPage extends ConsumerWidget {
  const WorldPage({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('世界故事')),
    body: SafeArea(
      child: ContentFrame(
        child: ref
            .watch(worldsProvider)
            .when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Center(child: Text('读取失败，请返回首页重试')),
              data: (worlds) {
                final matches = worlds.where((w) => w.id == id);
                if (matches.isEmpty) {
                  return const Center(child: Text('这个世界不存在'));
                }
                final world = matches.first;
                return ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(
                      world.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Text(world.genre),
                    const SizedBox(height: 24),
                    _StoryPreview(worldId: id),
                    const SizedBox(height: 16),
                    WorldImportRecords(worldId: world.id),
                    OutlinedButton(
                      onPressed: () => context.push('/definition/view/$id'),
                      child: const Text('世界设定、复制与导出'),
                    ),
                    const SizedBox(height: 24),
                    if (world.summary.trim().isNotEmpty)
                      Text(world.summary, style: const TextStyle(height: 1.9)),
                  ],
                );
              },
            ),
      ),
    ),
  );
}

class _StoryPreview extends ConsumerWidget {
  const _StoryPreview({required this.worldId});
  final String worldId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final source = worldStoryPreviewProvider(worldId);
    return ref
        .watch(source)
        .when(
          loading: () => const LinearProgressIndicator(),
          error: (_, _) => TextButton(
            onPressed: () => ref.invalidate(source),
            child: const Text('剧情暂时无法读取，点击重试'),
          ),
          data: (story) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (story.hasStory) ...[
                Text('最近剧情', style: Theme.of(context).textTheme.titleMedium),
                Text('最近节点 · ${story.node}'),
                if (story.playedAt case final time?)
                  Text(
                    '最后游玩 · ${MaterialLocalizations.of(context).formatShortDate(time.toLocal())} '
                    '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(time.toLocal()))}',
                  ),
                if (story.excerpt case final excerpt?)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(excerpt, style: const TextStyle(height: 1.9)),
                  ),
              ] else
                const Text('还没有剧情记录。你可以从第一个行动开始。'),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () async {
                  await context.push('/play/$worldId');
                  if (context.mounted) ref.invalidate(source);
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: Text(story.hasStory ? '继续故事' : '开始故事'),
              ),
            ],
          ),
        );
  }
}

class WorldImportRecords extends ConsumerWidget {
  const WorldImportRecords({super.key, required this.worldId});
  final String worldId;
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(worldImportHistoryProvider(worldId))
      .when(
        loading: () => const SizedBox.shrink(),
        error: (_, _) => const Text('迁移记录暂时无法读取，可在迁移中心查看。'),
        data: (rows) => Column(
          children: rows
              .map(
                (r) => ListTile(
                  title: Text(r.title),
                  subtitle: const Text('已导入的原始记录'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/imports/result/${r.jobId}'),
                ),
              )
              .toList(),
        ),
      );
}
