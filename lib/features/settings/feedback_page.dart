import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../shared/widgets/content_frame.dart';

const feedbackEmail = 'z0www1234@163.com';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  Future<void> _copyEmail(BuildContext context) async {
    var message = '邮箱已复制';
    try {
      await Clipboard.setData(const ClipboardData(text: feedbackEmail));
    } on PlatformException {
      message = '无法复制邮箱，请重试。';
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('意见反馈')),
    body: SafeArea(
      child: ContentFrame(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text('如果你在使用鱼者文游时遇到问题，或有任何建议，欢迎通过以下邮箱联系开发者。'),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(child: Text('开发者邮箱：$feedbackEmail')),
                IconButton(
                  tooltip: '复制邮箱',
                  color: Theme.of(context).colorScheme.primary,
                  icon: const Icon(Icons.content_copy_rounded, size: 20),
                  onPressed: () => _copyEmail(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('开发者：B站 UP 主 z0-www'),
          ],
        ),
      ),
    ),
  );
}
