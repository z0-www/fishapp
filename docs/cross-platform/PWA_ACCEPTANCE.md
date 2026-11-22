# 鱼者文游 PWA 上线验收报告

日期：2026-11-21
范围：主程序 PWA + 独立对话转换器 PWA
本轮通过用户授权的 Edge 调试会话，把主程序 Production 部署到
`https://fishapp-ett.pages.dev/`；没有读取或保存账号密码。

## 1. 两个发布包

| 站点 | 文件 | 大小 | SHA-256 |
| --- | --- | --- | --- |
| 主程序 | `dist/pwa/FishTextAdventure-main-PWA-cloudflare-pages.zip` | 9,137,288 | `D550A23AD5FD1726A89E2E83B4907651060A2124F4267E02A49E8170D29C9E88` |
| 转换器 | `dist/pwa/FishTextAdventure-converter-PWA-cloudflare-pages.zip` | 488,681 | `8730836A156AB09FF9BB21E09D197102B2545668E953C0CF1FC5686F81490282` |

两者根目录均有 `index.html`、`diagnostics.html`、`manifest.json`、`service_worker.js`、`_headers`；
没有 source map、没有 API Key、没有用户聊天、没有第三方统计。

## 2. 站点独立性实测

在同一浏览器会话中实际切换两个本地 origin：

```text
主程序 http://127.0.0.1:8140：写入 __pwa_main_probe=main
转换器 http://127.0.0.1:8141：读取 __pwa_main_probe = null
转换器写入 __pwa_converter_probe=converter
主程序再读取：main 仍在，converter = null
```

- Service Worker scope：各自站点根 `/`；
- Cache Storage：
  - 主程序：`fish-v0.5.8-20261121-2156`
  - 转换器：`fish-converter-v1.1.0-mobile`
- 两个 origin 的 localStorage 不互通。

**部署要求：必须两个独立项目/域名。** 同一域名不同路径会争抢根 SW，不能这样做。

## 3. 主程序 PWA 实测

实际 Cloudflare Production：

```text
https://fishapp-ett.pages.dev/
/canvaskit/canvaskit.js   → application/javascript
/assets/FontManifest.json → application/json
/icons/Icon-192.png       → image/png
```

Edge 实测：首帧约 8 秒，数据库进入 `sharedIndexedDb`。
WebKit 公网首次加载较慢（43 秒 engine-init、57 秒首帧），因此看门狗放宽到 60 秒；
慢网不会在 25 秒误判失败。

| 项目 | 结果 |
| --- | --- |
| 发布包审计（38 文件，21.9 MiB） | ✅ 根 index；无 source map |
| `manifest.json` | ✅ 存在，`display: standalone`，4 个图标 |
| Service Worker 注册/控制 | ✅ |
| Cache Storage | ✅ 主程序自己的 `fish-v0.5.8-...` |
| WebKit iPhone 尺寸空数据启动 | ✅ 首帧约 620ms，数据库约 1.2s |
| WebKit 旧版本 SW → 新构建 | ✅ 自动重载；旧声明记录保留，直接进首页 |
| 数据库 Worker 失败 | ✅ 显示“本地故事启动失败”，不无限加载 |
| Flutter bootstrap 失败 | ✅ HTML 错误面板 + 诊断入口 |
| 手机竖屏 390×844 加载 | ✅ Flutter 首屏渲染 |
| **断网重载** | ✅ `flt-glass-pane` 出现，主界面可打开 |
| 主程序站点与转换器存储隔离 | ✅ |

本轮新增的启动修复详见
[PWA_IPHONE_STARTUP_FIX.md](PWA_IPHONE_STARTUP_FIX.md)。

主程序的外部网络请求边界：

- AI 只直连 `api.deepseek.com`（用户配置 Key 后）；
- 字体可能从 Google Fonts/gstatic 拉取并缓存，不含聊天内容；
- 没有第三方统计/广告脚本；
- 没有开发者中转服务器。

上一轮真实 Chromium 已完成的主程序功能（本轮只改启动、数据库选择和 Service Worker，
未改创作、备份与 AI 调用逻辑）：

- 创建世界、进入世界；
- 完整故事备份导出/加密导出/导入；
- Service Worker 缓存版本 A→B 更新、旧缓存清理、重载；
- 离线字体与首屏；
- 无 Key 时不生成假剧情。

这些记录在 `PHASE2_ACCEPTANCE.md`、`TEST_REPORT.md` 及 `screenshots/`。
本轮不重复跑完整创作流程。

## 4. 转换器 PWA 实测

发布包：488,681 字节，14 个文件。

