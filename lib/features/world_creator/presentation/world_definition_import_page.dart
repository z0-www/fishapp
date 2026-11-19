import '../../../shared/widgets/back_home_button.dart';

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/content_frame.dart';
import '../../import_center/application/import_providers.dart';
import '../../worlds/application/world_providers.dart';
import '../application/providers.dart';
import '../domain/world_definition.dart';

class WorldDefinitionImportPage extends ConsumerStatefulWidget {
  const WorldDefinitionImportPage({super.key, this.jobId});
  final String? jobId;
  @override
  ConsumerState<WorldDefinitionImportPage> createState() =>
      _WorldDefinitionImportPageState();
}

class _WorldDefinitionImportPageState
    extends ConsumerState<WorldDefinitionImportPage> {
  WorldDefinition? preview;
  String? error;
  bool busy = false;
  @override
  void initState() {
    super.initState();
    if (widget.jobId != null) readJob();
  }

  Future<void> readJob() async {
    try {
      final job = await ref
          .read(pendingShareRepositoryProvider)
          .get(widget.jobId!);
      if (job?.state == 'saved') {
        throw const DefinitionFailure('这份分享已经导入，请在首页查看。');
      }
      if (job == null) throw const DefinitionFailure('暂存记录不存在。');
      String text = job.share.text;
      if (text.isEmpty) {
        if (job.share.files.length != 1) {
          throw const DefinitionFailure('请一次选择一个世界设定文件。');
        }
        final file = File(job.share.files.single.path);
        if (await file.length() > 512 * 1024) {
          throw const DefinitionFailure('设定文件过大。');
        }
        text = await file.readAsString();
      }
      final d = WorldDefinitionExchange.decode(text);
      if (mounted) setState(() => preview = d);
    } catch (e) {
      if (mounted) {
        setState(
          () => error = e is DefinitionFailure ? e.message : '无法读取设定文件。',
        );
      }
    }
  }

  Future<void> paste() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      final d = WorldDefinitionExchange.decode(data?.text ?? '');
      if (mounted) {
        setState(() {
          preview = d;
          error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(
          () => error = e is DefinitionFailure ? e.message : '剪贴板暂时不可用。',
        );
      }
    }
  }

  Future<void> pick() async {
    try {
      await ref.read(fileAccessProvider).pickFiles();
      if (mounted) ref.read(shareIntakeProvider).refresh();
    } catch (_) {
      if (mounted) setState(() => error = '请在手机上选择之前导出的设定文件。');
    }
  }

  Future<void> import() async {
    if (preview == null || busy) return;
    setState(() => busy = true);
    try {
      final d = preview!.copy();
      d.data['id'] = 'world-${DateTime.now().microsecondsSinceEpoch}';
      d.data['createdAt'] = null;
      d.data['updatedAt'] = null;
      final saved = await ref
          .read(worldDefinitionRepositoryProvider)
          .importDefinition(d, jobId: widget.jobId);

      if (mounted) {
        ref.invalidate(worldsProvider);
        ref.invalidate(pendingImportsProvider);
        context.go('/play/${saved.definition.id}');
      }
    } catch (e) {
      if (mounted) {
        setState(
          () => error = e is DefinitionFailure ? e.message : '导入未完成，原有世界不受影响。',
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const BackHomeButton(),
      title: const Text('导入世界设定'),
    ),
    body: SafeArea(
      child: ContentFrame(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text('选择之前导出的设定文件，或粘贴他人分享的鱼者世界设定。无需解压或手动修改内容。'),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: busy ? null : paste,
              child: const Text('粘贴世界设定'),
            ),
            OutlinedButton(
              onPressed: busy ? null : pick,
              child: const Text('从手机选择设定文件'),
            ),
            if (preview != null) ...[
              const SizedBox(height: 20),
              Text(
                preview!.title.isEmpty ? '未命名世界' : preview!.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(preview!.text('description') ?? '背景未设定'),
              Text(
                '人物 ${preview!.characterProfiles.length} · 地点 ${preview!.entries('locationProfiles').length} · 规则 ${preview!.entries('worldRules').length}',
              ),
              const Text('将保存为新世界，不覆盖任何已有世界，也不包含原设备的剧情历史。'),
              FilledButton(
                onPressed: busy ? null : import,
                child: const Text('确认导入为新世界'),
              ),
            ],
            if (error != null) Text(error!),
          ],
        ),
      ),
    ),
  );
}
