# iPhone Safari 启动卡死 · 修复与证据

日期：2026-11-21
症状：iPhone Safari 打开 Cloudflare Pages 主程序后，永久停在
“鱼者文游 / 正在加载本地故事…”，启动图标为问号。

## 1. 实际检查的启动链

```text
index.html HTML splash
  → flutter_bootstrap.js
  → flutter.js / CanvasKit（本地）
  → main.dart.js（Dart）
  → ProviderScope / GoRouter /startup
  → drift AppDatabase
      → sqlite3.wasm + drift_worker.js
      → OPFS 或 IndexedDB
  → productStatementSeen 查询
  → 首页
```

关键发现：

1. 原 HTML 只在 20 秒后隐藏 splash，没有失败 UI；
   如果 Flutter 引擎、WASM、Worker 或数据库 Future 永久不结束，用户只会看到白屏/加载文字。
2. 原数据库直接使用 drift 默认路径。默认优先 OPFS；Safari/OPFS 探测或
   Worker 打开没有超时，启动 Future 可能永不完成。
3. 原 Service Worker 对同源静态文件是 cache-first。
   新 `index.html` 与旧缓存 `main.dart.js` / `flutter_bootstrap.js` 可能混用，
   这会直接造成启动卡死。此问题在本机 WebKit 的“旧 SW → 新部署”实验中复现。
4. 图标问号说明 `<img src="icons/Icon-192.png">` 或 apple-touch-icon
   在实际部署中 404/被旧缓存命中；本地包内图标正常。

**不能只凭这些证据断言 iPhone 的唯一根因。** 本机没有 iPhone；
WebKit 实验里旧包能启动，因此 OPFS 探测挂起是高风险假设，而不是已证实的唯一原因。
已修复的是所有能导致“永久加载”的具体路径。

## 2. 已修改文件

| 文件 | 修改 |
| --- | --- |
| `web/index.html` | 启动阶段计时、8s/25s 看门狗、错误面板、重试/诊断入口、图标 404 内联回退、SW 提前注册与 controllerchange 安全重载 |
| `web/flutter_bootstrap.js` | 引擎初始化/runApp 18s 超时；失败显示诊断错误 |
| `web/diagnostics.html` | 独立启动诊断页；资源 200/MIME、SW、Cache、IndexedDB、OPFS、WebCrypto 检查 |
| `web/service_worker.js` | 同源资源改 network-first，旧缓存不再压过新构建；诊断页加入 shell |
| `web/_headers` | `index.html`/SW/诊断页 no-cache；worker JS MIME；WASM MIME |
| `lib/core/database/app_database.dart` | 使用可替换的 Web 数据库连接 |
| `lib/core/database/web_database_web.dart` | Safari 安全连接：新库优先 IndexedDB；已有 OPFS 保留；无存储时报错而不建空库 |
| `lib/core/database/web_database_stub.dart` | 原生/测试继续走 drift_flutter 原生路径 |
| `lib/platform/web/boot_trace_{stub,web}.dart` | Dart 阶段写入 HTML 启动轨迹（只记录阶段/耗时） |
| `lib/main.dart` | boot stage、Flutter/Platform 错误记录 |
| `lib/features/ai/presentation/startup_page.dart` | 数据库读取 12s 超时；失败显示“存档未删除”+重试+诊断，不自动清库 |
| `tool/web/build_web.ps1` | 构建必须包含 `diagnostics.html` |

没有删除、重建或迁移任何用户数据库；没有使用内存空数据库假装修复。

## 3. 修复后实测

测试环境：Windows 11 + Playwright WebKit（iPhone 尺寸/UA），
**不是 iPhone 真机**；Safari 真机仍需复测。

### 空数据首次访问

```text
first-frame 620ms
db-probe-done 777ms  storage=inMemory,sharedIndexedDb,unsafeIndexedDb
db-selected 778ms    sharedIndexedDb
db-open-done 809ms
startup-read-statement-done 1217ms
```

