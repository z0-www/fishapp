# 鱼者文游 V0.5.7+32 发布整改

**发布状态：BLOCKED。** 本轮交付 Android Debug 测试包和独立编译的 Release AOT 未签名产物。正式分发签名、原生 BYOK 公开分发复核和 Android 真机付费剧情均待完成。

## 发布安全

- Release API 使用源码中的分平台审核记录。Android、iOS 的 DeepSeek BYOK 和公开分享读取各有独立记录槽位。已核对的分发主体、渠道用途、条款版本及获准范围须能追溯到发行审核记录。当前记录为空。
- 客户端在每次请求前检查构建策略、官方 HTTPS 地址和支持模型。Debug 开关独立，无法为 Release 授权。Release 移除了开发诊断入口。实际服务错误依然以普通用户状态显示。
- Gradle 移除 Release 的 Debug 证书回退。仅识别开发者本机已经配置的 `android/key.properties`，检查密钥库文件存在并拒绝标准 Android Debug 别名。应用包名为 `com.yuzhe.fishtextadventure`，最低 Android API 24，版本号递增至 32。
- 新增 [正式 APK 核验脚本](../tool/Verify-AndroidRelease.ps1)，需要渠道审核过的证书 SHA-256。检查版本、包名、不可调试、明文网络限制、Flutter AOT 产物、16 KB ZIP 对齐、签名有效且匹配。正式证书和口令均由开发者维护。

## 预算和数据

手动确认绑定模型、预计输入及最大输出 Token，并且只使用一次。发送前重新核对日期、价格、用量状态和预算。设置每日预算时，无法核对价格或已发生费用会阻止请求。没有设置每日预算时，未知费用仍必须明确展示和逐次确认。本机预算用于客户端决策，服务商按实际账单结算。

数据库 schema 仍为版本 6，完整故事归档格式不变。升级前备份界面增加了签名变化提醒。Windows 源码回滚快照为 `fishtextadventure-v057-source-baseline.tar.gz`，SHA-256 为 `952340530E0A50F11868C8ED567F192F1B4EF37B50B327B4911DD60C87E9B0AF`。Git 当前分支尚无提交。本轮没有修改 Android 或 iOS 应用标识。

## 交付文件和包体

| 产物 | 字节数 | 验证结果 |
| --- | ---: | --- |
| [Android Debug APK](../build/app/outputs/flutter-apk/鱼者文游-V0.5.7+32-Debug.apk) | 181,743,011 | Android Debug 证书。包含 JIT 调试内核。 |
| [Android Release AOT 未签名 APK](../build/app/outputs/flutter-apk/鱼者文游-V0.5.7+32-Release-UNSIGNED.apk) | 71,487,756 | 没有 debuggable 标记及 JIT 内核，包含三种 ABI 的 AOT 库。Android 拒绝安装未签名产物。 |
| 正式签名 APK 与 AAB | — | 没发现正式签名配置。 |

Debug SHA-256 为 `AF42769FF4BE26B85FAC02034DE8D00DA0BDA71DC2424A47D1AA606A85BDE8B4`。Release SHA-256 为 `501DEB90FD3702C9596B2CA30B988B50494DE3CEE84FEFE893C3A10EC5DB5615`。Release 的 16 KB ZIP 对齐检查通过，ARM64 和 x86_64 的八个原生库都通过 ELF LOAD 对齐核对。未执行 16 KB 页大小设备的运行验收。 [APK 核验日志](../reports/release-v057/v057-package-audit.log)

## 实际修改文件

发布资料包括本报告、[正式验收清单](V057_RELEASE_CHECKLIST.md)、[真实 API](V057_REAL_API_ACCEPTANCE.md)、[导入](V057_IMPORT_ACCEPTANCE.md)、[安全与隐私](V057_SECURITY_AND_PRIVACY.md)及[本地隐私政策网页](privacy-policy.html)。

- [android/app/build.gradle.kts](../android/app/build.gradle.kts)
- [android/app/src/main/AndroidManifest.xml](../android/app/src/main/AndroidManifest.xml)
- [lib/app/router.dart](../lib/app/router.dart)
- [lib/core/app_version.dart](../lib/core/app_version.dart)
- [lib/core/release_access.dart](../lib/core/release_access.dart)
- [lib/features/ai/data/deepseek_config.dart](../lib/features/ai/data/deepseek_config.dart)
- [lib/features/ai/data/deepseek_error_handler.dart](../lib/features/ai/data/deepseek_error_handler.dart)
- [lib/features/ai/presentation/ai_settings_page.dart](../lib/features/ai/presentation/ai_settings_page.dart)
- [lib/features/ai/presentation/privacy_page.dart](../lib/features/ai/presentation/privacy_page.dart)
- [lib/features/import_center/application/import_providers.dart](../lib/features/import_center/application/import_providers.dart)
- [lib/features/import_center/presentation/import_preview_page.dart](../lib/features/import_center/presentation/import_preview_page.dart)
- [lib/features/settings/settings_page.dart](../lib/features/settings/settings_page.dart)
- [lib/features/wallet/application/wallet_controller.dart](../lib/features/wallet/application/wallet_controller.dart)
- [lib/features/wallet/application/wallet_limits.dart](../lib/features/wallet/application/wallet_limits.dart)
- [lib/features/wallet/presentation/wallet_plan_page.dart](../lib/features/wallet/presentation/wallet_plan_page.dart)
- [lib/features/world_backup/presentation/backup_pages.dart](../lib/features/world_backup/presentation/backup_pages.dart)
- [pubspec.yaml](../pubspec.yaml)
- [README.md](../README.md)
- [test/ai/deepseek_connection_test.dart](../test/ai/deepseek_connection_test.dart)
- [test/wallet/wallet_test.dart](../test/wallet/wallet_test.dart)
- [tool/Verify-AndroidRelease.ps1](../tool/Verify-AndroidRelease.ps1)
