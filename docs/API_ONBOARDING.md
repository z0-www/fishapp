> 历史实现记录。V0.4.5+12 的现行行为与测试见 [运行时整改报告](MOCK_REMOVAL_REPORT.md)。本文中旧版演示流程已停用。

# 首次 API 配置指引 · V0.4.2+9

打开应用先进入 StartupPage，仅检查本地是否保存密钥，不读取完整密钥、不自动测试连接或收费。

- 没有密钥：第一个交互页面为配置引导，顶部展示官方平台创建密钥、复制粘贴、手动测试及确认安全保存三步。
- 已保存密钥：直接进入主页，不重复要求输入。
- 安全存储异常：提供重试和本地使用入口，不主动清除原密钥。
- 可选择先体验本地世界；未保存密钥时下次正常启动仍会提示配置。系统分享继续保留离线预览能力。

当前构建继续为本地 Mock 模式，页面明确提示保存密钥也不会自动开启真实 DeepSeek 请求。没有改变原生直连许可门或新增服务器。

保留输入隐藏、手动粘贴、后台临时引用清理、保存确认、系统安全存储与已有存档。Logo原图及应用图标沿用上一版，主页聊天布局不变。

实际验证：flutter analyze无问题，92项测试全部通过，Debug APK构建及签名验证通过。新增测试分别验证未保存、已保存和安全存储异常三条启动路径，并检查零自动请求、零完整密钥读取。390×844与320×640/1.3倍字号截图已检查，无溢出。

截图为Flutter widget渲染，密钥状态使用Mock；不声称已经进行手机Keystore、iOS Keychain或真实DeepSeek联网验收。

修改：lib/app/router.dart、features/ai/presentation/api_setup_page.dart、settings_page.dart、pubspec.yaml、README.md及相关启动测试。无数据库迁移，无存档删除。

项目APK：C:\Users\lin\Desktop\FishTextAdventure\build\app\outputs\flutter-apk\app-debug.apk

交付APK：C:\Users\lin\Documents\Codex\2026-11-16\fishtextadventure-v0-1-windows-11-flutter\outputs\Onboarding-V0.4.2\FishTextAdventure-V0.4.2-debug.apk

字节数：180583573

SHA256：9FEC5C53BB9127D4D85C123A10D10B596998C07509A2E1F8D0296201A11A58D8