页面正常进入首次声明页。

### 有旧存档/旧版本重新访问

- 先用旧包在 WebKit 创建数据库并写入“声明已读”；
- 原目录覆盖为新包（模拟 Cloudflare 新 deployment）；
- 旧 Service Worker 仍在；
- 重载后新包启动，直接进入首页（`startup-navigate-home`），未再次弹声明。

这同时验证了：

- 旧 IndexedDB 存档被保留；
- 旧 SW 缓存不会继续压过新构建；
- 不需要用户清空网站数据。

### 数据库 Worker 失败

拦截 `drift_worker.js`：

```text
db-probe-done storage=inMemory
startup-failed
```

页面显示“本地故事启动失败 / 存档没有被删除”，提供“重试初始化”和“打开启动诊断”，
不再无限停在 splash。

### Flutter bootstrap 失败

拦截 `flutter_bootstrap.js`：

- splash 变为错误态；
- 显示“启动没有完成”；
- 显示阶段详情；
- 提供重试和诊断链接。

### 外部字体不可用

拦截 fonts.googleapis.com / fonts.gstatic.com：

- Flutter 仍出现首帧（1852ms）；
- 数据库正常打开；
- 说明启动不依赖 Google Fonts 成功。

### 图标

- 包内 `icons/Icon-192.png`、`Icon-180.png`、`Icon-512.png` 均存在；
- 诊断页显示 HTTP 200、image/png；
- 若图片 404，splash 使用内联 SVG 回退，不再显示问号。

## 4. 数据库策略（存档优先）

新 Web 数据库连接逻辑：

1. `WasmDatabase.probe` 有 15s 超时；
2. 检测已有数据库：
   - 已有 OPFS → 保留 OPFS；
   - 已有 IndexedDB → 保留 IndexedDB；
   - 已有数据库但当前无法打开 → 报错，**不创建空库**；
3. 全新数据库：
   - 优先 IndexedDB（Safari 可靠路径）；
   - 没有 IndexedDB 才用 OPFS；
   - 都没有 → 报错，不使用内存库冒充；
4. 打开有 20s 超时；启动页 12s 超时显示错误。

## 5. 仍未验证

- 真实 iPhone Safari 冷启动/添加到主屏幕/关闭重开；
- 真实 iPhone 上已有 OPFS 数据库的打开；
- Safari 软键盘、长篇小说滑动；
- 真实 Cloudflare Pages 本次 deployment（未使用你的账号）；
- 旧 iPhone 是否仍缓存了更早的 SW，需要按下方步骤复测。

## 6. 第二次 iPhone 截图（358ms unhandled rejection）

用户在新错误页看到：

```text
116ms  bootstrap-load
358ms  error:unhandled-rejection  未处理的异步错误（详情已省略）
```

这说明构建已经绕过了原来的永久白屏，但 **“任意 unhandled rejection 立即判死”** 太激进：
它可能在 Flutter 引擎/旧 Service Worker 的内部 Promise 竞争中提前报错，而应用随后本可继续启动。

已进一步改为：

- unhandled rejection 只记录错误类型（如 `Error`/`TypeError`），不再立即判死；
- 2.5 秒后若仍无首帧，自动注销旧 Service Worker 并安全重载一次；
  **不删除 IndexedDB、OPFS、Key 或世界数据**；
- 仍无首帧时：有 unhandled rejection 则在 12 秒显示错误，否则 60 秒；
- 首帧出现后错误面板会被正常隐藏；
- 启动前对 `main.dart.js`、`sqlite3.wasm`、`drift_worker.js`、`manifest.json`、
  `Icon-192.png` 做 HEAD 预检，错误详情会直接显示 HTTP 状态/MIME。

如果新截图里仍是 `asset:main.dart.js HTTP 404`，那是 Cloudflare 部署资产缺失，不是数据库问题。

## 7. 关键外部部署证据（2026-11-21 18:40）

用户给的 Cloudflare 项目是 `fishapp`。直接检查其默认域名：

