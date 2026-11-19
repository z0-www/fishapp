import 'package:material_ui/material_ui.dart';

Future<bool> showProductStatement(
  BuildContext context, {
  bool firstLaunch = false,
}) async =>
    await showDialog<bool>(
      context: context,
      barrierDismissible: !firstLaunch,
      barrierColor: const Color(0xCCEDF0F4),
      builder: (context) =>
          PopScope(canPop: !firstLaunch, child: const ProductStatementDialog()),
    ) ==
    true;

class ProductStatementDialog extends StatelessWidget {
  const ProductStatementDialog({super.key});

  static const _sections = [
    (title: '软件永久免费', body: '鱼者文游不收取软件使用费，无会员、无内购，也不提供付费解锁功能。'),
    (title: '独立开发者作品', body: '本产品由 B站 UP 主 z0-www 独立制作，并非 DeepSeek 或哔哩哔哩官方应用。'),
    (
      title: '关于 DeepSeek API',
      body: '软件本体完全免费。使用自己的 DeepSeek API Key 时，可能产生由 DeepSeek 收取的模型服务费用。鱼者不会额外收取软件使用费，付费调用前会显示预计费用。',
    ),
    (
      title: '关于故事与数据',
      body: '世界、聊天记录和存档主要保存在用户设备本地。使用在线 AI 功能时，必要的对话和世界上下文会发送给模型服务商。请注意保护个人隐私并及时备份存档。',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      shadowColor: const Color(0x22182435),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      constraints: const BoxConstraints(maxWidth: 420),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              key: const Key('product-statement-scroll'),
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/branding/fish_logo.png',
                          width: 48,
                          height: 48,
                          cacheWidth: 144,
                          cacheHeight: 144,
                          excludeFromSemantics: true,
                        ),
                        const SizedBox(height: 12),
                        Semantics(
                          header: true,
                          child: Text(
                            '欢迎来到鱼者文游',
                            textAlign: TextAlign.center,
                            style: text.titleLarge?.copyWith(fontSize: 22),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '一个由热爱创造的免费作品。',
                          textAlign: TextAlign.center,
                          style: text.bodyMedium?.copyWith(
                            color: const Color(0xFF606C7B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  for (final section in _sections) ...[
                    Semantics(
                      header: true,
                      child: Text(
                        section.title,
                        style: text.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      section.body,
                      style: text.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF455163),
                      ),
                    ),
                    if (section != _sections.last) const SizedBox(height: 15),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 20),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1E508B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('进入鱼者'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
