import '../../../shared/widgets/back_home_button.dart';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/content_frame.dart';
import '../../worlds/application/world_providers.dart';
import '../application/providers.dart';
import '../data/world_definition_repository.dart';
import '../domain/world_definition.dart';

class WorldDefinitionPage extends ConsumerStatefulWidget {
  const WorldDefinitionPage({super.key, required this.worldId});
  final String worldId;
  @override
  ConsumerState<WorldDefinitionPage> createState() =>
      _WorldDefinitionPageState();
}

class _WorldDefinitionPageState extends ConsumerState<WorldDefinitionPage> {
  late Future<DefinitionVersion?> future;
  bool busy = false;
  String? message;
  @override
  void initState() {
    super.initState();
    future = ref
        .read(worldDefinitionRepositoryProvider)
        .editable(widget.worldId);
  }

  Future<bool> confirm(String title, String text) async =>
      await showDialog<bool>(
        context: context,
        builder: (dialog) => AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialog, false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialog, true),
              child: const Text('确认'),
            ),
          ],
        ),
      ) ??
      false;
  Future<void> action(String kind, DefinitionVersion value) async {
    if (busy) return;
    final repo = ref.read(worldDefinitionRepositoryProvider);
    setState(() => busy = true);
    try {
      if (kind == 'copy') {
        if (!await confirm('复制世界设定？', '只复制设定，不复制历史对话与人物记忆；新世界会从初始场景开始。')) {
          return;
        }
        final copied = await repo.duplicate(value.definition);
        if (mounted) {
          ref.invalidate(worldsProvider);
          context.go('/play/${copied.definition.id}');
        }
      }
      if (kind == 'export') {
        if (!await confirm(
          '导出世界设定？',
          '导出包含你设置的人物私人秘密与关系，不包含 API Key、剧情历史或安全存储。请只分享给可信的人。',
        )) {
          return;
        }
        await Clipboard.setData(
          ClipboardData(text: WorldDefinitionExchange.encode(value.definition)),
        );
        if (mounted) {
          setState(
            () => message = '世界设定已复制。可通过手机聊天发送，再在鱼者的“导入世界设定”中粘贴，无需手动修改内容。',
          );
        }
      }
      if (kind == 'delete') {
        if (!await confirm(
          '删除这个世界？',
          '将删除此世界的设定版本、对话和人物记忆。原始导入历史保留但解除关联；其他世界和 API Key 不受影响。此操作不能撤销。',
        )) {
          return;
        }
        await repo.deleteWorld(widget.worldId);
        if (mounted) {
          ref.invalidate(worldsProvider);
          context.go('/');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(
          () => message = e is DefinitionFailure ? e.message : '操作失败，原有数据未修改。',
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> history() async {
    final repo = ref.read(worldDefinitionRepositoryProvider);
    final versions = await repo.versions(widget.worldId);
    if (!mounted) return;
    final selected = await showModalBottomSheet<DefinitionVersion>(
      context: context,
      builder: (sheet) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const ListTile(
              title: Text('设定版本记录'),
              subtitle: Text('恢复会追加新版本，不回退或改写剧情历史。'),
            ),
            for (final v in versions)
              ListTile(
                title: Text('版本 ${v.version} · ${v.definition.title}'),
                subtitle: Text(
                  v.definition.data['updatedAt']?.toString() ?? '',
                ),
                trailing: const Icon(Icons.restore),
                onTap: () => Navigator.pop(sheet, v),
              ),
          ],
        ),
      ),
    );
    if (selected == null || !mounted) return;
    if (!await confirm(
      '恢复此设定版本？',
      '会把版本 ${selected.version} 的设定保存为新版本，当前剧情仍使用绑定的版本。',
    )) {
      return;
    }
    try {
      final current = await repo.latest(widget.worldId);
      await repo.save(
        selected.definition,
        expectedVersion: current?.version ?? 0,
      );
      if (mounted) setState(() => future = repo.editable(widget.worldId));
    } catch (_) {
      if (mounted) setState(() => message = '版本恢复未完成，请重新读取当前设定后重试。');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const BackHomeButton(),
      title: const Text('世界设定与版本'),
    ),
    body: ContentFrame(
      child: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('读取失败，请返回重试。'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final v = snapshot.data;
          if (v == null) return const Center(child: Text('世界不存在。'));
          final d = v.definition;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                d.title.isEmpty ? '未命名世界' : d.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text('设定版本 ${v.version} · 设定与剧情分别保存'),
              const Text('修改不会自动套用到已开始的故事。若要体验新设定，请复制为新世界。'),
              const SizedBox(height: 16),
              Text(d.text('description') ?? '背景未设定'),
              Text('时代：${d.text('era') ?? '未设定'}'),
              Text('历法：${d.text('calendarSystem') ?? '未设定'}'),
              Text('初始时间：${d.text('worldDateTime') ?? '未设定'}'),
              Text('初始地点：${d.text('startingLocation') ?? '未设定'}'),
              Text(
                '人物 ${d.characterProfiles.length} · 地点 ${d.entries('locationProfiles').length} · 规则 ${d.entries('worldRules').length}',
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: busy
                    ? null
                    : () => context.push('/definition/edit/${widget.worldId}'),
                child: const Text('编辑世界设定'),
              ),
              OutlinedButton(
                onPressed: busy ? null : () => action('copy', v),
                child: const Text('复制设定并进入新世界'),
              ),
              OutlinedButton(
                onPressed: busy ? null : () => action('export', v),
                child: const Text('导出世界设定'),
              ),
              TextButton(
                onPressed: busy ? null : history,
                child: const Text('查看 / 恢复设定版本'),
              ),
              TextButton(
                onPressed: busy ? null : () => action('delete', v),
                child: const Text('删除世界'),
              ),
              if (message != null) Text(message!),
            ],
          );
        },
      ),
    ),
  );
}
