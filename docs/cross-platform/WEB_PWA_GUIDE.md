# Web / PWA 网页版指南

## 1. 目标与结论

目标：让没有电脑的 iPhone 用户用 Safari 打开鱼者文游，并“添加到主屏幕”像应用一样使用。

现状：**Web 构建可运行**，核心业务（世界、NPC、剧情、AI 配置、消费统计、`.yuzhe` 备份）
复用原有 Dart 代码。浏览器相关能力通过平台适配器实现，未复制一套游戏逻辑。

已在本机 Edge（Chromium 157）以 390×844 移动视口真实加载验证（见
[TEST_REPORT.md](TEST_REPORT.md)），但 **尚未在真实 iPhone Safari 上验证**。

## 2. 功能状态

| 功能 | Web 状态 | 说明 |
| --- | --- | --- |
| 本地数据库 / 迁移 | ✅ 已实现 | drift + `sqlite3.wasm`，浏览器 OPFS/IndexedDB；与 Android 同一 schema v6 |
| 世界创建、编辑、NPC 设定 | ✅ 已实现 | 复用原业务逻辑，浏览器内已验证创建世界 |
| 剧情、上下文、记忆 | ✅ 代码复用 | 依赖 AI 的部分需用户 Key；无 Key 时明确提示 |
| 第一/二/三人称、叙事方式、100–3000 字 | ✅ 代码复用 | 设置页与角色页保持不变 |
| DeepSeek API Key | ✅ 浏览器加密存储 | WebCrypto + localStorage；仅 HTTPS/localhost 可用 |
| 真实 DeepSeek 调用 | ✅ 直连已打通 | CORS 实测允许；SSE 用 fetch + ReadableStream（非 XHR 假流式） |
| Token/费用统计 | ✅ 代码复用 | 只使用 API 返回的 usage，不伪造 |
| 大肥鱼消费管家 | ✅ 代码复用 | 与移动端一致 |
| `.yuzhe` 导出 | ✅ 已实现 | 浏览器下载；密码加密可用（WebCrypto PBKDF2/AES-GCM） |
| `.yuzhe` 导入 / 恢复 | ✅ 已实现 | 文件选择 → 预览 → 恢复；已实测两次恢复出两个世界 |
| 附件原文件 | ⚠️ 仅元数据 | 网页版不打包附件二进制；导出/恢复时会明确提示 |
| 系统分享入口 | ⚠️ Safari 不支持 | 改用“从本机选择文件”；不会伪装成已支持 |
| PWA Manifest / 图标 | ✅ 已实现 | 白蓝配色、192/512/maskable/180 图标 |
| 离线缓存 | ✅ 已实现并实测 | 自定义 `service_worker.js`；首次在线加载后断网重新导航仍可启动（Chromium 实测） |
| Safari 软键盘/安全区 | ⚠️ 未实测 | 使用 `SafeArea`、`viewport-fit=cover`；需真机验收 |

## 3. 本地运行（Windows 已验证）

```powershell
flutter pub get
flutter build web --release
# 任选其一：
python -m http.server 8123 --directory build\web
# 或使用项目自带静态服务器（正确的 wasm MIME + keep-alive）：
node tool\web\serve_web.mjs 8124 build\web
```

打开 <http://127.0.0.1:8124/>。首次会显示产品声明；进入后可直接创建世界。

> 必须在 `localhost` 或 HTTPS 下使用，否则浏览器不提供 WebCrypto，API Key 无法保存。
> 这是浏览器安全限制，不是应用可以绕过的。

一键打包：

```powershell
powershell -ExecutionPolicy Bypass -File tool\web\build_web.ps1
```

## 4. 部署（静态托管即可）

Web 版是纯静态站点，不需要鱼者服务器，也不需要数据库服务器。把
`dist/web/FishTextAdventure-0.5.8-cloudflare-pages.zip` 上传到 Cloudflare Pages，
或把 `dist/web/FishTextAdventure-0.5.8-web/` 整个目录放到任意 HTTPS 静态托管：

- GitHub Pages（免费、HTTPS、无需后端）
- Cloudflare Pages / Netlify / Vercel（免费额度足够）
- 自己的 Nginx / 对象存储（必须 HTTPS）

注意事项：

1. **不要**把任何 API Key、`.env`、签名文件放进构建目录。
2. 路由使用 Flutter 默认的 hash 策略（`/#/settings`），静态托管无需 SPA 回退。
3. 可选：为获得 OPFS 完整能力，托管方可发送
   `Cross-Origin-Opener-Policy: same-origin` 与
   `Cross-Origin-Embedder-Policy: credentialless`。
   不发送也能运行（自动回退 IndexedDB）；本项目本地测试两种路径都通过。
