# 转换器 PWA 部署记录（V1.2.1）

日期：2026-11-22

## 线上地址

```text
https://fish-converter-offline.3231167124.workers.dev/
```

- Cloudflare 项目/Worker：`fish-converter-offline`
- 部署类型：Cloudflare Workers Static Assets（不是 Pages 项目）
- 独立 origin，与主程序 `https://fishapp-ett.pages.dev/` 分开；
- Service Worker scope：该 origin 根 `/`；
- Cache：`fish-converter-v1.2.1-mobile`；
- 未绑定自定义域，使用 Cloudflare 分配的 workers.dev 域名。

## 发布包

```text
dist/converter/FishTextAdventure-Converter-1.2.1-mobile-cloudflare-pages.zip
490,972 字节
SHA-256 EAA0ABED9E859BDDC803D1766F889666A4C2F090489B8ABDED950ACF1D03282C
```

## 已验证

- 根页面：鱼者文游 · 离线对话转换器；
- `app.js`：200 application/javascript；
- `service_worker.js`：200 application/javascript；
- `manifest.json`：200 application/manifest+json；
- `icon-192.png`：200 image/png；
- `offline.html`：200 text/html；
- Service Worker 已注册，scope 根；
- 实际选择 `01-chatbox-single.json`：
  - 1 个会话、5 条消息；
  - 生成 `.yuzhe`，Blob 12,377 字节，magic `YUZHE`；
- 断网重载显示“当前离线”，页面仍可用；
- 没有网络请求上传聊天，没有 API Key。

## 限制

- 这是 **Workers 静态资源**，`_headers` 的 Pages 安全头可能不生效；内容类型已验证正确；
- 未绑定自定义域名；
- 未在真实 iPhone/Android 真机验证；
- 真实 Chatbox 用户导出仍需脱敏样本验收；
- 多选会话请使用“合并为一个 .yuzhe”，或解压多会话 ZIP 分别导入。

## 更新方法

1. 重新构建 `converter/build.ps1`，得到新的 Pages ZIP；
2. 在 Cloudflare `fish-converter-offline` Worker 中重新上传/部署资产；
3. 保持 origin 不变，不要和主程序合并到同一站点；
4. 部署后检查 `service_worker.js` 缓存版本与 `manifest.json`。
