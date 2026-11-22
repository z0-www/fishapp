# 鱼者文游 FishTextAdventure

鱼者文游是一款 Android 优先、本地保存故事的 AI 文字角色扮演 App。
本仓库同时包含 **独立的外部对话转换器**，用于把 Chatbox / DeepSeek 等导出的
对话转换为鱼者文游可恢复的 `.yuzhe` 故事归档。

- 主程序源码版本：**V0.5.8+34**，包名 `com.yuzhe.fishtextadventure`
- 转换器版本：**V1.2.1**，包名 `com.yuzhe.converter`
- 主程序 PWA：https://fishapp-ett.pages.dev/
- 转换器 PWA：https://fish-converter-offline.3231167124.workers.dev/

## 两个部分

### 1. 鱼者文游主程序

- 用自然语言创建世界，编辑时代、历法、规则、地点、NPC 和人物关系；
- 对话、剧情、记忆和存档保存在设备本地；
- 通过 `.yuzhe` 完整故事备份导出/恢复；
- 使用用户自己的 DeepSeek API Key 生成 AI 剧情；
- 提供主程序 PWA（手机浏览器添加到主屏幕）。

### 2. 外部对话转换器 V1.2.1

- 独立 Android APK，也可作为独立 PWA 使用；
- 离线解析 Chatbox JSON/Markdown/ZIP、DeepSeek ZIP、普通 TXT；
- 生成主程序可直接恢复的 `.yuzhe`；
- 多会话可选择“合并为一个 .yuzhe”，或生成包含多个 `.yuzhe` 的 ZIP；
- 不上传聊天、不需要 API Key、不调用 AI。

## 下载

- **主程序 APK / 历史版本**：见 [GitHub Releases](https://github.com/z0-www/fishapp/releases)。
- **转换器 V1.2.1**：见本仓库 Releases 中的 `鱼者文游-转换器-v1.2.1-GitHub发布版.zip`；
  网盘用户可使用单独的“夸克网盘版”（仅 APK + 说明）。
- **PWA** 不需要下载安装包，直接打开上面的线上地址，按浏览器提示添加到主屏幕。

> PWA 不发布到网盘。网盘版只放 Android 转换器 APK 和安装说明。

## 目录

```text
lib/                        主程序 Flutter 源码
android/                    Android 工程
ios/                        iOS 工程
test/                       主程序自动化测试
web/                        主程序 PWA 资源与旧 iOS 兼容页
packages/yuzhe_codec/       .yuzhe v1 容器编解码器（主程序/转换器共用）
converter/                  外部对话转换器
  lib/                      解析器、归档生成器
  web/                      转换器 PWA
  android/                  独立 Android APK 工程
  test-files/               合成测试样本
  V1.2.1_ACCEPTANCE.md      兼容性验收报告
docs/                       主程序与跨平台文档
tool/                       构建、验证、Web 打包脚本
```

## 快速使用

### 主程序

1. 安装 APK；
2. 设置中填写自己的 DeepSeek API Key；
3. 创建/进入世界；
4. 完整故事备份 → 从 `.yuzhe` 备份恢复。

> **不要使用「DeepSeek 对话导入」入口来导入 `.yuzhe`。**
> 那个入口用于 DeepSeek 文本/分享链接，不读取 `.yuzhe` 备份。

### 转换器

1. 选择 Chatbox 导出的 JSON/Markdown，或 Chatbox 备份 ZIP；
2. 预览并勾选会话；
3. 生成 `.yuzhe`；
4. 保存/分享文件；
5. 回主程序：完整故事备份 → 从 `.yuzhe` 备份恢复。

多选会话时建议使用“合并为一个 .yuzhe”；主程序可直接一次恢复多个世界。
ZIP 内是多个独立 `.yuzhe`，主程序不直接读取 ZIP 本身。

## 构建

### 主程序

要求 Flutter 3.50.0 Stable / Dart 3.14.0 / Android SDK。

```sh
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```

Android 正式签名由发布者在本地保管和配置；iOS 构建需要 macOS/Xcode。

### 转换器

```powershell
powershell -ExecutionPolicy Bypass -File converter\build.ps1
powershell -ExecutionPolicy Bypass -File converter\android\build_apk.ps1 -SkipWebBuild
```

转换器测试：

```sh
flutter test test/converter_v121_compat_test.dart
```

## 测试状态

- 主程序全量：**322 passed**；
- 转换器 V1.2.1 专项：**13 passed**；
- `flutter analyze`：无问题；
- APK 实际生成 `.yuzhe` 并由主程序真实 `StoryBackup` 恢复通过。

详见：

- [转换器 V1.2.1 验收报告](converter/V1.2.1_ACCEPTANCE.md)
- [转换器 PWA 部署记录](converter/PWA_DEPLOYED.md)
- [跨平台文档](docs/cross-platform/README.md)

## 隐私

- 主程序不经过开发者服务器；用户配置 Key 后，浏览器/客户端直连 DeepSeek；
- 转换器不上传聊天，不联网，不需要 API Key；
- API Key 不写入 URL、日志或 `.yuzhe`；
- 图片/附件/工具调用参数不写入转换器生成的 `.yuzhe`；
- `.yuzhe` 默认不加密，包含原始对话文本，请妥善保管。

## 已知限制

- 真实 Chatbox 用户导出仍需脱敏样本验收；不能宣称兼容所有版本；
- 历史 `threads` 只提示、不合并，避免错误排序；
- 图片、附件、工具调用参数不转换；
- 真实 Android 手机与官方正式签名主程序的端到端导入仍需验收；
- 旧 iOS 主程序只提供兼容提示和只读 `.yuzhe` 阅读器；完整 Flutter 主程序需要较新 iOS。

## 反馈

请通过 [GitHub Issues](https://github.com/z0-www/fishapp/issues) 反馈，并注明 App/转换器版本。
不要附 API Key、真实聊天、未脱敏存档或签名私钥。
