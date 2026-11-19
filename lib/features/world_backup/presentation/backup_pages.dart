import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../shared/widgets/content_frame.dart';
import '../../import_center/application/import_providers.dart';
import '../../worlds/application/world_providers.dart';
import '../data/backup_format.dart';
import '../data/story_backup.dart';

const _channel = MethodChannel('fish/share_intake');
const _safeError = '无法处理归档，请检查文件、应用权限和剩余存储空间。';

final _storyBackupProvider = FutureProvider((ref) async {
  final db = ref.watch(databaseProvider);
  final support = await getApplicationSupportDirectory();
  return StoryBackup(
    db,
    Directory(p.join(support.path, 'story_backup_attachments')),
  );
});

class StoryBackupLibraryPage extends ConsumerWidget {
  const StoryBackupLibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('完整故事备份')),
    body: SafeArea(
      child: ContentFrame(
        child: ref
            .watch(worldsProvider)
            .when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(
                child: TextButton(
                  onPressed: () => ref.invalidate(worldsProvider),
                  child: const Text('无法读取世界，点击重试'),
                ),
              ),
              data: (worlds) => ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  ListTile(
                    title: const Text('从 .yuzhe 备份恢复'),
                    subtitle: const Text('在迁移中心选择本机文件'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/imports'),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      '换手机或安装不同签名的版本前，先把完整 .yuzhe 备份保存到应用以外的位置。卸载会清除本机存档。',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '选择要备份的世界',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (worlds.isEmpty) const Text('此设备还没有可备份的世界。'),
                  for (final world in worlds)
                    ListTile(
                      title: Text(world.title),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => showStoryBackup(context, world.id),
                    ),
                ],
              ),
            ),
      ),
    ),
  );
}

Future<void> showStoryBackup(BuildContext context, String worldId) async {
  final choice = await showDialog<bool>(
    context: context,
    builder: (dialog) => AlertDialog(
      title: const Text('世界备份'),
      content: const Text('完整故事备份包含对话、人物秘密、记忆和关联分支。你可以给文件设置密码。'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialog, false),
          child: const Text('仅导出世界设定'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialog, true),
          child: const Text('完整故事备份'),
        ),
      ],
    ),
  );
  if (!context.mounted) return;
  if (choice == false) {
    context.push('/definition/view/$worldId');
  } else if (choice == true) {
    await Navigator.of(context)
        .push<void>(MaterialPageRoute(builder: (_) => _ExportPage(worldId)));
  }
}

