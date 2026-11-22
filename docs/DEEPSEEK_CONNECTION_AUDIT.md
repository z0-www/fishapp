> 历史 V0.4.3 报告。V0.4.5 已补回原生适用许可条件；开发开关不能替代许可。当前代码、测试与交付请见 [V0.4.5 审计](DEEPSEEK_REAL_API_AUDIT.md) 和 [交付报告](V045_DELIVERY_REPORT.md)。

# DeepSeek 连接审计 · V0.4.3

日期：2026-11-17  
项目：`C:\Users\lin\Desktop\FishTextAdventure`  
Flutter 3.50.0 Stable / Dart 3.14.0  
审计目标：修复 V0.4.2 默认只能使用 `LocalDialogueEngine`、无法真正测试 DeepSeek API Key 的问题，同时保留正式发行限制。

## 1. 结论摘要

- **真实 API 客户端契约测试：通过。** 使用本地假 HTTP 适配器、虚构密钥和本地假 SSE 数据验证了请求结构、SSE 分片、`finish_reason`、Token usage、缓存字段与错误映射。
- **手机端真实 DeepSeek 调用：未进行。** 本次没有可用的真实 API Key，也没有取得适用许可确认，因此不能宣称“真实 DeepSeek 已接通”。
- **默认构建仍是本地 Mock。** 交付的 Debug APK 未传入任何真实 API 构建标记，不会自动联网。
- **正式发行限制保留并加强。** Profile/Release 构建在本版本中固定拒绝真实直连，`DEEPSEEK_NATIVE_BYOK_PERMISSION_GRANTED` 未设置，也未通过其他方式伪造。
- **V0.4.2 源码本身无法通过 `flutter analyze`。** 基线存在 `BlockedDialogueEngine` 未定义和 `DeepSeekDialogueEngine.onError` 参数不存在的问题，导致真实模式相关代码根本不能编译；本轮已修复。

## 2. 基线审计

修复前实际运行：

```text
flutter analyze
error - The function 'BlockedDialogueEngine' isn't defined
error - The named parameter 'onError' isn't defined
error - The name 'BlockedDialogueEngine' isn't defined ...
warning - Dead code ...
4 issues found (exit 1)
```

这说明 V0.4.2 的“真实适配器”调用链并未完整接通：Provider 已经尝试构造 `DeepSeekDialogueEngine` 并传入错误回调，但引擎缺少对应构造函数参数；`TurnCoordinator` 也引用了不存在的阻断引擎类型。

## 3. `permitsDirectCalls` 原判断条件

旧实现等价于：

| 条件 | 旧值来源 | 问题 |
| --- | --- | --- |
| `kDebugMode` | Flutter 运行时 | 正确但过窄，无法区分开发测试与正式发行 |
| `!kIsWeb` | Flutter 运行时 | 正确 |
| Android 或 iOS | `defaultTargetPlatform` | 正确 |
| `DEEPSEEK_NATIVE_BYOK_PERMISSION_GRANTED` | 编译期 `bool.fromEnvironment` | 与发布许可绑定；未取得许可时永远不能测试 |
| `DEEPSEEK_EXPERIMENTAL` | 编译期标记 | 与许可标记混在一起 |
| `nativeByokPermissionConfirmed` | 同一个许可标记 | 重复条件，没有独立语义 |
| `hasSafeEndpoint` | 固定官方 HTTPS host | 正确 |

旧 `policyAllows` 还要求 `debug == true`，因此 Release/Profile 永远拒绝直连；这一点本身是安全约束，但旧代码没有为“开发者本地真实测试”留出合法路径。结果是：默认构建只能 Mock，开发者即使想用自己的 Key 做本地验证也无法进入真实客户端。

## 4. 三种模式（本轮实现）

| 模式 | 进入条件 | 对话引擎 | 网络请求 | 用途 |
| --- | --- | --- | --- | --- |
| 本地 Mock | 默认；`DEEPSEEK_EXPERIMENTAL` 未开；或正式发行构建 | `LocalDialogueEngine` | 无 | 本地剧情、UI、存档回归 |
| 真实 API 开发测试 | Debug + Android/iOS + `DEEPSEEK_EXPERIMENTAL=true` + `DEEPSEEK_REAL_API_DEV_TEST=true` | `DeepSeekDialogueEngine` | 真实 DeepSeek | 开发者本地 BYOK 测试；会产生费用 |
| 真实直连未启用 | Debug + 实验开关已开但未开开发测试标记；或端点不安全 | `BlockedDialogueEngine` | 无 | 明确报错，不静默退回 Mock |
| 正式发行限制 | Profile/Release（`!kDebugMode`） | `LocalDialogueEngine` | 无 | 本版本正式发行固定不直连 |

