# GitHub Actions 构建 iOS 未签名 IPA（私有仓库）

本文只使用**未签名 IPA**：不需要 Apple 开发者证书、不需要私钥、不需要把 Key 放进仓库。
真正的签名由你在 Windows 上用 Sideloadly + 自己的 Apple ID 完成。

> 当前状态：本机没有 GitHub 远程仓库、没有 `gh` 登录、没有 GitHub Token，也没有 macOS。
> 因此 **Actions 没有实际运行，IPA 没有生成**。下面是你本人完成外部账号步骤后的最短路径。

## 1. 当前条件核查（真实结果）

| 条件 | 结果 |
| --- | --- |
| Git 仓库 | 有（`integration/cross-platform` 分支） |
| GitHub remote | **无**（`git remote -v` 为空） |
| `gh` CLI | **未安装** |
| GitHub Token | **无** |
| macOS / Xcode | **无**（Windows 11） |
| `flutter build ios` | 本机报 `Could not find a subcommand named "ios"`（Windows 不支持） |
| 工作流 YAML | 已用 PyYAML 解析通过 |
| `project.pbxproj` | 已用 `pbxproj` 解析：RunnerTests / Runner / ShareExtension 三个 target |
| iOS 静态检查 | `python tool/ios/check_ios_project.py` → 31/31 通过 |
| Shell 脚本语法 | `bash -n tool/ios/build_unsigned_ipa.sh` → 通过 |

结论：代码侧能做的准备已经完成；**外部阻塞是 GitHub 账号/仓库授权和 macOS Runner**。
不会擅自把你的源码推到任何地方。

## 2. 推送前安全检查

在项目根目录执行：

```powershell
python tool\git\check_push_safety.py
```

它会检查：

- 是否跟踪了 `.jks/.keystore/.p12/.p8/.mobileprovision/.ipa/.env/key.properties`；
- 是否跟踪了 `dist/`、`reports/`、`build/`；
- 文本里是否有私钥块、`sk-` 长密钥、AWS/GitHub/Slack/Google 令牌；
- 是否有超过 20 MiB 的异常文件。

当前结果：**没有凭据类文件或字面密钥**；只有 23 个历史文档包含本机路径的警告
（私有仓库可接受，公开仓库建议清理）。

> 不要提交 `ios/Podfile.lock` 里的私有源、不要提交任何签名文件、不要把 API Key
> 写进 `dart-define`、环境变量文件或 Actions secrets 之外的任何地方。
> 未签名工作流**不需要任何 secrets**。

## 3. 创建私有仓库并推送

1. 在 GitHub 新建仓库：
   - 名称例如 `FishTextAdventure-private`；
   - 选择 **Private**；
   - **不要**勾选初始化 README / .gitignore（本地已有）。
2. 在本机项目目录：

   ```powershell
   git status                      # 应干净
   git remote add origin https://github.com/<你的账号>/FishTextAdventure-private.git
   git push -u origin integration/cross-platform
   ```

   如果只想推送一个分支：

   ```powershell
   git push -u origin integration/cross-platform:main
   ```

3. 打开仓库 → **Settings → Actions → General**，确认允许 Actions。
4. 不需要配置 Secrets（未签名构建）。

## 4. 运行 iOS 构建

1. 仓库 → **Actions**。
2. 左侧选择 **iOS unsigned IPA**。
3. 右侧 **Run workflow** → 选择分支 → **Run workflow**。
4. 等待 `Build unsigned IPA` 完成（首次通常 10–25 分钟，含 Flutter/SPM 缓存）。
5. 打开运行记录 → 页面底部 **Artifacts** → 下载：
   - `fishtextadventure-ios-unsigned-<run_number>`：IPA
   - `fishtextadventure-ios-build-log-<run_number>`：失败时的日志/诊断

工作流会实际执行：

```bash
flutter config --enable-swift-package-manager
plutil -lint ...
xcodebuild -list -project ios/Runner.xcodeproj
python3 tool/ios/check_ios_project.py
flutter precache --ios
bash tool/ios/build_unsigned_ipa.sh
```

`build_unsigned_ipa.sh` 会：

- `flutter build ios --release --no-codesign --dart-define=FISH_IOS_BYOK=true`
- 校验 `Runner.app` 的 Bundle ID、版本号、build number、App.framework、
  ShareExtension、两份 PrivacyInfo；
