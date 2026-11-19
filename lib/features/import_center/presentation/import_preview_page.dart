import 'dart:async';

import '../../world_creator/data/world_definition_repository.dart';
import '../data/quick_import.dart';
import '../../world_creator/application/definition_intake.dart';

import 'package:material_ui/material_ui.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/conversation_parsers.dart';

import '../data/deepseek_share_import_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/content_frame.dart';
import '../../worlds/application/world_providers.dart';
import '../application/import_providers.dart';
import '../domain/import_models.dart';
import 'import_progress_page.dart';

class ImportPreviewPage extends ConsumerStatefulWidget {
  const ImportPreviewPage({super.key, required this.id});
  final String id;
  @override
  ConsumerState<ImportPreviewPage> createState() => _ImportPreviewPageState();
}

class _ImportPreviewPageState extends ConsumerState<ImportPreviewPage> {
  ConversationDraft? draft;
  ImportJob? job;
  String? error, worldId, selectedNode;
  String titleFilter = '';
  bool includeExcerpt = false;
  bool loading = true, saving = false;
  double progress = 0;
  ImportCancellation cancellation = ImportCancellation();
  int attempt = 0;
  CancelToken? download;
  bool fetching = false, checkingPublicConsent = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    cancellation.cancel();
    download?.cancel();
    attempt++;
    super.dispose();
  }

  Future<void> load() async {
    final ticket = ++attempt;
    cancellation.cancel();
    final token = ImportCancellation();
    cancellation = token;
    if (mounted) {
      setState(() {
        loading = true;
        error = null;
        progress = 0;
      });
    }
    final repo = ref.read(pendingShareRepositoryProvider);
    final parser = ref.read(importParserProvider);
    try {
      final incoming = await repo.get(widget.id);
      if (incoming == null) throw const ImportFailure('暂存记录不存在。');
      if (incoming.state == 'saved') {
        if (mounted) context.replace('/imports/result/${widget.id}');
        return;
      }
      if (await isWorldDefinitionShare(incoming.share)) {
        if (mounted) context.replace('/definition/import/${widget.id}');
        return;
      }
      token.check();
      await repo.mark(widget.id, 'processing');
      final parsed = await parser.parse(incoming.share, token, (p) {
        if (mounted && attempt == ticket) setState(() => progress = p);
      });
      token.check();
      await repo.mark(widget.id, 'preview');
      if (mounted && attempt == ticket) {
        setState(() {
          job = incoming;
          draft = parsed;
          selectedNode = parsed.currentMessageId;
          loading = false;
        });
        if (parsed.sourceUrl case final String url
            when !parsed.canSave && DeepSeekShareImportService.accepts(url)) {
          unawaited(readPublicShare(url, automatic: true));
        }
      }
    } on ImportCancelled {
      if (attempt == ticket) {
        await repo.mark(widget.id, 'cancelled');
        if (mounted) {
          setState(() {
            loading = false;
            error = '已取消，暂存内容仍在本机，可以重试。';
          });
        }
      }
    } catch (e) {
      if (attempt == ticket) {
        final message = e is ImportFailure
            ? e.message
            : '内容无法解析，请检查文件格式、编码或重新分享。';
        await repo.mark(widget.id, 'failed', error: message);
        if (mounted) {
          setState(() {
            loading = false;
            error = message;
          });
        }
      }
    } finally {
      if (mounted) ref.invalidate(pendingImportsProvider);
    }
  }

  Future<void> pasteConversation() async {
    try {
      final payload = await Clipboard.getData(Clipboard.kTextPlain);
      final text = payload?.text ?? '';
      if (!mounted) return;
      if (text.trim().isEmpty || DeepSeekShareParser().linkIn(text) != null) {
        setState(() => error = '请先复制对话正文，再返回粘贴。剪贴板里的链接不能恢复成世界。');
        return;
      }
      final id = await ref
          .read(pendingShareRepositoryProvider)
          .receive(
            IncomingShare(
              id: 'paste-${DateTime.now().microsecondsSinceEpoch}',
              source: ImportSource.paste,
              receivedAt: DateTime.now(),
              text: text,
            ),
          );
      if (!mounted) return;
      ref.invalidate(pendingImportsProvider);
      if (id != widget.id) context.push('/imports/preview/$id');
    } catch (_) {
      if (mounted) setState(() => error = '暂时无法读取或保存剪贴板，请从迁移中心手动粘贴。');
    }
  }

  Future<void> openSharePage(String link) async {
    if (!DeepSeekShareImportService.accepts(link)) return;
    try {
      if (await launchUrl(
        Uri.parse(link),
        mode: LaunchMode.externalApplication,
      )) {
        return;
      }
    } catch (_) {}
    if (mounted) setState(() => error = '无法打开分享页，请在 DeepSeek 中复制对话正文。');
  }

  Future<void> readPublicShare(String link, {bool automatic = false}) async {
    if (checkingPublicConsent) return;
    checkingPublicConsent = true;
    try {
      await _readPublicShare(link, automatic: automatic);
    } finally {
      checkingPublicConsent = false;
    }
  }

  Future<void> _readPublicShare(String link, {required bool automatic}) async {
    if (fetching ||
        job == null ||
        !ref.read(deepSeekShareImportProvider).accessPermitted) {
      return;
    }
    final preferences = WorldDefinitionRepository(ref.read(databaseProvider));
    var optedIn = false;
    try {
      optedIn =
          (await preferences.draft('public-share-read-v1'))?['enabled'] == true;
    } catch (_) {}
    if (!mounted || fetching) return;
    if (!optedIn) {
      if (automatic) return;
      final yes = await showDialog<bool>(
        context: context,
        builder: (dialog) => AlertDialog(
          title: const Text('开启公开分享读取？'),
          content: const Text(
            '持有链接的人可能查看该分享。鱼者只读取这份公开快照，不登录、不下载附件。请确认已取得分享者同意。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialog, false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialog, true),
              child: const Text('同意并读取'),
            ),
          ],
        ),
      );
      if (yes != true || !mounted || fetching) return;
      try {
        await preferences.saveDraft('public-share-read-v1', {'enabled': true});
      } catch (_) {}
    }
    if (!mounted || fetching) return;
    setState(() {
      fetching = true;
      error = null;
    });
    download = CancelToken();
    try {
      final parsed = await ref
          .read(deepSeekShareImportProvider)
          .fetch(link, confirmed: true, cancellation: download);
      if (!mounted) return;
      setState(() {
        draft = parsed;
        selectedNode = parsed.currentMessageId;
      });
    } catch (e) {
      if (mounted) {
        setState(() => error = e is ImportFailure ? e.message : '读取失败，原有档案保留。');
      }
    } finally {
      if (mounted) setState(() => fetching = false);
    }
  }

  Future<void> save({
    bool createWorld = false,
    bool linkExisting = false,
    bool review = false,
  }) async {
    if (saving || fetching || draft == null || !draft!.canSave) return;
    if (linkExisting && worldId == null) {
      setState(() => error = '请先选择已有世界。');
      return;
    }
    setState(() => saving = true);
    try {
      final repo = ref.read(pendingShareRepositoryProvider);
      if (createWorld && !review) {
        final id = await QuickImport(repo).restore(
          widget.id,
          draft!,
          selectedNode: selectedNode,
          includeExcerpt: includeExcerpt,
        );
        if (!mounted) return;
        ref.invalidate(pendingImportsProvider);
        ref.invalidate(importHistoryProvider);
        ref.invalidate(worldsProvider);
        context.replace('/play/$id');
        return;
      }
      final result = await repo.save(
        widget.id,
        draft!,
        linkExisting
            ? ImportDestination.existingWorld
            : ImportDestination.history,
        worldId: worldId,
        selectedNode: selectedNode,
      );
      if (!mounted) return;
      ref.invalidate(pendingImportsProvider);
      ref.invalidate(importHistoryProvider);
      ref.invalidate(worldsProvider);
      if (worldId != null) ref.invalidate(worldImportHistoryProvider(worldId!));
      context.replace(
        createWorld
            ? '/story/recover/${result.conversationId}'
            : '/imports/result/${widget.id}',
      );
    } catch (e) {
      if (mounted) {
        setState(
          () => error = e is ImportFailure ? e.message : '导入失败，暂存与原有世界仍保留，请重试。',
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  Future<void> selectArchive(ArchiveSession session) async {
    final incoming = job;
    if (incoming == null || saving) return;
    setState(() => saving = true);
    try {
      final id = await ref
          .read(pendingShareRepositoryProvider)
          .selectSession(incoming, session);
      if (!mounted) return;
      ref.invalidate(pendingImportsProvider);
      await context.push('/imports/preview/$id');
    } catch (_) {
      if (mounted) setState(() => error = '无法选择这段会话，请重新选择导出文件。');
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  Future<void> discard() async {
    try {
      await ref.read(pendingShareRepositoryProvider).discard(widget.id);
      if (!mounted) return;
      ref.invalidate(pendingImportsProvider);
      context.go('/imports');
    } catch (_) {
      if (mounted) setState(() => error = '未能清理本机暂存，可稍后重试。');
    }
  }

  static String excerpt(String value) =>
      String.fromCharCodes(value.runes.take(240));

  @override
  Widget build(BuildContext context) => PopScope<Object?>(
    onPopInvokedWithResult: (didPop, _) {
      if (didPop && !saving) unawaited(pauseCurrent());
    },
    child: buildPreview(context),
  );

  Future<void> pauseCurrent() async {
    try {
      final repo = ref.read(pendingShareRepositoryProvider);
      await repo.pause(widget.id);
      if (mounted) ref.invalidate(pendingImportsProvider);
    } catch (_) {
      // Navigation remains usable while storage is unavailable.
    }
  }

  Future<void> leavePreview({bool toCenter = false}) async {
    cancellation.cancel();
    download?.cancel();
    attempt++;
    await pauseCurrent();
    if (!mounted) return;
    if (toCenter) {
      context.go('/imports');
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  Widget buildPreview(BuildContext context) {
    if (loading) {
      return ImportProgressPage(
        progress: progress,
        onCancel: () => cancellation.cancel(),
      );
    }
    if (draft == null || error != null && job == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: '返回',
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: saving ? null : leavePreview,
          ),
          title: const Text('导入对话'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(error ?? '暂时无法识别内容'),
              TextButton(onPressed: load, child: const Text('重试')),
              TextButton(
                onPressed: () => leavePreview(toCenter: true),
                child: const Text('返回迁移中心'),
              ),
            ],
          ),
        ),
      );
    }
    final d = draft!;
    if (d.archiveSessions.isNotEmpty) {
      final needle = titleFilter.trim().toLowerCase();
      final choices = d.archiveSessions
          .where((s) => s.title.toLowerCase().contains(needle))
          .toList();
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: '返回',
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: saving ? null : leavePreview,
          ),
          title: const Text('选择单个会话'),
        ),
        body: SafeArea(
          child: ContentFrame(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: (value) => setState(() => titleFilter = value),
                    decoration: const InputDecoration(labelText: '按会话标题搜索'),
                  ),
                ),
                if (error != null) Text(error!),
                if (choices.isEmpty) const Text('没有匹配的会话。'),
                Expanded(
                  child: ListView.builder(
                    itemCount: choices.length,
                    itemBuilder: (context, index) {
                      final entry = choices[index];
                      return ListTile(
                        title: Text(entry.title),
                        subtitle: Text('索引标注 ${entry.messageCount} 条消息'),
                        onTap: saving ? null : () => selectArchive(entry),
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
    final users = d.messages.where((m) => m.role == 'user').length;
    final ai = d.messages.where((m) => m.role == 'assistant').length;
    final incomplete = d.sourceUrl != null && !d.canSave;
    final link = d.sourceUrl;
    final shareLink = link != null && DeepSeekShareImportService.accepts(link)
        ? link
        : null;
    final branch = d.canSave
        ? QuickImport.branch(d, selectedNode)
        : const <ImportedMessage>[];
    final readable = branch.where(QuickImport.readable).toList();
    final facts = QuickImport.candidates(branch);
    final parents = d.messages.map((message) => message.parentId).toSet();
    final leaves = d.messages
        .where((message) => !parents.contains(message.id))
        .toList();
    final options = <ImportedMessage>[
      ...leaves.take(100),
      if (selectedNode != null &&
          !leaves.take(100).any((m) => m.id == selectedNode))
        ...d.messages.where((m) => m.id == selectedNode),
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: '返回',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: saving ? null : leavePreview,
        ),
        title: const Text('导入对话'),
      ),
      body: SafeArea(
        child: ContentFrame(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(d.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(
                incomplete
                    ? '只收到分享链接，尚无对话正文'
                    : d.canSave
                    ? '已接收 ${d.messages.length} 条消息 · 用户 $users · AI $ai'
                    : '文件已暂存，尚未识别格式',
                style: const TextStyle(fontSize: 13, color: Color(0xFF858A93)),
              ),
              if (incomplete)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text('尚未取得对话正文。持有公开链接的人可能查看该分享。可复制正文或导入文件。'),
                ),
              if (incomplete) ...[
                FilledButton.icon(
                  onPressed: fetching ? null : pasteConversation,
                  icon: const Icon(Icons.content_paste),
                  label: const Text('粘贴对话正文'),
                ),
                if (shareLink != null)
                  TextButton(
                    onPressed: () => openSharePage(shareLink),
                    child: const Text('打开 DeepSeek 分享页'),
                  ),
              ],
              if (shareLink != null && incomplete) ...[
                if (ref.watch(deepSeekShareImportProvider).accessPermitted)
                  TextButton(
                    onPressed: fetching
                        ? null
                        : () => readPublicShare(shareLink),
                    child: const Text('读取公开分享内容'),
                  )
                else
                  const Text('当前版本未开放接口直读。请从官方分享页复制正文，或导入 TXT、JSON、官方 ZIP。'),
                if (fetching)
                  TextButton(
                    onPressed: () => download?.cancel(),
                    child: const Text('停止读取'),
                  ),
              ],
              if (d.warnings.any((w) => w.contains('不完整导入')))
                const Text('部分对话快照（不完整导入）'),
              if (job?.share.archiveSession != null) const Text('官方导出中的所选会话'),
              if (d.canSave &&
                  d.sourceUrl == null &&
                  job?.share.archiveSession == null)
                const Text('已收到所分享的正文，完整性无法独立确认。'),
              if (d.nodeUncertain) const Text('分享未指明所选回复。请核对续写节点。'),
              if (d.canSave && (leaves.length > 1 || d.nodeUncertain))
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedNode,
                    decoration: const InputDecoration(labelText: '选择续写分支'),
                    isExpanded: true,
                    items: [
                      for (final node in options)
                        DropdownMenuItem(
                          value: node.id,
                          child: Text(
                            node.content.isEmpty
                                ? '消息 ${node.id}'
                                : String.fromCharCodes(
                                    node.content.runes.take(38),
                                  ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: saving
                        ? null
                        : (value) => setState(() => selectedNode = value),
                  ),
                ),
              if (readable.isNotEmpty) ...[
                const SizedBox(height: 18),
                const Text('第一条消息'),
                SelectableText(excerpt(readable.first.content)),
                const SizedBox(height: 12),
                const Text('最后一条消息'),
                SelectableText(excerpt(readable.last.content)),
                const SizedBox(height: 12),
                Text(
                  '可恢复资料 ${facts.length} 项 · 人物 ${facts.where((f) => f['category'] == 'npc').length} 项',
                ),
                for (final fact in facts.take(5))
                  Text(
                    '${fact['accepted'] == true ? '玩家明确设定' : '待核对'} · ${fact['text']}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('后续续写可使用所选分支的近期原文'),
                  subtitle: const Text('本次导入在本机完成。之后的 AI 请求仍按消费计划执行。'),
                  value: includeExcerpt,
                  onChanged: saving
                      ? null
                      : (value) =>
                            setState(() => includeExcerpt = value == true),
                ),
              ],
              ExpansionTile(
                title: const Text('识别详情与更多选项'),
                tilePadding: EdgeInsets.zero,
                children: [
                  for (final warning in d.warnings)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        warning,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  Text(
                    '分支：${d.branches ?? '未识别'} · 附件 ${d.attachments.length}',
                  ),
                  for (final a in d.attachments)
                    ListTile(
                      leading: const Icon(Icons.attach_file),
                      title: Text(a.name),
                      subtitle: Text('${a.size} 字节 · 仅保存在本机'),
                    ),
                  if (readable.isNotEmpty)
                    TextButton(
                      onPressed: saving
                          ? null
                          : () => save(createWorld: true, review: true),
                      child: const Text('先审核人物与恢复'),
                    ),
                  if (d.canSave) ...[
                    ref
                        .watch(worldsProvider)
                        .when(
                          loading: () => const SizedBox.shrink(),
                          error: (_, _) => const Text('世界列表暂时无法读取'),
                          data: (worlds) => worlds.isEmpty
                              ? const SizedBox.shrink()
                              : DropdownButtonFormField<String>(
                                  initialValue: worldId,
                                  decoration: const InputDecoration(
                                    labelText: '关联已有世界（可选）',
                                  ),
                                  items: worlds
                                      .map(
                                        (w) => DropdownMenuItem(
                                          value: w.id,
                                          child: Text(
                                            w.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: saving
                                      ? null
                                      : (v) => setState(() => worldId = v),
                                ),
                        ),
                    if (worldId != null)
                      TextButton(
                        onPressed: saving
                            ? null
                            : () => save(linkExisting: true),
                        child: const Text('保存并关联这个世界'),
                      ),
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      '原始内容只读保存。模型生成的设定候选可在恢复审核中核对。AI 整理需确认预算。',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              if (error != null) Text(error!),
              if (!d.canSave)
                TextButton(
                  onPressed: () => leavePreview(toCenter: true),
                  child: const Text('粘贴链接或选择文件'),
                ),
              if (job?.share.files.isEmpty == true && !fetching && !saving)
                TextButton(onPressed: discard, child: const Text('放弃此分享')),
            ],
          ),
        ),
      ),
      bottomNavigationBar: d.canSave
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: saving ? null : () => save(),
                        child: const Text('仅保存历史'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: saving || readable.isEmpty
                            ? null
                            : () => save(createWorld: true),
                        child: Text(saving ? '正在保存…' : '导入并继续故事'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
