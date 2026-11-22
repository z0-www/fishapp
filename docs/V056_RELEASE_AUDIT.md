# 鱼者文游 V0.5.6+31 · 可发布性审计

**结论：当前这个 APK 不能作为正式版本发布。** 它可以作为私下测试包，但存在 4 个硬阻断（构建形态、签名、正式构建未签名、正式版 AI 关闭）和若干合规/资料缺口。代码质量与自动化测试本身没有问题。

审计时间：2026-11-19。审计对象：`build/app/outputs/flutter-apk/鱼者文游-V0.5.6+31-Debug.apk`。

## 1. 审计对象与基线

| 项目 | 值 |
| --- | --- |
| APK | `鱼者文游-V0.5.6+31-Debug.apk` |
| 大小 | 181,745,619 字节（约 173 MiB） |
| SHA-256 | `6A8B6A5FE08BA4325CCB468A8FBA08F0899B73BBF4EF85DD4E4D256C2D8E4606` |
| versionName / versionCode | 0.5.6 / 31 |
| minSdk / targetSdk | 24 / 36 |
| 权限 | 仅 `INTERNET`（另有系统自动生成的动态接收器权限） |
| 16 KB 页对齐 | 通过（`zipalign -c -P 16` Verification successful） |
| `flutter analyze` | 无问题（本轮复跑） |
| `flutter test` | **295 项全部通过**（本轮复跑） |

## 2. 硬阻断（不解决就不能发布）

### 2.1 这是 Debug 构建，不是发布构建

- Manifest 带 `application-debuggable`；
- 包含 `assets/flutter_assets/kernel_blob.bin`（119,386,384 字节，JIT 内核快照）；
- 体积 181 MB，启动与运行都慢于 Release；
- `debuggable=true` 意味着在开启 USB 调试的设备上可通过 `run-as` 读取应用私有数据（世界、聊天、存档）。对一个存本地故事的 App，这是真实的隐私风险；
- 应用商店会直接拒绝 debuggable 包。

### 2.2 使用 Android Debug 证书签名

```
Signer #1 certificate DN: C=US, O=Android, CN=Android Debug
Signer #1 certificate SHA-256: 69f8f902194447bd3fd82a13d8a517266fae547cb0faf69c961425f91265f2d6
Verified using v2 scheme: true
```

Debug 证书不是发布身份。更严重的是升级路径：如果用户先装这个 Debug 签名包，之后换成正式签名包，Android 会因签名不一致拒绝覆盖安装，用户必须先卸载，**本地世界和聊天会一起消失**（除非事先导出 `.yuzhe` 备份）。

### 2.3 正式构建产物未签名，无法安装

本轮实际执行了 `flutter build apk --release`：

| 项目 | 值 |
| --- | --- |
| 产物 | `build/app/outputs/flutter-apk/app-release.apk`（已重命名为 `app-release-UNSIGNED-do-not-publish.apk`） |
| 大小 | 69,505,308 字节 |
| SHA-256 | `D738C021942DE81B8BE6D83B96E7F84836BC7ABBDE57041001C314CDAB111F60` |
| `apksigner verify` | **DOES NOT VERIFY — Missing META-INF/MANIFEST.MF** |
| 签名配置 | `android/key.properties` 不存在，也没有任何 keystore |

`android/app/build.gradle.kts` 只有在 `android/key.properties` 存在时才创建 release 签名；否则 release 的 `signingConfig` 为 null（只有设置 `FISH_INTERNAL_RELEASE_CANDIDATE=1` 才临时回退 Debug 签名，这只能用于内部测试）。所以现在没有可安装、可分发的正式包。

目录里另有一个 `鱼者文游-V0.5.2+27-Release-候选.apk`（68,448,366 字节，SHA-256 `672BADEB4FA35CC921403E3E295393C970FB7940A7A3199A265A59DA72F12C2F`）。它确实是 Release 模式（无 `application-debuggable`），但证书仍是 `CN=Android Debug`，走的是内部候选回退路径，版本也停留在 0.5.2+27。**它同样不能公开发布**，只能内部安装测试。

### 2.4 正式版会关闭 AI 直连

`lib/features/ai/data/deepseek_config.dart`：

```dart
static const _androidReleaseReviewed = false;
static const _iosReleaseReviewed = false;
```

`permitsDirectCalls` 在 Release 下依赖 `releaseAllowed`，两个平台都是 false。也就是说：**即使现在补上签名打 Release，App 里的生成功能也会提示“当前构建未启用 DeepSeek 直连”**，核心体验直接缺失。要带 AI 发布，必须完成分发合规复核后，把对应平台改为 true 的**一次经评审代码修改**，不能靠构建参数或运行时开关绕过。

