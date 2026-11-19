import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';
import '../../../shared/widgets/content_frame.dart';

class ApiKeyGuidePage extends StatelessWidget {
  const ApiKeyGuidePage({super.key});

  static final Uri keyPage = Uri.https('platform.deepseek.com', '/api_keys');
  static const imageFolder = 'assets/tutorials/deepseek_keys';
  static const feeNote =
      '鱼者文游免费。通过鱼者使用 DeepSeek API（含连接测试）可能产生费用，由 DeepSeek 计费。';

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('图解获取 API Key')),
    body: SafeArea(
      bottom: false,
      child: ContentFrame(
        child: ListView(
          key: const Key('api-key-guide-steps'),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: const [
            Text('跟着红圈和箭头操作。以下为脱敏的网页截图，手机上的按钮位置可能不同。'),
            SizedBox(height: 12),
            Text(feeNote),
            SizedBox(height: 20),
            _GuideStep(1, '登录后找到 API keys', '登录后若未进入密钥页面，在官网菜单中点「API keys」。', [
              '01-api-keys.png',
            ]),
            _GuideStep(2, '创建密钥', '点「创建 API key」，给密钥起个名字，例如「鱼者文游」，再点「创建」。', [
              '02-create-button.png',
              '03-create-dialog.png',
            ]),
            _GuideStep(3, '复制密钥', '在关闭弹窗前点「复制」。如果忘记复制，可以重新创建一把。请勿把真实密钥发给他人。', [
              '04-copy-button.png',
            ]),
            _GuideStep(
              4,
              '回鱼者粘贴并保存',
              '切回鱼者后会看到密钥输入框。点「粘贴」，再点「保存 API Key」并确认。保存后可手动测试连接。',
              [],
            ),
          ],
        ),
      ),
    ),
    bottomNavigationBar: SafeArea(
      top: false,
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.open_in_new_rounded),
                label: const Text('打开 DeepSeek 密钥页面'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _GuideStep extends StatelessWidget {
  const _GuideStep(this.number, this.title, this.detail, this.images);

  final int number;
  final String title, detail;
  final List<String> images;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '$number. $title',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(detail),
        for (final image in images) ...[
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              '${ApiKeyGuidePage.imageFolder}/$image',
              fit: BoxFit.fitWidth,
              excludeFromSemantics: true,
              errorBuilder: (_, _, _) => const ColoredBox(
                color: FishTheme.soft,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('图片暂时无法显示，可按上方文字继续操作。'),
                ),
              ),
            ),
          ),
        ],
      ],
    ),
  );
}
