# 手机端离线转换器 · 测试报告

版本：V1.2.1-mobile
日期：2026-11-22
环境：Windows 11，Flutter 3.50.0 / Dart 3.14.0，Edge 157 Chromium，
Android 模拟器 Medium Phone API 37（debug APK），
**无真实 iPhone、无真实 Chatbox 导出样本、无有效 DeepSeek Key。**

## 1. 自动化测试

| 测试 | 结果 |
| --- | --- |
| converter `dart analyze` | ✅ No issues |
| V1.2.1 专项测试 | ✅ **13/13** |
| 主 app `flutter analyze` | ✅ No issues |
| 主 app 全量测试 | ✅ **322 passed** |
| Chatbox JSON → `.yuzhe` → 现有 `StoryBackup` 恢复 | ✅ |
| Chatbox Markdown（H1 导出标题 + H2 会话）→ 恢复 | ✅ |
| Chatbox 备份 ZIP → 恢复 | ✅ |
| 对象键控 sessions JSON | ✅ |
| 多会话 ZIP | ✅ |
| 未识别纯文本 → 明确报错、无归档 | ✅ |
| 消息数量、角色、顺序、换行 | ✅ |
| 恢复后 `RoleplayRepository.load` + `TurnCoordinator.prepare` | ✅ |

## 2. 手机 PWA 浏览器实测

测试视口：390×844（手机竖屏），桌面 Chromium；非真实手机。

| 操作 | 结果 |
| --- | --- |
| 手机端新手引导 | ✅ 首次打开显示 3 步说明，明确警告不要用「DeepSeek 对话导入」 |
| PWA manifest / Service Worker | ✅ 注册成功，manifest 可读取 |
| 首次在线加载后缓存 | ✅ 顶部显示“离线资源已缓存” |
| **断网重载** | ✅ 页面完整打开，不是只显示首页 |
| **断网选择文件 → 预览 → 生成** | ✅ 生成 9,275 字节 `.yuzhe` |
| **断网点“保存 / 分享文件”** | ✅ 捕获到 `YUZHE` 文件，文件名“离线测试.yuzhe” |
| **断网多会话 → ZIP → 保存** | ✅ 捕获到 4,200 字节 ZIP（`PK`） |
| 未识别文件 | ✅ 显示错误，隐藏预览/导出，不生成归档 |
| 缓存/存储警告 | ✅ 顶部提示浏览器可能清理缓存；SW 有“离线资源已被清理”提示页 |
| iOS 分享分支 | ✅ 用 iPhone UA + stub `navigator.share` 验证：调用 share，未走下载 |
| Android 下载分支 | ✅ 桌面 Chromium 捕获 Blob 下载；真实 Android Chrome 未走完整文件选择 |
| 原始文件修改 | ❌ 转换器从未写入原文件 |

## 3. Android 实际端到端（模拟器）

环境：Android 模拟器 Medium Phone API 37，Chrome，通过 `adb reverse` 访问本机
HTTPS/HTTP 测试服务；设备状态栏显示“No internet connection”，转换、保存均为本地。

### 3.1 Android Chrome：选择文件 → 生成 → 下载

1. 把 `examples/chatbox-sample.json` 放入模拟器 `/sdcard/Download`；
2. Chrome 打开转换器（127.0.0.1:8132，adb reverse）；
3. 点“点这里从手机选择文件”；
4. 系统 DocumentsUI 打开，搜索并选择 `chatbox-sample.json`；
5. 页面显示“已识别：chatbox-sample.json · 459 B · Chatbox JSON · 1 个会话 · 5 条消息”；
6. 点“生成 .yuzhe”，结果区显示“雨夜测试.yuzhe · 11.4 KB · 5 条消息 · 尚未保存”；
7. 点“保存 / 分享文件”，Chrome 弹出“Choose where to download”，确认后
   `/sdcard/Download/雨夜测试.yuzhe` 实际存在，11,699 字节。

截图：`../docs/cross-platform/screenshots/converter-android-chrome-selected.png`、
`../docs/cross-platform/screenshots/converter-android-chrome-saved.png`。

### 3.2 Android debug app：恢复 Android Chrome 生成的归档

把上述 11,699 字节 `.yuzhe` 放入 app 原生 `share_inbox`，启动 app →
对话迁移中心 → 检查系统分享暂存区：

- 自动进入“恢复故事备份”：雨夜测试、世界 1、对话回合 0、**导入消息 5**、记忆 0、分支 1；
- 点“确认恢复”；
- 世界页显示“雨夜测试”和“导入故事的最后片段”。

说明：安装的是当前源码的 **debug APK**，不是正式签名 V0.5.8+34；正式包/签名/用户数据未改动。
导入通过原生 share_inbox 触发，没有走“从手机选择文件”按钮，但走的是同一套
`StoryBackup.inspect/restore` 和恢复 UI。

## 4. 未验证 / 不得声称通过

- **真实 Android 手机**：本次是 Android 模拟器 + Chrome，不是实体手机；
  系统文件管理器、下载目录、厂商浏览器差异仍需真机确认。
- **官方正式签名 APK**：没有正式包/签名材料；只验证同版本 debug 构建，
  且 app 导入通过原生 share_inbox 触发，不是从 app 内“选择文件”按钮。
- **真实 iPhone Safari**：没有设备；只模拟 iOS UA 和 Web Share 调用，
  未验证 Safari 实际文件选择、分享面板“存储到文件”、添加到主屏幕后的离线行为。
- **缓存被彻底清理后的冷启动**：Service Worker 有 `offline.html` / 内联提示，
  但自动化测试中浏览器仍从内存/HTTP 缓存恢复页面，未能确证完全冷启动路径；
  页面顶部缓存警告已实测。
- **真实 Chatbox 导出样本**：没有样本；解析器按公开结构实现，新增 H1+H2、
  对象键控 sessions 支持，但**不能宣称所有 Chatbox 版本均兼容**。
- **真实 AI 继续生成**：没有有效 DeepSeek Key，未测试；没有生成假剧情。
- **加密 Chatbox 备份**：不支持，会报错。
- **图片/附件/工具调用**：不转换。

## 5. 发布包

```text
dist/converter/FishTextAdventure-Converter-1.2.1-mobile/
dist/converter/FishTextAdventure-Converter-1.2.1-mobile.zip
dist/converter/FishTextAdventure-Converter-1.2.1-mobile-cloudflare-pages.zip
490,972 字节
SHA-256 EAA0ABED9E859BDDC803D1766F889666A4C2F090489B8ABDED950ACF1D03282C
```

ZIP 根目录含 `index.html`、`manifest.json`、`service_worker.js`、
`offline.html`、`_headers`、`styles.css`、`app.js`、图标、README、examples。
无 source map、无远程脚本、无统计。

## 6. 示例与证据

- `examples/chatbox-sample.json`：合成 Chatbox JSON；
- `examples/chatbox-sample.yuzhe`：转换器 UI 实际生成，现有 app 测试及
  Android debug 客户端导入通过；
- `examples/multi-sample.zip`：多会话 ZIP 示例；
- `../docs/cross-platform/screenshots/converter-mobile.png`：手机竖屏页面；
- `../docs/cross-platform/screenshots/converter-android-restored.png`：
  Android debug 客户端恢复后的世界页。
