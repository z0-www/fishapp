# 鱼者文游 V0.4.9 · DeepSeek API 整改

## 构建策略

| 环境 | 直连条件 |
| --- | --- |
| Android / iOS Debug | 普通原生 Debug 已启用两个开发开关。端点限官方 HTTPS 并校验模型，实际请求仍需有效 Key 和本轮费用确认。 |
| Android Release | Android 发布审核独立控制。源码审核状态仍为关闭，Debug 开关无法打开发布直连。 |
| iOS Release | iOS 发布审核单独控制，需核对原生 BYOK 适用范围、Apple 渠道要求和签名。 |
| Windows 开发验收 | 独立工具使用与应用相同的 DeepSeek HTTP 协议层。Key 从本机遮蔽终端输入。每次请求单独确认。 |

本轮核对了官方 Chat Completions、SSE、模型和价格。使用 `deepseek-flash`，正式接入依据需保留提供方确认覆盖的平台、发布渠道、地区和允许的密钥流转方式。第 1.1 节允许下游集成，第 2.2 节对客户端代码中的 Key 暴露有明确限制。Windows 连通结果与原生发行审核分别验收。 [官方接口](https://api-docs.deepseek.com/api/create-chat-completion/) [官方价格](https://api-docs.deepseek.com/quick_start/pricing/) [开放平台条款](https://cdn.deepseek.com/policies/en-US/deepseek-open-platform-terms-of-service.html)

## 已修复

- 费用确认显示当前模型、输入估算、最大输出 Token 和「预计费用（非严格上限）」。
- 成功回合在同一 SQLite 事务保存回复、世界状态、检查点和已返回用量。失败或中止时，若服务已返回用量，仍保留计费证据；未返回用量时保持未知。
- 密钥继续由 Android Keystore 或 iOS Keychain 保护。Windows 证据只保存时间、HTTP、模型、用量和合成测试正文预览。

## 已通过真实测试

2026-11-18，Windows 本机进行了 1 次非流式最小连通请求和 10 轮流式 JSON 剧情。11 次均为 HTTP 200，均取得真实模型正文。连通请求耗时 698 毫秒，使用输入 7、输出 2 Token。

| 范围 | 输入 | 输出 | 输入缓存命中 | 总 Token |
| --- | ---: | ---: | ---: | ---: |
| 连通和 10 轮剧情 | 5,446 | 802 | 3,584 | 6,248 |

按所核实的峰值单价估算约 USD 0.001543。供应商 API 返回 Token 用量，账单金额以控制台为准。原始脱敏回执见 [v049_windows_api_result.json](../reports/v049_windows_api_result.json)。

## 仅通过自动化测试

V0.4.9 静态分析无问题，272 项测试通过。覆盖未配置 Key、失败、取消、SSE 与回复存档等行为。Windows 无离线替身参与真实联调。

## 尚未验证

Android 与 iOS 真机上的 HTTP 200、连续剧本、费用落库与杀进程后恢复仍待实测。Windows 验收工具保留同一会话的真实模型输入输出，移动端 SQLite 持久化由自动化另行覆盖。

Windows 可复现入口为 `dart run tool/deepseek_verify.dart --story --report=reports/v049_windows_api_result.json`。先在本机遮蔽提示处输入 Key，每次看到费用后输入 `YES`。
