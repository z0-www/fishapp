# 鱼者文游 V0.4.8 · DSH 接管与交接

## 1. 源码目录确认

| 目录 | 结论 |
| --- | --- |
| `C:\Users\lin\Desktop\FishTextAdventure` | **正式源码目录**：包含 `lib/`、`android/`、`test/`、`pubspec.yaml`、`docs/`、`tool/`；`flutter analyze` 与 259 项测试在此运行 |
| `C:\Users\lin\Documents\Codex\...\work\v047` | 仅是上一轮 Codex 的临时脚本与日志目录（`*.ps1`、`*.cjs`、`test.log`），**不是**项目副本，未在此修改任何产品代码 |

本轮所有产品代码修改都在 Desktop 项目内。该目录是 Git 仓库，但 `master` 尚无任何提交（全部文件为未跟踪状态），因此没有历史提交可回滚。

## 2. 实际阻断原因（不是 UI 问题）

### 2.1 代码与自身安全文档矛盾，Android 永远进不了真实调用

`BYOK_SECURITY.md` 明确写：真实 API 开发测试只要求 `DEEPSEEK_EXPERIMENTAL=true` + `DEEPSEEK_REAL_API_DEV_TEST=true`，且“不读取该许可标记”。但 `DeepSeekConfig.devTestAllowed` 实际还把 `DEEPSEEK_NATIVE_BYOK_PERMISSION_GRANTED` 作为硬性条件：

```dart
permissionGranted: buildPermission && nativeByokPermissionConfirmed,
```

结果：按文档只传两个开关构建的 APK，`permitsDirectCalls` 恒为 false，`dialogueEngineProvider` 永远返回 `BlockedDialogueEngine`。用户即使保存了有效 Key，点发送也只会得到“当前版本暂时无法生成 AI 回复”。这就是“保存 Key 后仍无法进入真实模型调用流程”的直接原因。

V0.4.8 的处理：删除许可门与相关字段，保留两个显式开发开关；`policyAllows` 只判断 Debug + Android/iOS + 两个开关。

### 2.2 主 Manifest 缺少 INTERNET 权限

`android/app/src/main/AndroidManifest.xml` 原本没有 `INTERNET`，只有 `src/debug/AndroidManifest.xml` 有。Debug APK 靠 manifest 合并能用网，但任何非 Debug 构建（Profile/Release/CI）都没有网络权限，表现为“连接失败”。已在主 Manifest 增加 `INTERNET`。

### 2.3 上一轮 Key 从未进入验证流程（并已泄露在文本文件中）

Codex 临时目录的 `Open-DeepSeek-Input.cmd` 第 4 行被误粘贴了一个 **明文 `sk-` 开头密钥**。这是上一轮 Windows 请求一直拿不到有效结果的最可能原因之一：用户把 Key 粘进了脚本文件，而脚本本身不读取它。

本轮处置：

- 该文件已被重写为不含密钥的提示文件；
- 全项目（`lib/`、`test/`、`docs/`、`reports/`、日志）扫描确认没有其他 `sk-` 明文；
- 该 Key 视为已泄露，**必须到 DeepSeek 官方平台删除并重新创建**。DSH 没有使用它，也没有把它写入任何报告。

### 2.4 其他修复

- `settings_page.dart` 与 `feedback_page.dart` 硬编码 `V0.4.6`，在 0.4.8 APK 里仍显示旧版本。新增 `lib/core/app_version.dart` 统一版本号。
- 上一轮遗留的隐藏 WinForms 密钥窗口进程（等待输入约 15 分钟）已终止，避免继续挂着旧窗口。
- `DeepSeekHttpProtocol.listModels` 现在也上报 HTTP 状态，便于独立验证工具记录状态码。

## 3. 修改清单

