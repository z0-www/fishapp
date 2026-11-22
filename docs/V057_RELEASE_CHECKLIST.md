# 鱼者文游 V0.5.7+32 发布清单

**Android 公开发行：BLOCKED。Google Play：BLOCKED。iOS：未验证。**

## 执行及产物

- `flutter analyze --no-pub` 通过，无问题。
- `flutter test --no-pub` 全量 **296 项通过**。
- `flutter build apk --debug --no-pub` 与 `flutter build apk --release --no-pub` 均通过。Release APK 非可调试，当前未签名。
- [Debug APK](../build/app/outputs/flutter-apk/鱼者文游-V0.5.7+32-Debug.apk) · [Release AOT 未签名产物](../build/app/outputs/flutter-apk/鱼者文游-V0.5.7+32-Release-UNSIGNED.apk)

## 逐项验收

| 检查 | 状态 | 证据 |
| --- | --- | --- |
| 正式签名与长期覆盖升级 | BLOCKED | 当前 `android/key.properties` 不存在。用户签名身份、渠道证书及长期覆盖路径待核对。 |
| Debug 构建 | 通过 | 可安装的 Debug 测试包。 |
| Release 非调试形态 | 通过 | 独立 Release AOT 产物，检查签名、包版本、Kernel、明文 HTTP、平台可调试标志与 ZIP 对齐。 |
| Android 安装与升级 | 模拟器实测 | 只在隔离模拟器使用同一内部测试证书覆盖 V0.5.6，再验证旧世界和原文。正式证书覆盖真实设备未验收。 |
| 最低 Android 版本 | Android 模拟器实测 | Android 7.0 / API 24 官方镜像上全新安装内部 AOT 副本，首次声明可完成，系统分享的 4 条本地消息可预览并恢复到聊天。Android 实体设备仍未验收。 |
| 费用、预算、不重试 | 自动化测试通过 | 无 Key 时没有生成。401／402、网络失败、费用流程和一次性确认覆盖。 |
| 长故事与 UI | 自动化测试通过 | 聊天和导入长列表、键盘、大字体、横屏、声明、导航和复制邮箱。真实设备性能未验收。 |
| 归档、迁移与回滚 | 模拟器实测，自动化测试通过 | 在 API 37 使用系统文档选择器导出和重新导入 .yuzhe，预览显示 12 条原文，恢复后可读最后一条。自动化覆盖归档错误密码、损坏、重复导入、回滚、分支及旧数据库升级。 |
| 公开 BYOK 与真实手机 10 轮 | BLOCKED | 未提供本轮付费授权，未能复核公开发行范围，且没有测试真机。 |
| 公开分享正文 | 未通过 | 此前授权链接 429，0 条正文。允许粘贴或文件替代。 |
| Google Play | BLOCKED | 私钥／上传签名、公开隐私 URL、平台问卷及可送达的应用内 AI 内容举报待完成。 |
| iOS | 未验证 | Windows 环境无法执行 Xcode 构建和真机验收。 |

## 测试证据与截图

- [API 24 首次声明](../reports/release-v057/v057-api24-statement.png) · [API 24 本地故事](../reports/release-v057/v057-api24-story.png)
- [Release AI 服务状态](../reports/release-v057/v057-release-ai-settings.png) · [升级后原文](../reports/release-v057/v057-release-restored-story.png) · [飞行模式下的草稿](../reports/release-v057/v057-release-airplane-draft.png)
- [.yuzhe 恢复预览](../reports/release-v057/v057-release-backup-preview.png) · [恢复后的最后片段](../reports/release-v057/v057-release-backup-restored.png)
- [消费管家显示余额不可用](../reports/release-v057/v057-release-wallet.png) · [读档验证](../reports/release-v057/v057-android-wallet.log)
- [静态分析](../reports/release-v057/v057-analyze.log) · [全量测试](../reports/release-v057/v057-tests.log) · [Debug 构建](../reports/release-v057/v057-build-debug.log) · [Release 构建](../reports/release-v057/v057-build-release.log)
- [APK 签名及资源](../reports/release-v057/v057-package-audit.log) · [签名核验脚本拒绝测试证书](../reports/release-v057/v057-formal-signer-gate.log)
- [模拟器旧版数据](../reports/release-v057/v057-android-seed.log) · [Android 37 升级](../reports/release-v057/v057-android-upgrade.log) · [Android 24 安装](../reports/release-v057/v057-android-api24.log) · [Android 归档恢复](../reports/release-v057/v057-android-backup-complete.log)

## 更新保护

同一 Android 包名要用兼容证书覆盖。现有 Debug 安装和开发者正式证书通常不同。迁移前，从「设置 → 完整故事备份」逐个保存需要的世界及其分支到应用外，确认可读取归档并保管密码，再变更安装；随后通过迁移中心恢复 `.yuzhe`。密钥需要在新安装中由用户重新配置。模拟器验证未清理任何现有实体手机数据。 [Android 签名与升级](https://developer.android.com/studio/publish/app-signing)

[实际代码与构建](V057_RELEASE_REMEDIATION.md) · [真实 API](V057_REAL_API_ACCEPTANCE.md) · [导入](V057_IMPORT_ACCEPTANCE.md) · [安全与隐私](V057_SECURITY_AND_PRIVACY.md)