class _ExportPage extends ConsumerStatefulWidget {
  const _ExportPage(this.worldId);
  final String worldId;
  @override
  ConsumerState<_ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends ConsumerState<_ExportPage> {
  final password = TextEditingController();
  final confirm = TextEditingController();
  bool encrypted = false;
  bool busy = false;
  String? message;

  @override
  void dispose() {
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (encrypted &&
        (password.text.length < 8 || password.text != confirm.text)) {
      setState(() => message = '请输入至少 8 个字符，并确认两次密码一致。');
      return;
    }
    final secret = encrypted ? password.text : null;
    setState(() {
      busy = true;
      message = null;
    });
    Directory? session;
    try {
      final root = await getTemporaryDirectory();
      final staging = Directory(p.join(root.path, 'yuzhe_export'));
      await staging.create(recursive: true);
      session = await staging.createTemp('backup-');
      final file = File(p.join(session.path, '鱼者文游故事备份.yuzhe'));
      final repository = await ref.read(_storyBackupProvider.future);
      await repository.export(file, widget.worldId, password: secret);
      if (!mounted) return;
      final details = await repository.inspect(file, password: secret);
      if (!mounted) return;
      if (details.missingFiles > 0) {
        final proceed = await showDialog<bool>(
          context: context,
          builder: (dialog) => AlertDialog(
            title: const Text('部分附件无法备份'),
            content: Text('有 ${details.missingFiles} 个附件仅保留名称等元数据。要继续保存吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialog, false),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialog, true),
                child: const Text('继续保存'),
              ),
            ],
          ),
        );
        if (proceed != true || !mounted) return;
      }
      final saved = await _channel.invokeMethod<bool>('saveStoryBackup', {
        'path': file.path,
      });
      if (mounted) {
        setState(() => message = saved == true ? '完整故事备份已保存。' : '已取消保存。');
        if (saved == true) {
          password.clear();
          confirm.clear();
        }
      }
    } on BackupFailure catch (error) {
      if (mounted) setState(() => message = error.message);
    } catch (_) {
      if (mounted) setState(() => message = _safeError);
    } finally {
      if (session != null) {
        try {
          await session.delete(recursive: true);
        } on FileSystemException {
          // Export is temporary and scoped to this attempt.
        }
      }
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => _BackupLayout(
    title: '完整故事备份',
    children: [
      const Text('归档保存在你选择的位置。请妥善保管文件和密码。'),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('使用密码加密'),
        value: encrypted,
        onChanged: busy ? null : (value) => setState(() => encrypted = value),
      ),
      if (encrypted) ...[
        _password(password, '归档密码', busy),
        const SizedBox(height: 12),
        _password(confirm, '再次输入密码', busy),
        const SizedBox(height: 12),
      ],
      FilledButton(onPressed: busy ? null : save, child: const Text('选择保存位置')),
      if (busy) const LinearProgressIndicator(),
      if (message != null) Text(message!),
    ],
  );
}

class StoryBackupRestorePage extends ConsumerStatefulWidget {
  const StoryBackupRestorePage(this.jobId, {super.key});
  final String jobId;
  @override
  ConsumerState<StoryBackupRestorePage> createState() =>
      _StoryBackupRestoreState();
}

class _StoryBackupRestoreState extends ConsumerState<StoryBackupRestorePage> {
  final password = TextEditingController();
  File? file;
  BackupPreview? preview;
  bool encrypted = false;
  bool busy = true;
  String? message;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    password.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final job = await ref
          .read(pendingShareRepositoryProvider)
          .get(widget.jobId);
      final files = job?.share.files
          .where((entry) => isStoryBackupName(entry.name))
          .toList();
      if (files == null || files.length != 1) {
        throw const BackupFailure('请每次选择一个 .yuzhe 完整故事备份。');
      }
      final source = File(files.single.path);
      final locked = await StoryBackupFormat.isEncrypted(source);
      if (!mounted) return;
      setState(() {
        file = source;
        encrypted = locked;
        busy = false;
      });
      if (!locked) await _run(restore: false);
    } on BackupFailure catch (error) {
      if (mounted) {
        setState(() {
          busy = false;
          message = error.message;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          busy = false;
          message = _safeError;
        });
      }
    }
  }

  Future<void> _run({required bool restore}) async {
    final source = file;
    final review = preview;
    if (source == null || (restore && review == null)) return;
    final secret = encrypted ? password.text : null;
    setState(() {
      busy = true;
      message = null;
    });
    try {
      final repository = await ref.read(_storyBackupProvider.future);
      if (restore) {
        final id = await repository.restore(source, review!, password: secret);
        try {
          await ref
              .read(pendingShareRepositoryProvider)
              .mark(widget.jobId, 'saved');
        } catch (_) {
          // Duplicate protection still prevents replay after a handoff error.
        }
        if (!mounted) return;
        password.clear();
        ref.invalidate(worldsProvider);
        ref.invalidate(pendingImportsProvider);
        ref.invalidate(importHistoryProvider);
        context.go('/play/$id');
      } else {
        final summary = await repository.inspect(source, password: secret);
        if (mounted) setState(() => preview = summary);
      }
    } on BackupFailure catch (error) {
      if (mounted) setState(() => message = error.message);
    } catch (_) {
      if (mounted) setState(() => message = _safeError);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final review = preview;
    return _BackupLayout(
      title: '恢复故事备份',
      children: [
        if (encrypted && review == null) ...[
          _password(password, '归档密码', busy),
          FilledButton(
            onPressed: busy ? null : () => _run(restore: false),
            child: const Text('解锁并预览'),
          ),
        ],
        if (review != null) ...[
          Text(
            review.titles.take(8).join('、'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Text(
            '世界 ${review.titles.length} · 对话回合 ${review.counts['roleplay_turns'] ?? 0} · 导入消息 ${review.counts['imported_messages'] ?? 0}',
          ),
          Text(
            '记忆 ${review.counts['roleplay_memories'] ?? 0} · 分支 ${review.counts['story_branches'] ?? 0}',
          ),
          if (review.missingFiles > 0) Text('${review.missingFiles} 个附件只有元数据。'),
          const Text('恢复会创建独立世界，当前存档会保留。'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: busy ? null : () => _run(restore: true),
            child: const Text('确认恢复'),
          ),
        ],
        if (busy) const LinearProgressIndicator(),
        if (message != null) Text(message!),
      ],
    );
  }
}

bool isStoryBackupName(String filename) =>
    filename.toLowerCase().endsWith(StoryBackupFormat.extension);

Widget _password(TextEditingController controller, String label, bool busy) =>
    TextField(
      controller: controller,
      enabled: !busy,
      obscureText: true,
      autocorrect: false,
      enableSuggestions: false,
      maxLength: 256,
      decoration: InputDecoration(labelText: label),
    );

class _BackupLayout extends StatelessWidget {
  const _BackupLayout({required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: SafeArea(
      child: ContentFrame(
        child: ListView(padding: const EdgeInsets.all(24), children: children),
      ),
    ),
  );
}