| 文件 | 修改 |
| --- | --- |
| `lib/features/ai/data/deepseek_config.dart` | 删除许可门字段/常量；`policyAllows` 改为 Debug + 原生 + 两个开发开关；更新限制说明 |
| `lib/features/ai/application/ai_providers.dart` | 不再读取 `DEEPSEEK_NATIVE_BYOK_PERMISSION_GRANTED` |
| `lib/features/ai/data/deepseek_http_protocol.dart` | `/models` 上报 HTTP 状态 |
| `android/app/src/main/AndroidManifest.xml` | 增加 `android.permission.INTERNET` |
| `pubspec.yaml` | 版本 `0.4.6+13` → `0.4.8+14` |
| `lib/core/app_version.dart` | 新增统一显示版本常量 |
| `lib/features/settings/settings_page.dart` | 版本标签改用 `appVersion` |
| `lib/features/settings/feedback_page.dart` | 反馈主题改用 `appVersion` |
| `test/ai/deepseek_connection_test.dart` | 更新策略真值表；验证“无需许可标记”；provider 测试补内存数据库 |
| `test/roleplay_quality_test.dart` | 反馈主题断言跟随 `appVersion` |
| `tool/deepseek_verify.dart` | 新增：stdin 收 Key、单次付费请求、SSE/JSON/usage、脱敏报告 |
| `tool/DeepSeek-Verify.ps1` | 新增：本机 WinForms 遮蔽输入 + 费用同意 + 结果展示 |
| `tool/Open-DeepSeek-Verify.cmd` | 新增：双击入口（Windows PowerShell 5.1 兼容） |
| `docs/REAL_DEEPSEEK_FIX.md` | 更新为两开关构建、移除许可门说明 |
| `BYOK_SECURITY.md` | 删除 Mock 描述，更新 V0.4.8 实际状态 |
| `docs/V048_*.md` | 本轮四份验收/交付文档 |

未改动：数据库 schema（仍为 6）、世界/存档结构、UI 版式、Mock 历史字段读取、其他 AI 供应商、服务器架构。

## 4. 权限与条款口径

本轮按项目所有者的要求，把三件事分开：

1. **普通 API 使用**：开放平台条款 1.1 允许把模型能力集成进下游应用；用用户自己的 Key、在自己的设备上调用官方 API，不需要“单独书面特殊授权”。项目不再用虚构许可标记拦截它。
2. **原生客户端密钥安全**：条款 2.2 要求不得泄露/分享/公开自己的 Key，也不得把它暴露在客户端代码中。本项目：用户自己输入、Android Keystore / iOS Keychain 保护、不进 APK、不进日志/诊断/备份/源码。
3. **公开发行合规**：公开分发一个向终端用户索取 Key 的原生客户端，仍需单独复核 2.2 的适用性、告知与隐私要求。因此 **Profile/Release 仍硬性禁用直连**，这是代码级发布决定，不是构建参数。本轮没有、也不会宣称已获得 DeepSeek 特殊授权。

## 5. 验证结果

| 命令 | 结果 |
| --- | --- |
| `flutter analyze --no-fatal-infos` | No issues found |
| `flutter test` | 259 项通过 |
| `flutter build apk --debug --dart-define=DEEPSEEK_EXPERIMENTAL=true --dart-define=DEEPSEEK_REAL_API_DEV_TEST=true` | 成功 |
| Windows 真实请求 | HTTP 200，139 Token，见 [V048_REAL_API_TEST.md](V048_REAL_API_TEST.md) |
| Android 模拟器 | Android 17（API 37）安装/启动/直连开关/Keystore 保存/重启/删除全部通过 |

## 6. 复现命令

```powershell
Set-Location 'C:\Users\lin\Desktop\FishTextAdventure'
flutter analyze
flutter test
flutter build apk --debug `
  --dart-define=DEEPSEEK_EXPERIMENTAL=true `
  --dart-define=DEEPSEEK_REAL_API_DEV_TEST=true
```

真实请求验证：双击 `tool\Open-DeepSeek-Verify.cmd`，在本机窗口输入 Key；付费按钮每次窗口最多一次。

## 7. 环境备注

`flutter clean` 会清掉 Windows 测试用的预编译 SQLite DLL。本机访问 GitHub Release 偶发超时，表现为 `flutter test` 报 `Building native assets failed`。恢复办法：重新下载 `sqlite3.x64.windows.dll`（SHA-256 `643956b0…2028`）到 `.dart_tool/hooks_runner/shared/sqlite3/build/download-643956b0/sqlite3.dll`，或保证网络后重跑 `flutter test`。这是工具链缓存问题，不是产品缺陷。
