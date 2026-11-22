# 鱼者文游 V0.4.8 · 真实 API 请求验收

本轮在用户逐次授权下，使用用户新输入的 Key 发出 **一次** 最小真实请求。密钥只存在于本机遮蔽输入框和一次进程内存中，DSH 未读取、未输出、未保存完整密钥。脱敏报告：`reports/v048_api_result.json`。

## 1. 执行方式

- 入口：`tool/Open-DeepSeek-Verify.cmd` → 本机 WinForms 遮蔽输入窗口（`tool/DeepSeek-Verify.ps1`）。
- 支付同意：窗口内必须勾选费用同意；`tool/deepseek_verify.dart` 还会要求 `--confirm-cost`，每次调用最多一次付费请求。
- 传输：Dart 子进程通过标准输入接收 Key，使用项目自己的 `DeepSeekHttpProtocol`，与手机 App 共用同一套 SSE / JSON / usage 解析。
- 端点：`https://api.deepseek.com`，无代理环境变量、无自定义证书、无中间服务器。

## 2. 实际结果（2026-11-18 13:02:13 本地时间）

| 项目 | 实际值 |
| --- | --- |
| 结果 | **success** |
| HTTP 状态 | **200** |
| 模型 | `deepseek-flash` |
| 完成原因 | `stop` |
| 真实生成正文 | 有，JSON 结构有效 |
| 输入 Token | **83**（均为 cache miss） |
| 输出 Token | **56** |
| 缓存命中 Token | **0** |
| 总 Token | **139** |
| 耗时 | **1240 ms** |
| Key 指纹 | `029aa884`（SHA-256 前 8 位，仅用于确认“读到的是这次输入的新 Key”） |
| 请求次数 | 1 次付费请求（与此前 401 无凭据探测无关） |

返回正文预览（真实模型生成，未改写）：

```json
{"narration":"门轴吱呀一声，潮湿的冷风裹着雨腥味涌进茶馆，檐下灯笼的光在积水里晃成一片碎金。","replies":[],"proposal":{"minutes":1,"npcMoves":[]}}
```

这条正文证明：模型按系统提示返回了带 `narration` / `replies` / `proposal` 的合法 JSON，与 App 角色扮演引擎期望的协议一致。

## 3. 逐项核验

| 核验项 | 结论 | 证据 |
| --- | --- | --- |
| 是否正确读取新的 API Key | 是 | 报告中的 Key 指纹来自本次输入；窗口未回填旧 Key |
| 是否连接官方 DeepSeek HTTPS | 是 | 唯一构造地址 `https://api.deepseek.com/chat/completions` |
| 当前模型是否真实可用 | 是 | 响应 `model=deepseek-flash`，官方文档当前主推模型 |
| 是否收到 HTTP 200 | 是 | `httpStatus=200` |
| 是否收到真实模型文本 | 是 | `hasModelText=true`，正文见上 |
| 是否取得实际 Token Usage | 是 | 输入 83 / 输出 56 / 缓存命中 0 / 总 139 |
| 网络代理、证书、请求格式 | 无异常 | 直连成功、`finish_reason=stop`、JSON 有效、无 4xx/5xx |

## 4. 费用

本次为 1 次流式请求，输入 83 + 输出 56 Token，缓存命中 0。按官方公开价（`deepseek-flash` 非高峰：输入 miss $0.15 / 1M，输出 $0.6 / 1M）推算约 **USD 0.000046**；即使按高峰价也不超过约 USD 0.0001。实际扣费以 DeepSeek 账单为准，本文不把估算当账单。

## 5. 与 V0.4.7 的差异

V0.4.7 只取得过一次不带 `Authorization` 的 HTTP 401（真实认证拒绝），没有已认证生成。本轮是项目第一次取得 **已认证 HTTP 200 + 真实正文 + 真实 Token 用量**。此前“Windows 请求没有取得有效 Token 用量”的问题已解决。

## 6. Android 端真实请求

Android 端 **未由 DSH 发出实时生成请求**：没有可用的真机连接（`adb devices` 为空），且本轮费用授权是单次 Windows 请求。Android 侧的构建门、网络权限、安全存储与重启持久化已在 Android 17 模拟器上实际验证，见 [V048_ANDROID_ACCEPTANCE.md](V048_ANDROID_ACCEPTANCE.md)。手机上的首次实时生成仍需用户在自己的手机上输入 Key 后完成一次预算确认。

## 7. 无 Mock 声明

`lib/` 中不存在任何运行时 Mock 生成器；失败时只显示明确错误，不产生替代回复。本报告中的正文来自真实服务端响应，不是测试夹具。
