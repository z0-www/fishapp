# 跨平台交付报告（iOS / Web PWA）

项目：鱼者文游 FishTextAdventure
基线：V0.5.8+34（`com.yuzhe.fishtextadventure`）
日期：2026-11-20
执行：DSH 接管开发（Windows 11，Flutter 3.50.0 / Dart 3.14.0）

## 一、实际完成了什么

### A. Web / PWA（实际可运行）

1. 在现有 Flutter 工程上启用 Web 平台（`web/`），没有重写游戏逻辑。
2. 平台适配层：
   - `lib/platform/files/`：原生路径与浏览器内存文件句柄统一读取；
   - `lib/platform/web/web_storage_guard.dart`：持久化存储状态/配额；
   - `lib/platform/files/web_file_picker*.dart`：浏览器文件选择；
   - `lib/platform/files/web_download*.dart`：iOS 系统分享优先、下载兜底。
3. 数据库：drift + 自带 `sqlite3.wasm` / `drift_worker.js`，浏览器 OPFS 或
   IndexedDB 回退，schema 仍为 v6，与 Android 共用。
4. 安全存储：`flutter_secure_storage_web`（WebCrypto AES-GCM），
   仅 HTTPS/localhost；UI 明确提示网页版弱于系统 Keychain。
5. 真实 AI：
   - 开放 Web 直连策略（官方端点 + 支持模型双白名单不变）；
   - 新增 `fetch` + `ReadableStream` 的 SSE 传输，保证真实流式；
   - 未使用 Mock、未伪造 Token/剧情。
6. `.yuzhe`：
   - 编解码抽成文件/内存共用实现，格式仍为 `YUZHE` v1；
   - Web 导出（含密码加密）→ 浏览器下载 / iOS 分享面板；
   - Web 导入 → 预览 → 恢复，完整故事数据落库；
   - 浏览器无附件原文件，只保留元数据并明确提示。
7. PWA：
   - 中文 manifest、白蓝主题、192/512/maskable/180 图标；
   - 自定义 `service_worker.js`：预缓存启动壳 + 运行时缓存 + 页面资源预热；
   - 断网重新导航已实测可启动（Chromium）；
   - `web/flutter_bootstrap.js` 接管加载，避免 Flutter 3.50 自动注销 SW；
   - `--no-web-resources-cdn` 本地打包 CanvasKit，保证离线资源完整；
   - Safari `viewport-fit=cover`、`apple-mobile-web-app-*` 元信息。
8. 导入中心/世界设定导入适配 Web；系统分享入口在 Web 明确不可用，不假装支持。
9. 构建脚本 `tool/web/build_web.ps1`，产物在 `dist/web/`。

### B. iOS（工程与构建配置完成，未编译/签名）

1. 审计整个 `ios/`：Runner、ShareExtension、entitlements、pbxproj、UTI、Scene 配置。
2. 修复/加固：
   - `ShareInbox.root()` 在 App Group 不可用时回退到应用沙盒，
     保证免费签名下 Files 导入仍可用（系统分享扩展会明确不可用）；
   - 新增 Runner 与 ShareExtension 的 `PrivacyInfo.xcprivacy` 并接入构建阶段；
   - Info.plist：中文开发区域/本地化、显式关闭 ATS 任意加载；
   - iOS 个人侧载直连开关 `FISH_IOS_BYOK`（默认关闭，不改变商店审核策略）。
3. 新增 `tool/ios/check_ios_project.py`：31 项工程静态检查，当前全部通过。
4. 新增 `tool/ios/build_unsigned_ipa.sh`：macOS 一键未签名 IPA。
5. 新增 GitHub Actions：
   - `.github/workflows/ios-unsigned.yml`：macOS 生成未签名 IPA；
   - `.github/workflows/ios-signed-testflight.yml`：未来 TestFlight 签名模板（未执行）。
6. 文档：Sideloadly 教程、免费签名限制、真机验收清单、TestFlight 准备。

### C. 共享与回归

1. 独立 Git 分支 / worktree：
   - `feature/web-pwa`、`feature/ios-native`、`integration/cross-platform`。
2. Android 回归：`flutter analyze` 无问题、309 个测试全过、Debug APK 构建成功。
3. 没有覆盖/删除正式签名 APK、签名证书或用户故事存档；没有上传任何源码/Key/签名。
4. 没有部署服务器；Web 版是官方端点直连（CORS 实测通过）。

## 二、生成了哪些文件

### 代码（主要）

