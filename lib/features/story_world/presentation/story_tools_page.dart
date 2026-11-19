import '../../../shared/widgets/back_home_button.dart';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/content_frame.dart';
import '../../worlds/application/world_providers.dart';
import '../../roleplay/data/roleplay_repository.dart';
import '../../roleplay/domain/models.dart';
import '../data/story_repository.dart';
import '../domain/story_models.dart';
import '../application/context_engine.dart';

class StoryToolsPage extends ConsumerStatefulWidget {
  const StoryToolsPage({super.key, required this.worldId});
  final String worldId;
  @override
  ConsumerState<StoryToolsPage> createState() => _StoryToolsPageState();
}

class _StoryToolsPageState extends ConsumerState<StoryToolsPage> {
  WorldState? state;
  List<StoryCheckpoint> checkpoints = [];
  List<PersonalMemory> memories = [];
  List<Map<String, dynamic>> timeline = [];
  String? error, owner;
  bool busy = false;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final db = ref.read(databaseProvider);
      state = await RoleplayRepository(db).load(widget.worldId);
      memories = await RoleplayRepository(db).memories(widget.worldId);
      checkpoints = await RecoveryCoordinator(db).checkpoints(widget.worldId);
      timeline = await EventTimeline(db).entries(widget.worldId);
      owner ??= state!.characters.firstOrNull?.id ?? 'narrator';
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted) setState(() => error = '世界资料读取失败，请返回重试。');
    }
  }

  Future<bool> confirm(String title, String text) async =>
      await showDialog<bool>(
        context: context,
        builder: (dialog) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: Text(text)),
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
  Future<void> run(Future<void> Function() action) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await action();
      await load();
    } catch (e) {
      if (mounted) {
        setState(
          () => error = e is RoleplayFailure ? e.message : '操作未完成，原存档保留。',
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> compact() async {
    final compressor = ContextCompressor(ref.read(databaseProvider));
    final preview = await compressor.preview(widget.worldId, owner!);
    if (!mounted) return;
    final yes = await confirm(
      '整理记忆前后对比',
      '本地增量索引：不请求 AI，不删除原始历史，不改写记忆原文。\n新增 ${preview['newEntries']} 项；原始元数据估算 ${preview['beforeEstimate']}，索引估算 ${preview['afterEstimate']} Token。估算可能更大，不承诺节省。\n仅检索当前人物的相关条目，不每轮重压缩。\n${((preview['candidate'] as Map)['entries'] as List).map((e) => (e as Map)['text']).join('\n')}',
    );
    if (yes) await compressor.commit(preview, confirmed: true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const BackHomeButton(),
      title: const Text('世界记忆与剧情节点'),
    ),
    body: SafeArea(
      child: ContentFrame(
        child: state == null
            ? Center(child: Text(error ?? '正在读取…'))
            : ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text('${state!.displayTime} · ${state!.displayLocation}'),
                  const Text('辅助操作保留原世界。恢复旧节点会创建独立分支，不覆盖原存档。'),
                  OutlinedButton(
                    onPressed: busy
                        ? null
                        : () => run(() async {
                            final id = await ConversationImportService(
                              ref.read(databaseProvider),
                            ).fromWorld(widget.worldId);
                            if (context.mounted) {
                              context.push('/story/recover/$id');
                            }
                          }),
                    child: const Text('把现有对话转换为新世界'),
                  ),
                  ExpansionTile(
                    title: Text('查看世界记忆（${memories.length}）'),
                    children: [
                      for (final m in memories)
                        ListTile(
                          title: Text(m.text),
                          subtitle: Text(
                            '${m.owner} · ${m.source} · 回合 ${m.turn}',
                          ),
                        ),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('剧情时间线与已核实设定'),
                    children: [
                      for (final f in timeline)
                        ListTile(
                          title: Text(f['text']?.toString() ?? ''),
                          subtitle: Text(
                            '${f['kind']} · 出处 ${(f['sourceMessageIds'] as List? ?? []).join('、')}',
                          ),
                        ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text('剧情节点（${checkpoints.length}）'),
                    children: [
                      for (final c in checkpoints)
                        ListTile(
                          title: Text(
                            '回合 ${c.state.revision} · ${c.state.displayLocation}',
                          ),
                          subtitle: Text(c.state.displayTime),
                          trailing: const Icon(Icons.call_split),
                          onTap: busy
                              ? null
                              : () => run(() async {
                                  if (!await confirm(
                                    '从此节点创建新分支？',
                                    '复制该时刻的状态、历史与个人记忆，原世界及之后的剧情继续保留。',
                                  )) {
                                    return;
                                  }
                                  final id = await RecoveryCoordinator(
                                    ref.read(databaseProvider),
                                  ).fork(c.id, confirmed: true);
                                  if (context.mounted) {
                                    ref.invalidate(worldsProvider);
                                    context.go('/play/$id');
                                  }
                                }),
                        ),
                    ],
                  ),
                  OutlinedButton(
                    onPressed: busy
                        ? null
                        : () => run(() async {
                            await RecoveryCoordinator(
                              ref.read(databaseProvider),
                            ).checkpoint(widget.worldId);
                          }),
                    child: const Text('保存当前剧情节点'),
                  ),
                  const Divider(),
                  const Text('上下文用量与记忆整理'),
                  const Text(
                    '正常行动最多一次请求；近期原文最多三轮。世界规则与玩家身份优先保留，超出预算会停止而非删除关键事实。实际 Token、缓存与费用在本地费用统计中显示；无 usage 时保持未知。',
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: owner,
                    items: [
                      const DropdownMenuItem(
                        value: 'narrator',
                        child: Text('旁白'),
                      ),
                      for (final c in state!.characters)
                        DropdownMenuItem(value: c.id, child: Text(c.name)),
                    ],
                    onChanged: busy ? null : (v) => setState(() => owner = v),
                  ),
                  OutlinedButton(
                    onPressed: busy ? null : () => run(compact),
                    child: const Text('整理记忆 · 查看差异'),
                  ),
                  TextButton(
                    onPressed: () => context.push('/usage'),
                    child: const Text('查看真实用量和预算提醒'),
                  ),
                  if (busy) const LinearProgressIndicator(),
                  if (error != null) Text(error!),
                ],
              ),
      ),
    ),
  );
}
