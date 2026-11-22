# iOS 原生版构建、签名与免费安装指南

## 0. 四种状态必须分开说

| 状态 | 当前结果 | 证据 |
| --- | --- | --- |
| 代码/工程静态检查 | ✅ 通过 31/31 | `python tool/ios/check_ios_project.py` |
| Xcode 工程解析 | ✅ 通过（RunnerTests / Runner / ShareExtension） | `pbxproj` 解析器 |
| Xcode 编译通过 | ❌ **未验证** | Windows 无 iOS 构建目标；`flutter build ios` 返回 “Could not find a subcommand named ios” |
| 生成可签名 IPA | ❌ **未生成** | 需在 macOS 或 GitHub Actions 上执行 |
| 签名成功 | ❌ **未验证** | 无 Apple 账号/证书 |
| 真机安装运行 | ❌ **未验证** | 无 iPhone 连接与构建产物 |

> 第二阶段已核查：本机没有 GitHub remote / `gh` 登录 / Token，也没有 macOS，
> 因此 Actions 未运行、IPA 未生成。上传私有仓库与运行 Actions 的步骤见
> [GITHUB_IOS_ACTIONS.md](GITHUB_IOS_ACTIONS.md)。

> 不能用“工程看起来完整”冒充“iPhone 上跑通”。以下步骤是真实可执行的路径，
> 但在你完成 macOS 构建之前，不能对外说 iOS 版已可安装。

## 1. 本次对 iOS 工程做的实际修改

1. **修复工程完整性风险**：确认 `ShareIntakeBridge.swift`、`ShareInbox.swift` 同时编入
   Runner 与 ShareExtension 目标；分享扩展已嵌入主应用。
2. **App Group 降级**：免费 Apple ID 经 Sideloadly 签名时 App Group 会被剥离。
   `ShareInbox.root()` 在拿不到 App Group 时回退到应用自己的 Application Support，
   因此 **Files 文件选择、`.yuzhe` 导入/导出仍然可用**；系统分享扩展在这种签名下不可用，
   会明确失败而不是假装成功。
3. **隐私清单**：新增 `Runner/PrivacyInfo.xcprivacy` 与
   `ShareExtension/PrivacyInfo.xcprivacy`，并加入各自 Resources 构建阶段
   （iOS 17+ 审核要求；本次只声明不使用跟踪，文件时间戳 API 理由 C617.1）。
4. **Info.plist**：开发区域改为 `zh_CN`，增加 `zh-Hans/en` 本地化；
   显式关闭 ATS 任意加载（`NSAllowsArbitraryLoads=false`）。
5. **iOS 正式版 BYOK 开关**：`FISH_IOS_BYOK=true` 编译时允许个人签名/侧载 IPA
   使用真实 DeepSeek 直连。不设置时维持“iOS 发布需独立审核”的保守策略。
   App Store/TestFlight 不应默默带这个开关。
6. **Keychain**：`flutter_secure_storage` 使用 `unlocked_this_device`、不同步、独立服务名；
   Runner 的 Keychain entitlement 保留，Share Extension 只有 App Group（最小权限）。
7. **构建配置**：新增 `tool/ios/build_unsigned_ipa.sh`、静态检查脚本、
   GitHub Actions 未签名 IPA 工作流和 TestFlight 签名工作流模板。

## 2. 推荐路径 A：GitHub Actions 生成未签名 IPA（无需 Mac）

前提：你愿意把源码放到 GitHub 仓库。**DSH 没有上传任何代码**，这一步需要你本人操作。

1. 在 GitHub 新建仓库（建议 Private）。
2. 在本机项目目录执行：

   ```powershell
   git remote add origin https://github.com/<你的账号>/<仓库名>.git
   git push -u origin feature/web-pwa
   # 或合并到 main 后推送
   ```

3. 打开仓库 **Actions → iOS unsigned IPA → Run workflow**。
4. 等待 macOS runner 构建完成，下载 artifact `fishtextadventure-ios-unsigned`。
5. 解压得到 `FishTextAdventure-0.5.8-unsigned.ipa`。

