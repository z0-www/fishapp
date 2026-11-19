# 鱼者文游 FishTextAdventure

鱼者文游是一款 Android 优先、本地保存故事的 AI 文字角色扮演 App。当前源码版本为 **V0.5.8+34**，Android 包名为 `com.yuzhe.fishtextadventure`。

## 功能

- 用自然语言快速创建世界，详细编辑时代、原创历法、世界规则、地点、NPC 和人物关系。
- 自定义目标字数、旁白人称和叙事风格，对话和剧情保存在设备上。
- 从文本或本地导出文件导入旧故事，使用 `.yuzhe` 完整备份及恢复。
- 通过大肥鱼消费管家查看本机用量，设置每日预算和单轮提醒。

## 安装和使用

Android 7.0 及以上可安装 `鱼者文游-安卓公测版.apk`。已有旧版时，请先将 .yuzhe 备份保存到应用以外的文件夹，并确认文件可以预览。出现签名冲突时，请先保留旧版和备份。

**生成 AI 剧情必须配置自己的 DeepSeek API Key。** 在 DeepSeek 开放平台获取密钥后，进入「设置 → AI 服务设置 → 配置 API Key」。世界、存档和密钥由设备保存。在线剧情请求会将本次输入和必要上下文直接发送给 DeepSeek。软件本体免费，手动测试和模型调用可能由 DeepSeek 计费。[DeepSeek 官方接入文档](https://api-docs.deepseek.com/)

此安装包是使用既有正式证书签名的候选构建，公开公测待最终签名包的真机复验和发行条件核实。

| 校验项 | 值 |
| --- | --- |
| APK 版本 | `0.5.8+34` |
| APK SHA-256 | `F381CD8EB4B1C98DE7A01A8AF44AEFD3B5402BF6D9759AF3501D4546AB79FB86` |
| Android 签名证书 SHA-256 | `261619CF1EA80929DB0A0D76516E706BF5EA7F6D406169F7BC5C094FBF0C38F4` |

## 构建和测试

使用 Flutter 3.50.0 Stable、Dart 3.14.0 和 Android SDK。在源码根目录执行。

```sh
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```

源码整理自实际 Flutter 工程，保留 `lib/`、资源、自动化测试及 Android/iOS 平台工程。Android 正式签名由发布者在本机保管和配置。iOS 工程需要在 macOS/Xcode 上构建和验证。

## 下载与反馈

Android 安装包将随验收通过的版本通过 [GitHub Releases](https://github.com/z0-www/fishapp/releases) 提供。当前源码对应 V0.5.8+34 正式签名候选构建。

可通过 [GitHub Issues](https://github.com/z0-www/fishapp/issues) 反馈问题。请注明 App 版本、Android 版本和复现步骤，避免附上 API Key、私人聊天或存档。

开发者为 B 站 UP 主 z0-www，反馈邮箱为 z0www1234@163.com。