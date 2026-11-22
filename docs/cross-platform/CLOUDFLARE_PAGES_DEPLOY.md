# Cloudflare Pages 部署教程（最简单路径）

本教程只使用 Cloudflare Pages 的 **Direct Upload（直接上传）**，不需要 Git、
不需要构建命令、不需要 Node 环境，也不会上传任何 API Key。

> 本文不会使用你的 Cloudflare 账号，也不会代你部署。所有操作由你本人在浏览器里完成。

## 1. 准备文件

最终上传包：

```text
dist/web/FishTextAdventure-0.5.8-cloudflare-pages.zip
```

这个 ZIP 已经满足：

- `index.html` 位于压缩包根目录（没有多一层 `FishTextAdventure-.../` 文件夹）；
- 37 个文件、解压约 21.9 MiB，ZIP 约 9.1 MB；
- 不含 `.map`、`.symbols`、`.last_build_id`、源码、密钥、用户存档；
- 含 `_headers`（安全头、WASM MIME）、`service_worker.js`、`sqlite3.wasm`；
- SHA-256：`6297B9E11228F118523693F6A9DBED91E485F87D452F6909844776F432A40ED2`。

解压后的站点目录也可以直接上传：

```text
dist/web/FishTextAdventure-0.5.8-web/
```

## 2. 在 Cloudflare 创建 Pages 项目

1. 登录 <https://dash.cloudflare.com/>。
2. 左侧选择 **Workers & Pages**。
3. 点 **Create application** → **Pages** 标签 → **Upload assets**。
4. 项目名例如 `fish-text-adventure`（会得到 `https://fish-text-adventure.pages.dev`）。
5. 把上面的 ZIP 拖进去（或选择“上传文件夹”并选中解压后的目录）。
6. 确认文件列表里根目录有 `index.html`，点 **Deploy site**。
7. 等待状态变成 **Success**，打开给出的 `*.pages.dev` 地址。

不需要填：

- Build command
- Build output directory
- 环境变量
- 任何 API Key

## 3. 部署后检查

在电脑或 iPhone 浏览器打开 `https://<项目名>.pages.dev/`：

1. 首屏出现“鱼者文游 / 欢迎来到鱼者文游”，不是 404 或目录列表。
2. 进入首页，创建世界。
3. 设置 → 网页版与数据：显示“添加到 iPhone 主屏幕”和存储状态。
4. 打开开发者工具 Network，确认：
   - `index.html` 200；
   - `main.dart.js` 200；
   - `sqlite3.wasm` 的 Content-Type 为 `application/wasm`；
   - 没有对 `api.deepseek.com` 的请求（未配置 Key 时）。
5. 首次在线打开后，刷新一次；再从首页进入设置，确认 Service Worker 注册
   （Application → Service Workers）。
6. 可选：在 Safari 分享菜单选择“添加到主屏幕”，再从桌面图标打开。

## 4. 更新版本

1. 在本地重新执行：

   ```powershell
   powershell -ExecutionPolicy Bypass -File tool\web\build_web.ps1
   ```

   脚本会重新生成 ZIP，并自动改写 `CACHE_VERSION`，
   旧 Service Worker 缓存会在下次激活时被清理。
2. 回到 Cloudflare Pages 项目 → **Create new deployment** → 上传新的 ZIP。
3. 用户下次打开时，浏览器会下载新 Service Worker；如仍是旧界面，
   关闭标签页再打开，或清除该站点数据后重试。

## 5. 自定义域名（可选）

项目 → **Custom domains** → 添加你的域名并按提示配置 DNS。
Cloudflare 会自动签发 HTTPS 证书；不要使用裸 HTTP 地址。

## 6. 常见问题

| 现象 | 处理 |
| --- | --- |
| 打开是 404 / 文件列表 | ZIP 里多了一层文件夹；重新用根目录含 `index.html` 的 ZIP |
| 白屏，Network 里 wasm 是 `text/plain` | `_headers` 未生效或托管商未识别；确认上传了 `_headers` 和 `sqlite3.wasm` |
| 离线打不开 | 必须 HTTPS；首次在线打开并等待 5–12 秒让缓存写入 |
| 更新后仍是旧版 | 关闭标签页重开；确认部署包里的 `CACHE_VERSION` 已变化 |
| 添加到主屏幕后仍是浏览器栏 | 必须用 Safari 的分享菜单添加；Chrome iOS 不提供该入口 |
| iPhone 上输入 Key 提示不安全 | 必须是 HTTPS 或 localhost；`pages.dev` 满足 |

Cloudflare 官方限制参考：[Pages limits](https://developers.cloudflare.com/pages/platform/limits/)
（单文件最大 25 MiB；本项目最大文件是 CanvasKit wasm，低于该限制）。

## 7. 不要做的事

- 不要把 API Key 填进 Cloudflare 环境变量、URL 查询参数或 `_headers`。
- 不要把 `.yuzhe`、签名证书、私钥、`dist/`、`reports/` 上传到公开仓库。
- 不要为了“看起来能离线”而伪造缓存结果；本项目用真实 Service Worker 测试过。
- 不要使用来源不明的第三方中转；当前 Web 版是官方端点直连。
