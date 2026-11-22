# 鱼者文游 · 离线对话转换器 V1.2.1（手机端）

独立的静态单页 PWA：把 Chatbox / DeepSeek 等导出的对话，转换为
鱼者文游现有客户端可以恢复的 `.yuzhe` 故事归档。

**手机本地处理：不上传聊天、不需要登录、不需要 API Key、不调用 AI。**
首次联网加载后，断网也能选择文件、转换并保存。

## 目录

```text
converter/
  web/                 HTML/CSS/Dart 源码（Dart 编译成 app.js）
    offline.html       缓存被清理时的离线提示页
    _headers           Cloudflare Pages 安全/缓存头
    manifest.json      PWA manifest
    service_worker.js  离线缓存
  lib/                 解析器、归档写入器
  examples/            合成示例（含实际生成的 .yuzhe）
  build.ps1            构建/打包脚本
  README.txt           给最终用户的使用说明（打进 ZIP）
  MOBILE_GUIDE.md      Android / iPhone 手机端教程
  TEST_REPORT.md       实测结果与限制
```

## Android APK V1.2.1

线上转换器 PWA（独立 origin）：

```text
https://fish-converter-offline.3231167124.workers.dev/
```

在网页 PWA 之外，新增了独立的 Android 原生 WebView 壳：

```text
converter/android/
dist/android/鱼者文游-离线对话转换器-v1.2.1-安卓版.apk
dist/android/鱼者文游-离线对话转换器-v1.2.1-夸克网盘发布包.zip
```

- 包名 `com.yuzhe.converter`，版本 1.2.1；
- 全部网页资源打入 APK assets；
- 无 INTERNET/存储权限；
- 系统 `ACTION_OPEN_DOCUMENT` 选择、`ACTION_CREATE_DOCUMENT` 保存；
- 正式签名：`converter/signing/`（本地 gitignore），不使用 debug 签名；
- 测试与构建说明见 [android/README.md](android/README.md)、
  [android/TEST_REPORT.md](android/TEST_REPORT.md)。

## 构建

```powershell
powershell -ExecutionPolicy Bypass -File converter\build.ps1
```

要求：Dart 3.14+（Flutter 3.50 自带即可）。产物：

```text
dist/converter/FishTextAdventure-Converter-1.2.1-mobile/
dist/converter/FishTextAdventure-Converter-1.2.1-mobile.zip
dist/converter/FishTextAdventure-Converter-1.2.1-mobile-cloudflare-pages.zip
```

Cloudflare Pages ZIP 与主 ZIP 内容相同，可直接上传；`index.html` 在根目录。

- Windows / 电脑备用：解压后双击 `index.html`（`file://` 已实测）。
- Android：推荐 HTTPS 静态托管 + Chrome；也保留本地 HTML 备用。
- iPhone：必须 HTTPS（Safari 通常不能运行“文件”里的本地 HTML）；
  Safari 分享 → 添加到主屏幕。

## 手机端流程

1. 选择文件：从系统文件管理器选择 Chatbox JSON / Markdown / ZIP。
2. 预览并勾选会话。
3. 点“生成 .yuzhe”；多选时可点“合并为一个 .yuzhe”；生成后点“保存 / 分享文件”。
4. 打开鱼者文游 → **完整故事备份** → **从 .yuzhe 备份恢复**。
   **不要使用「DeepSeek 对话导入」入口。**

首次访问会出现手机端新手引导，明确这条恢复路径；关闭后可随时点
“手机使用说明”重新打开。

## PWA / 离线

- Service Worker 缓存 `index.html`、`app.js`、样式、图标、`offline.html`。
- 页面顶部显示离线资源状态；浏览器存储未被持久化时提醒可能被清理。
- 缓存被系统清理后：断网会显示“离线资源已被清理，请联网重新打开”；
  联网重新打开一次即可恢复离线能力。
- 转换和保存都在内存中完成；保存使用浏览器 Blob / 下载或 Web Share，
  不经过任何服务器。

## 支持与识别

按**内容结构**识别，不按扩展名：

- Chatbox JSON：`sessions` / `chats` / 对象键控 sessions / 单个 `messages`；
- Chatbox Markdown：`User:` / `Assistant:` / `用户：` / `助手：`，
  支持 H1 导出标题 + H2 会话标题；
- Chatbox 备份 ZIP、DeepSeek 导出 ZIP（结构识别，实验性）；
- 普通 TXT + 角色标记。

消息保留正文、顺序、角色、换行、Markdown 文本。图片/附件/工具调用参数
不写入归档，预览会提示；未识别文件直接报错，不修改原文件。
`.yuzhe` 默认不加密，包含原始对话文本。

## 世界结构

Chatbox 对话没有鱼者世界设定。转换器只生成**最小合法世界**：

- 世界标题来自会话标题（无标题时使用默认标题）；
- 世界背景/地点/NPC/规则/记忆为空，不编造；
- `customFields.converter.generatedDefaults` 明确列出转换器生成的字段；
- 原始对话保存在 `imported_messages`、`story_checkpoints`、`timeline_entries`，
  并写入 `importedRecent` 供继续生成时作为历史资料；
- 世界状态 revision=0，用户可在鱼者中继续生成剧情。

## 复用现有编码器

`.yuzhe` 编码使用 `packages/yuzhe_codec`（从现有 `StoryBackupFormat` 的
v1 帧格式抽取的纯 Dart 编解码器），主应用和转换器共用它。
主应用的文件流式适配器与内存编解码器已有跨后端测试。

## 测试

见 [TEST_REPORT.md](TEST_REPORT.md)。示例文件：

- `examples/chatbox-sample.json`：合成 Chatbox JSON；
- `examples/chatbox-sample.yuzhe`：由转换器 Web UI 实际导出的归档，
  已用现有 `StoryBackup` 解码/恢复测试读取；
- `examples/multi-sample.zip`：多会话 ZIP 示例。

## 已实测 / 未实测

已实测（桌面 Chromium 手机竖屏 390×844）：

- 在线加载 → Service Worker 缓存 → 断网重载 → 选择文件 → 预览 →
  生成 `.yuzhe` → 点保存按钮 → 捕获到 `YUZHE` 文件；
- 断网多会话 → 生成 ZIP → 保存 → 捕获到 ZIP `PK`；
- 缓存清理警告、PWA manifest/SW、首次新手引导；
- Android 模拟器 Chrome：系统 DocumentsUI 选择文件 → 生成 → 下载确认 →
  `/sdcard/Download/雨夜测试.yuzhe`（11,699 字节）；
- Android debug APK：把上述归档放入 share_inbox，走“恢复故事备份”UI，
  显示导入消息 5 并恢复世界；
- 桌面 `file://` 备用模式：本地文件模式转换/保存。

未实测：

- 真实 Android 手机（本次是模拟器；厂商文件管理器差异未覆盖）；
- 官方正式签名 APK；
- 真实 iPhone Safari 的文件选择与分享（仅模拟 iOS UA + Web Share）；
- 真实 Chatbox 导出样本（解析器按公开结构实现，未宣称所有版本兼容）；
- 有效 DeepSeek Key 下的继续生成（没有 Key，不生成假剧情）。