新增标记 `DEEPSEEK_REAL_API_DEV_TEST` 是**本地开发测试开关**，不是发布许可，也不是面向普通用户的设置。默认 APK、CI 和交付构建都不传该标记。

发布安全的具体实现：

```dart
if (web || !nativeMobile || !experimental) return false;
if (!debug) return false; // Profile/Release 固定拒绝，不依赖许可标记
return devTestEnabled;
```

`DEEPSEEK_NATIVE_BYOK_PERMISSION_GRANTED` 仍保留为审计用构建标记，但没有被设为 `true`，也不能单独解锁任何构建。正式发行若要直连，必须在许可确认后做一次经过评审的代码修改，而不是加一个构建参数。

## 5. 调用链审计

实际链路：

```text
玩家行动
→ RoleplayPage.send()
→ TurnCoordinator.prepare()
→ WorldContextBuilder / PromptAssembler
→ 预算确认 showTurnBudget()
→ TurnCoordinator.execute()
→ 本地 SQLite 预约回合
→ DeepSeekDialogueEngine
→ DeepSeekApiClient（策略检查）
→ DeepSeekHttpProtocol（Dio）
→ DeepSeek /chat/completions
→ SSE decodeSse
→ finish_reason / usage
→ DialogueOutput
→ UsageRepository.record()
→ WorldStateValidator
→ RoleplayRepository.commit()
→ SQLite 存档
```

关键核对：

- **世界背景与玩家身份**：`WorldContextBuilder.worldData()` + `PromptAssembler` 的 L0 层发送标题、描述、时代、规则、玩家档案、叙事偏好等；已由测试断言标题、描述、玩家行动进入 prompt。
- **NPC 人格**：`CharacterEngine.card()` 发送姓名、职业、背景、性格、价值观、目标、恐惧、说话风格、例句、情绪、当前活动等；已由测试断言“陈禾 / 审慎”进入 prompt。
- **相关记忆**：`MemoryEngine.retrieve()` 按 owner、关键词、重要度、时间衰减检索，L2 层发送；已由测试断言记忆文本进入 prompt。
- **最近原文**：最多三轮同人物历史，作为 user/assistant 消息发送。
- **预算确认**：`showTurnBudget` 在真实请求前显示费用上限；取消不会调用引擎。
- **收费请求防重**：`RoleplayRepository.reserve()` 用唯一 turn id 和 running 状态防止同一确认重复发请求；测试验证同一 plan 第二次执行时引擎调用数仍为 1。
- **失败不写存档**：生成失败、取消、协议错误、校验失败都不会提交世界状态；已用本地完成标记和 revision 断言。
- **Token 记录**：真实引擎把 `usage.prompt_tokens`、`completion_tokens`、`prompt_cache_hit_tokens` 写入本地用量表；即使 `finish_reason=length` 或 JSON 无效，只要服务端返回了 usage，也会先记录再报错，避免“已收费但本机无记录”。
- **停止生成**：取消后不提交状态；界面提示可能已消耗 Token。当前版本不会为被取消的请求补记未知 usage，因此显示“可能已产生费用”而不是伪造账单。

## 6. 官方 API 契约核对

核对日期：2026-11-17。参考官方文档：