```text
https://fishapp.pages.dev/main.dart.js
  HTTP 200
  Content-Type: text/html
  body 开头：<!DOCTYPE html> ... <title>Cocos Creator | client</title>

https://fishapp.pages.dev/icons/Icon-192.png
  HTTP 200
  Content-Type: text/html
  同一份 Cocos HTML

https://fishapp.pages.dev/
  HTTP 200
  body 是 Cocos Creator，不是鱼者文游
```

这说明 `fishapp.pages.dev` **不是截图中的鱼者文游站点**，或者项目当前部署的是另一个
Cocos 应用/回退页。它不能解释为普通数据库错误：`main.dart.js` 返回 HTML 会让
Flutter loader 产生 unhandled rejection，图标也会显示问号。

因此：

- 截图中的实际 Safari 地址栏域名必须确认；
- 不要把鱼者文游 ZIP 盲目上传到可能属于 Cocos 的 `fishapp` 项目；
- 必须找到实际提供鱼者文游 HTML 的 Cloudflare 项目/自定义域名；
- 上传后 `main.dart.js` 必须是 JS、`sqlite3.wasm` 必须是 application/wasm、
  `Icon-192.png` 必须是 image/png，不能是 HTML。

## 8. 真实站点 `fishapp-ett.pages.dev` 的最终定位（2026-11-21 19:40）

用户提供实际站点：

```text
https://fishapp-ett.pages.dev/
```

实测：

```text
/                         HTTP 200 text/html   ← 鱼者文游 HTML 正确
/main.dart.js             HTTP 200 application/javascript
/sqlite3.wasm             HTTP 200 application/wasm
/drift_worker.js          HTTP 200 application/javascript
/flutter.js               HTTP 200 application/javascript
/flutter_bootstrap.js     HTTP 200 application/javascript
/version.json             HTTP 200 application/json

/canvaskit/canvaskit.js   HTTP 200 text/html   ← 应为 application/javascript
/canvaskit/canvaskit.wasm HTTP 200 text/html   ← 应为 application/wasm
/assets/FontManifest.json HTTP 200 text/html   ← 应为 application/json
/icons/Icon-192.png       HTTP 200 text/html   ← 应为 image/png
```

WebKit 控制台：

```text
CompileError: WebAssembly.Module doesn't parse at byte 0:
  module doesn't start with '\0asm'

TypeError: 'text/html' is not a valid JavaScript MIME type for module
script 'https://fishapp-ett.pages.dev/canvaskit/canvaskit.js'
```

结论：**Cloudflare 部署只包含根目录文件，`canvaskit/`、`assets/`、`icons/` 目录没有部署上去。**
`main.dart.js` 本身是好的，但 Flutter 引擎加载 CanvasKit 失败，启动立即崩溃；图标也因 `icons/` 缺失回退为问号/内联图。

这不是数据库、IndexedDB 或 OPFS 问题，也不是 Windows 浏览器问题。
当前 ZIP 内确实存在这些目录（38 个文件，包含 `canvaskit/`、`assets/`、`icons/`），
但线上 deployment 没有这些目录。

## 9. 部署修复结果（2026-11-21 20:20）

已通过你登录的 Edge 调试会话，把修复后的 ZIP 直接上传到 `fishapp` 项目
（Production，域 `fishapp-ett.pages.dev`）。

修复后的线上检查：

```text
/canvaskit/canvaskit.js   → 200 application/javascript
/canvaskit/canvaskit.wasm → 200 application/wasm
/assets/FontManifest.json → 200 application/json
/icons/Icon-192.png       → 200 image/png
/main.dart.js             → 200 application/javascript
```

Edge 实际加载：首帧约 8 秒，数据库栈 `sharedIndexedDb` 正常。
WebKit 公网首次加载较慢（约 43 秒才 engine-init、57 秒首帧），因此启动看门狗
从 25 秒放宽到 60 秒；慢网下会继续等待，不会在 25 秒误判失败。