- manifest/SW 注册正常；Cache `fish-converter-v1.1.0-mobile`；
- manifest `display: standalone`，2 个图标；
- 首次在线后断网重载；
- 断网选择文件 → 预览 → 生成 `.yuzhe`；
- 断网点“保存 / 分享文件”捕获到 `YUZHE`：8,997 字节；
- 输出目录、消息数与角色正确；
- 与主程序 localStorage 隔离；
- 详情见 `converter/TEST_REPORT.md`、`converter/android/TEST_REPORT.md`。

## 5. Android / iPhone 适配

### Android Chrome

已检查：页面在 Android Chrome/Chromium 手机视口可加载，布局竖屏；
本轮没有真实 Android 手机，因此以下仍是**待真机**：

- Chrome“安装应用/添加到主屏幕”；
- 软键盘弹出后的输入框位置；
- 长篇故事滚动性能；
- 关闭后重新打开世界的持久化；
- 离线启动的实际表现。

### iPhone Safari

**本轮仍没有 iPhone 真机**。已用 Playwright WebKit（iPhone 尺寸/UA）验证：

- 空数据首帧约 620ms，数据库约 1.2s；
- 旧 SW → 新构建后自动重载，旧数据库保留；
- 数据库 Worker 失败显示错误，不无限停在 splash；
- 外部 Google Fonts 全部阻断时，首帧仍约 1.85s。

以下仍是**待真机**：

- Safari“添加到主屏幕”；
- 真实 iPhone Safari 冷启动、关闭重开；
- 已有 OPFS 数据库的实际打开；
- 软键盘、长篇小说滑动；
- iOS 存储清理后的恢复。

WebKit 不等于 iPhone Safari，不能据此宣称 iPhone 已全部通过。

## 6. 真实 DeepSeek 接入

**没有有效 DeepSeek Key，本轮没有做真实生成，不能声明通过。**

必须由你人工完成：

1. 在主程序 PWA 设置中填入你自己的 Key；
2. DevTools → Network 确认：
   - `OPTIONS https://api.deepseek.com/chat/completions` 预检；
   - `POST .../chat/completions` 200；
   - `content-type: text/event-stream`；
   - 流式 `data:` 分片、usage、`[DONE]`；
3. 确认页面真的生成新剧情（不是模板/假剧情）；
4. 检查输入/输出 Token 和本地费用统计；
5. 生成中断网：确认没有假剧情、没有自动重发收费请求；
6. Key 失效/401：确认明确报错、不生成故事；
7. 输入含 Key 的截图/日志不要外发。

只验证 `/models` 401 不能证明聊天可用。

## 7. 隐私与数据

- 主程序不经过开发者服务器；只有你配置 Key 后，浏览器直连 DeepSeek；
- 转换器无网络请求，聊天只在浏览器内存处理；
- API Key 放在 `Authorization` 请求头，不进入 URL；
- 没有第三方统计/广告脚本；
- Cloudflare 托管本身可能记录访问 IP/URL 等常规日志；本应用不把聊天正文写入 URL；
- Key 存在浏览器 localStorage（WebCrypto 加密），弱于原生 Keychain/Keystore；
- 清除站点数据会删除世界/Key/缓存；UI 已提示并引导 `.yuzhe` 备份；
- `.yuzhe` 默认不加密，含聊天原文。

## 8. 存档兼容与升级

- Web/Android `.yuzhe` 互通测试 3/3 通过；
- 主 app 全量测试 309 passed；converter 7/7；
- 本机 WebKit 做过“旧包数据库 + 旧 SW → 新构建”覆盖测试：
  新包进入首页，旧“声明已读”记录仍在，没有清空 IndexedDB；
- 没有在真实 Cloudflare 部署上做完整世界（含多章正文）的升级测试；
- 真实 OPFS 数据库升级仍需 iPhone 真机复测；
- 升级前请先导出 `.yuzhe`。

## 9. 尚未通过清单

1. 真实 Android 手机安装到主屏幕、软键盘、长滚动；
2. 真实 iPhone Safari 添加到主屏幕、冷启动/关闭重开、文件选择、存储到文件、OPFS 旧库；
3. 真实 DeepSeek 生成、Token/费用、断线/401；
4. 真实 Cloudflare 上完整世界的版本升级；
5. B站两个实际 URL（主程序已部署，转换器尚未部署）。

## 10. 结论

- 两个 PWA 包已准备好，可独立 Direct Upload；
- 主程序离线壳、转换器离线完整转换、站点隔离已在本机浏览器验证；
- 真实 iPhone/Android 和真实 DeepSeek 仍需真机/真 Key 验收，不能提前宣称全部通过。
