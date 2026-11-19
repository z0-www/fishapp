import 'package:material_ui/material_ui.dart';

class ContentFrame extends StatelessWidget {
  const ContentFrame({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: child,
    ),
  );
}

class EmptyWorlds extends StatelessWidget {
  const EmptyWorlds({super.key, required this.onCreate});
  final VoidCallback onCreate;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 40),
    child: Column(
      children: [
        const Icon(
          Icons.auto_stories_outlined,
          size: 48,
          color: Color(0xFF2563EB),
        ),
        const SizedBox(height: 16),
        Text('你的故事，从这里开始', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        const Text('还没有世界，写下你的第一个灵感吧。'),
        const SizedBox(height: 20),
        OutlinedButton(onPressed: onCreate, child: const Text('创建第一个世界')),
      ],
    ),
  );
}
