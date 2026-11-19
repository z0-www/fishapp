import 'package:material_ui/material_ui.dart';

class ImportProgressPage extends StatelessWidget {
  const ImportProgressPage({
    super.key,
    required this.progress,
    required this.onCancel,
  });
  final double progress;
  final VoidCallback onCancel;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('正在准备导入')),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('正在本机读取与解析，不会上传内容。'),
            const SizedBox(height: 20),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 12),
            Text('${(progress * 100).round()}%'),
            const SizedBox(height: 24),
            OutlinedButton(onPressed: onCancel, child: const Text('取消解析，保留暂存')),
          ],
        ),
      ),
    ),
  );
}
