# 鱼者文游 V0.4.7 · 真实 AI 接入验收

本轮验收以产品基线 `0.4.6+13` 为起点。独立 Windows 开发入口更新，Android 正式发行限制保持有效。静态分析无问题，259 项自动化测试通过，无费用确认参数时开发工具会在联网前退出。

| 验收项 | 实际结论 |
| --- | --- |
| Windows 持有效 Key 请求 | 未验证 |
| 原生 BYOK 适用许可 | 用户反馈已确认，具体覆盖范围待提供和核验 |
| Android 真实生成请求 | 未执行。未获得可核验的许可范围，ADB 检查未发现已连接手机，Android 费用未授权 |
| Windows 实际 Token 用量 | 未取得 |
| Android 实际 Token 用量 | 未取得 |
| HTTP 状态和失败原因 | 此前 Windows 终端确认阶段结束，未发出请求。重新发起的密码输入尚无已认证请求结果。 |
| 正式发布候选 | 否。Android 真人机端到端验证及正式公开分发范围确认尚未完成 |

## 官方协议

开发入口与 App 共用 `DeepSeekHttpProtocol`。官方 `POST /chat/completions` 当前支持 `deepseek-flash` 和 `deepseek-v4-pro`。Windows 最小请求按既有非流式探测路径，输出最多 8 Token，禁用 Thinking。App 角色请求采用 SSE 和 JSON 输出，结束内容块可同时携带 `finish_reason` 与 `usage`，流以 `[DONE]` 结束。服务端 Token 字段包括输入、输出和缓存命中量。 [Chat Completions](https://api-docs.deepseek.com/api/create-chat-completion/) · [模型和价格](https://api-docs.deepseek.com/quick_start/pricing/)

Windows 开发工具显示服务端模型正文，并把实际 HTTP 状态、耗时、模型和 Token 用量写入可选的脱敏报告。终端未能完成输入时，备用 Windows 密码对话框使用独立的 HTTPS 请求，验证范围限于 Windows 官方端点。报告不写入密钥、请求头和正文。V0.4.6 的无凭据 401 属于认证拒绝记录。

## 独立 Windows 入口

在本机交互终端内运行。输入 `YES` 后再按提示隐藏输入开发者 Key。本轮已授权一次以下最小请求。

```powershell
Set-Location 'C:\Users\lin\Desktop\FishTextAdventure'
dart run tool/deepseek_smoke.dart --confirm-cost --probe
```

## Android 待验收

确认许可范围和费用后才构建专用 Debug 测试包。可由 ADB 安装，也可在手机本地手动安装。使用单独的自定义世界验证连接测试、自由行动的真实回复、Token 用量、近期修改的 NPC 档案在请求中的使用，以及重启后的存档。再分别关闭网络和移除 Key，检查均无伪造回复。脱敏验收记录包括应用版本、测试时间、连接状态、HTTP 状态（如可取得）、返回用量和存档结果。

许可咨询稿见 [DEEPSEEK_BYOK_PERMISSION_INQUIRY.md](DEEPSEEK_BYOK_PERMISSION_INQUIRY.md)。