4. `sqlite3.wasm` 必须以 `application/wasm` 返回；GitHub Pages/Cloudflare 默认正确，
   自建服务器请检查 MIME。
5. 构建脚本使用 `--no-web-resources-cdn` 把 CanvasKit 打进本地，配合自定义
   `service_worker.js` 实现离线启动；不要把它改回 CDN，否则首次离线可能缺 CanvasKit。
6. `tool/web/build_web.ps1` 会在打包产物里把 `CACHE_VERSION` 改写成
   `fish-v<版本>-<构建时间>`，所以每次重新构建都会自动使旧缓存失效；
   若你直接 `flutter build web` 而不走该脚本，才需要手动修改缓存版本。

## 5. Safari「添加到主屏幕」

1. 用 **Safari** 打开部署后的 HTTPS 地址（不是微信/QQ 内置浏览器）。
2. 点底部工具栏中间的“分享”按钮。
3. 向下找到“添加到主屏幕” → 名称建议“鱼者” → 添加。
4. 从主屏幕图标打开，即为无地址栏的独立窗口。
5. 首次打开后建议进入「设置 → 网页版与数据」：
   - 点“请求持久化存储”；
   - 立即导出一次 `.yuzhe` 备份。

> iOS 的“添加到主屏幕”不会像 Android 那样弹安装横幅，必须手动走分享菜单。
> Safari 的网站数据可能在“清除历史记录与网站数据”或长期未使用时被清除。

## 6. 数据保护

- 浏览器存储不是永久保险箱。设置页会显示当前是否获得持久化存储，并持续提示导出备份。
- 清除网站数据、换浏览器、换手机都会丢失本地世界；`.yuzhe` 是迁移的唯一完整载体。
- 网页版刷新后，**已选择但尚未导入完成的文件内容不会保留**（只保存在本次会话内存），
  页面会提示重新选择，不会用空内容冒充原文件。
- `.yuzhe` 中的附件原文件在网页版只保留名称、大小等元数据；世界、人物、对话、记忆、
  分支、检查点等故事数据完整保留。
- 离线字体依赖已访问页面缓存的 Noto 子集；未访问页面的生僻字可能显示方框。
  在线状态不受影响。若需要完全离线字体覆盖，后续可内置一份中文字体子集。

## 7. API Key 与 BYOK

- Key 由用户自行在 DeepSeek 官方平台申请；鱼者不代管账户、不代付费用。
- 网页版使用 `flutter_secure_storage_web`：AES-GCM 加密后写入 `localStorage`，
  包装密钥也在同源存储中。这能防止明文直读，但**不能抵御 XSS、恶意扩展或已被攻破的浏览器**。
- Key 只发送给 `https://api.deepseek.com`，不经过鱼者服务器，不写入日志、URL、分析系统。
- 公共电脑、网吧、他人手机不建议保存 Key；使用后可在「AI 服务设置 → 删除 API Key」清除。
- 清除站点数据会同时删除 Key；需要重新输入。

## 8. 与移动端的差异（必须如实告知用户）

| 项目 | Android/iOS 原生 | Web |
| --- | --- | --- |
| 密钥存储 | Keystore / Keychain | WebCrypto + localStorage（较弱） |
| 文件导入 | 系统分享、文件选择 | 浏览器文件选择（无系统分享入口） |
| 附件原文件备份 | 完整 | 仅元数据 |
| 离线 | 安装后离线可用 | 首次在线加载后可离线启动（Chromium 实测；iPhone 未实测） |
| 后台/生命周期 | 原生生命周期 | 浏览器标签页，切后台可能被冻结 |

## 9. 已知问题 / 下一步

1. 在真实 iPhone Safari 上验证安全区、软键盘、长文阅读和“添加到主屏幕”。
2. 验证 service worker 断网启动（当前只确认构建产物包含缓存脚本）。
3. 用真实 DeepSeek Key 完成一轮网页版生成，核对 Token 与费用记录。
4. 如需要附件原文件，可在后续版本增加 IndexedDB 附件仓（本次未实现，避免伪装完整）。
5. 托管方若收紧 CORS，请参考 [CORS_AND_RELAY.md](CORS_AND_RELAY.md) 的最简中转设计，
   在获得用户批准前不要部署中转服务器。
