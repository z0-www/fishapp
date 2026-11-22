# 当前版本 V0.2.0+4 — Fish Roleplay Core

进入任意世界 → “进入文游 · V0.2” → 首次选择现代/民国/奇幻场景 → 自由输入行动 → 查看预算并确认。默认是明确标注的本地规则试玩，不请求 DeepSeek、不读取 API Key 或伪造真实账单。人物记忆与世界进度会自动保存；真实调用仍待许可并默认关闭。

架构、研究、人格、记忆和评测见 docs/ROLEPLAY_*.md、docs/NPC_PERSONA_DESIGN.md、docs/WORLD_MEMORY_DESIGN.md。以下保留历史版本说明。

# 当前版本 0.1.1+2：Local BYOK

请先阅读 [BYOK_SECURITY.md](BYOK_SECURITY.md)；默认网络适配器为 Mock，正式直连未启用。以下保留 V0.1 首轮说明。

# 鱼者文游 FishTextAdventure

V0.1 Flutter 本地原型。Flutter **3.50.0 Stable** / Dart **3.14.0**。
Android applicationId / iOS bundle identifier: `com.yuzhe.fishtextadventure`。

## 运行

```powershell
flutter pub get
dart run build_runner build
flutter analyze
flutter test
flutter build apk --debug
flutter run
```

Windows 当前会话若未刷新 PATH，可使用
`C:\Users\lin\Documents\Codex\Development\flutter\bin\flutter.bat`。

## 本轮行为

- 首页：蓝白浅色、鱼者文游标题、新建世界、独立最近世界记录、设置入口、加载/错误重试/空状态。
- Chatform：对话提示和输入框；发送前显示 Before 预算 ¥0.00，明确为本地 Mock。
- 世界详情：Light 浅色故事预览，无完整游戏引擎。
- Drift SQLite 保存本地世界。首次使用注入三个固定示例；新世界置顶，重启后保留。
- Riverpod 管理依赖与异步世界列表，go_router 提供首页/创建/详情/设置路由。
- Dio / flutter_secure_storage 仅预留 provider，不配置服务地址、不发请求、不保存任何 Key。
- Material 3 使用 Flutter 3.50 模板提供的 `material_ui` 包。

空状态可在全新应用数据环境中通过 `flutter run --dart-define=FISH_START_EMPTY=true` 查看；此开关不删除已有数据。数据位于系统应用文档目录的 SQLite 文件中，卸载可能清除数据。

## 目录

```text
lib/
  main.dart
  app/                  # app、路由、主题
  core/database/        # Drift 表、数据库、生成代码
  core/services/        # 网络/安全存储基础设施
  features/worlds/
    domain/             # World 模型
    data/               # 本地 Mock 仓库
    application/        # Riverpod providers
    presentation/       # 首页、卡片、创建、世界预览
  features/settings/    # 设置
  shared/widgets/       # 内容宽度容器、空状态
test/                   # SQLite 与页面交互测试
android/                # Android 工程
ios/                    # iOS 工程
```

## 验证与限制

详细实测结果见交付测试报告和原始日志。截图通过 Flutter widget 渲染导出时会明确注明，并非声称 Android 真机截图。
Windows 无法执行 iOS 的 Xcode 编译和签名，需要后续在 macOS 上验证。
本轮不包含真实 API、世界生成引擎、账号、云同步或正式发布签名。
冻结方案为 Chatform / Before / Light；本轮仅依据本次用户提供的文字规范实施。

依赖从 pub.dev 获取；Android 使用 Flutter 模板原有 Google/Maven Central/Gradle 仓库，未调整 Gradle 版本。
开发参考：[Flutter 文档](https://docs.flutter.dev/)、[Drift](https://drift.simonbinder.eu/setup/)、[Riverpod](https://riverpod.dev/)、[go_router](https://pub.dev/packages/go_router)。
在此 Windows 开发机导出首页渲染截图：flutter test --dart-define=FISH_CAPTURE=true --reporter expanded。输出 reports/home.png（需系统微软雅黑）。
