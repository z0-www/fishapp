# 鱼者文游 V0.4.8+22 · 手机验收与 iOS 准备

## 验收状态

| 平台 | 已实现 | 已实测 | 未验证 |
| --- | --- | --- | --- |
| Android Debug | 共用真实 DeepSeek 客户端、逐次费用确认、脱敏诊断、剧情与用量存档 | Android Debug 构建与 v2 签名已核验。Windows 上的 Flutter 回归覆盖 HTTP 状态和用量展示、故障脱敏、连续剧情及数据库重开 | 本轮 Android 真机 HTTP 200、真实用量、十轮真实剧情及人物记忆、重启后继续真实对话 |
| Android Release | 独立的发布准入判定。当前 Android 发布批准标记关闭，普通 Debug 开关不会影响它 | 发布判定的自动化回归已执行 | Android Release 打包与签名验收、公开分发许可范围、正式版真实请求 |
| iOS | 共用 Dart 客户端和诊断。iOS 发布批准标记独立。已检查 Keychain、SQLite、文件导入、分享扩展和故事备份 | 静态检查目标配置、签名资源引用和共享容器标识。Windows 主机运行 Flutter 共用业务测试 | macOS/Xcode 构建、签名、TestFlight 或 iPhone 实机流程 |

静态分析无问题，272 项自动化测试通过。本轮未发出付费 DeepSeek 请求。诊断测试使用明确的测试数据，历史 Windows HTTP 200 记录属于 [此前验收](V048_REAL_API_TEST.md)。

## Android 无 ADB 安装

1. 把本机的 `C:\Users\lin\Desktop\FishTextAdventure\build\app\outputs\flutter-apk\app-debug.apk` 传到 Android 手机，例如通过 USB 文件传输。
2. 用手机文件管理器打开 APK。若系统要求授权，只允许当前文件管理器安装，安装后可关闭该权限。选择更新或覆盖安装来保留世界和记录。遇到签名冲突或系统提示卸载时，先停在原版本，当前还不能导出完整剧情备份。
3. 打开鱼者，在「设置 → AI 服务设置」填入并保存个人 Key。点击「手动测试连接」，查看估价与发送范围后确认本次费用。
4. 进入「AI 服务设置 → 开发诊断」，查看实际 HTTP 状态、响应模型、输入和输出 Token、缓存命中及安全错误。可点「复制脱敏诊断」记录证据。复制内容不含 Key、请求头、聊天正文或世界编号。HTTP 200 伴随格式异常时，连接测试仍判为未完成。
5. 连接成功后，在单独的测试世界创建一名 NPC，设定便于辨认的称呼或约定。逐轮确认费用，沿同一故事测试约定、人物记忆和已发生事件。在第五轮后正常退出并重开，确认原先回复仍可读，然后继续到第十轮。
6. 对照「开发诊断」和「用量与预算」，记录真实请求数、HTTP 状态、输入/输出/缓存用量，以及最后一个可读取的剧情节点。如果失败，先记录现场。重新生成仍需新的逐次费用确认。

诊断页保留最近的本机用量记录，最近错误显示在当前运行期间。离线或服务端未提供字段时显示「未取得」。预计费用和服务端 Token 用量各自显示，实际金额以官方账单为准。

## 正式发布接入

Android Release 暂不能调用的直接原因是源码中的 Android 发布审批值仍关闭，且 Profile 与 Release 分开判定。当前资料缺少可核验、明确覆盖公开分发渠道和地区的适用接入范围。iOS 使用独立审批条件。任一平台的 Debug 开关、测试成功或另一平台获批，都不改变本平台的正式接入判定。

正式方案沿用本机 BYOK。由用户输入自己的 Key，只在设备私有安全存储中保存，按确认的用途向 DeepSeek 官方 HTTPS 发送必要内容。正式启用前逐平台核对适用条款、第三方 AI 的明确告知和同意、分发地区及渠道，保留费用确认和拒绝重定向。iOS 发行还需单独复核 App Store 的第三方 AI 数据分享要求。 [DeepSeek 开放平台条款](https://cdn.deepseek.com/policies/en-US/deepseek-open-platform-terms-of-service.html) · [Apple 审核指南 5.1.2](https://developer.apple.com/app-store/review/guidelines/#data-use-and-sharing)

## iOS 兼容性检查

| 项目 | 静态检查 | macOS 或真机待办 |
| --- | --- | --- |
| Keychain | 集成现有 `flutter_secure_storage`。使用仅本机、设备解锁可访问的条目，关闭同步。Runner 的签名资源加入自身私有访问组，分享扩展仍仅有 App Group | 用实际团队签名检查写入、重启读取、替换、删除及扩展无访问权 |
| SQLite | Runner 内使用与 Android 共用的 Drift/SQLite 与存档格式。现有数据库版本 6 | 验证 iOS 原生 SQLite 库装载、迁移、两次重启及十轮存档 |
| 文件导入 | 现有 UIDocumentPicker 读取安全范围 URL，再复制到有大小限制的暂存区。共享 Dart 解析器可接收原文和 DeepSeek ZIP | 实测本机文件和 iCloud 文件选择，含取消、大文件与格式错误 |
| 分享扩展 | Runner 与扩展已声明同一 App Group。扩展版本改为继承 Flutter 的版本号和构建号 | 用自己的团队配置 App Group 和两个目标的签名，实测分享文本、链接、文件以及返回主 App 后确认导入 |
| 完整故事备份 | 可导出世界设定。应用级完整剧情备份及恢复还没有实现，聊天、人物记忆和检查点仍保存在本地数据库 | 完整备份功能后续独立实现并验证往返，包括敏感信息排除；本轮只做检查 |

Windows 主机未运行 Xcode。下一步在 macOS 上用项目支持的 Flutter/Xcode 打开 `ios/Runner.xcworkspace`，核对两个目标各自的 provisioning 和 App Group，再运行 `flutter build ios --simulator` 与带实际签名的真机测试。供应商要求及安装见 [Flutter iOS 开发环境](https://docs.flutter.dev/platform-integration/ios/setup) · [Apple App Groups](https://developer.apple.com/documentation/xcode/configuring-app-groups)。

Android Debug APK SHA-256 7EE6887C5B60DC686FFFDC3DA4E76BA98E166819BECAB734597530FDCD96A07C
