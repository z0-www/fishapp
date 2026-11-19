import '../../wallet/application/wallet_controller.dart';
import '../../wallet/application/wallet_limits.dart';
import '../../wallet/presentation/floating_wallet_ball.dart';
import '../../world_backup/presentation/backup_pages.dart';

import 'dart:async';

import '../../../shared/widgets/chat_composer.dart';
import '../../../shared/widgets/turn_budget_sheet.dart';
import '../../../shared/data/text_draft_store.dart';
import '../../story_world/data/story_repository.dart';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../shared/widgets/content_frame.dart';
import '../../ai/application/ai_providers.dart';
import '../../ai/data/deepseek_error_handler.dart';
import '../../ai/presentation/api_key_reminder.dart';
import '../../usage/usage_repository.dart';
import '../data/content_trace_repository.dart';
import '../../worlds/application/world_providers.dart';
import '../application/providers.dart';
import '../application/narrative_settings.dart';
import '../domain/models.dart';
import '../domain/narrative_preferences.dart';
import '../../story_world/application/context_engine.dart';
import '../../world_creator/application/providers.dart';

class RoleplayPage extends ConsumerStatefulWidget {
  const RoleplayPage({super.key, required this.worldId, this.initialAction});
  final String worldId;
  final String? initialAction;
  @override
  ConsumerState<RoleplayPage> createState() => _RoleplayPageState();
}

