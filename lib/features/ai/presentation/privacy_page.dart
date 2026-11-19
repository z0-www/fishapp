import 'package:material_ui/material_ui.dart';

import '../../../shared/widgets/content_frame.dart';
import '../../settings/feedback_page.dart' show feedbackEmail;

const localPrivacy =
    '鱼者文游由 B站 UP 主 z0-www 独立开发。隐私联系邮箱 $feedbackEmail。\n\n'
    '世界、聊天、原始导入资料、草稿和用量记录保存在此设备。API Key 使用 Android Keystore 保护的加密存储或 iOS 仅本机 Keychain，与故事数据库和备份分开。鱼者文游没有账号、密钥服务器或请求代理。\n\n'
    '在可用的在线构建中，发送剧情、运行测试或选择 AI 整理前需要费用确认，或受你主动设置的有效预算授权约束。相应的用户输入、必要世界上下文和 API Key 经 HTTPS 直接交给 DeepSeek。打开消费管家或刷新余额时可能向 DeepSeek 发送 API Key，不附带剧情。DeepSeek 按其服务规则处理数据并计费。\n\n'
    '系统分享、文件和剪贴板内容仅在你选择时读取。获准读取公开分享时，鱼者匿名访问 DeepSeek 官方地址。公开分享可能被持有链接的人看到。导出的故事备份由你保管，可以设置密码。\n\n'
    '你可在设置中删除本机 API Key，也可在世界设定中删除世界。已导入的原始档案与世界独立保存。清除应用数据会移除本机故事与档案，请先保存独立备份。你复制或导出的文件需自行管理。DeepSeek 侧数据管理请以其规则为准。';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('隐私说明')),
    body: SafeArea(
      child: ContentFrame(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const [Text(localPrivacy, style: TextStyle(height: 1.9))],
        ),
      ),
    ),
  );
}