后续用户 21:37 的截图又暴露了一个误判：WebKit 的一个 unhandled rejection 在
12 秒时触发红色错误框，但引擎随后仍可能启动。最终版已改为：

- unhandled rejection **只记录**，不判死、不自动注销 SW；
- 只有 60 秒仍无首帧才显示红色错误；
- 引擎初始化/runApp 超时 45 秒；
- 当前线上已覆盖为最终包 `D550…`。

### 真正的打包根因

Windows 的：

```powershell
[System.IO.Compression.ZipFile]::CreateFromDirectory(...)
```

把 ZIP 条目名写成了反斜杠：

```text
assets\AssetManifest.bin
canvaskit\canvaskit.js
icons\Icon-192.png
```

Cloudflare Pages 把反斜杠当作**文件名字符**，所以这些文件虽然上传了，
但真实 URL `/canvaskit/canvaskit.js` 找不到，回退成 `index.html`。

已改为 `tool/web/zip-static.ps1` 手工写入 **forward slash**：

```text
assets/AssetManifest.bin
canvaskit/canvaskit.js
icons/Icon-192.png
```

并在发布审计中新增“ZIP entry names use forward slashes”检查，防止再犯。
主程序和转换器的构建脚本都已改用该 helper。

## 10. 旧版 iOS 兼容模式（2026-11-22）

主程序使用 Flutter 3.50 CanvasKit，需要 WebGL、WebAssembly 和现代 JavaScript。
旧的 iOS/Safari（低于约 iOS 13.4）无法运行该引擎，这是浏览器能力限制，不能靠启动代码补丁
让完整 Flutter 应用在旧 WebView 里运行。

新增：

- `web/legacy.html`：纯 HTML/ES5 的**只读 `.yuzhe` 阅读器**；
  - 支持未加密 YUZHE v1；
  - 显示世界标题和原始消息；
  - 加密归档会明确提示需要新版主程序；
  - 不联网、不上传、不修改文件。
- `web/index.html`：iOS < 13.4、无 WebGL、无 WebAssembly 或缺少 Promise/fetch 时，
  不再加载 Flutter，直接显示兼容模式页面，避免旧 iPhone 永久白屏。
- Service Worker 缓存 `legacy.html`；
- 构建要求包含 `legacy.html`。

线上实测 `https://fishapp-ett.pages.dev/?old=1`（WebKit iPhone 12.5 UA）：

```text
legacy show
当前 iOS 12.5 低于主程序最低要求（约 iOS 13.4）。
flutter 0
```

`/legacy` 实际读取示例 `.yuzhe`：1 个世界、5 条消息。

**限制：** 旧 iOS 只能只读查看备份，不能创建世界或调用 AI；要完整文游仍需升级 iOS/换设备。

## 11. iPhone 复测步骤

1. 重新上传新的主程序 ZIP 到**同一个** Cloudflare Pages 项目；
2. 不要删除项目，不要清空网站数据；
3. iPhone 关闭旧主屏幕图标/标签页，Safari 重新打开主程序 URL；
4. 如仍看到旧画面，下拉刷新一次；新 SW 接管会自动重载一次；
5. 正常应进入“欢迎来到鱼者文游”或首页；
6. 若仍失败：
   - 打开 `https://你的域名/diagnostics.html`；
   - 截图/复制诊断文本（不要含 Key/聊天）；
   - 把“上次启动阶段”和资源检查结果发回；
7. 图标问号：
   - 确认 `https://你的域名/icons/Icon-180.png` 返回 200；
   - 删除旧主屏幕图标后重新“添加到主屏幕”；
   - 不要清除 Safari 网站数据，以免删掉世界。

## 12. 结论

已消除三类“永久加载”风险：

- 旧 SW 缓存与新构建混用；
- 数据库/Worker 无超时；
- 引擎/资源失败无 UI。

但真实 iPhone 仍未验收；本轮不能宣称“iPhone 已全部通过”。
