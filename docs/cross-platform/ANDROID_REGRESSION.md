# Android 回归测试报告

日期：2026-11-20
基线：`df49fb0`（V0.5.8+34，`com.yuzhe.fishtextadventure`）
共享核心修改后执行，目的是确认 Web/iOS 适配没有破坏 Android。

## 1. 结果

| 项目 | 命令 | 结果 |
| --- | --- | --- |
| 静态分析 | `flutter analyze` | ✅ No issues found（38.9s） |
| 单元/Widget 测试 | `flutter test` | ✅ **309 passed**（新增 3 个跨端 `.yuzhe` 测试 + 7 个转换器测试） |
| Debug APK 构建 | `flutter build apk --debug` | ✅ 构建成功（151.6s / 重跑通过） |
| APK 身份 | `aapt dump badging` | ✅ `com.yuzhe.fishtextadventure`，versionCode 34，versionName 0.5.8 |
| 应用名 | `aapt dump badging` | ✅ 鱼者文游 |
| minSdk / targetSdk | `aapt dump badging` | ✅ 24 / 36（与基线构建配置一致） |

产物：

- `build/app/outputs/flutter-apk/app-debug.apk`
- 大小：220,589,337 字节
- SHA-256：`13FC07EDC14811A4B989CD65EC505BF4C1D024E27A49B4B00FE0A717CA32C201`
- 这是 **debug** 签名包，不是公开测试的正式签名 APK。

## 2. 本次共享核心改动对 Android 的影响

| 改动 | Android 影响 | 验证 |
| --- | --- | --- |
| `AppDatabase` 增加 Web 的 `DriftWebOptions` | 原生忽略 web 参数，数据库名、schema v6 不变 | 全部测试通过、Debug APK 启动路径未变 |
| 文件读取改走 `LocalFiles` 适配器 | 原生分支仍是 `File`；导入路径校验和符号链接检查保留 | `share_import_test`、`story_backup_test` 等通过 |
| `StoryBackupFormat` 抽出内存/文件共用的编解码 | 原生文件 API、加密、完整性校验行为保持不变 | `story_backup_test` 3 项全通过（含错误密码、损坏回滚） |
| `ShareIntakeService` 增加 Web 空实现 | Android 仍使用同一个 MethodChannel | 相关测试通过 |
| `DeepSeekConfig` 增加 Web/iOS 直连开关 | Android 既有审核/开关逻辑不变；`policyAllows` 仍拒绝 Web | `deepseek_connection_test` 通过 |
| `ApiKeyStorage` 增加 WebOptions | AndroidOptions 未改，命名空间/加密算法不变 | `byok_security_test` 通过 |
| 新增 `web` pub 依赖 | 仅 Web 使用；Android 构建正常 | Debug APK 构建成功 |

## 3. 未执行/未改动

- **正式签名 APK 未重建**：项目里没有 `key.properties` 与签名证书，按指令不触碰正式签名材料。
  仓库内也不存在 V0.5.8+34 正式 APK，因此没有覆盖/删除任何正式包。
- **未做真机回归**：没有连接 Android 设备/模拟器执行人工 UI 走查。
  现有 `flutter test` 是 Widget/单元测试，不等同于真机验收。
- **未做 Release 构建**：缺少正式签名配置，且 Release BYOK 有独立审核门槛；
  本次不改变发布状态。

## 4. 结论

共享核心修改没有导致 Android 静态分析、测试或 Debug 构建回归。
正式签名 APK 与签名材料保持原状，未被本次工作改写。
