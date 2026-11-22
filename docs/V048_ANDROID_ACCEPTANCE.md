# 鱼者文游 V0.4.8 · Android 验收

## 1. 交付 APK

| 项目 | 值 |
| --- | --- |
| 路径 | `build/app/outputs/flutter-apk/app-debug.apk` |
| 包名 | `com.yuzhe.fishtextadventure` |
| versionName / versionCode | **0.4.8 / 14** |
| 大小 | 180,651,885 字节（约 172 MiB，Debug JIT 包，体积偏大属正常） |
| SHA-256 | `DFEDC860169649C3EE3A0448480F165F8AF2D1D4986C191170869080E2316222` |
| SHA-1 | `F20636928C38C479D2B1BE08004B91F112D5F1BD` |
| minSdk / targetSdk | 24 / 36 |
| INTERNET 权限 | 已在主 Manifest 声明，APK 中可见 |
| 构建命令 | `flutter build apk --debug --dart-define=DEEPSEEK_EXPERIMENTAL=true --dart-define=DEEPSEEK_REAL_API_DEV_TEST=true` |

这是**私下验收包**，不是正式发行包。Release/Profile 仍然禁止直连。

## 2. 已在 Android 17 模拟器完成的实测

设备：`sdk_gphone64_x86_64`，Android 17（API 37），`emulator-5554`。

| 验证项 | 结果 | 证据 |
| --- | --- | --- |
| 安装 | 通过（`adb install -r -t`，Success） | — |
| 启动 | 通过，无崩溃 | `reports/v048_emulator_1.png` |
| 真实直连构建门 | **已启用**：开发诊断显示“原生真实直连开发测试已启用”，且无任何限制条目 | `reports/v048_emulator_6.png` |
| 保存 Key 到安全存储 | 通过，显示“API Key 已保存：••••••••” | `reports/v048_emulator_10.png` |
| 关闭 Key 后不伪造连接 | 未配置时“手动测试连接”不出现 | `reports/v048_emulator_5.png` |
| 进程强杀后重启 | 通过，直接进入首页（Key 仍在），非欢迎页 | `reports/v048_emulator_11.png` |
| 删除 Key | 通过，显示“密钥已删除；本地世界已保留” | `reports/v048_emulator_13.png` |
| 安全存储实现 | `shared_prefs` 中只有 Keystore 包装密钥与 AES-GCM 密文；**未发现明文 `sk-`** | 见下 |
| 版本显示 | 设置页显示 `FishTextAdventure · V0.4.8` | `reports/v048_emulator_17.png` |

安全存储实测细节（使用一次性假占位 Key，不是真实凭据，验证后已删除）：

- `shared_prefs/FlutterSecureKeyStorage:fish_api_credentials.xml`：AES 密钥被 RSA 包装；
- `shared_prefs/FlutterSecureStorageConfiguration:fish_api_credentials.xml`：`AES_GCM_NoPadding` + `RSA_ECB_OAEPwithSHA_256andMGF1Padding`；
- `shared_prefs/fish_api_credentials.xml`：EncryptedSharedPreferences 密文，扫描无 `sk-` 明文。

## 3. 尚未完成：真机实时生成

`adb devices` 仍为空，没有检测到用户手机；本轮费用授权是一次 Windows 请求，没有在 Android 上再发付费生成请求。因此：

- **Android 端 HTTP 200 / 真实 Token 用量：未取得**，不能用模拟器安装成功代替；
- 已证明的是“APK 具备真实调用资格、网络权限存在、Key 能安全保存并在重启后读取”，剩下的一步是用户在手机上输入自己的 Key 并确认一次预算。

## 4. 手机连接步骤

### 4.1 USB 调试（推荐）

1. 手机：设置 → 关于手机 → 连续点击“版本号”7 次，开启开发者选项。
2. 开发者选项 → 打开“USB 调试”。
3. USB 线连接电脑，手机弹窗选择“允许 USB 调试”，并勾选“始终允许”。
4. 电脑执行：

```powershell
Set-Location 'C:\Users\lin\AppData\Local\Android\Sdk\platform-tools'
.\adb devices -l
```

看到 `<序列号>  device` 即可。若显示 `unauthorized`，在手机上重新确认授权；若 `offline`，拔插数据线或执行 `adb kill-server` 后重试。

### 4.2 无线调试（Android 11+，备用）

手机与电脑同一 Wi-Fi。开发者选项 → 无线调试 → 使用配对码配对：

```powershell
.\adb pair <手机IP>:<配对端口>
.\adb connect <手机IP>:<调试端口>
.\adb devices
```

### 4.3 ADB 仍不可用时：手动安装

1. 把 `build\app\outputs\flutter-apk\app-debug.apk` 通过 USB/网盘/聊天工具传到手机；
2. 在手机文件管理器点击 APK，允许“安装未知应用”；
3. 打开 App → 设置 → AI 服务设置 → 配置 API Key；
4. 用 App 内的“开发诊断”“手动测试连接”“用量与预算”完成同样的验收。

不需要 ADB 也能完成全部功能验收，ADB 只用于自动安装和截图。

## 5. 手机端验收清单（逐项记录）

| 步骤 | 预期 |
| --- | --- |
| 设置 → AI 服务设置 → 开发诊断 | “原生真实直连开发测试已启用”，无限制条目 |
| 配置 API Key → 保存 → 确认 | “API Key 已保存：••••••••”，状态“已配置，等待连接” |
| 手动测试连接 → 确认费用 | 显示“最近验证：deepseek-flash · N ms”；费用记录增加一条真实用量 |
| 创建/进入自定义世界，确认 NPC 设定 | NPC 名称、性格、地点按设定出现 |
| 输入自由行动 → 确认预算 | 收到真实 DeepSeek 回复；台词与旁白分角色显示 |
| 查看“用量与预算” | 有输入/输出/缓存 Token 记录 |
| 重启 App | Key、聊天历史、世界状态仍在 |
| 关闭网络或删除 Key 后再发送 | 明确错误提示；**不出现任何模拟回复** |

记录建议：应用版本（设置页 V0.4.8）、测试时间、连接状态、HTTP 状态（如界面给出）、返回用量、存档结果。

## 6. 已知限制

- Debug APK 约 172 MiB，安装与启动比 Release 慢；
- 正式发行直连仍锁定，公开分发前必须单独复核条款；
- 分享链接自动读取仍默认关闭（许可未确认），可继续用 ZIP/TXT/JSON/粘贴导入；
- iOS 未在 Windows 构建或验收。