- 打包 `Payload/Runner.app` 成 `.ipa`；
- 校验 IPA 中确实有 `Runner`、`Info.plist`、`App.framework/App`、
  `PlugIns/ShareExtension.appex/Info.plist`。

> 这仍然只是“未签名 IPA 生成成功”。签不签得过、装不装得上，要看 Sideloadly 和真机。

## 5. 下载后本地核验（Windows 可做）

```powershell
# 看 IPA 是否是标准 Payload 结构
tar -tf FishTextAdventure-0.5.8-unsigned.ipa
# 或
Expand-Archive -Path FishTextAdventure-0.5.8-unsigned.ipa -DestinationPath ipa-check
Get-Item ipa-check\Payload\Runner.app\Info.plist
```

`Info.plist` 是二进制 plist；用 Python：

```python
import plistlib
with open(r"ipa-check/Payload/Runner.app/Info.plist", "rb") as f:
    p = plistlib.load(f)
print(p["CFBundleIdentifier"], p["CFBundleShortVersionString"], p["CFBundleVersion"])
```

期望：

```text
com.yuzhe.fishtextadventure 0.5.8 34
```

## 6. Sideloadly 免费签名（Windows）

1. 安装 iTunes（或 Apple Devices）与 [Sideloadly](https://sideloadly.io/)。
2. 数据线连接 iPhone，解锁并“信任此电脑”。
3. 把未签名 IPA 拖进 Sideloadly。
4. 填自己的 Apple ID；建议用 App 专用密码，减少 2FA 弹窗。
5. Start，等待完成。
6. iPhone：设置 → 通用 → VPN 与设备管理 → 信任开发者。
7. iOS 16+：设置 → 隐私与安全性 → 开发者模式 → 打开并重启。
8. 打开鱼者，配置自己的 DeepSeek Key 后测试。

免费 Apple ID 的限制（必须告知用户）：

- **7 天到期**，过期后需要重新签名；重装前先导出 `.yuzhe`。
- 最多同时 3 个侧载应用。
- **App Group 会被剥离**：系统分享扩展不可用；本项目已做沙盒回退，
  应用内“从本机选择文件”和 `.yuzhe` 导入/导出仍可用。
- 不会生成“永久可用”的免费签名；任何声称通用的已签名 IPA 都不可信。

## 7. 构建失败时怎么反馈

把 Actions 运行记录中的以下内容发回：

- 失败步骤名称与最后 80 行日志；
- `ios-build-log-<run>` artifact；
- Xcode 版本（`xcodebuild -version`）与 Flutter 版本。

常见原因：

| 错误 | 处理 |
| --- | --- |
| `No such module 'Flutter'` / SPM package missing | 确认工作流执行了 `flutter config --enable-swift-package-manager`，并重新 `flutter pub get` |
| `Podfile` / CocoaPods 相关 | 当前 iOS 插件均为 SPM 或 Dart FFI；若后续新增 pod-only 插件，需要加标准 Podfile 并验证 |
| `Signing for "Runner" requires a development team` | 未签名工作流不应签名；检查是否误用了 `flutter build ipa` 而不是 `build ios --no-codesign` |
| `ShareExtension.appex missing` | 检查 `project.pbxproj` 的 Embed App Extensions 和依赖；本地静态检查应能发现 |
| `Info.plist` 版本不匹配 | 检查 `pubspec.yaml` 的 `version: 0.5.8+34` 是否被改动 |
| Xcode too old/new | `macos-15` runner 默认 Xcode 可能变化；在日志中记录版本，必要时固定 `xcode-version` |

## 8. TestFlight / 正式签名（未来）

`.github/workflows/ios-signed-testflight.yml` 是模板，需要：

- 付费 Apple Developer Program；
- App Store Connect API Key；
- Runner 与 ShareExtension 的证书/描述文件/App Group；
- repository secrets：`IOS_TEAM_ID`、`APPSTORE_KEY_ID`、`APPSTORE_ISSUER_ID`、`APPSTORE_KEY_P8`。

该模板**没有执行过**，不要当作已验证的发布流水线。TestFlight 还需要 Beta 审核，
App Store 还需要隐私标签、出口合规、内容分级与 AI 内容说明。

## 9. 重要边界

- 不把源码推到公开仓库；私有仓库由你创建。
- 不上传签名证书/私钥/描述文件；未签名工作流不需要它们。
- 不把用户 `.yuzhe`、数据库、日志上传到仓库。
- 不虚报“IPA 已经真机验收”；只有你完成 Sideloadly 安装并逐项测试后才算通过。