```text
lib/core/database/app_database.dart                 Web drift 运行时
lib/core/security/api_key_storage.dart              Web 加密存储选项
lib/features/ai/data/deepseek_config.dart           Web/iOS 直连策略
lib/features/ai/data/deepseek_http_protocol.dart    Web SSE 分流
lib/features/ai/data/web_sse_stream.dart            条件入口
lib/features/ai/data/web_sse_bytes_web.dart         fetch/ReadableStream SSE
lib/features/ai/data/web_sse_bytes_stub.dart        原生空实现
lib/platform/files/local_files*.dart                文件读取适配
lib/platform/files/web_file_vault.dart              浏览器会话文件仓
lib/platform/files/web_file_picker*.dart            浏览器选择器
lib/platform/files/web_download*.dart               分享/下载
lib/platform/web/web_storage_guard*.dart            持久化存储/配额
lib/features/import_center/application/web_import.dart  Web 导入暂存
lib/features/world_backup/data/backup_format.dart   .yuzhe 内存/文件共用编解码
lib/features/world_backup/data/story_backup.dart    Web bytes 导入导出
lib/features/world_backup/presentation/backup_pages.dart  Web 分支
lib/features/import_center/**                       文件读取/导入适配
lib/features/world_creator/**                       设定导入适配
lib/features/settings/settings_page.dart            网页版数据区
lib/features/ai/presentation/api_setup_page.dart    Web 密钥说明
lib/platform/share_intake/share_intake_service.dart Web 空入口
lib/platform/share_intake/share_event_deduplicator.dart 浏览器指纹
```

### Web / PWA

```text
web/index.html, web/manifest.json, web/icons/*
web/sqlite3.wasm, web/drift_worker.js
web/flutter_bootstrap.js, web/service_worker.js
tool/web/build_web.ps1, tool/web/serve_web.mjs, tool/web/cdp_probe.mjs
tool/generate_web_icons.py
```

### iOS

```text
ios/Runner/Info.plist, ios/Runner/PrivacyInfo.xcprivacy
ios/ShareExtension/PrivacyInfo.xcprivacy
ios/ShareExtension/ShareInbox.swift
ios/Runner.xcodeproj/project.pbxproj
tool/ios/check_ios_project.py, tool/ios/build_unsigned_ipa.sh
.github/workflows/ios-unsigned.yml
.github/workflows/ios-signed-testflight.yml
```

### 文档与报告

```text
docs/cross-platform/README.md
docs/cross-platform/WEB_PWA_GUIDE.md
docs/cross-platform/CORS_AND_RELAY.md
docs/cross-platform/IOS_BUILD_AND_SIDELOAD.md
docs/cross-platform/ANDROID_REGRESSION.md
docs/cross-platform/TEST_REPORT.md
docs/cross-platform/DELIVERY_REPORT.md
docs/cross-platform/screenshots/*.png
BYOK_SECURITY.md（追加跨平台安全边界）
README.md（追加跨平台入口）
```

### 构建产物

```text
dist/web/FishTextAdventure-0.5.8-web/                  静态站点（37 个文件，21.9 MiB）
dist/web/FishTextAdventure-0.5.8-cloudflare-pages.zip  Cloudflare Pages 上传包
                                                      9,124,522 字节
                                                      SHA-256 6297B9E11228F118523693F6A9DBED91E485F87D452F6909844776F432A40ED2
build/app/outputs/flutter-apk/app-debug.apk            Android 回归包（debug，220,589,337 字节）
                                                      SHA-256 13FC07EDC14811A4B989CD65EC505BF4C1D024E27A49B4B00FE0A717CA32C201
```

## 三、哪些功能通过了真实测试