- [Your First API Call](https://api-docs.deepseek.com/)
- [Chat Completions API](https://api-docs.deepseek.com/api/create-chat-completion)
- [Thinking Mode](https://api-docs.deepseek.com/guides/thinking_mode)
- [JSON Output](https://api-docs.deepseek.com/guides/json_mode)
- [Context Caching](https://api-docs.deepseek.com/guides/kv_cache)
- [Error Codes](https://api-docs.deepseek.com/quick_start/error_codes)
- [Models & Pricing](https://api-docs.deepseek.com/quick_start/pricing)
- [Rate Limit & Isolation](https://api-docs.deepseek.com/quick_start/rate_limit)

| 项目 | 官方契约 | 本项目实现 | 状态 |
| --- | --- | --- | --- |
| Base URL | `https://api.deepseek.com`（OpenAI 格式） | 固定该地址，禁止重定向，固定 host 白名单 | 通过 |
| 接口 | `POST /chat/completions` | 同一路径 | 通过 |
| 模型 | `deepseek-flash`（V4.1-Flash-1017）、`deepseek-v4-pro` | 默认 `deepseek-flash` | 通过 |
| 授权 | `Authorization: Bearer <key>` | 每次请求单独 header，不放入全局默认 header | 通过 |
| thinking | `{"thinking":{"type":"enabled/disabled"}}`；默认开启 | 显式发送 `{"type":"disabled"}`，避免额外推理费用与延迟 | 通过 |
| reasoning_effort | `none/low/high/max` | 未发送；thinking disabled 时不需要 | 不适用 |
| response_format | `{"type":"json_object"}`；prompt 需包含 “json” 和示例 | 发送 json_object；系统提示含“只返回 JSON”与结构示例 | 通过 |
| JSON 空内容 | 无法识别为 JSON 时 API 可能用空格替换，content 可能为空 | 显式识别空/空白内容并报错，不伪造回复 | 通过 |
| 流式 | `stream:true`，data-only SSE，以 `data: [DONE]` 结束 | 解析 UTF-8、CRLF、注释、多 data 行、任意字节边界；要求 DONE | 通过 |
| stream_options | `{"include_usage":true}`；最后一个内容块携带 usage | 发送 include_usage，读取最后一个非空 usage | 通过 |
| 非流式探测 | 200 + `model` + `choices[0].message.content` + `finish_reason` | 测试连接使用 8 token 短请求；接受 `stop` 或 `length` | 通过 |
| usage | `prompt_tokens`、`completion_tokens`、`total_tokens`、`prompt_cache_hit_tokens`、`prompt_cache_miss_tokens` | 读取并校验非负整数；支持 `prompt_tokens_details.cached_tokens` 回退 | 通过 |
| 缓存命中 | `prompt_cache_hit_tokens` / `prompt_cache_miss_tokens` | 写入本地 usage，页面显示命中/未命中 | 通过 |
| finish_reason | `stop`、`length`、`content_filter`、`tool_calls`、`insufficient_system_resource`、`aborted` | 非 stop 显示明确中文错误；`length` 视为截断 | 通过 |
| 错误码 | 400/401/402/408/413/422/429/500/503/504 | 固定中文映射；另补 403/404 防御性映射 | 通过 |
| 价格 | Peak：缓存命中 $0.006/M、未命中 $0.3/M、输出 $1.2/M；Off-peak 减半 | 本地价格快照使用 Peak 上限估算，实际以官方账单为准 | 通过（估算口径） |
| 速率限制 | 429；Keep-alive 注释 | 保留 keep-alive 注释处理；429 映射为频率受限 | 通过 |

官方文档同时说明：JSON Output 下若 `finish_reason=length`，content 可能被截断；本项目已把该情况作为明确错误处理，不再尝试解析半截 JSON 并误报为“协议无效”。

## 7. 发现并修复的问题

1. **编译阻断**：`BlockedDialogueEngine` 未定义、`DeepSeekDialogueEngine.onError` 参数不存在。已新增阻断引擎和错误回调。
2. **同步抛错绕过 Future/Stream 捕获**：`DeepSeekApiClient.testConnection` 和 `streamMessages` 在策略拒绝时同步抛异常，测试和调用方无法用 `expectLater` / `Stream` 错误处理捕获。已改为 `async` / `async*`。
3. **真实 Dio 流类型不匹配**：`decodeSse` 对 `Stream<Uint8List>` 直接使用 `utf8.decoder`，在真实 `ResponseBody.stream` 上会抛 `Utf8Decoder is not a subtype of StreamTransformer<Uint8List, String>`。已改为 `bytes.cast<List<int>>()`。
4. **没有 finish_reason 语义**：旧引擎只拼接 `delta.content`，`length`、`content_filter`、`insufficient_system_resource` 等会变成半截 JSON 或空字符串。已集中映射为明确错误。
5. **空内容未识别**：JSON Output 可能返回空白 content；旧代码会解析失败并显示泛化“协议无效”。已显示“模型返回空内容（JSON 输出可能被过滤或截断）”。
6. **usage 在失败时丢失**：旧引擎只在成功返回 `DialogueOutput` 后记录 usage；截断/空内容/协议错误时即使服务端已计费也不会记录。现在引擎返回带 `issue` 的输出，`TurnCoordinator` 先记录 usage 再抛错。
7. **模型输出兼容性**：旧解析器只接受精确的 ` ```json\n...\n``` `，不接受 ` ```json ... ``` `、行内空格、缺失 proposal、模型用人物姓名代替 ID。现在支持 Markdown fence、缺失可选字段、姓名到 ID 的精确别名映射；未知顶层字段、非法回复结构仍拒绝，避免控制字段注入。
8. **Provider/UI 模式混淆**：旧设置页只显示“Mock / 实验直连”，不区分真实连接测试是否完成，也不显示最近错误。现已显示模式、模型、Key 状态、Mock 测试状态、真实测试状态、最近错误。
9. **连接测试与业务请求混淆**：Mock 测试通过不再显示为“实验连接测试通过”；真实测试成功后显示模型、耗时和 Token，失败时显示安全中文错误。真实测试前新增费用确认。
10. **真实模式静默 Mock 风险**：Roleplay 在阻断模式下使用 `BlockedDialogueEngine` 直接报错；世界建议/故事提取在正式发行/阻断模式下不再把“非直连”误判为 Mock。

## 8. 安全边界

- 密钥仍只由 `ApiKeyStorage` 读写；没有新增日志、导出、明文写入 SQLite/SharedPreferences/构建参数。
- 真实 API 客户端只允许固定官方 HTTPS host；`hasSafeEndpoint` 拒绝 http、非官方 host、端口、userInfo、query、fragment。
- 错误白名单只放行固定中文消息；不显示原始响应、请求头、`Authorization`、DioException 或平台异常。
- 测试使用虚构 `sk-AAAA...` 夹具；仓库中没有真实 Key。
- 默认构建不读取真实 Key；只有用户主动配置并显式进入开发者模式后才可能读取。
- 正式发行硬锁在代码中，不依赖构建参数；V0.4.3 未设置任何许可标记。
- 本次没有调用真实 DeepSeek，也没有把任何真实 Token、响应时间或缓存命中写成实测结果。

## 9. 未验证与限制

1. 没有真实 DeepSeek API Key，未做任何真实网络请求。
2. 没有连接 Android 设备；手机端 Keystore、网络、SSE 长连接、后台回收未验收。
3. 没有 Mac/Xcode；iOS Keychain 与网络行为未验证。
4. 未构建 Release/Profile 包；正式发行硬锁由纯策略函数测试和代码审查确认，不是实际 Release 包联网测试。
5. DeepSeek Open Platform Terms 2.2 要求不将 API Key 暴露在浏览器或其他客户端代码中；本项目把“正式发行原生 BYOK”继续视为未获许可，详见 `docs/RELEASE_API_DECISION.md`。
6. 世界建议与故事提取的真实模型输出只做了代码路径审查，没有真实模型样本对照；本轮重点验证角色扮演主链路。
7. 未验证真实账户余额、限流、区域网络与 DeepSeek 服务端实际计费。

## 10. 相关文件

- `lib/features/ai/data/deepseek_config.dart`
- `lib/features/ai/data/deepseek_api_client.dart`
- `lib/features/ai/data/deepseek_http_protocol.dart`
- `lib/features/ai/data/deepseek_repository.dart`
- `lib/features/ai/data/deepseek_error_handler.dart`
- `lib/features/ai/application/ai_providers.dart`
- `lib/features/ai/presentation/ai_settings_page.dart`
- `lib/features/ai/presentation/api_setup_page.dart`
- `lib/features/roleplay/application/dialogue_engine.dart`
- `lib/features/roleplay/application/turn_coordinator.dart`
- `lib/features/roleplay/application/providers.dart`
- `lib/features/roleplay/domain/models.dart`
- `test/ai/deepseek_connection_test.dart`
- `tool/deepseek_smoke.dart`
