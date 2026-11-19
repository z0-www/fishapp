import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/database/app_database.dart';
import '../../../shared/widgets/back_home_button.dart';
import '../../../shared/widgets/content_frame.dart';
import '../application/import_providers.dart';

class ImportResultPage extends ConsumerStatefulWidget {
  const ImportResultPage({super.key, required this.id});
  final String id;
  @override
  ConsumerState<ImportResultPage> createState() => _ImportResultPageState();
}

typedef _ImportReading = ({
  ImportedConversationRow conversation,
  List<({String role, String body})> messages,
  List<ImportedAttachmentRow> attachments,
  bool publicShare,
});

class _ImportResultPageState extends ConsumerState<ImportResultPage> {
  late final Future<_ImportReading?> record = _load();

  Future<_ImportReading?> _load() async {
    final repo = ref.read(pendingShareRepositoryProvider);
    final conversation = await repo.conversation(widget.id);
    if (conversation == null) return null;
    return (
      conversation: conversation,
      messages: await repo.readableMessages(conversation.id),
      attachments: await repo.attachments(conversation.id),
      publicShare: await repo.isPublicShare(conversation.id),
    );
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: record,
    builder: (context, snapshot) {
      if (snapshot.data case final record?) {
        return ImportResultContent(
          conversation: record.conversation,
          messages: record.messages,
          attachments: record.attachments,
          publicShare: record.publicShare,
        );
      }
      return Scaffold(
        appBar: _appBar(),
        body: Center(
          child: snapshot.hasError
              ? const Text('读取失败，原始记录未修改，请返回后重试。')
              : snapshot.connectionState == ConnectionState.done
              ? const Text('记录尚未保存。')
              : const CircularProgressIndicator(),
        ),
      );
    },
  );
}

AppBar _appBar({List<Widget>? actions}) => AppBar(
  leading: const BackHomeButton(),
  title: const Text('已保存的原始记录'),
  actions: actions,
);

class ImportResultContent extends StatefulWidget {
  const ImportResultContent({
    super.key,
    required this.conversation,
    required this.messages,
    required this.attachments,
    required this.publicShare,
  });
  final ImportedConversationRow conversation;
  final List<({String role, String body})> messages;
  final List<ImportedAttachmentRow> attachments;
  final bool publicShare;

  @override
  State<ImportResultContent> createState() => _ImportResultContentState();
}

class _ImportResultContentState extends State<ImportResultContent> {
  bool _fromEnd = false;
  int _jump = 0;
  static final _bareLink = RegExp(r'^https?://\S+$');

  void _goToEdge(bool end) => setState(() {
    _fromEnd = end;
    _jump++;
  });

  @override
  Widget build(BuildContext context) {
    final conversation = widget.conversation;
    final messages = widget.messages;
    final hasStory = messages.any(
      (m) =>
          m.body.trim().isNotEmpty &&
          !(m.role == 'unknown' && _bareLink.hasMatch(m.body.trim())),
    );
    return Scaffold(
      appBar: _appBar(
        actions: [
          if (messages.length > 1) ...[
            IconButton(
              tooltip: '跳到开头',
              onPressed: () => _goToEdge(false),
              icon: const Icon(Icons.vertical_align_top_rounded),
            ),
            IconButton(
              tooltip: '跳到结尾',
              onPressed: () => _goToEdge(true),
              icon: const Icon(Icons.vertical_align_bottom_rounded),
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: ContentFrame(
          child: ListView.builder(
            key: ValueKey(_jump),
            primary: false,
            reverse: _fromEnd,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            itemCount: messages.length + 1,
            itemBuilder: (context, index) {
              final ordinal = _fromEnd ? messages.length - index : index;
              if (ordinal == 0) return _header(context, conversation, hasStory);
              final message = messages[ordinal - 1];
              final label = switch (message.role) {
                'user' => '用户',
                'assistant' => 'AI',
                _ => '原文',
              };
              return Padding(
                padding: const EdgeInsets.only(top: 18, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(label, style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 6),
                    SelectableText(
                      message.body,
                      style: const TextStyle(fontSize: 16, height: 1.85),
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

  Widget _header(
    BuildContext context,
    ImportedConversationRow c,
    bool hasStory,
  ) {
    final source = widget.publicShare
        ? 'DeepSeek 公开分享'
        : switch (c.source) {
            'system' => '系统分享',
            'picker' => '本机文件',
            'paste' => '粘贴导入',
            'local' => '鱼者本地故事',
            _ => '已保存的原始档案',
          };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(c.title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          hasStory
              ? '已保存到本机 · 共 ${widget.messages.length} 条原始消息'
              : '此档案没有对话正文。',
        ),
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: const Text('来源与导入完整性'),
          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('来源 · $source'),
            Text(
              widget.publicShare
                  ? '部分对话快照 · 仅包含分享范围内实际取得的消息'
                  : '已保留所选来源中的正文 · 原会话完整性无法确认',
            ),
            for (final file in widget.attachments)
              ListTile(
                leading: const Icon(Icons.attachment),
                title: Text(file.displayName),
                subtitle: Text('${file.byteSize} 字节'),
              ),
          ],
        ),
        if (c.worldId != null && hasStory)
          FilledButton(
            onPressed: () => context.go('/play/${c.worldId}'),
            child: const Text('继续已导入的故事'),
          ),
        Wrap(
          children: [
            if (c.worldId != null && hasStory)
              TextButton(
                onPressed: () => context.push('/definition/edit/${c.worldId}'),
                child: const Text('编辑关联世界'),
              ),
            if (hasStory)
              TextButton(
                onPressed: () => context.push('/story/recover/${c.id}'),
                child: const Text('恢复为可继续的世界'),
              ),
            if (c.worldId != null)
              TextButton(
                onPressed: () => context.push('/world/${c.worldId}'),
                child: const Text('查看关联世界'),
              ),
            TextButton(
              onPressed: () => context.go('/imports'),
              child: const Text('返回迁移中心'),
            ),
          ],
        ),
      ],
    );
  }
}
