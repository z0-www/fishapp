# DeepSeek SSE、断线、Token Usage 与费用逻辑审计

日期：2026-11-20
范围：Flutter Web 真实传输路径、Dio 非流式路径、`DialogueEngine`、`UsageRepository`、
`TurnCoordinator`、钱包/价格估算。
结论先行：**没有发现伪造 Token 或伪造费用的路径；真实 API 仍未用有效 Key 联调。**

## 1. Web 真实是流式，不是假流式

- 非流式请求（余额、模型列表、连接测试）走 Dio；浏览器适配器是 XHR，会等完整响应，
  这对这些短请求可接受。
- 剧情生成走 `web_sse_bytes_web.dart`：
  - `fetch('https://api.deepseek.com/chat/completions')`；
  - `Response.body.getReader()` 逐块读取；
  - 每块交给 `DeepSeekHttpProtocol.decodeSse`，按 `data:` 与空行分帧；
  - 必须收到 `[DONE]` 才正常结束。
- 因此不是 XHR 缓冲完整响应后一次性解析。

## 2. 断线与异常处理

| 场景 | 行为 | 是否可能伪造 |
| --- | --- | --- |
| 连接 30 秒未建立 | 中止请求，提示“连接超时：30 秒内未能建立到 api.deepseek.com 的连接。” | 否 |
| 180 秒无新数据 | abort，提示“等待超时：180 秒内未收到响应数据。” | 否 |
| 流中途网络错误 | 丢弃半截正文，提示“流式连接中断，请重试。” | 否 |
| 连接正常关闭但没有 `[DONE]` | 视为异常，不保存本轮 | 否 |
| 收到错误帧 | 提示“模型服务在回复过程中返回错误，本轮未保存。” | 否 |
| HTTP 401/402/429 等 | 映射为固定中文提示，不进入剧情正文 | 否 |
| 用户点停止 | abort，提示“已停止请求；服务端可能已消耗 Token。” | 否 |

半截正文只有在收到完整完成标记、JSON 解析、世界校验都通过后才会提交；
不会把半截内容当完整剧情保存。

## 3. Token Usage 的来源

- 请求体使用 `stream_options.include_usage = true`。
- 只读取服务端返回的 `usage` 字段：
  `prompt_tokens`、`completion_tokens`、`prompt_cache_hit_tokens`、
  `prompt_cache_miss_tokens`、`total_tokens`；
  以及兼容字段 `prompt_tokens_details.cached_tokens`。
- `DeepSeekHttpProtocol.readUsage` 只接受非负整数；缓存命中不能大于输入 Token。
- 没有“按字数估算 Token”后写成实际 Token 的路径。
- 若流在 usage 帧之前断开：`markAwaitingUsage` 留下的记录会保持“用量未知”，
  UI 显示“用量未知，可能已产生费用”；不会补一个假数字。
- 若已经收到 usage 但后续 JSON 解析/世界校验失败：`DialogueEngine` 返回带
  `inputTokens/outputTokens` 的结果，`TurnCoordinator` 在失败路径仍记录已知 usage，
  但不会提交正文或世界状态。

## 4. 费用估算

- `UsageRepository.record` 只有当：
  - 价格表存在且模型匹配；
  - 缓存 Token 已知（或输入为 0）
  才计算 `estimatedUsd`。
- 否则 `estimatedUsd = null`，页面显示“未估价”，并计入“未估价/未知”次数；
  不把未知费用显示为 0 或“免费”。
- 价格版本写入 `priceVersion`；实际账单仍以 DeepSeek 官方为准。
- 本地费用统计只是估算，不能替代官方账单。

## 5. 已知的保守/潜在问题（非伪造）

1. **未知记录不会自动过期。** 失败请求留下的 `usage-request-*` 会一直出现在
   “请求 Token 与上下文差异”中；钱包只统计当天的未知数。历史未知可能让用户困惑，
   但不会让金额变多或变少。
2. **缓存 Token 缺失时无法估价。** 部分响应可能不带缓存字段；此时估价为 null。
   这是保守处理，不是漏记 Token。
3. **流式开始后才收到 401/402**（少见）时，`DialogueEngine` 的
   `rejectedBeforeGeneration` 判定可能不成立，待确认记录会保留为未知。
   这是“宁可显示未知，也不伪造已拒绝”的取舍。
4. **浏览器标签页被冻结**时，计时器与读取可能暂停；恢复后可能超时，
   本轮显示未知。不会自动重发，避免重复计费。
5. **真实 Safari 的 fetch/ReadableStream 行为**未在 iPhone 上验证；
   Chromium 与生产代码浏览器级桩测试通过。
6. **`usage` 是服务端真实返回**；如果 DeepSeek 返回异常数值，`readUsage` 会拒绝，
   而不是猜测。

## 6. 测试证据

- `tool/web/sse_selftest.dart` + `sse_selftest.html`（浏览器真实 `Response`/`ReadableStream` 桩）：
  - 正常流 + usage + `[DONE]`；
  - 中途断网；
  - EOF 无 `[DONE]`；
  - HTTP 401；
  - 用户取消。
  结果 5/5 通过。
- `test/ai/deepseek_connection_test.dart` 覆盖：
  - usage 缺失不伪造；
  - 401 清除待确认；
  - 丢完成标记仍记录已返回 usage 但拒绝半截正文；
  - `finish_reason=length` 记录 usage 且不提交状态；
  - 错误 JSON 在记录 usage 后拒绝；
  - 失败 usage 写入回滚。
- 浏览器端到端：无 Key 时行动发送 **0 次** DeepSeek 请求，页面无剧情；
  保存 Key 后 `localStorage` 只有密文，URL/资源/正文无明文。

## 7. 仍需真实 Key 验证的项目

- 真实模型返回的 `usage` 是否包含缓存字段；
- 真实流式速度与“逐段显示”；
- 真实 401/402/429 与断网提示；
- 费用估算与官方账单的差异；
- Safari 真机上的流式与后台切换。

没有有效 Key 时，这些项目**不能**标记为通过。