说明：

- 工作流使用 `macos-15` + Flutter 3.50.0 + Xcode 自带工具链。
- 会先跑静态检查，再 `flutter build ios --release --no-codesign`，
  最后把 `Runner.app` 打成 `Payload/*.ipa`。
- **未签名 IPA 不能直接安装**；必须用 Sideloadly/SideStore/Xcode 签名。
- 如果第一次运行失败，优先看日志中的插件/SPM/CocoaPods 错误；
  本项目当前没有 Podfile，构建脚本会执行
  `flutter config --enable-swift-package-manager`，与工程内的
  `FlutterGeneratedPluginSwiftPackage` 引用一致。若未来新增只支持 CocoaPods 的插件，
  需要在 `ios/` 增加标准 Podfile 并重新验证（见第 7 节）。

## 3. 推荐路径 B：有 Mac 时直接构建

```bash
# 在 macOS + Xcode 环境
bash tool/ios/build_unsigned_ipa.sh
```

脚本会：检查 Flutter/Xcode → 启用 SPM → `pub get` → 静态审计 →
`flutter build ios --release --no-codesign --dart-define=FISH_IOS_BYOK=true` →
生成 `dist/ios/FishTextAdventure-<版本>-unsigned.ipa`。

如需直接在 Xcode 真机调试：

```bash
open ios/Runner.xcworkspace
```

在 Xcode：

1. Runner target → Signing & Capabilities → 选择自己的 Team（免费 Apple ID 也可）。
2. 为 Runner 与 ShareExtension 配置同一个 App Group
   `group.com.yuzhe.fishtextadventure`（付费账号；免费账号没有该能力）。
3. 连接 iPhone，选择设备，Run。

## 4. Sideloadly 免费安装教程（Windows）

> 适用：没有 Mac、没有付费开发者账号，只想在自己的 iPhone 上短期使用。
> 免费账号限制：**7 天过期、最多 3 个侧载应用、App Group 被剥离**。

准备：