- Web 首屏、产品声明、首页在真实 Chromium（390×844）加载，无异常/404。
- 浏览器内创建世界 → 进入世界页（真实 DB 写入 + 路由）。
- PWA manifest（名称/4 图标/standalone）与 Service Worker 注册成功。
- 首次在线加载后断网重新导航，Flutter 正常启动（离线缓存实测）。
- Service Worker 缓存版本更新、旧缓存清理、重载正常。
- 直接访问 hash 路由并刷新，路由保持。
- HTTPS 安全上下文（自签测试）：`isSecureContext`、WebCrypto、SW 均可用。
- 发布包审计：37 文件/21.9 MiB，无 map/symbols/源码/密钥/本机路径。
- SSE 生产代码浏览器自测 5/5（正常流+usage、断线、缺 DONE、401、取消）。
- API Key 只以密文存 localStorage；URL/资源/正文均无明文。
- 无 Key 时发送行动：0 次 DeepSeek 请求、无假剧情。
- `.yuzhe` 原生文件后端与浏览器字节后端双向互通（含密码）。
- `.yuzhe` 导出：1992 字节，魔数 `YUZHE\x01\x00`，下载触发。
- 密码加密导出：2088 字节，加密标志 1。
- 加密归档：输入密码 → 预览 → 恢复成功。
- 未加密归档：预览 → 恢复 → 世界列表出现两个世界。
- API Key：保存（localStorage 加密项）→ AI 设置显示已配置 → 删除后恢复未配置。
- DeepSeek CORS：真实浏览器 `fetch` 返回 401（type=cors），不是 CORS 阻断。
- WebAssembly 数据库：OPFS/IndexedDB 路径均可启动，无控制台异常。
- Android：静态分析、309 测试、Debug APK 构建通过。
- iOS：31 项静态工程检查、pbxproj 解析、YAML/脚本语法通过；**未编译**。

## 四、哪些仍待验证（不得当作已完成）

- iOS 的 Xcode 编译、IPA 生成、签名、真机安装（无 macOS/Apple 账号）。
- 真实 DeepSeek Key 的网页版完整生成、Token 统计与费用核对（无用户 Key）。
- 真实 iPhone Safari 的安全区、软键盘、长文阅读、添加到主屏幕。
- PWA 断网启动已在桌面 Chromium 通过；iPhone 上的 service worker 行为仍需真机确认。
- Android 真机回归与正式签名包（按指令未触碰签名材料）。
- 网页版附件二进制（设计上仅元数据）。
- `service_worker.js` 缓存版本由构建脚本自动改写；直接 `flutter build web` 时需手动或重新打包。

## 五、是否有可安装 IPA / 可部署 Web 构建

- **可部署 Web 构建：有。** `dist/web/FishTextAdventure-0.5.8-cloudflare-pages.zip`
  （9,124,522 字节，37 文件，21.9 MiB），上传到 Cloudflare Pages 或任意 HTTPS 静态托管即可；
  不需要鱼者服务器。
- **可安装 IPA：没有。** 未生成、未签名。需要在 macOS（本机或 GitHub Actions）
  构建未签名 IPA，再用 Sideloadly/付费证书签名。详见
  [IOS_BUILD_AND_SIDELOAD.md](IOS_BUILD_AND_SIDELOAD.md)。

## 六、下一步用户具体需要操作什么

### 想先用网页版

1. 把 `dist/web/FishTextAdventure-0.5.8-web.zip` 解压后上传到 GitHub Pages /
   Cloudflare Pages / 任意 HTTPS 静态托管。
2. 用 **iPhone Safari** 打开该地址，分享 → 添加到主屏幕。
3. 进入设置 → 请求持久化存储；先导出一份 `.yuzhe` 备份。
4. 在 AI 服务设置填入自己的 DeepSeek Key，先用“手动测试连接”确认。

### 想装到 iPhone

1. 把仓库推到你自己的 GitHub（建议 Private）。
2. Actions → “iOS unsigned IPA” → Run workflow。
3. 下载 artifact，按 `IOS_BUILD_AND_SIDELOAD.md` 第 4 节用 Sideloadly 签名安装。
4. 免费 Apple ID：7 天有效、系统分享扩展不可用（应用内文件导入可用）。
5. 安装后按第 5 节真机清单逐项验收，再把结果反馈回来。

### 想上 TestFlight / App Store

需要付费 Apple Developer Program、App Store Connect 记录、隐私政策 URL、
出口合规与 AI 内容说明；签名工作流只是模板，需先补齐证书与描述文件。

## 七、需要说明的架构/边界变化

1. **Web 允许官方端点直连**：这是为满足“网页版真实 AI”而新增的策略分支；
   BYOK 不变（Key 只在浏览器，只发官方域名）。CORS 实测支持。
2. **iOS 个人侧载允许直连**：通过 `FISH_IOS_BYOK` 编译开关；不改变商店审核结论。
3. **Web 密钥存储弱于原生**：WebCrypto + localStorage，不能抵御 XSS/恶意扩展；
   已在 UI 与文档明确告知。
4. **Web 附件仅元数据**：没有用假附件填充；导出/恢复时有提示。
5. **没有中转服务器**：如未来 CORS 失效，按 `CORS_AND_RELAY.md` 先说明再部署，
   本次未部署、未上传 Key。
