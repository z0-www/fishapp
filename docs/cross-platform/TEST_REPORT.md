# 跨平台测试报告

日期：2026-11-20
环境：Windows 11（10.0.26200），Flutter 3.50.0 Stable / Dart 3.14.0，
Android SDK 36，Edge 157（Chromium），无 macOS、无 Xcode、无 iPhone、无有效 DeepSeek Key。

> 原则：只记录真实执行过的测试。没有真实设备/凭据的项目明确标为“未执行”。

## 1. 静态分析与自动化测试

| 测试 | 命令 | 结果 |
| --- | --- | --- |
| Flutter 静态分析 | `flutter analyze` | ✅ No issues found |
| 全量测试 | `flutter test` | ✅ 309 passed，0 failed（含 3 个跨端编解码 + 7 个转换器测试） |
| Android Debug 构建 | `flutter build apk --debug` | ✅ 成功 |
| Web Release 构建 | `flutter build web --release` | ✅ 成功 |
| 发布包审计 | `python tool/web/check_release_bundle.py --zip ...` | ✅ 全部通过（37 文件，21.9 MiB） |
| iOS 工程静态审计 | `python tool/ios/check_ios_project.py` | ✅ 31/31 通过 |
| iOS pbxproj 解析 | `pbxproj` 解析器 | ✅ 三个 target |
| Workflow YAML | PyYAML 解析 | ✅ 两个文件通过 |
| iOS 构建脚本语法 | `bash -n tool/ios/build_unsigned_ipa.sh` | ✅ 通过 |
| 备份专项 | `flutter test test/world_backup/story_backup_test.dart` | ✅ 3/3 通过 |
| `.yuzhe` 跨端 | `flutter test test/world_backup/interop_test.dart` | ✅ 3/3 通过 |

## 2. Web 真实浏览器验收（Chromium / Edge 157）

加载地址 `http://127.0.0.1:8128/`，视口 390×844（iPhone 尺寸），
使用 DevTools Protocol 驱动真实点击、键盘输入与截图，不是 Widget 测试。

| 场景 | 结果 | 证据 |
| --- | --- | --- |
| 首屏加载、产品声明 | ✅ | `screenshots/web-statement.png` |
| 点击“进入鱼者”进入首页 | ✅ | `screenshots/web-home.png` |
| 输入世界描述 → 创建 → 进入世界 | ✅ | `screenshots/web-world.png` |
| drift WebAssembly 数据库 | ✅ 控制台无异常，使用 OPFS locks（启用 COOP/COEP 时）/ IndexedDB 回退 | 控制台日志 |
| 完整故事备份页面 | ✅ 列出世界 | `screenshots/web-backup-library.png` |
| `.yuzhe` 导出 | ✅ 生成 1992 字节，魔数 `YUZHE\x01\x00`，触发下载 | `screenshots/web-backup-export.png` |
| 密码加密导出 | ✅ 生成 2088 字节，加密标志 `1` | 测试日志 |
| 加密归档恢复 | ✅ 输入密码 → 预览 → 恢复成功 | `screenshots/web-encrypted-restore.png` |
| 未加密归档恢复 | ✅ 预览显示“世界 1” → 恢复 → 世界列表出现两个世界 | `screenshots/web-backup-restore.png` |
| API Key 保存 | ✅ localStorage 出现加密项，AI 设置显示“已配置，等待连接” | `screenshots/web-ai-settings.png` |
| API Key 删除 | ✅ 加密项移除，显示“未配置 API Key” | 测试日志 |
| DeepSeek CORS 直连 | ✅ 浏览器内 `fetch /models` 返回 401（type=cors），非 CORS 阻断 | [CORS_AND_RELAY.md](CORS_AND_RELAY.md) |
| PWA manifest | ✅ 名称“鱼者文游”、display=standalone、4 个图标 | 浏览器内解析结果 |
| Service Worker 注册 | ✅ 1 个注册，scope 为站点根路径 | 浏览器内 `getRegistrations()` |
| **断网冷启动** | ✅ 首次在线加载后切离线并重新导航，Flutter 首帧正常、无异常、数据库打开 | `screenshots/web-offline.png` |
| 网页版设置区 | ✅ 显示“添加到 iPhone 主屏幕”、存储持久化状态、备份入口 | `screenshots/web-settings.png` |
| 页面运行异常 | ✅ 无未捕获异常、无 404、无资源加载失败 | CDP 日志 |
| 直接访问 `/#/settings`、`/#/backup` | ✅ 路由正确 | `screenshots/web-backup-route.png` |
| 页面刷新 | ✅ 刷新后仍停留在同一 hash 路由 | `location.href` + 截图 |
| HTTPS 安全上下文 | ✅ 自签 HTTPS 下 `isSecureContext=true`、`crypto.subtle` 可用、SW 注册成功 | `screenshots/https-secure-context.png` |
| Service Worker 更新 | ✅ 缓存 A → B，旧缓存删除，重载正常 | `screenshots/sw-update.png` |
| 离线深链 | ✅ 在线访问过备份页后，断网重载 `/#/backup` 正常，字体子集已缓存 | `screenshots/web-offline-backup.png` |
| SSE 生产代码自测 | ✅ 5/5（正常流/usage、中途断线、缺 DONE、401、取消） | `screenshots/sse-selftest.png` |
| API Key 不入 URL/日志/页面 | ✅ localStorage 仅密文；URL/资源/正文均无明文 | `screenshots/web-key-saved.png` |
| 无 Key 不生成剧情 | ✅ 0 次 DeepSeek 请求，仅提示配置 Key，无剧情 | `screenshots/no-key.png` |
| 原生文件 ↔ 浏览器字节 `.yuzhe` | ✅ 双向读取、密码加密互通、错误密码拒绝 | `test/world_backup/interop_test.dart` |

