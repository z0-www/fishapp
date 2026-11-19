import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

class BackHomeButton extends StatelessWidget {
  const BackHomeButton({super.key});
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: '返回',
    icon: const Icon(Icons.arrow_back_rounded),
    onPressed: () {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/');
      }
    },
  );
}
