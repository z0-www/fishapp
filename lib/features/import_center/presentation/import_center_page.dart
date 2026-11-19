import '../../world_backup/presentation/backup_pages.dart';
import '../../../shared/widgets/back_home_button.dart';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/content_frame.dart';
import '../application/import_providers.dart';
import '../domain/import_models.dart';

class ImportCenterPage extends ConsumerStatefulWidget {
  const ImportCenterPage({super.key});
  @override
  ConsumerState<ImportCenterPage> createState() => _ImportCenterPageState();
}

class _ImportCenterPageState extends ConsumerState<ImportCenterPage> {
  final input = TextEditingController();
  bool busy = false;
  String? error;
  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  Future<void> stage() async {
    if (input.text.trim().isEmpty) {
      setState(() => error = '请先粘贴文本或分享链接。');
      return;
    }
    setState(() => busy = true);
    try {
      final repo = ref.read(pendingShareRepositoryProvider);
      final id = await repo.receive(
        IncomingShare(
          id: 'paste-${DateTime.now().microsecondsSinceEpoch}',
          source: ImportSource.paste,
          receivedAt: DateTime.now(),
          text: input.text,
        ),
      );
      if (!mounted) return;
      input.clear();
      ref.invalidate(pendingImportsProvider);
      final job = await repo.get(id);
      if (mounted) {
        context.push(
          job?.state == 'saved'
              ? '/imports/result/$id'
              : '/imports/preview/$id',
        );
      }
    } catch (_) {
      if (mounted) setState(() => error = '暂存失败，请检查空间和内容大小后重试。');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> pick() async {
    setState(() => busy = true);
    try {
      await ref.read(fileAccessProvider).pickFiles();
      if (mounted) ref.read(shareIntakeProvider).refresh();
    } catch (_) {
      if (mounted) setState(() => error = '无法读取文件，请在手机上重新选择较小文件。');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const BackHomeButton(),
      title: const Text('对话迁移中心'),
    ),
    body: SafeArea(
      child: ContentFrame(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('把熟悉的故事带过来', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            const Text(
              '在其他应用选择“分享 → 鱼者文游”，或粘贴文本、选择文件。先预览，确认后才保存；不会自动调用 AI。',
              style: TextStyle(height: 1.7),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: busy ? null : pick,
              icon: const Icon(Icons.folder_open),
              label: const Text('从手机选择文件'),
            ),
            const SizedBox(height: 20),
            TextField(
              key: const Key('import-text'),
              controller: input,
              minLines: 3,
              maxLines: 6,
              maxLength: 50000,
              decoration: const InputDecoration(labelText: '粘贴对话或分享链接'),
            ),
            TextButton.icon(
              onPressed: busy
                  ? null
                  : () async {
                      try {
                        final data = await Clipboard.getData(
                          Clipboard.kTextPlain,
                        );
                        if (mounted) input.text = data?.text ?? '';
                      } catch (_) {
                        if (mounted) setState(() => error = '剪贴板暂时不可用，请手动粘贴。');
                      }
                    },
              icon: const Icon(Icons.content_paste),
              label: const Text('粘贴'),
            ),
            FilledButton(
              onPressed: busy ? null : stage,
              child: const Text('暂存并预览'),
            ),
            if (error != null) Text(error!),
            if (ref.watch(intakeIssueProvider) != null)
              Text(ref.watch(intakeIssueProvider)!),
            TextButton(
              onPressed: () => ref.read(shareIntakeProvider).refresh(),
              child: const Text('检查系统分享暂存区'),
            ),
            const SizedBox(height: 24),
            Text('待处理', style: Theme.of(context).textTheme.titleMedium),
            ref
                .watch(pendingImportsProvider)
                .when(
                  loading: () => const LinearProgressIndicator(),
                  error: (_, _) => const Text('暂存记录读取失败，请稍后重试。'),
                  data: (jobs) => jobs.isEmpty
                      ? const Text('没有待处理分享。')
                      : Column(
                          children: jobs
                              .map(
                                (job) => ListTile(
                                  title: Text(
                                    job.share.text.isEmpty
                                        ? '分享文件（${job.share.files.length}）'
                                        : job.share.text,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    '${job.share.source.name == "picker"
                                        ? "手机文件"
                                        : job.share.source.name == "paste"
                                        ? "复制粘贴"
                                        : "系统分享"} · ${job.state == "cancelled" ? "已取消，可重试" : "待预览"}',
                                  ),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () => context.push(
                                    job.share.files.any(
                                          (file) =>
                                              isStoryBackupName(file.name),
                                        )
                                        ? '/backup/restore/${job.id}'
                                        : '/imports/preview/${job.id}',
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                ),
            const SizedBox(height: 24),
            Text('已保存的历史', style: Theme.of(context).textTheme.titleMedium),
            ref
                .watch(importHistoryProvider)
                .when(
                  loading: () => const LinearProgressIndicator(),
                  error: (_, _) => const Text('历史记录暂时不可用。'),
                  data: (rows) => rows.isEmpty
                      ? const Text('确认导入后会显示在这里。')
                      : Column(
                          children: rows
                              .map(
                                (r) => ListTile(
                                  title: Text(r.title),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () => context.push(
                                    '/imports/result/${r.jobId}',
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                ),
          ],
        ),
      ),
    ),
  );
}
