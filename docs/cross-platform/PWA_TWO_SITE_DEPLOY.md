# 两个独立 PWA 站点 · Cloudflare Pages 部署说明

> 本说明不包含任何账号登录、Token 或自动部署操作。需要你本人登录 Cloudflare
> 并上传。未经授权，本轮没有公开部署。

## 1. 发布包

```text
dist/pwa/FishTextAdventure-main-PWA-cloudflare-pages.zip
9,137,288 字节
SHA-256 D550A23AD5FD1726A89E2E83B4907651060A2124F4267E02A49E8170D29C9E88

dist/pwa/FishTextAdventure-converter-PWA-cloudflare-pages.zip
488,681 字节
SHA-256 8730836A156AB09FF9BB21E09D197102B2545668E953C0CF1FC5686F81490282
```

两个 ZIP 的 `index.html` 均在根目录，含各自的 `manifest.json`、`diagnostics.html`、
`service_worker.js`、`_headers`。没有 source map、API Key、用户聊天或统计脚本。

## 2. 必须使用两个独立站点/域名

**不要**把两个站点放在同一个项目、同一个域名下：

- 主程序的 Service Worker 在站点根 scope（`/`）；
- 转换器的 Service Worker 也在它自己的根 scope；
- 同一 origin 下会争抢根路径缓存/控制权，且 localStorage 共用。

推荐：

```text
主程序：https://play.example.com/      （独立 Cloudflare Pages 项目）
转换器：https://convert.example.com/   （另一个独立项目）
```

没有自有域名也可以先用 Cloudflare 分配的：

```text
https://fish-text-adventure.pages.dev/
https://fish-converter.pages.dev/
```

仍然是两个独立 origin。

## 3. 上传步骤（主程序）

1. 登录 Cloudflare Dashboard；
2. **Workers & Pages → Create → Pages → Upload assets**；
3. 项目名：`fish-text-adventure`；
4. 上传 `FishTextAdventure-main-PWA-cloudflare-pages.zip`；
5. 生产分支/部署；等待状态变成成功；
6. 打开 `https://<project>.pages.dev/`，确认是“鱼者文游”主界面；
7. 在 Pages 项目 → Custom domains 绑定 `play.example.com`（可选）。

## 4. 上传步骤（转换器）

1. 再新建一个 Pages 项目，项目名：`fish-converter`；
2. 上传 `FishTextAdventure-converter-PWA-cloudflare-pages.zip`；
3. 打开 `https://<project>.pages.dev/`，确认显示“鱼者文游 · 离线对话转换器”；
4. 绑定 `convert.example.com`（可选）。

**绝对不要**把转换器 ZIP 传到主程序项目，或反过来。

## 5. 部署后检查

主程序：

- [ ] `https://play.../` 首屏正常；
- [ ] `https://play.../diagnostics.html` 可打开，图标/WASM/Worker 均为 200；
- [ ] Network 里 `manifest.json`、`service_worker.js` 均为 200；
- [ ] Application → Service Workers 显示主程序 SW；
- [ ] Cache Storage 中出现 `fish-v0.5.8-...`；
- [ ] Chrome 菜单出现“安装应用/添加到主屏幕”；
- [ ] Safari 分享出现“添加到主屏幕”。

转换器：

- [ ] `https://convert.../` 显示转换器；
- [ ] Service Worker scope 是转换器自己的 origin；
- [ ] Cache Storage 是 `fish-converter-v1.1.0-mobile`；
- [ ] 与主程序 localStorage 不互通。

## 6. 更新版本

- 更新主程序：重新构建 `dist/web/...zip`，在**同一个** Pages 项目上传新 deployment；
  主程序 SW 的 `CACHE_VERSION` 会随构建变化，旧缓存清理；不要删除项目。
  新页面会提前注册 SW；若检测到旧 controller，会安全重载一次，避免旧
  `main.dart.js` 与新 `index.html` 混用。
- **不要**让用户清除 Safari/Chrome 网站数据来升级；数据库连接会保留已有
  IndexedDB/OPFS，打不开时只报错，不会建空库。
- 升级后如仍失败，先打开 `/diagnostics.html` 取证。
- 更新转换器：重新构建 converter ZIP，在**同一个** converter 项目上传。
- 两个项目的部署互不影响。
- 更新后先在线打开两次，再测试离线；重要世界先导出 `.yuzhe`。

## 7. 不要做的事

- 不要用同一个 Pages 项目托管两个站点；
- 不要把两个站点放到同一域名的 `/app`、`/converter` 子路径；
- 不要在 B站/聊天中发布带 API Key 的 URL；
- 不要为了让 PWA 能联网而添加第三方统计、广告或中转服务器。
