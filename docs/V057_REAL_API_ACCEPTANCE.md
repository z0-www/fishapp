# V0.5.7 真实 DeepSeek 验收

**真机与真实付费验收：未验证。** 本轮没有收到新的费用授权，且 Windows 工作站没有检测到连接的 Android 真机。没有发出模型生成、付费连通探针或余额请求。没有真实 HTTP 200、真实 Token 数量或十轮故事记录。

## 官方资料核对

2026-11-19 核对官方 Chat Completions、usage 及余额接口。代码使用官方 HTTPS 主机，非流式连接测试与 SSE 剧情共用协议层，核对 JSON 结果、流终止及是否存在服务端用量。模型仍为 `deepseek-flash` 与 `deepseek-v4-pro`。当前自带价格表和峰谷时段匹配公开标价，表过期后按未知处理。 [Chat Completions](https://api-docs.deepseek.com/api/create-chat-completion/) · [模型及价格](https://api-docs.deepseek.com/quick_start/pricing/) · [余额](https://api-docs.deepseek.com/api/get-user-balance/)

中国版开放平台协议第 1.1 节描述下游应用集成，第 2.4 节限制凭据外露。原生设备运行时用户输入自己的 Key、由系统安全存储保护，经 HTTPS 直接向平台发请求，与把开发者 Key 嵌入安装包不同。本项目公开分发适用范围仍待确认，不能以技术验证代表获批。 [DeepSeek 开放平台服务协议](https://cdn.deepseek.com/policies/zh-CN/deepseek-open-platform-terms-of-service.html)

## 已核对与未核对项

| 场景 | 状态 | 证据 |
| --- | --- | --- |
| Debug Android/iOS 原生开发入口 | 已实现，自动化测试通过 | 两个本地 Debug 条件、HTTPS、模型与设置检查。 |
| Android Release 配置 | 已实现审核接入点，正式调用未验证 | 默认记录为空，模拟器中在线功能关闭。 |
| iOS Release 配置 | 已实现审核接入点，未验证 | 与 Android 审核隔离，共用真实客户端，当前记录为空。 |
| 无 Key、服务失败、401、402、超时、SSE | 自动化测试通过 | 无假回复或自动扣费重试。Android 模拟器另外检查无 Key、断网仍能阅读。 |
| 手动费用和预算 | 自动化测试通过 | 确认绑定具体参数并单次使用。覆盖余额不足、价格未知和有日预算时用量未确认。 |
| 人称、模型与 3000 字输出 | 自动化测试通过 | 测试拦截实际请求体。没有验证实际生成风格或收费额度。 |
| 有效 Key 的 200、真实正文、真实 Usage、连续十轮与重启 | 未验证 | 需适用分发范围、正式签名版本、Android 真机和本轮明确费用授权。 |

验收表只能记录实际取得的 HTTP 状态、模型、脱敏 Token 用量及耗时。用量未返回时写未知。失败后的重试独立确认。密钥在真机本地输入。 [验收与测试日志](V057_RELEASE_CHECKLIST.md)
