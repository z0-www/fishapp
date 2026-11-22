> 历史实现记录。V0.4.5+12 的现行行为与测试见 [运行时整改报告](MOCK_REMOVAL_REPORT.md)。本文中旧版演示流程已停用。

# DeepSeek 真实 API 审计 · V0.4.5

项目：`C:\Users\lin\Desktop\FishTextAdventure`。实际版本 `0.4.5+11`。审计日 2026-11-17。

**没有执行带真实密钥的生成请求，不能宣称真实 DeepSeek 已接通。** 本地契约与模拟 HTTP 贯通测试通过；手机真实调用、连续对话和账单均未验收。

## 实际现状与增量

接手时 pubspec 为 `0.4.3+10`，不是最早的 V0.4.2。已存在独立协议层、角色引擎、ZIP/文本导入、恢复审核和历史报告。当前实际代码曾允许只用 Debug 开发开关进入原生直连。本轮补回适用许可条件，统一模式说明，增强输出校验、模型配置、诊断与回归测试。此前报告不能代替本轮执行结果。

Git 目录存在；本环境 `git status` 返回 “this operation must be run in a work tree”，`git log` 表明 master 尚无提交。本轮未设置身份、未提交。实际文件清单以 `V045_MODIFIED_FILES.md` 和 SHA-256 清单为准。

## permitsDirectCalls 的全部条件

1. `kDebugMode`；Profile / Release 永远不允许原生直连。
2. 非 Web。
3. Android 或 iOS 目标平台。
4. `enableExperimental`，应用从 `DEEPSEEK_EXPERIMENTAL` 读取，默认 false。
5. `devRealApiTestEnabled`，从 `DEEPSEEK_REAL_API_DEV_TEST` 读取，默认 false。
6. `buildPermission && nativeByokPermissionConfirmed`。应用配置与构建标记均来自 `DEEPSEEK_NATIVE_BYOK_PERMISSION_GRANTED`，默认 false。二者不是两份独立许可；标记也不是法律授权。本轮没有将其设为 true。
7. HTTPS、精确 `api.deepseek.com`、无用户信息、无查询和片段、无非 443 端口、无其他路径。
8. 模型在集中管理的当前支持目录中。

模式：Mock 选择 LocalDialogueEngine / MockDeepSeekRepository；显式请求实验但条件未满足选择 Blocked 引擎并明确报错；获准的 Debug 开发测试才选择 DeepSeekDialogueEngine。正式构建显示直连关闭，不因实验标记自动开放。默认 APK 为 Mock。

## 协议核实与实现

按 2026-11-17 官方资料核实：HTTPS `/chat/completions`、Bearer 鉴权、`deepseek-flash` / `deepseek-v4-pro`。默认模型集中在 DeepSeekModels；提供 `/models` 查询契约，不启动自动刷新。目录是有日期的快照，模型退役后需重新核实。

Thinking 可配置，默认 disabled；不把 reasoning_content 当剧情。JSON 使用 json_object 并明确提示 schema；JSON 合法不等于世界状态合法。SSE 支持 UTF-8 任意分片、CRLF、注释、多 data 行、usage-only 块与 DONE；缺少结束或异常结束不能写入剧情。单外层 Markdown fence 与当前发言者的精确姓名可规范化；未知控制字段、无效 JSON 和越权状态仍拒绝。无付费修复、自动重试或 Mock 回退。

读取 prompt_tokens、completion_tokens、prompt_cache_hit_tokens / miss；只保存服务端返回的非负数值。未返回用量保持未知。按日期版本价格表估价，不把估价称为实际账单。

处理 400/401/402/403/404/408/413/422/429/500/503/504、超时、取消、异常格式、length、content_filter 等状态。只有明确上游过滤字段才归为上游过滤；空内容或非 JSON 本身不构成内容违规结论。

## 实际网络与测试边界

- Windows 匿名 GET `https://api.deepseek.com/models`：HTTP 401 / application/json，无 Authorization。证明匿名链路可达，不能证明密钥有效或生成成功。
- 模拟 HttpClientAdapter → HTTP 请求格式 → DeepSeekDialogueEngine → TurnCoordinator → JSON → WorldStateValidator → SQLite：有自动化覆盖。
- 对话真正携带世界事实、玩家身份、当前人物人格、知情范围、相关记忆、近期历史与玩家行动；不把其他人物秘密全部发送。
- 同一预算 reservation 持久化，重复执行不发第二次请求；失败/中断不自动重发；用户重生成须重新确认预算。
- 真实密钥未读取、未记录、未放入构建参数。ApiKeyStorage 和平台备份策略保留。

## 开发者下一步

独立 Windows 工具 `dart run tool/deepseek_smoke.dart --confirm-cost`：必须使用交互终端，再输入费用同意及隐藏的本人密钥；每次最多一次 SSE 请求。可加 `--probe` 改为单次非流式探测。不要把密钥写入命令、环境设置脚本、聊天、源码或日志。该工具本轮只做无确认参数的拒绝路径检查，不做真实调用。

原生手机测试还需取得适用接入许可、审阅配置、连接设备、本人保存密钥并在每次请求前确认费用。正式发行需要另行评审，不靠构建开关解锁。

## 官方来源

- [模型与价格](https://api-docs.deepseek.com/quick_start/pricing/)
- [Chat Completions](https://api-docs.deepseek.com/api/create-chat-completion/)
- [模型查询](https://api-docs.deepseek.com/api/list-models/)
- [Thinking](https://api-docs.deepseek.com/guides/thinking_mode/)
- [JSON 输出](https://api-docs.deepseek.com/guides/json_mode/)
- [缓存](https://api-docs.deepseek.com/guides/kv_cache/)
- [错误码](https://api-docs.deepseek.com/quick_start/error_codes/)
- [开放平台条款](https://cdn.deepseek.com/policies/en-US/deepseek-open-platform-terms-of-service.html)

官方资料给出技术协议；条款对客户端密钥暴露有限制。本项目未取得原生 BYOK 适用许可，不能据技术测试声称正式接入合规。
