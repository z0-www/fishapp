# 鱼者文游 V0.5.1 · iOS 工程准备

## 已实现与静态核对

- Runner 已接入 `fish/share_intake` 原生桥。Files 导入通过 security-scoped URL 读取；完整备份通过系统导出选择器复制。`.yuzhe` 已登记文件类型。
- Share Extension 与 Runner 通过同一 App Group 移交文件，扩展在成功暂存时确认完成，失败返回系统失败回执。文件大小受限，组目录排除系统备份，暂存文件使用 iOS 文件保护。原生桥缺失会显示明确错误。
- 密钥使用独立的 Runner Keychain，要求设备解锁、设备专用且关闭同步。Share Extension 只具备 App Group 权限。
- 复用 Flutter SQLite 数据目录和现有 schema 6。归档格式与 Android 共用，没有搬迁已有数据库。
- 生成中进入后台或应用分离时，通过现有取消令牌停止请求，草稿继续保留。Release 内隐藏开发开关详情，保留脱敏连接记录。

## macOS 验收

使用 Xcode 为 Runner 和 Share Extension 选择同一 Apple Developer Team，为两个 Target 配置对应的 App Group，并在签名配置下检查 Keychain 权限。先运行 `flutter build ios --debug --no-codesign` 验证工程，再在签名真机运行；发行另行检查隐私清单、第三方模型数据告知与同意、App Store Connect 内容分级和渠道适用范围。 [Flutter iOS 环境](https://docs.flutter.dev/platform-integration/ios/setup) [Apple App Groups](https://developer.apple.com/documentation/xcode/configuring-app-groups) [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

| 验收项 | 状态 |
| --- | --- |
| plist、签名权限声明、App Group 和共享 Dart 回归 | Windows 静态检查与自动化 |
| Xcode 构建与签名、iPhone 安全区域和键盘 | 尚未验证 |
| iPhone Keychain 保存与重启读取 | 尚未验证 |
| iPhone Files、系统分享、备份恢复 | 尚未验证 |
| iPhone 有效 Key、真实 HTTP、流式回复和重启 | 尚未验证 |
| Android → iPhone 与 iPhone → Android 备份往返 | 尚未验证 |

当前环境为 Windows，iOS Swift/UIKit 编译、签名与真实设备行为须在 macOS/Xcode 环境验证。正式版直连仍使用 iOS 自己的发行审核状态。