- Windows 电脑、数据线、iPhone。
- 安装 [iTunes](https://www.apple.com/itunes/)（或 Apple Devices）与
  [Sideloadly](https://sideloadly.io/)。
- 从第 2 节拿到未签名 IPA。

步骤：

1. 用数据线连接 iPhone，解锁并在手机上点“信任此电脑”。
2. 打开 Sideloadly，把 `.ipa` 拖进窗口。
3. `Apple account` 填你的 Apple ID；建议先到
   [appleid.apple.com](https://appleid.apple.com/) 生成 App 专用密码并填到密码框，
   避免 2FA 反复弹窗。
4. 点 **Start**，等待注入与安装完成。
5. iPhone 上首次打开会提示“不受信任的开发者”：
   设置 → 通用 → VPN 与设备管理 → 开发者 App → 信任你的 Apple ID。
6. iOS 16 及以上还需要：设置 → 隐私与安全性 → **开发者模式** → 打开 → 重启手机。
7. 打开鱼者文游；在「AI 服务设置」里填入自己的 DeepSeek Key。

免费签名下会发生什么：

- **可以**：创建世界、编辑设定、使用 AI 对话、导出/导入 `.yuzhe`（通过应用内“文件选择”）。
- **不可以**：系统分享面板里的“鱼者文游”扩展（因为 App Group 被剥离）。
  应用会引导你改用“导入故事 → 从本机选择文件”。
- 7 天后应用会打不开，需要重新用 Sideloadly 签名；故事存档在应用沙盒里，
  **重装前务必先导出 `.yuzhe` 到“文件”App，否则会丢失**。

## 5. 真机验收清单（拿到 IPA 后逐项打勾）

- [ ] 首次启动显示产品/费用声明，可进入首页。
- [ ] iPhone 刘海/灵动岛、底部 Home 指示条不遮挡内容（SafeArea）。
- [ ] 键盘弹出时输入框和发送按钮可见（角色页、世界创建、设置）。
- [ ] API Key 保存后杀进程重启仍能读取（Keychain）。
- [ ] 删除 Key 后不再发起请求。
- [ ] 无 Key 时有明确提示，不生成假剧情。
- [ ] 有 Key 时连接测试显示真实模型名与耗时。
- [ ] 角色页发送行动 → 费用确认 → 真实流式回复 → 重启后剧情恢复。
- [ ] 导出 `.yuzhe` 到“文件”，换目录/重装前可再次导入恢复。
- [ ] 系统分享（仅付费签名/App Group 可用）能出现在分享面板。
- [ ] 断网/飞行模式提示网络错误，不伪造回复。

## 6. TestFlight / App Store（未来）

1. 需要付费 Apple Developer Program（$99/年）与 App Store Connect 应用记录。
2. 在 Xcode 为 Runner 与 ShareExtension 配置 App Group、签名与 Capabilities。
3. 使用 `.github/workflows/ios-signed-testflight.yml` 模板，配置：
   `IOS_TEAM_ID`、`APPSTORE_KEY_ID`、`APPSTORE_ISSUER_ID`、`APPSTORE_KEY_P8`。
4. 该模板**尚未实际运行**，首次使用需要补齐证书、描述文件和 Apple 账号授权。
5. TestFlight 外部测试需要 Beta App Review；App Store 上架还需：
   - 隐私政策 URL（项目已有 `docs/privacy-policy.html`，需自行部署）；
   - App 隐私标签（用户内容会发送给 DeepSeek）；
   - 出口合规（本地 `.yuzhe` 使用 AES-GCM/PBKDF2，应按实际情况回答，
     不要直接填“不使用加密”）；
   - 内容分级、AI 生成内容说明、BYOK 与第三方服务告知。
6. App Store 版本是否启用 `FISH_IOS_BYOK` 必须单独评审；
   不能把“个人侧载可用”当成“商店审核已通过”。

## 7. 权限与网络安全设置

- **不需要**相机、麦克风、相册、通讯录、定位权限；没有对应的 Info.plist 用途说明。
- 文件导入使用系统文档选择器（`UIDocumentPickerViewController`），由用户在系统 UI 中授权，
  应用只读取用户选中的单个文件；`.yuzhe` 导出也走系统导出面板。
- 分享扩展只接收文本/URL/图片/文件（最多 16 个），不访问网络。
- ATS：`NSAllowsArbitraryLoads=false`，只允许 HTTPS。DeepSeek 端点为
  `https://api.deepseek.com`，不需要任何明文例外。
- 剪贴板读取只发生在用户点击“粘贴”时；API Key 输入关闭自动纠错、建议与自动填充。
- Keychain：`unlocked_this_device`、不同步 iCloud；Share Extension 不读取 Keychain。
- 未添加后台模式、定位、蓝牙等多余权限。

## 8. 常见问题

**Q: `flutter build ios` 报找不到 Podfile / 插件？**
A: 本项目按 SPM 集成配置。先执行 `flutter config --enable-swift-package-manager`。
如未来有插件只支持 CocoaPods，在 `ios/` 增加官方模板 Podfile（`platform :ios, '15.0'` +
`flutter_install_all_ios_pods`），再 `pod install`，并重新跑静态检查与真机构建。

**Q: Sideloadly 报 entitlements / App Groups 错误？**
A: 免费账号没有 App Groups。Sideloadly 通常会剥离该 entitlement；
本项目已为“文件选择导入”做了沙盒回退，系统分享扩展会不可用。若签名仍失败，
在 Xcode 中把两个 target 的 App Group capability 暂时移除后再导出（需自行承担
系统分享不可用），或使用付费账号。

**Q: 为什么不能直接给我一个已签名的 IPA？**
A: iOS 签名与设备 UDID/证书绑定，且需要你的 Apple 账号授权。任何声称“通用已签名 IPA”
的产物都无法在未越狱设备上安装；本项目不会伪造这种文件。

**Q: 7 天到期后存档还在吗？**
A: 应用过期后无法启动，但沙盒数据通常保留到卸载/重装。重新签名覆盖安装一般保留数据；
卸载会清除。**请在到期前导出 `.yuzhe`**。
