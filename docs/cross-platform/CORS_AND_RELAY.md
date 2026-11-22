# DeepSeek 浏览器直连实测与中转方案

测试时间：2026-11-20（Asia/Shanghai）
测试端点：`https://api.deepseek.com`（官方 HTTPS）
测试网络：本机 Windows 11，Edge 157（Chromium），页面来源 `http://127.0.0.1:8124`

## 1. 预检（curl）

```text
OPTIONS /chat/completions
Origin: http://localhost:8080
Access-Control-Request-Method: POST
Access-Control-Request-Headers: authorization,content-type

HTTP/1.1 200 OK
access-control-allow-credentials: true
access-control-allow-methods: POST
access-control-allow-headers: authorization,content-type
access-control-allow-origin: http://localhost:8080
vary: origin, access-control-request-method, access-control-request-headers

OPTIONS /user/balance
HTTP/1.1 200 OK
access-control-allow-methods: GET
access-control-allow-headers: authorization
access-control-allow-origin: http://localhost:8080

GET /models（带 Origin，无有效 Key）
HTTP/1.1 401 Authorization Required
access-control-allow-origin: http://localhost:8080
access-control-allow-credentials: true
```

服务端会把请求的 `Origin` 回显到 `access-control-allow-origin`，并允许
`authorization` 与 `content-type` 请求头。

## 2. 浏览器内实测（真实页面 Origin）

在加载鱼者 Web 构建的页面里执行：

```js
fetch('https://api.deepseek.com/models', {
  headers: { Authorization: 'Bearer INVALID_TEST_KEY' },
}).then(async (r) => ({ status: r.status, type: r.type, body: await r.text() }));
```

结果：

```json
{
  "status": 401,
  "type": "cors",
  "body": "{\"error\":{\"message\":\"Authentication Fails, Your api key: ****0000 is invalid ...\"}}"
}
```

`type` 为 `cors`、能读到 401 响应体，说明浏览器**没有**把请求当作 CORS 阻断；
失败原因只是测试用密钥无效。预检请求在 DevTools 中为 200，无 CORS 错误。

## 3. 结论

1. **可以直接从浏览器调用官方 DeepSeek API，不需要中转服务器。**
2. 因此 Web 版保持原 BYOK 架构：Key 只存在用户浏览器，只发往 `api.deepseek.com`。
3. 流式输出使用 `fetch` + `ReadableStream`（`lib/features/ai/data/web_sse_bytes_web.dart`），
   不是 XHR 假流式；Dio 的浏览器适配器（XHR）只用于余额、模型列表、连接测试等非流式请求。
4. 本次没有部署任何服务器、没有上传 Key、没有把 Key 写入源码/网址/日志/分析系统。

## 4. 如果未来 CORS 收紧

`api.deepseek.com` 的 CORS 策略可能变化（服务端配置不在本项目控制内）。若某天直连失败，
**不要**在客户端伪造剧情或静默降级；应按以下顺序处理：

1. 先确认失败类型是 CORS（浏览器控制台/`fetch` 的 `TypeError: Failed to fetch`），
   而不是 401/402/网络断开。
2. 告知用户“当前浏览器环境无法直连”，保留本地世界与手动重试；不要自动改用假数据。
3. 只有在用户明确批准并理解以下影响后，才部署中转。

### 最简中转设计（未部署）

- **形态**：一个无状态 HTTPS 反向代理（Cloudflare Worker、Deno Deploy、自建 Nginx 均可）。
- **职责**：转发 `POST /chat/completions`、`GET /user/balance`、`GET /models`；
  透传 `Authorization`、`Content-Type`、`Accept`，原样流式返回 SSE。
- **不保存**：不写日志、不缓存请求体、不落盘 Key；只允许官方端点，不开放任意 URL。
- **CORS**：只允许鱼者网页的实际 Origin；`Access-Control-Allow-Credentials` 按需最小化。
- **费用**：中转本身只产生带宽/函数调用费用（Cloudflare Workers 免费额度通常足够），
  **模型费用仍由用户 Key 在 DeepSeek 结算**，不会因为中转而改变。
- **安全影响（必须向用户说明）**：
  - 用户的请求正文与 API Key 会经过中转运营者，信任模型从“只有 DeepSeek”变为
    “DeepSeek + 中转运营者”；
  - 中转成为可用性单点，必须 HTTPS、限流、防滥用；
  - 不允许在中转记录 Key 或对话内容，否则违反本项目 BYOK 与隐私原则。
- **应用侧改动（当前未实现）**：需要新增用户显式开启的“中转地址”设置，
  并放宽 `DeepSeekConfig.hasSafeEndpoint` 的固定主机限制；这会改变现有安全边界，
  因此必须单独评审，不能偷偷把默认地址改到第三方。

示例 Worker 骨架（仅设计参考，未部署、未接入应用）：

```js
export default {
  async fetch(request) {
    const url = new URL(request.url);
    if (!['/chat/completions', '/user/balance', '/models'].includes(url.pathname)) {
      return new Response('not found', { status: 404 });
    }
    const origin = request.headers.get('Origin') || '';
    if (origin !== 'https://your-fish-host.example') {
      return new Response('forbidden', { status: 403 });
    }
    const upstream = await fetch(`https://api.deepseek.com${url.pathname}`, {
      method: request.method,
      headers: {
        Authorization: request.headers.get('Authorization') || '',
        'Content-Type': 'application/json',
        Accept: request.headers.get('Accept') || 'application/json',
      },
      body: request.method === 'GET' ? undefined : request.body,
    });
    const headers = new Headers(upstream.headers);
    headers.set('Access-Control-Allow-Origin', origin);
    headers.set('Vary', 'Origin');
    return new Response(upstream.body, { status: upstream.status, headers });
  },
};
```

> 再次强调：以上中转**没有**部署，也没有被 Web 构建使用；当前 Web 版是官方端点直连。