关键日志（加密导出）：

```text
{"size":2088,"magic":"YUZHE\u0001\u0001","flag":1}
```

关键日志（恢复后世界列表）：

```text
返回\n全部世界\n世界设定\n世界设定
```

## 3. 未执行的测试（不得声称通过）

| 项目 | 原因 | 影响 |
| --- | --- | --- |
| iOS 编译（`flutter build ios`） | Windows 无 iOS 构建目标；无 macOS/Xcode | iOS 是否可编译未验证 |
| 生成 IPA / 签名 / 真机安装 | 无 macOS、无 Apple 账号、无 GitHub remote/token | 未产出可安装 IPA |
| 真实 DeepSeek 生成 | 无有效 API Key；不能使用他人 Key | 只验证了 CORS、401 错误路径、SSE 生产代码（浏览器网络桩） |
| 网页版真实 AI 流式回复 | 同上 | 未与真实模型联调，不能声称通过 |
| iPhone Safari 真机 | 无 iPhone | 安全区/软键盘/添加到主屏幕未验证 |
| PWA 添加到主屏幕（真机） | 无 iPhone | 桌面 Chromium 通过，iOS 安装流程未实测 |
| Android 真机回归 | 无连接设备 | 只做到构建+自动化测试 |
| Android Release 签名包 | 无签名材料，且按指令不触碰 | 正式 APK 状态未改变 |
| 大文件/附件二进制导入导出 | 网页版附件仅元数据（设计限制） | 已在 UI 与文档明确提示 |
| iOS Actions 实际运行 | 无 GitHub 仓库授权 | 工作流未执行，不能声称构建通过 |

## 4. 测试产物

- 集成测试截图：`docs/cross-platform/screenshots/`
- 浏览器探针脚本：`tool/web/cdp_probe.mjs`（可复现控制台/网络/截图）
- 静态服务器：`tool/web/serve_web.mjs`
- 发布包审计：`tool/web/check_release_bundle.py`
- SSE 自测：`tool/web/sse_selftest.dart` + `sse_selftest.html`
- 构建日志：见 `reports/cross-platform/`（本机工作副本）
- 最终 Web 包：37 个文件，解压 21.9 MiB，ZIP 9,124,522 字节；
  SHA-256 `6297B9E11228F118523693F6A9DBED91E485F87D452F6909844776F432A40ED2`；
  `service_worker.js` 缓存版本自动写为 `fish-v0.5.8-<构建时间>`。
- 最终 Android Debug APK：220,589,337 字节，
  SHA-256 `13FC07EDC14811A4B989CD65EC505BF4C1D024E27A49B4B00FE0A717CA32C201`。
