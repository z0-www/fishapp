import '../../../shared/widgets/back_home_button.dart';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../shared/widgets/content_frame.dart';
import '../../worlds/application/world_providers.dart';
import '../data/roleplay_repository.dart';
import '../domain/models.dart';

class ChatHistoryPage extends ConsumerStatefulWidget {
  const ChatHistoryPage({super.key, required this.worldId});
  final String worldId;
  @override
  ConsumerState<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends ConsumerState<ChatHistoryPage> {
  final rows = <RoleplayTurn>[];
  bool loading = false, more = true;
  WorldState? state;
  String? importJob, error;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    if (loading) return;
    setState(() => loading = true);
    try {
      final db = ref.read(databaseProvider);
      state ??= await RoleplayRepository(db).load(widget.worldId);
      final result =
          await (db.select(db.roleplayTurns)
                ..where(
                  (t) =>
                      t.worldId.equals(widget.worldId) &
                      t.state.equals('completed'),
                )
                ..orderBy([
                  (t) => OrderingTerm.desc(t.createdAt),
                  (t) => OrderingTerm.desc(t.id),
                ])
                ..limit(50, offset: rows.length))
              .get();
      final c = (state!.data['recovery'] as Map?)?['conversationId'];
      if (c is String) {
        importJob = (await (db.select(
          db.importedConversations,
        )..where((t) => t.id.equals(c))).getSingleOrNull())?.jobId;
      }
      if (mounted) {
        setState(() {
          rows.addAll(result);
          more = result.length == 50;
        });
      }
    } catch (_) {
      if (mounted) setState(() => error = '历史读取失败，原始记录仍保留。');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(leading: const BackHomeButton(), title: const Text('阅读历史')),
    body: SafeArea(
      child: ContentFrame(
        child: ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: rows.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '按最近回合排列。原始记录只读保存。',
                    style: TextStyle(fontSize: 13, color: Color(0xFF858A93)),
                  ),
                  if (importJob != null)
                    TextButton(
                      onPressed: () =>
                          context.push('/imports/result/$importJob'),
                      child: const Text('阅读导入前的完整故事'),
                    ),
                ],
              );
            }
            if (index == rows.length + 1) {
              return Column(
                children: [
                  if (loading) const CircularProgressIndicator(),
                  if (error != null) Text(error!),
                  if (more && !loading)
                    TextButton(onPressed: load, child: const Text('加载更早对话')),
                ],
              );
            }
            final row = rows[index - 1],
                packet = DialoguePacket.parse(rows[index - 1].responseJson!);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '回合 ${row.baseRevision + 1}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF858A93),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '你：${row.action}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  if (packet.narration.isNotEmpty)
                    SelectableText(
                      packet.narration,
                      style: const TextStyle(fontSize: 16, height: 1.9),
                    ),
                  for (final r in packet.replies)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: SelectableText(
                        '${state!.characters.where((c) => c.id == r['speaker']).firstOrNull?.name ?? '人物'}\n${r['text']}',
                        style: const TextStyle(fontSize: 16, height: 1.8),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}
