import 'package:material_ui/material_ui.dart';

import '../../app/theme.dart';

class ComposerAction {
  const ComposerAction(this.label, this.icon, this.onTap);
  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

class ChatComposer extends StatelessWidget {
  const ChatComposer({
    super.key,
    required this.controller,
    required this.hint,
    required this.onSend,
    required this.actions,
    this.busy = false,
    this.onStop,
    this.inputKey,
    this.sendLabel = '发送',
    this.focusNode,
  });
  final TextEditingController controller;
  final String hint, sendLabel;
  final VoidCallback? onSend, onStop;
  final List<ComposerAction> actions;
  final bool busy;
  final Key? inputKey;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: FishTheme.soft,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 8, 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: inputKey,
              controller: controller,
              focusNode: focusNode,
              enabled: !busy,
              minLines: 1,
              maxLines: MediaQuery.sizeOf(context).height < 400 ? 2 : 5,
              maxLength: 2000,
              textInputAction: TextInputAction.newline,
              style: const TextStyle(fontSize: 16, height: 1.5),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: FishTheme.muted),
                counterText: '',
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            Row(
              children: [
                PopupMenuButton<int>(
                  tooltip: '添加与更多',
                  enabled: !busy,
                  icon: const Icon(Icons.add_rounded, color: FishTheme.muted),
                  itemBuilder: (_) => [
                    for (final e in actions.indexed)
                      PopupMenuItem(
                        value: e.$1,
                        child: Row(
                          children: [
                            Icon(e.$2.icon, size: 20),
                            const SizedBox(width: 12),
                            Text(e.$2.label),
                          ],
                        ),
                      ),
                  ],
                  onSelected: (i) => actions[i].onTap(),
                ),
                const Spacer(),
                IconButton.filled(
                  tooltip: busy ? '停止生成' : sendLabel,
                  onPressed: busy ? onStop : onSend,
                  style: IconButton.styleFrom(
                    minimumSize: const Size(48, 48),
                    backgroundColor: FishTheme.blue,
                    foregroundColor: Colors.white,
                  ),
                  icon: Icon(
                    busy ? Icons.stop_rounded : Icons.arrow_upward_rounded,
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
