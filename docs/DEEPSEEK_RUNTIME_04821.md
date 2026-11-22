# 鱼者文游 V0.4.8+21 · DeepSeek 接入与验收

## 构建行为与正式版设计

| 构建环境 | 当前行为 |
| --- | --- |
| Android / iOS 原生 Debug | 普通 Debug 构建默认可真实调用。显式设置 `DEEPSEEK_EXPERIMENTAL=false` 或 `DEEPSEEK_REAL_API_DEV_TEST=false` 可关闭 |
| Profile / Release | 原生直连仍关闭。Debug 编译参数不会改变这个条件 |
| Web / 桌面 App | 应用原生直连路径关闭。独立开发工具与 App 的开关分开 |

Android 和 iOS 共用 `DeepSeekApiClient`、SSE 解析、用量记录、对话校验和存档。密钥由用户输入，保存在 Keystore 保护的安全存储或仅本机 Keychain。请求使用官方 HTTPS 地址，不跟随重定向。不将密钥嵌入源码、构建参数、APK 或诊断。

正式发布建议延用用户自己的 Key 和共用客户端。收到足以覆盖公开分发、Android/iOS 平台和预定地区的适用许可范围后，在发布审查中开启单独的正式接入配置，并复核费用授权、在线处理范围告知、凭据存储和禁止重定向。用户已表示已获得确认，具体范围或脱敏依据尚待提供，因此当前 Release 开关保持关闭。正式版设计没有引入鱼者服务器。 [DeepSeek 开放平台条款](https://cdn.deepseek.com/policies/en-US/deepseek-open-platform-terms-of-service.html)

## 官方协议与价格

使用 `POST https://api.deepseek.com/chat/completions`。模型 `deepseek-flash` 和 `deepseek-v4-pro` 当前均支持 JSON 格式。剧情使用 SSE，从事件读取 `finish_reason` 和服务端 `usage`，要求收到 `[DONE]` 才能继续校验并保存。连接测试使用一次最多 8 输出 Token 的非流式请求。 [Chat Completions](https://api-docs.deepseek.com/api/create-chat-completion/)

| 模型 | 峰时缓存未命中输入 | 峰时缓存命中输入 | 峰时输出 |
| --- | ---: | ---: | ---: |
| deepseek-flash | USD 0.30 | USD 0.006 | USD 1.20 |
| deepseek-v4-pro | USD 1.32 | USD 0.044 | USD 3.96 |

表中单位为每百万 Token，官方非峰时费率为表中一半。预算使用保守参考估算，实际费用以 DeepSeek 账单为准。每轮确认后最多尝试一次，失败、停止或重启均不会自动重发。 [DeepSeek 模型与价格](https://api-docs.deepseek.com/quick_start/pricing/)

## 真实请求证据与回归

本轮收到用户对 Android 真机一次最小连通测试和十轮剧情的费用授权。ADB 检查没有检测到已连接手机。**本轮 Android 已认证请求未执行，HTTP 200 和十轮真实剧情均未验收。** 早期的 Windows 记录中，实际收到过一条 `deepseek-flash` HTTP 200 响应（输入 83、输出 56、缓存命中 0）。可在同目录的 [V0.4.8 历史实测](V048_REAL_API_TEST.md) 查看历史证据。

本机静态分析通过，268 项自动化测试通过。测试覆盖发行构建判定、凭据缺失和 HTTP 错误、流分片及断开、取消与预算防重、十轮旁白上下文、数据库重开及中断状态整理。测试替身不在生产运行路径。真机验收仍需在手机本机填写 Key，先测试连接，再在独立测试世界逐轮确认预算并记录 HTTP 状态、实际输入/输出/缓存 Token 和落库情况。可在「设置 → 用量与预算 → 请求 Token 与上下文差异」查看脱敏记录。重开 App 后继续同一世界，确认先前回复仍可读。
