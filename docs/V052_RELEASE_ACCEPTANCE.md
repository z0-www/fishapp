# 鱼者文游 V0.5.2+27 · 发布验收

## 分阶段结果

| 阶段 | 实际证据 |
| --- | --- |
| V0.4.9 API | 分析通过，272 项自动化测试通过。Windows 1 次最小请求和 10 轮真实剧情均返回 HTTP 200。 |
| V0.5.0 备份、导入与安全 | 275 项全量测试和 Android Debug 构建通过。随后导入 52 项专项、导入与安全联合 55 项专项通过。 |
| V0.5.1 iOS 准备 | 4 个 plist / entitlements 文件 XML 解析，静态分析和 21 项专项测试通过。Windows Flutter 无 iOS 构建子命令。 |
| V0.5.2 回归 | 依赖解析、静态分析和 278 项全量测试通过，两个 Android APK 均构建和验签成功。 |

## 平台状态

| 平台 | 已实现或已构建 | 已实测 | 尚未验证 |
| --- | --- | --- | --- |
| Windows 开发工具 | 共享官方 HTTPS、JSON 和 SSE 传输 | 11 次 HTTP 200，输入 5,446、输出 802、缓存命中 3,584、总计 6,248 Token | 移动端 Keychain / Keystore、手机端保存与恢复 |
| Android Debug | 默认可使用局部开发直连，完整备份和恢复，脱敏连接诊断；Debug APK 构建和验签通过。 | Android 模拟器安装和冷启动通过；无连线真机 | 有效与无效 Key、断网、真实 10 轮、实机存档恢复和文件选择器往返 |
| Android Release | Release APK 已构建，使用 Android Debug 证书作为内部候选，正式直连仍关闭；Android 模拟器冷启动通过。 | 参看 APK 构建和证书核验 | 正式密钥签名、发布审核、真实 API 以及实际上线环境 |
| iOS | 核对工程设置、Keychain 和 App Group 配置，接入 Files 与分享回执 | Windows 静态与共享自动化 | 原生编译、签名、真机功能和两端归档往返 |

Windows 第 10 轮再次问及开场时的第一句话，模型在回复中复述了有关木盒寄件人的问题。证据保存在 `reports/v049_windows_api_result.json`。这是共享传输层和连续上下文的真实验收；SQLite、秘密隔离、失败和回滚有独立自动化覆盖。

## 产物及校验

- [鱼者文游-V0.5.2+27-Debug.apk](../build/app/outputs/flutter-apk/鱼者文游-V0.5.2+27-Debug.apk) · 173.31 MiB · SHA-256 `3cb98fe5838160e858ab4cae22e769c85a06ed8457075e10b51ef8d306232ac0`
- [鱼者文游-V0.5.2+27-Release-候选.apk](../build/app/outputs/flutter-apk/鱼者文游-V0.5.2+27-Release-候选.apk) · 65.28 MiB · SHA-256 `672badeb4fa35cc921403e3e295393c970fb7940a7a3199a265a59da72f12c2f`

APK 使用相同应用 ID `com.yuzhe.fishtextadventure`，版本号 `0.5.2`，版本代码 `27`。可在手机本地点击 Debug APK 安装。在应用的「AI 服务设置 → 开发诊断」查看脱敏 HTTP、模型和用量，能够用手机自行复现。每轮付费确认保留。

## 发布前阻碍

- 向 DeepSeek 确认所需的原生 BYOK 发布适用范围，将确认依据同版本和渠道一起记录。Android 和 iOS 发布直连分别由各自审核状态控制。
- 正式 Android 发布密钥走忽略提交的本地 `android/key.properties`。内部候选仅在显式允许开发签名时使用 Debug 证书。公开分享自动读取也须取得适用授权。
- 取得具备 macOS/Xcode 和签名能力的环境，完成 iOS 构建与实际数据保护、分享和备份验收。完成两端实际付费确认、10 轮、失败回滚、重启恢复和备份往返。
- 工程 Git 尚无首次提交，也无已配置作者身份。按用户此前暂缓 Git 的指示，本轮代码写入现有工程，各阶段单独执行检查并记录结果。