class _RoleplayPageState extends ConsumerState<RoleplayPage>
    with WidgetsBindingObserver {
  final scroll = ScrollController();
  late TextDraftStore draftStore;
  Timer? draftTimer;
  Future<void> draftWrites = Future.value();
  bool draftLoaded = false;
  final input = TextEditingController();
  WorldState? state;
  List<RoleplayTurn> rows = [];
  String title = '鱼者文游';
  String? speaker, error;
  bool definitionChanged = false;
  bool loading = true, busy = false, initializing = false;
  TurnCancellation? cancellation;
  bool generating = false;
  bool upcomingNearBudget = false;
  bool _showJump = false;
  Map<String, dynamic> _sessionNarration = {};
  @override
  void initState() {
    super.initState();
    draftStore = ref.read(textDraftStoreProvider);
    input.addListener(draftChanged);
    scroll.addListener(_onScroll);
    WidgetsBinding.instance.addObserver(this);
    load();
  }

  @override
  void dispose() {
    cancellation?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    draftTimer?.cancel();
    saveInput();
    input.removeListener(draftChanged);
    scroll.dispose();
    input.clear();
    input.dispose();
    super.dispose();
  }

  Future<void> load() async {
    final repo = ref.read(roleplayRepositoryProvider);
    try {
      final worlds = await ref.read(repositoryProvider).load();
      final found = worlds.where((w) => w.id == widget.worldId);
      if (found.isNotEmpty) title = found.first.title;
      WorldState s;
      final definition = await ref
          .read(worldDefinitionRepositoryProvider)
          .latest(widget.worldId);
      try {
        s = await repo.load(widget.worldId);
      } on RoleplayFailure {
        if (definition == null) rethrow;
        s = await repo.initialize(widget.worldId);
      }
      definitionChanged =
          definition != null &&
          definition.version != s.data['definitionVersion'];
      await ref.read(interruptedTurnRecoveryProvider.future);
      if (!mounted) return;
      final history = await repo.history(widget.worldId);
      final firstLoad = state == null;
      await restoreInput();
      if (mounted) {
        setState(() {
          state = s;
          rows = history.reversed.toList();
          speaker =
              speaker == 'narrator' ||
                  s.presentCharacters.any((c) => c.id == speaker)
              ? speaker
              : s.presentCharacters.firstOrNull?.id;
        });
      }
      scrollToEnd(force: firstLoad);
    } catch (_) {
      if (mounted) setState(() => error = '此世界尚未配置演绎场景，或存档暂时不可读。已有世界资料不会删除。');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> initialize() async {
    setState(() => initializing = true);
    try {
      await ref.read(roleplayRepositoryProvider).initialize(widget.worldId);
      await load();
      if (mounted) setState(() => error = null);
    } catch (_) {
      if (mounted) setState(() => error = '初始化失败，请重试；原有资料未修改。');
    } finally {
      if (mounted) setState(() => initializing = false);
    }
  }

  Future<void> send({String? destination, String? actionOverride}) async {
    if (busy || state == null) return;
    draftTimer?.cancel();
    saveInput();
    final unavailable = ref.read(aiActionUnavailableProvider);
    if (unavailable != null) {
      setState(
        () => error = unavailable == missingDeepSeekKeyMessage
            ? null
            : unavailable,
      );
      return;
    }
    final action =
        actionOverride ??
        (destination == null ? input.text : '我明确选择前往$destination。');
    setState(() {
      busy = true;
      error = null;
    });
    final token = TurnCancellation();
    cancellation = token;
    try {
      final core = ref.read(fishRoleplayCoreProvider);
      final plan = await core.prepare(
        widget.worldId,
        action,
        addressed: speaker,
        destination: destination,
        sessionNarration: _sessionNarration,
      );
      if (!mounted) return;
      final model = ref.read(deepSeekConfigProvider).model;
      final wallet = ref.read(walletGuardProvider);
      final quote = await wallet.quote(
        model,
        plan.tokens,
        plan.maxOutputTokens,
      );
      if (!mounted) return;
      final planned = quote.estimated;
      final daily = quote.plan.daily;
      if (planned != null && daily != null) {
        setState(
          () => upcomingNearBudget = quote.spending.usd + planned >= daily * .8,
        );
      }
      if (quote.blocked) throw WalletRequestBlocked(quote.notice!);
      final automatic = quote.automaticAllowed;
      if (!automatic) {
        final monthlyNotice = quote.estimated == null
            ? null
            : await UsageTracker(ref.read(databaseProvider))
                  .notice(upcoming: quote.estimated!);
        if (!mounted) return;
        FocusScope.of(context).unfocus();
        final yes = await showTurnBudget(
          context,
          plan,
          model: model,
          estimatedUsd: quote.estimated,
          notice: [quote.notice, monthlyNotice].whereType<String>().join('\n'),
        );
        if (yes != true || !mounted) return;
      }
      await wallet.dispatch(
        model,
        plan.tokens,
        plan.maxOutputTokens,
        () {
          token.check();
          if (mounted) setState(() => generating = true);
          return core.execute(plan, token, confirmed: true);
        },
        approval: quote,
        automatic: automatic,
      );
      if (mounted) {
        ref.read(apiDiagnosticsProvider.notifier).connected();
        if (actionOverride == null && destination == null) {
          draftTimer?.cancel();
          await draftWrites;
          if (!mounted) return;
          try {
            await draftStore.clear('play-${widget.worldId}');
          } catch (_) {
            if (mounted) setState(() => error = '回复已保存，旧草稿暂无法清除。');
          }
          if (!mounted) return;
          input.clear();
        }
        ref.invalidate(contentTracesProvider);
        final followReply =
            scroll.hasClients && scroll.position.extentAfter < 100;
        await load();
        if (followReply) scrollToEnd(force: true);
      }
    } catch (e) {
      if (mounted) {
        final message = e is WalletRequestBlocked
            ? e.message
            : e is RoleplayFailure
            ? e.message
            : '生成失败，未提交本轮世界变化。网络请求可能已产生费用，重试将重新确认。';
        setState(() => error = message);
        if (e is! WalletRequestBlocked &&
            ref.read(deepSeekConfigProvider).permitsDirectCalls &&
            !message.contains('已停止生成')) {
          if (e is RoleplayFailure) {
            ref
                .read(apiDiagnosticsProvider.notifier)
                .requestFailedMessage(message);
          } else {
            ref.read(apiDiagnosticsProvider.notifier).requestFailed(e);
          }
        }
      }
    } finally {
      if (mounted) {
        ref.invalidate(usageProvider);
        ref.invalidate(usageMetricsProvider);
        ref.invalidate(contentTracesProvider);
        setState(() {
          busy = false;
          generating = false;
          upcomingNearBudget = false;
        });
      }
      cancellation = null;
    }
  }

  Future<void> recover() async {
    if (busy) return;
    await ref
        .read(roleplayRepositoryProvider)
        .recoverInterrupted(widget.worldId);
    if (mounted) setState(() => error = '未完成回合已标记中断，不会自动重发；请重新输入并确认预算。');
  }

  void archive() {
    final s = state!;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheet) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              '世界档案与当前人物',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('时间 ${s.displayTime}；地点 ${s.displayLocation}'),
            for (final c in s.characters)
              ListTile(
                title: Text('${c.name} · ${c.occupation}'),
                subtitle: Text(
                  '${c.currentLocation} · ${c.data['currentActivity'] ?? '活动未设定'}\n${c.list('personalityTraits').join('、')} · ${c.list('speechExamples').firstOrNull ?? '台词未设定'}',
                ),
              ),
            Text('已知物品：${(s.data['knownItems'] as Map).keys.join('、')}'),
            Text('线索：${(s.data['activePlotThreads'] as List).join('、')}'),
            const Text('私人知识不在档案中展示；原始消息与 NPC 个人记忆独立保存。'),
          ],
        ),
      ),
    );
  }

  Future<void> chooseSpeaker() async {
    final s = state!;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const ListTile(title: Text('这次想和谁交谈？')),
            ListTile(
              title: const Text('旁白'),
              selected: speaker == 'narrator',
              onTap: () {
                setState(() => speaker = 'narrator');
                Navigator.pop(sheet);
              },
            ),
            for (final c in s.presentCharacters)
              ListTile(
                title: Text(c.name),
                subtitle: Text(c.occupation),
                selected: speaker == c.id,
                onTap: () {
                  setState(() => speaker = c.id);
                  Navigator.pop(sheet);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> locations() async {
    final s = state!;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              title: Text(s.displayLocation),
              subtitle: Text(s.displayTime),
            ),
            for (final place in s.knownLocations[s.playerLocation] ?? [])
              ListTile(
                title: Text(place),
                trailing: const Icon(Icons.arrow_forward_rounded),
                onTap: () {
                  Navigator.pop(sheet);
                  send(destination: place);
                },
              ),
            if ((s.knownLocations[s.playerLocation] ?? []).isEmpty)
              const ListTile(title: Text('尚未设定可直接前往的地点。')),
          ],
        ),
      ),
    );
  }

  Future<void> regenerate() async {
    if (busy || rows.isEmpty || ref.read(aiActionUnavailableProvider) != null) {
      return;
    }
    final last = rows.last;
    final repo = RecoveryCoordinator(ref.read(databaseProvider));
    final nodes = await repo.checkpoints(widget.worldId);
    final node = nodes
        .where((c) => c.state.revision == last.baseRevision)
        .firstOrNull;
    if (!mounted) return;
    if (node == null) {
      setState(() => error = '这段旧回复没有对应的历史节点，可以继续当前故事，或在剧情节点中创建分支。');
      return;
    }
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('在新分支中重新生成？'),
        content: const Text('原回复与后续剧情都会保留。新分支使用原行动，并在生成前再次确认预算。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text('创建分支'),
          ),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    try {
      final id = await repo.fork(node.id, confirmed: true);
      if (mounted) {
        ref.invalidate(worldsProvider);
        context.go('/play/$id?retry=${Uri.encodeComponent(last.action)}');
      }
    } catch (_) {
      if (mounted) setState(() => error = '分支创建失败，原回复未修改。');
    }
  }

  Future<void> more(String value) async {
    if (busy) return;
    switch (value) {
      case 'world':
        await _moreOptions('世界与人物', const {
          'definition': '世界设定',
          'characters': '当前人物',
          'locations': '地点',
        });
      case 'story':
        await _moreOptions('剧情与记忆', const {
          'tools': '时间线、记忆与历史节点',
          'history': '阅读历史',
          'recover': '恢复中断回合',
          '/feedback': '意见反馈',
        });
      case 'definition':
        context.push('/definition/view/${widget.worldId}');
      case 'characters':
        archive();
      case 'locations':
        await locations();
      case 'tools':
        context.push('/story/tools/${widget.worldId}');
      case 'history':
        context.push('/history/${widget.worldId}');
      case 'recover':
        await recover();
      case 'backup':
        await showStoryBackup(context, widget.worldId);
      case 'narration':
        await _showNarration();
      default:
        context.push(value);
    }
  }

  Future<void> _moreOptions(String title, Map<String, String> entries) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text(title, style: Theme.of(sheet).textTheme.titleMedium),
            ),
            for (final entry in entries.entries)
              ListTile(
                title: Text(entry.value),
                onTap: () => Navigator.pop(sheet, entry.key),
              ),
          ],
        ),
      ),
    );
    if (selected != null && mounted) await more(selected);
  }

  Future<void> _showNarration() async {
    final global = await ref
        .read(globalNarrativePreferencesProvider.future)
        .catchError((Object _) => <String, dynamic>{});
    if (!mounted) return;
    final definition = await ref
        .read(worldDefinitionRepositoryProvider)
        .latest(widget.worldId)
        .catchError((Object _) => null);
    if (!mounted) return;
    final world =
        (definition?.definition.data ??
                state?.data['definitionSnapshot']
                    as Map?)?['narrativePreferences']
            as Map?;
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheet) => StatefulBuilder(
        builder: (sheet, updateSheet) {
          final value = NarrativePreferences.resolve([
            global,
            world ?? {},
            _sessionNarration,
          ]);
          void change(String key, Object field) => updateSheet(
            () => _sessionNarration = {..._sessionNarration, key: field},
          );
          return SafeArea(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              children: [
                Text('本次聊天的叙事偏好', style: Theme.of(sheet).textTheme.titleLarge),
                const Text('从下一轮生效'),
                const SizedBox(height: 12),
                Text('目标字数 · ${value.targetWords} 字'),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final words in const [300, 800, 1500, 3000])
                      ChoiceChip(
                        label: Text('$words 字'),
                        selected: value.targetWords == words,
                        onSelected: (_) => change('targetWords', words),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('旁白人称'),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final item in NarrativePerspective.values)
                      ChoiceChip(
                        label: Text(item.label),
                        selected: value.perspective == item,
                        onSelected: (_) => change('pointOfView', item.name),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('叙事风格'),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final item in NarrativeStyle.values)
                      ChoiceChip(
                        label: Text(item.label),
                        selected: value.style == item,
                        onSelected: (_) => change('narrationStyle', item.name),
                      ),
                  ],
                ),
                if (_sessionNarration.isNotEmpty)
                  TextButton(
                    onPressed: () => updateSheet(() => _sessionNarration = {}),
                    child: const Text('恢复世界设置'),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(sheet);
                    context.push('/definition/edit/${widget.worldId}');
                  },
                  child: const Text('编辑世界的长期叙事偏好'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onScroll() {
    final show = scroll.hasClients && scroll.position.extentAfter >= 100;
    if (show != _showJump && mounted) setState(() => _showJump = show);
  }

  void scrollToEnd({bool force = false, int attempts = 8}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          scroll.hasClients &&
          scroll.position.extentAfter > 1 &&
          (force || scroll.position.extentAfter < 100)) {
        scroll.jumpTo(scroll.position.maxScrollExtent);
        if (force && attempts > 1) {
          // Variable-length lazy rows may change maxScrollExtent after a jump.
          scrollToEnd(force: true, attempts: attempts - 1);
        }
      }
      if (mounted) _onScroll();
    });
  }

  void draftChanged() {
    draftTimer?.cancel();
    draftTimer = Timer(const Duration(milliseconds: 300), saveInput);
  }

  void saveInput() {
    final text = input.text;
    draftWrites = draftWrites
        .then((_) => draftStore.write('play-${widget.worldId}', text))
        .catchError((_) {
          if (mounted) setState(() => error = '输入草稿暂未保存，请稍后重试。');
        });
  }

  Future<void> restoreInput() async {
    if (draftLoaded) return;
    draftLoaded = true;
    try {
      final text =
          widget.initialAction ??
          await draftStore.read('play-${widget.worldId}');
      if (mounted && input.text.isEmpty && text != null) input.text = text;
    } catch (_) {}
    if (widget.initialAction != null && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) send();
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      cancellation?.cancel();
    }
  }

  @override
  void didChangeMetrics() {
    scrollToEnd();
  }

  @override
  Widget build(BuildContext context) {
    final aiUnavailable = ref.watch(aiActionUnavailableProvider);
    final s = state;
    return Scaffold(
      appBar: AppBar(
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        leading: IconButton(
          tooltip: '返回首页',
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          IconButton(
            tooltip: '快速调整叙事',
            onPressed: busy || s == null ? null : _showNarration,
            icon: const Icon(Icons.tune_rounded),
          ),
          PopupMenuButton<String>(
            tooltip: '世界更多操作',
            enabled: !busy,
            icon: const Icon(Icons.more_horiz),
            onSelected: more,
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'world', child: Text('世界与人物')),
              PopupMenuItem(value: 'story', child: Text('剧情与记忆')),
              PopupMenuItem(value: 'narration', child: Text('叙事偏好')),
              PopupMenuItem(value: 'backup', child: Text('故事备份')),
              PopupMenuItem(value: '/usage', child: Text('消费与用量')),
              PopupMenuItem(value: '/ai-settings', child: Text('AI 服务设置')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: ContentFrame(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : s == null
              ? ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    const Text('继续原有世界'),
                    const SizedBox(height: 12),
                    const Text('此旧世界尚未配置初始场景。原有世界与导入历史仍保留，也可以从世界设定中完善。'),
                    FilledButton(
                      onPressed: initializing ? null : initialize,
                      child: const Text('打开世界'),
                    ),
                    TextButton(
                      onPressed: () =>
                          context.push('/definition/edit/${widget.worldId}'),
                      child: const Text('自由编辑世界设定'),
                    ),
                    if (error != null) Text(error!),
                  ],
                )
              : Column(
                  children: [
                    if (definitionChanged)
                      TextButton(
                        onPressed: () =>
                            context.push('/definition/view/${widget.worldId}'),
                        child: const Text('设定有新版本，下一轮读取最新人物档案'),
                      ),
                    Expanded(
                      child: FloatingWalletBall(
                        generating: generating,
                        upcomingNearBudget: upcomingNearBudget,
                        child: ListView.builder(
                          key: const Key('story-scroll'),
                          controller: scroll,
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                          itemCount: rows.length + 1 + (busy ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (s.data['importedRecent'] is List)
                                    ExpansionTile(
                                      title: const Text('导入故事的最后片段'),
                                      children: [
                                        for (final raw
                                            in s.data['importedRecent'] as List)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: SelectableText(
                                              (raw as Map)['content']
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                height: 1.9,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  if (rows.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 24),
                                      child: SelectableText(
                                        s.data['openingScene'] as String? ??
                                            '故事从你的行动开始。',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          height: 1.9,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            }
                            if (index > rows.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  '正在续写…',
                                  style: TextStyle(color: Color(0xFF858A93)),
                                ),
                              );
                            }
                            final turn = rows[index - 1];
                            return Column(
                              key: ValueKey(turn.id),
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.sizeOf(context).width *
                                          .82,
                                    ),
                                    margin: const EdgeInsets.only(
                                      top: 24,
                                      bottom: 24,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF6F7F9),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: SelectableText(
                                      turn.action,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.65,
                                      ),
                                    ),
                                  ),
                                ),
                                ...responseWidgets(turn, s),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    if (_showJump)
                      TextButton.icon(
                        onPressed: () => scrollToEnd(force: true),
                        icon: const Icon(
                          Icons.arrow_downward_rounded,
                          size: 18,
                        ),
                        label: const Text('跳到最新剧情'),
                      ),
                    if (error != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 6,
                        ),
                        child: Text(
                          error!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF858A93),
                          ),
                        ),
                      ),
                    const ApiKeyReminder(),
                    ChatComposer(
                      controller: input,
                      inputKey: const Key('roleplay-input'),
                      hint: aiUnavailable == missingDeepSeekKeyMessage
                          ? '你想做什么……'
                          : aiUnavailable ?? '你想做什么……',
                      onSend:
                          aiUnavailable == null ||
                              aiUnavailable == missingDeepSeekKeyMessage
                          ? () => send()
                          : null,
                      busy: busy,
                      onStop: () => cancellation?.cancel(),
                      actions: [
                        if (s.presentCharacters.isNotEmpty)
                          ComposerAction(
                            '交谈对象',
                            Icons.person_outline,
                            chooseSpeaker,
                          ),
                        if (aiUnavailable == null)
                          ComposerAction(
                            '继续故事',
                            Icons.play_arrow_rounded,
                            () => send(actionOverride: '继续故事。'),
                          ),
                        if (aiUnavailable == null && rows.isNotEmpty)
                          ComposerAction(
                            '重新生成',
                            Icons.refresh_rounded,
                            regenerate,
                          ),
                        ComposerAction(
                          '阅读历史',
                          Icons.history_rounded,
                          () => context.push('/history/${widget.worldId}'),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  List<Widget> responseWidgets(RoleplayTurn turn, WorldState s) {
    final packet = DialoguePacket.parse(turn.responseJson!);
    return [
      if (packet.narration.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SelectableText(
            packet.narration,
            style: const TextStyle(
              fontSize: 16,
              height: 1.95,
              color: Color(0xFF202124),
            ),
          ),
        ),
      for (final r in packet.replies)
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.characters
                        .where((c) => c.id == r['speaker'])
                        .firstOrNull
                        ?.name ??
                    '人物',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF858A93),
                ),
              ),
              const SizedBox(height: 5),
              SelectableText(
                r['text'] as String,
                style: const TextStyle(fontSize: 16, height: 1.85),
              ),
            ],
          ),
        ),
      if (turn.mock)
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            '旧版离线记录',
            style: TextStyle(fontSize: 11, color: Color(0xFF858A93)),
          ),
        ),
    ];
  }
}
