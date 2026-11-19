import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/content_frame.dart';
import '../../../shared/widgets/chat_composer.dart';
import '../../../shared/widgets/world_drawer.dart';
import '../../../shared/data/text_draft_store.dart';
import '../../ai/presentation/api_key_reminder.dart';
import '../../world_creator/application/providers.dart';
import '../../world_creator/domain/world_definition.dart';
import '../application/world_providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final input = TextEditingController();
  late TextDraftStore store;
  Timer? timer;
  Future<void> pending = Future.value();
  bool busy = false, edited = false;
  String? error;
  @override
  void initState() {
    super.initState();
    store = ref.read(textDraftStoreProvider);
    restore();
    input.addListener(changed);
  }

  Future<void> restore() async {
    try {
      final text = await store.read('home');
      if (mounted && !edited && text != null) input.text = text;
    } catch (_) {}
  }

  void changed() {
    edited = true;
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 300), flush);
  }

  void flush() {
    final text = input.text;
    pending = pending.then((_) => store.write('home', text)).catchError((_) {
      if (mounted) setState(() => error = '输入草稿暂未保存，请稍后重试。');
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    flush();
    input.removeListener(changed);
    input.dispose();
    super.dispose();
  }

  Future<void> create() async {
    if (busy) return;
    final description = input.text.trim();
    if (description.isEmpty) {
      setState(() => error = '先写下你想进入的世界。');
      return;
    }
    FocusScope.of(context).unfocus();
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _WorldConfirmation(description: description),
    );
    if (result == null || !mounted) return;
    if (result['advanced'] == 'true') {
      context.push('/create?prompt=${Uri.encodeComponent(description)}');
      return;
    }
    setState(() => busy = true);
    try {
      final d = WorldDefinition.empty(
        'world-${DateTime.now().microsecondsSinceEpoch}',
      );
      d.data['title'] = result['title']?.trim();
      d.data['description'] = description;
      await ref
          .read(worldDefinitionRepositoryProvider)
          .save(d, expectedVersion: 0);
      timer?.cancel();
      await pending;
      await store.clear('home');
      input.clear();
      ref.invalidate(worldsProvider);
      if (mounted) context.go('/play/${d.id}');
    } catch (_) {
      if (mounted) setState(() => error = '世界暂未保存，输入内容仍保留。请重试。');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: const WorldDrawer(),
    appBar: AppBar(
      title: const Text('鱼者文游'),
      leading: Builder(
        builder: (context) => IconButton(
          tooltip: '打开世界菜单',
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          tooltip: '更多操作',
          icon: const Icon(Icons.more_horiz),
          onSelected: (v) => context.push(v),
          itemBuilder: (_) => const [
            PopupMenuItem(value: '/imports', child: Text('导入旧故事')),
            PopupMenuItem(value: '/settings', child: Text('设置')),
          ],
        ),
      ],
    ),
    body: SafeArea(
      child: ContentFrame(
        child: Column(
          children: [
            const ApiKeyReminder(),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(28),
                  child: ref
                      .watch(worldsProvider)
                      .when(
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => Column(
                          children: [
                            const Text('世界暂时无法读取，请重试。'),
                            TextButton(
                              onPressed: () => ref.invalidate(worldsProvider),
                              child: const Text('重新加载'),
                            ),
                          ],
                        ),
                        data: (worlds) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '今天，想进入怎样的世界？',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                height: 1.6,
                              ),
                            ),
                            if (worlds.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () =>
                                    context.push('/play/${worlds.first.id}'),
                                child: Text(
                                  '继续 · ${worlds.first.title}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                ),
              ),
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(error!, style: const TextStyle(fontSize: 12)),
              ),
            ChatComposer(
              controller: input,
              inputKey: const Key('home-input'),
              hint: '描述你想创造的世界……',
              sendLabel: '创建世界',
              busy: busy,
              onSend: create,
              actions: [
                ComposerAction(
                  '导入旧故事',
                  Icons.file_open_outlined,
                  () => context.push('/imports'),
                ),
                ComposerAction(
                  '详细自定义',
                  Icons.tune_rounded,
                  () => context.push(
                    '/create?prompt=${Uri.encodeComponent(input.text)}',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _WorldConfirmation extends StatefulWidget {
  const _WorldConfirmation({required this.description});
  final String description;
  @override
  State<_WorldConfirmation> createState() => _WorldConfirmationState();
}

class _WorldConfirmationState extends State<_WorldConfirmation> {
  final title = TextEditingController();
  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '开始这个世界',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: title,
              maxLength: 100,
              decoration: const InputDecoration(labelText: '世界名称（可稍后填写）'),
            ),
            const SizedBox(height: 12),
            Text(
              widget.description,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            const Text(
              '创建与保存只在本机完成，不调用 AI。',
              style: TextStyle(fontSize: 13, color: Color(0xFF858A93)),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.pop(context, {'title': title.text}),
              child: const Text('进入世界'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, {'advanced': 'true'}),
              child: const Text('完善更多设定'),
            ),
          ],
        ),
      ),
    ),
  );
}