### 2.5 原生 BYOK 公开分发仍未复核

项目自己的 `V056_ACCEPTANCE.md` 也写明：Android Release 真实 API“发布审核开关保持关闭”。公开分发一个向终端用户索取 API Key 的原生客户端，涉及 DeepSeek 条款 2.2 的适用性、告知与隐私要求；在完成复核前，不应把它当作“已获授权”发布。

## 3. 发布前还应补齐

| 项目 | 现状 | 影响 |
| --- | --- | --- |
| AI 内容举报入口 | 只有邮箱反馈，无应用内举报 | 应用商店对生成式 AI 内容通常要求可举报/处置渠道 |
| 隐私政策公网地址 | 只有 App 内文本 | 商店与合规材料需要可访问的 URL |
| 分享链接导入 | 公开样本 HTTP 429，未取得正文 | 该功能对外不可用，需在发布说明中标注或继续关闭 |
| iOS | 未编译、未真机、未签名 | 不能宣称支持 iOS |
| Git 历史 | `master` 仍无首次提交 | 发布溯源、回滚、审计都缺依据 |
| README 版本 | 已从 V0.4.8+22 更正为 V0.5.6+31 | 文档一致性 |
| 商店材料 | 软著、ICP/App 备案、隐私清单、AI 合规说明等未准备 | 国内商店上架必需 |

## 4. 这个 Debug 包实际能做什么（本轮实测）

在 Android 17（API 37）模拟器全新安装后：

- 首次启动正确显示「欢迎来到鱼者文游」产品声明，四项内容完整、可滚动；
- 点击「进入鱼者」正常进入首页；
- 强制停止后重启，**不再重复弹出**；
- 全程无 FATAL/ANR，未配置 Key 时没有发起 AI 请求；
- 设置页显示版本 V0.5.6，「关于鱼者」内含产品声明入口。

截图：`reports/v056_publish_1.png`（首次声明）· `reports/v056_publish_3.png`（首页）· `reports/v056_publish_7.png`（设置）。

**因此它适合私下测试，但不适合公开分发。**

## 5. 要发布，按这个顺序做

### 5.1 建立正式签名（一次性）

```powershell
Set-Location 'C:\Users\lin\Desktop\FishTextAdventure'
keytool -genkeypair -v -keystore android/release-upload.jks `
  -alias yuzhe -keyalg RSA -keysize 4096 -validity 10000
```

把口令写入 `android/key.properties`（已在 `.gitignore` 中，勿提交）：

```
storeFile=release-upload.jks
storePassword=...
keyAlias=yuzhe
keyPassword=...
```

**务必备份 keystore 与口令**；丢失后无法再发布可覆盖升级的版本。

### 5.2 决定并完成 AI 发布合规

三选一，必须由项目所有者明确决定：

1. **带 AI 发布**：完成 BYOK 公开分发复核、隐私告知、AI 内容举报渠道，然后把对应平台的 `_androidReleaseReviewed` / `_iosReleaseReviewed` 改为 true（经评审的代码修改），再构建发布。
2. **不带 AI 发布**：保持开关 false，发布说明必须明确“本版本不含在线 AI 生成”，否则用户会认为功能坏了。
3. **暂不发布**：继续私下测试，等合规完成。

### 5.3 构建并验证正式包

```powershell
flutter build appbundle --release      # Google Play
# 或
flutter build apk --release            # 国内商店/侧载

# 验证
apksigner verify --print-certs -v build/app/outputs/flutter-apk/app-release.apk
aapt2 dump badging build/app/outputs/flutter-apk/app-release.apk
```

必须确认：`DOES NOT VERIFY` 不再出现、证书是正式证书、无 `application-debuggable`、无 `kernel_blob.bin`、`versionCode` 递增、真机安装并跑通关键流程。

### 5.4 真机与商店验收

- 在至少一台真实 Android 手机上安装正式包，走完：首次声明 → 本地世界 → 配置 Key → 手动测试连接 → 一轮生成 → 重启存档；
- 验证导入、`.yuzhe` 完整备份与恢复；
- 补齐隐私政策 URL、AI 内容举报、商店截图与描述、软著/备案材料。

## 6. 一句话结论

**代码可以测，包不能发。** 当前产物是 Debug 调试包，正式构建又未签名且会关闭 AI；先把签名与 AI 发布策略定下来，再谈上架。
