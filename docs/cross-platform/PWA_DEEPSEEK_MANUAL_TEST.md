# PWA 真实 DeepSeek 人工验收步骤

> 本轮没有有效 Key，**没有**做真实生成验收。下面步骤需你本人执行；
> 不要把 Key 发到聊天、截图、B站评论或公开仓库。

## Android Chrome / 桌面 Chrome

1. 打开已部署的主程序 PWA（HTTPS）。
2. 设置 → API Key：
   - 填入你自己的 DeepSeek Key；
   - 保存后刷新页面，确认 Key 仍在（仅在当前站点）。
3. 打开 DevTools → Network，勾选 Preserve log。
4. 新建/进入世界，发送一条短行动（例如“我推开门”）。
5. 必须看到：
   - `OPTIONS https://api.deepseek.com/chat/completions` 预检成功；
   - `POST .../chat/completions` 状态 200；
   - Response Headers `content-type: text/event-stream`；
   - EventStream 中有 `data:` 分片、usage、`[DONE]`。
6. 页面必须出现真实 AI 生成的新剧情，而不是固定模板。
7. 查看 Token：
   - 输入 Token、输出 Token；
   - 本地费用统计/预算提示是否更新；
   - 与 DeepSeek 控制台记录核对。
8. 失败路径：
   - 生成中断网/取消：不能出现假剧情；不能自动重发收费 POST；
   - Key 失效/401：明确报错，不生成故事；
   - 刷新页面：不应自动重新发起上一次收费请求。

## iPhone Safari

Safari 远程调试通常需要 Mac + Safari Web Inspector；没有 Mac 时：

1. 用 iPhone Safari 打开主程序；
2. 输入 Key，生成一条短剧情；
3. 观察是否真实生成、Tokens/费用是否显示；
4. 断网后再次生成，确认报错且不出假剧情；
5. 用另一台设备/录屏记录，**不要录到 Key**。

没有 Mac 的情况下，不能声称完成 iPhone 网络层验收；只能做界面和结果层人工检查。

## 只看 `/models` 不算通过

`GET /models` 返回 401/200 只能证明网络可达/Key 可能有效，**不能证明**：

- `/chat/completions` POST 正常；
- 流式 SSE 正常；
- 能生成剧情；
- Usage 和费用正确。

## 安全

- Key 只在 `Authorization` 头，不应出现在 URL；
- 不要提交含 Key 的 HAR/截图；
- 测试后可在 DeepSeek 控制台吊销临时 Key；
- 浏览器 localStorage 中的 Key 仅 WebCrypto 加密，弱于原生 Keychain/Keystore。
