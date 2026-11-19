import '../../wallet/application/wallet_controller.dart';
import '../../wallet/application/wallet_limits.dart';
import '../../../shared/widgets/back_home_button.dart';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../shared/widgets/content_frame.dart';
import '../../worlds/application/world_providers.dart';
import '../../world_creator/presentation/editors.dart';
import '../../roleplay/domain/models.dart';
import '../../import_center/data/pending_share_repository.dart';
import '../../ai/application/ai_providers.dart';
import '../../usage/usage_repository.dart';
import '../application/story_world_engine.dart';
import '../data/story_repository.dart';
import '../domain/story_models.dart';

class WorldRecoveryPreviewPage extends ConsumerStatefulWidget {
  const WorldRecoveryPreviewPage({super.key, required this.conversationId});
  final String conversationId;
  @override
  ConsumerState<WorldRecoveryPreviewPage> createState() =>
      _WorldRecoveryPreviewPageState();
}

class _WorldRecoveryPreviewPageState
    extends ConsumerState<WorldRecoveryPreviewPage> {
  late AppDatabase db;
  late ConversationToWorldEngine pipeline;
  List<ImportedMessageRow> messages = [], branch = [];
  WorldDraft? draft;
  String? node, error;
  String title = '恢复的故事', progress = '';
  bool loading = true, busy = false;
  CancelToken? cancellation;
  String get draftId => 'recovery-${widget.conversationId}-$node';
  @override
  void initState() {
    super.initState();
    db = ref.read(databaseProvider);
    pipeline = ConversationToWorldEngine(
      ref.read(deepSeekConfigProvider),
      ref.read(apiKeyStorageProvider),
      ref.read(usageRepositoryProvider),
    );
    load();
  }

  @override
  void dispose() {
    cancellation?.cancel();
    super.dispose();
  }

  Future<void> load() async {
    try {
      final repo = PendingShareRepository(db);
      messages = await repo.messages(widget.conversationId);
      final c = await (db.select(
        db.importedConversations,
      )..where((t) => t.id.equals(widget.conversationId))).getSingle();
      title = c.title;
      node = c.currentMessageId ?? messages.lastOrNull?.messageId;
      if (node == null) throw const RoleplayFailure('档案没有可恢复的正文。');
      if (messages.length == 1 &&
          Uri.tryParse(messages.single.body.trim())?.hasAbsolutePath == true &&
          messages.single.body.trim().startsWith('http')) {
        throw const RoleplayFailure('尚未取得完整聊天内容。请导入正文或 DeepSeek ZIP。');
      }
      await selectNode(node!);
    } catch (_) {
      error = '尚未取得完整聊天内容，或原始消息树不可读。请返回检查档案。';
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> selectNode(String value) async {
    if (busy) return;
    node = value;
    branch = await ConversationImportService(db)
        .branch(widget.conversationId, value);
    draft =
        await WorldDraftRepository(db).load(draftId) ??
        WorldDraft({
          'id': draftId,
          'conversationId': widget.conversationId,
          'nodeId': value,
          'title': title,
          'facts': [],
        });
    if (mounted) setState(() {});
  }

  Future<void> rename() async {
    final value = await editFreeFields(
      context,
      title: '恢复后的世界名称',
      fields: const {'name': '世界名称'},
      initial: {'name': draft?.data['title'] ?? title},
    );
    if (value == null || !mounted || draft == null) return;
    setState(() {
      title = value['name'] as String? ?? title;
      draft!.data['title'] = title;
    });
    await persist();
  }

  Future<void> persist() async {
    if (draft == null) return;
    try {
      await WorldDraftRepository(db).save(draft!);
    } catch (_) {
      if (mounted) setState(() => error = '审核草稿未保存，请移除凭据或精简内容后重试。');
    }
  }

  Future<void> extract() async {
    if (busy || node == null) return;
    try {
      final plan = pipeline.prepare(
        widget.conversationId,
        node!,
        title,
        branch,
      );
      final model = ref.read(deepSeekConfigProvider).model;
      final wallet = ref.read(walletGuardProvider);
      final quote = await wallet.quote(
        model,
        plan.inputEstimate,
        plan.outputLimit,
      );
      if (!mounted) return;
      if (quote.blocked) throw WalletRequestBlocked(quote.notice!);
      final yes = await showDialog<bool>(
        context: context,
        builder: (dialog) => AlertDialog(
          title: const Text('整理前确认范围与预算'),
          content: SingleChildScrollView(
            child: Text(
              '处理此分支从开头到选定节点的 ${branch.length} 条消息；不发送附件、其他分支或设备密钥。\n分 ${plan.chunks.length} 段处理，最多 ${plan.chunks.length} 次请求，无隐藏合并请求。\n输入保守估算 ${plan.inputEstimate} Token；输出总上限 ${plan.outputLimit} Token。\n预计费用（非严格上限） ${quote.estimated?.toStringAsFixed(6) ?? '未知'} 美元，实际按服务商计费。${quote.notice ?? ''}\n不会覆盖当前审核草稿或正式世界，完成后可选择替换草稿。',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialog, false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialog, true),
              child: const Text('确认整理'),
            ),
          ],
        ),
      );
      if (yes != true || !mounted) return;
      setState(() => busy = true);
      cancellation = CancelToken();
      final result = await wallet.dispatch(
        model,
        plan.inputEstimate,
        plan.outputLimit,
        () => pipeline.convert(
          plan,
          branch,
          confirmed: true,
          cancellation: cancellation,
          checkSegment: (tokens) async {
            final current = await wallet.quote(model, tokens, 1600);
            if (current.blocked) throw WalletRequestBlocked(current.notice!);
            if (current.day != quote.day ||
                current.version != quote.version ||
                current.spending.unknown > quote.spending.unknown) {
              throw const WalletRequestBlocked('计费状态已变化，已暂停后续整理。请重新确认费用。');
            }
          },
          progress: (n, total) {
            if (mounted) setState(() => progress = '已处理 $n / $total 段');
          },
        ),
        approval: quote,
      );
      if (!mounted) return;
      final replace =
          draft!.facts.isEmpty ||
          await showDialog<bool>(
                context: context,
                builder: (dialog) => AlertDialog(
                  title: const Text('替换审核草稿？'),
                  content: const Text('原始档案与正式世界不变；本次结果会替换尚未提交的审核项。'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialog, false),
                      child: const Text('保留原草稿'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(dialog, true),
                      child: const Text('使用本次建议'),
                    ),
                  ],
                ),
              ) ==
              true;
      if (replace && mounted) {
        result.data['id'] = draftId;
        setState(() => draft = result);
        await persist();
      }
    } catch (e) {
      if (mounted) {
        setState(
          () => error = e is WalletRequestBlocked
              ? e.message
              : e is RoleplayFailure
              ? e.message
              : '整理失败，原草稿与档案保留。',
        );
      }
    } finally {
      cancellation = null;
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> editFact(int? index) async {
    final facts = draft!.facts;
    final old = index == null ? null : facts[index];
    final sources = old?['sourceMessageIds'] as List? ?? [node!];
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => _FactEditor(
        initial: old,
        sources: sources.cast<String>(),
        npcs: facts.where((f) => f['category'] == 'npc').toList(),
      ),
    );
    if (result == null || !mounted) return;
    result['id'] ??= 'fact-user-${DateTime.now().microsecondsSinceEpoch}';
    if (index == null) {
      facts.add(result);
    } else {
      facts[index] = result;
    }
    setState(() => draft!.data['facts'] = facts);
    await persist();
  }

  Future<void> reviewStyle() async {
    if (draft == null) return;
    draft!.data['styleDNA'] ??= StyleDNAExtractor().extract(branch);
    final style = draft!.data['styleDNA'] as Map;
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('保留原文叙事节奏？'),
        content: Text(
          '统计范围：当前选定分支。平均段落长度 ${style['averageParagraphCharacters']} 字。\n${style['guidance']}\n仅应用节奏建议，不自动确认人物情感、秘密或事件。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('不应用'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text('确认应用节奏'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    setState(() => draft!.data['styleConfirmed'] = yes == true);
    await persist();
  }

  Future<void> recover() async {
    if (busy || draft == null) return;
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('从这里继续游玩？'),
        content: Text('将从节点 $node 创建独立世界，原始故事和其他世界保留。此操作无需 AI。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text('确认创建独立世界'),
          ),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    setState(() => busy = true);
    try {
      final id = await WorldRecoveryService(db)
          .recover(draft!, confirmed: true);
      if (mounted) {
        ref.invalidate(worldsProvider);
        context.go('/play/$id');
      }
    } catch (e) {
      if (mounted) {
        setState(
          () => error = e is RoleplayFailure ? e.message : '恢复失败，旧存档保持不变。',
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  void source(Map<String, dynamic> f) {
    final ids = (f['sourceMessageIds'] as List).toSet();
    showDialog<void>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('原文出处（只读）'),
        content: SingleChildScrollView(
          child: Text(
            branch
                .where((m) => ids.contains(m.messageId))
                .map((m) => '${m.role} · ${m.messageId}\n${m.body}')
                .join('\n\n'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const BackHomeButton(),
      title: const Text('旧故事恢复预览'),
    ),
    body: SafeArea(
      child: ContentFrame(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    draft?.data['title'] as String? ?? title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  if (draft != null)
                    TextButton(
                      onPressed: busy ? null : rename,
                      child: const Text('修改世界名称'),
                    ),
                  const Text('原始档案只读保存。可离线选择剧情节点、手动审核设定并恢复世界。'),
                  const SizedBox(height: 20),
                  if (node != null)
                    DropdownButtonFormField<String>(
                      initialValue: node,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: '从哪个消息节点继续'),
                      items: messages
                          .map(
                            (m) => DropdownMenuItem(
                              value: m.messageId,
                              child: Text(
                                '消息 ${messages.indexOf(m) + 1} · ${m.role == 'user'
                                    ? '玩家'
                                    : m.role == 'assistant'
                                    ? '角色'
                                    : '原文'} · ${m.body}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: busy ? null : (v) => selectNode(v!),
                    ),
                  Text(
                    '当前分支 ${branch.length} 条消息 · ${draft?.facts.where((f) => f['category'] == 'npc').length ?? 0} 个人物候选',
                  ),
                  if (branch.isNotEmpty)
                    ExpansionTile(
                      title: const Text('当前剧情节点与原始时间线'),
                      children: [
                        for (final m
                            in branch.reversed.take(20).toList().reversed)
                          ListTile(
                            title: Text(
                              '消息 ${messages.indexOf(m) + 1} · ${m.role == 'user'
                                  ? '玩家'
                                  : m.role == 'assistant'
                                  ? '角色'
                                  : '原文'}',
                            ),
                            subtitle: Text(m.body),
                          ),
                      ],
                    ),
                  if (draft != null) ...[
                    const SizedBox(height: 16),
                    ExpansionTile(
                      title: const Text('人物、关系与恢复设置'),
                      tilePadding: EdgeInsets.zero,
                      children: [
                        OutlinedButton(
                          onPressed:
                              busy ||
                                  ref.watch(aiActionUnavailableProvider) != null
                              ? null
                              : extract,
                          child: Text('AI 智能整理 · 先确认预算'),
                        ),
                        TextButton(
                          onPressed: busy ? null : reviewStyle,
                          child: const Text('原文风格与节奏（可选）'),
                        ),
                        TextButton(
                          onPressed: busy ? null : () => editFact(null),
                          child: const Text('手动添加已核实设定'),
                        ),
                        const Text('审核项默认不应用。推测、传闻、角色原话与客观事实分别保存；秘密默认不公开。'),
                        for (final e in draft!.facts.indexed)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              children: [
                                CheckboxListTile(
                                  value: e.$2['accepted'] == true,
                                  onChanged: busy
                                      ? null
                                      : (v) async {
                                          if (v == true &&
                                              e.$2['kind'] != 'fact' &&
                                              e.$2['kind'] != 'utterance') {
                                            await editFact(e.$1);
                                            return;
                                          }
                                          final facts = draft!.facts;
                                          facts[e.$1]['accepted'] = v;
                                          setState(
                                            () => draft!.data['facts'] = facts,
                                          );
                                          await persist();
                                        },
                                  title: Text(
                                    '${WorldDraft.labels[e.$2['category']]} · ${e.$2['text']}',
                                  ),
                                  subtitle: Text(
                                    '${WorldDraft.kindLabels[e.$2['kind']]} · 提取置信度 ${e.$2['confidence']}（不等于真实概率）',
                                  ),
                                ),
                                Wrap(
                                  children: [
                                    TextButton(
                                      onPressed: () => source(e.$2),
                                      child: const Text('查看出处'),
                                    ),
                                    TextButton(
                                      onPressed: busy
                                          ? null
                                          : () => editFact(e.$1),
                                      child: const Text('编辑与核实'),
                                    ),
                                    TextButton(
                                      onPressed: busy
                                          ? null
                                          : () async {
                                              final facts = draft!.facts
                                                ..removeAt(e.$1);
                                              setState(
                                                () => draft!.data['facts'] =
                                                    facts,
                                              );
                                              await persist();
                                            },
                                      child: const Text('移除建议'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    if (WorldRecoveryService.storyExcerpt(branch)
                        case final excerpt when excerpt.isNotEmpty)
                      ExpansionTile(
                        title: const Text('用近期对话接续故事'),
                        subtitle: const Text('可选 · 仅在确认后续生成费用时发送'),
                        children: [
                          for (final message in excerpt)
                            ListTile(title: Text(message['text']!)),
                          SwitchListTile(
                            title: const Text('允许使用以上摘录作为故事背景'),
                            value: draft!.data['includeSourceExcerpt'] == true,
                            onChanged: busy
                                ? null
                                : (value) => setState(
                                    () => draft!.data['includeSourceExcerpt'] =
                                        value,
                                  ),
                          ),
                        ],
                      ),
                    FilledButton(
                      onPressed: busy ? null : recover,
                      child: const Text('从这里继续游玩'),
                    ),
                  ],
                  if (busy) ...[
                    Text(progress),
                    TextButton(
                      onPressed: () => cancellation?.cancel(),
                      child: const Text('停止整理'),
                    ),
                  ],
                  if (error != null) Text(error!),
                ],
              ),
      ),
    ),
  );
}

class _FactEditor extends StatefulWidget {
  const _FactEditor({this.initial, required this.sources, required this.npcs});
  final Map<String, dynamic>? initial;
  final List<String> sources;
  final List<Map<String, dynamic>> npcs;
  @override
  State<_FactEditor> createState() => _FactEditorState();
}

class _FactEditorState extends State<_FactEditor> {
  late TextEditingController text;
  late String category, kind;
  late bool public;
  late Set<String> owners;
  Map<String, dynamic>? profile;
  @override
  void initState() {
    super.initState();
    text = TextEditingController(
      text: widget.initial?['text'] as String? ?? '',
    );
    category = widget.initial?['category'] as String? ?? 'unknown';
    kind = widget.initial?['kind'] as String? ?? 'unconfirmed';
    public = widget.initial?['visibility'] == 'public';
    owners = (widget.initial?['owners'] as List? ?? []).cast<String>().toSet();
    profile = widget.initial?['profile'] is Map
        ? Map<String, dynamic>.from(widget.initial!['profile'] as Map)
        : null;
  }

  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('审核并编辑这条设定'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            initialValue: category,
            items: WorldDraft.categories
                .map(
                  (c) => DropdownMenuItem(
                    value: c,
                    child: Text(WorldDraft.labels[c]!),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => category = v!),
          ),
          TextField(
            controller: text,
            minLines: 2,
            maxLines: 6,
            maxLength: 6000,
            decoration: const InputDecoration(labelText: '设定内容（人物项填写姓名）'),
          ),
          DropdownButtonFormField<String>(
            initialValue: kind,
            items: const [
              DropdownMenuItem(value: 'fact', child: Text('我已核实为事实')),
              DropdownMenuItem(value: 'utterance', child: Text('仅为人物原话')),
              DropdownMenuItem(value: 'inference', child: Text('推测')),
              DropdownMenuItem(value: 'rumor', child: Text('传闻')),
              DropdownMenuItem(value: 'unconfirmed', child: Text('尚未确认')),
              DropdownMenuItem(value: 'conflict', child: Text('存在冲突')),
            ],
            onChanged: (v) => setState(() => kind = v!),
          ),
          CheckboxListTile(
            value: public && category != 'secret',
            onChanged: category == 'secret'
                ? null
                : (v) => setState(() => public = v!),
            title: const Text('允许作为公开背景进入上下文'),
          ),
          if (category == 'secret')
            const Text('秘密不会进入公开背景。请指定已知情人物，否则不向任何 NPC 提供。'),
          for (final npc in widget.npcs)
            CheckboxListTile(
              value: owners.contains(npc['id']),
              onChanged: (v) => setState(() {
                if (v == true) {
                  owners.add(npc['id'] as String);
                } else {
                  owners.remove(npc['id']);
                }
              }),
              title: Text('知情人物：${npc['text']}'),
            ),
          if (category == 'npc')
            TextButton(
              onPressed: () async {
                final c = await CharacterEditor.open(
                  context,
                  character: CharacterProfile({
                    ...?profile,
                    'id': widget.initial?['id'] ?? 'draft-npc',
                    'name': text.text,
                  }),
                );
                if (c != null && mounted) {
                  setState(() {
                    profile = c.toJson();
                    text.text = c.name;
                  });
                }
              },
              child: const Text('编辑人物档案、风格与示例台词'),
            ),
          const Text('保存后仍可撤销勾选；原文不会被修改。'),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('取消'),
      ),
      FilledButton(
        onPressed: () {
          if (text.text.trim().isEmpty) return;
          Navigator.pop(context, {
            ...?widget.initial,
            'category': category,
            'kind': kind,
            'text': text.text.trim(),
            'confidence': widget.initial?['confidence'] ?? 1,
            'sourceMessageIds': widget.sources,
            'visibility': category == 'secret'
                ? 'private'
                : public
                ? 'public'
                : 'private',
            'owners': owners.toList(),
            'accepted': ['fact', 'utterance'].contains(kind),
            if (profile != null) 'profile': profile,
          });
        },
        child: const Text('保存审核结果'),
      ),
    ],
  );
}
