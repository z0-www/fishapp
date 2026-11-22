> 历史 V0.4.3 报告。V0.4.5 已补回原生适用许可条件；开发开关不能替代许可。当前代码、测试与交付请见 [V0.4.5 审计](DEEPSEEK_REAL_API_AUDIT.md) 和 [交付报告](V045_DELIVERY_REPORT.md)。

# 真实 API 测试报告 · V0.4.3

日期：2026-11-17  
项目：`C:\Users\lin\Desktop\FishTextAdventure`  
版本：`0.4.3+10`  
环境：Windows 11 工作站，Flutter 3.50.0 Stable，Dart 3.14.0，无 Android 设备连接，无真实 DeepSeek API Key。

## 1. 结论（先看这里）

- **未进行真实 DeepSeek 联网调用。**
- **不能宣称“真实 DeepSeek 已接通”。**
- 真实 API 客户端的**本地契约测试通过**：请求结构、SSE 分片、usage、缓存字段、finish_reason、错误映射均有自动化测试。
- 手机端真实调用**未验证**：没有密钥、没有许可确认、没有设备。
- 默认 Debug APK 仍为本地 Mock；交付包没有开启任何真实 API 构建标记。
- 本报告没有任何真实 Token 数、真实响应时间或真实错误记录，因为本轮没有发出真实请求。

## 2. 已执行的验证

| 命令 / 检查 | 实际结果 |
| --- | --- |
| `flutter analyze` | No issues found，退出 0 |
| `flutter test --reporter compact` | 115 项全部通过，退出 0 |
| 新增 `test/ai/deepseek_connection_test.dart` | 23 项全部通过 |
| `flutter build apk --debug` | 见第 6 节产物（构建成功） |
| `dart run tool/deepseek_smoke.dart`（无 `--confirm-cost`） | 退出 2，拒绝运行，无网络请求 |
| `dart run tool/deepseek_smoke.dart --confirm-cost`（无 Key） | 退出 2，拒绝运行，无网络请求 |
| 本地假 HTTP 适配器契约测试 | 请求体、鉴权头、SSE、usage、finish_reason 全部通过 |
| 真实 DeepSeek 请求 | **0 次** |

说明：`test_baseline.log` 是修复前的失败记录；它证明 V0.4.2 基线无法通过 analyze，不作为本轮最终结果。

## 3. 十二项要求逐项结果

| # | 场景 | 覆盖方式 | 结果 | 是否真实联网 |
| --- | --- | --- | --- | --- |
| 1 | 没有 API Key 的处理 | `TestKeyStorage` 无 Key + 真实引擎 | 在发出请求前明确报“请先配置本机 API Key”，引擎调用 0 次，存档不变 | 否 |
| 2 | API Key 无效 | 假适配器返回 401 | 显示“API Key 无效，请检查或更换密钥。”，不泄露 Key/Authorization | 否 |
| 3 | 余额不足 | 假适配器返回 402 | 显示“账户余额不足，请前往官方平台查看。” | 否 |
| 4 | 网络中断 / 超时 | 假 DioException（connectionError / receiveTimeout） | 显示“连接失败，请检查网络后重试。”或超时提示，不提交状态 | 否 |
| 5 | SSE 数据分片 | 逐字节拆分的 UTF-8、CRLF、注释、多 data 行、usage 块 | 正确解析 2 个事件并读取 usage；DONE 缺失时明确报“流式连接中断” | 否 |
| 6 | JSON 响应异常 | 非 JSON、空内容、markdown fence、未知顶层字段 | 非 JSON 显示“不是有效 JSON”；空内容显示“空内容”；未知字段仍拒绝；fence 与姓名别名可接受 | 否 |
| 7 | 用户停止生成 | 真实引擎 + 取消 token | 不提交世界状态、不写完成历史；界面提示可能已消耗 Token | 否 |
| 8 | 费用确认取消 | `confirmed:false` | 引擎调用 0 次，无请求、无 usage、无存档变化 | 否 |
| 9 | 正确世界上下文传递 | 真实数据库 + `TurnCoordinator.prepare` | prompt 包含世界标题、描述、NPC 姓名/性格、相关记忆、玩家行动 | 否 |
| 10 | 回复保存与重新打开 | 临时 SQLite 文件 + 关闭重开 | 完成回复、revision、历史记录在重开后保留 | 否 |
| 11 | 防止重复收费请求 | 同一 plan 执行两次 | 第二次在预约阶段失败，引擎调用仍为 1，usage 记录仍为 1 | 否 |
| 12 | 正式发布不意外使用实验配置 | `policyAllows` 真值表 + 默认构建 | `debug:false`、Web、未开实验、未开开发测试标记均返回 false；默认 APK 不传标记 | 否 |

补充说明：

- 第 3 项“余额不足”仅验证状态码到中文错误映射，未验证真实账户余额。
- 第 12 项“正式发布”没有通过实际构建 Release APK 后联网验证；本版本 Release/Profile 在代码中硬锁，纯策略测试只能证明策略函数拒绝。
- 第 5 项使用本地假 SSE；它验证解析器，不验证 DeepSeek 真实网络分片行为。

## 4. 真实调用为什么未执行

同时缺少以下必要条件：

1. **没有真实 API Key。** 密钥不应写入源码、Git、构建参数、测试快照或日志；本轮没有提供可用密钥。
2. **没有取得适用许可确认。** DeepSeek Open Platform Terms 2.2 明确要求密钥不得暴露在浏览器或其他客户端代码中；本项目继续把正式发行原生 BYOK 视为未获许可。
3. **没有费用确认。** 真实调用会产生费用，必须由开发者本人确认；本轮无法代替开发者同意。
4. **没有连接 Android 设备。** 即使有密钥，手机端 Keystore、网络与 SSE 长连接仍需要真机验证。

因此，本报告不提供任何“实际 Token、响应时间、错误”数字。任何此类数字若出现，均属虚构，本报告拒绝填入。

## 5. 开发者如何自行执行真实测试

### 5.1 先做最小真实冒烟（推荐）

只在本机 Windows 开发环境、使用你自己的密钥：

```powershell
$env:DEEPSEEK_API_KEY = '<你的 DeepSeek API Key>'
dart run tool/deepseek_smoke.dart --confirm-cost
Remove-Item Env:DEEPSEEK_API_KEY
```

脚本行为：

- 没有 `--confirm-cost` 时拒绝运行。
- 没有 `DEEPSEEK_API_KEY` 时拒绝运行。
- 不打印密钥、不写盘、只请求官方 `https://api.deepseek.com`。
- 先做一个 8 Token 的非流式探测，再做一次流式 JSON 请求。
- 输出模型、耗时、usage、finish_reason、content 字符数与 JSON 顶层字段。
- 任何错误只显示固定中文安全消息。

请把实际输出（不要包含密钥）记录到本节，作为真实联网证据。

### 5.2 再做手机端真实模式（仅限本机开发）

```powershell
flutter build apk --debug `
  --dart-define=DEEPSEEK_EXPERIMENTAL=true `
  --dart-define=DEEPSEEK_REAL_API_DEV_TEST=true
adb install -r build\app\outputs\flutter-apk\app-debug.apk
```

然后：

1. 打开设置 → AI 服务设置，确认显示“真实 DeepSeek · 开发测试模式”。
2. 配置 API Key；真实连接测试前会再次确认费用。
3. 完成一次真实连接测试，记录模型、耗时、Token。
4. 进入一个本地世界，完成一轮对话；每轮仍需确认预算。
5. 打开“本地费用统计”，记录输入/输出/缓存命中 Token。
6. 停止一次生成，确认没有提交半轮剧情。
7. 测试结束后，重新构建**不带** `--dart-define` 的默认 APK，避免把开发者测试包交给普通用户。

该 APK 不应分发、不应上传、不应作为正式发布包。

### 5.3 需要记录的最小字段

| 字段 | 示例 | 本轮 |
| --- | --- | --- |
| 请求时间 | 2026-11-17 22:xx | 未执行 |
| 模型 | `deepseek-flash` | 未执行 |
| 响应时间 | 例如 3.2 s | 未执行 |
| 输入 Token | 服务端 `prompt_tokens` | 未执行 |
| 输出 Token | 服务端 `completion_tokens` | 未执行 |
| 缓存命中 | `prompt_cache_hit_tokens` | 未执行 |
| 错误 | 401/402/超时/格式错误 | 未执行 |

## 6. 构建产物

| 项目 | 值 |
| --- | --- |
| 构建命令 | `flutter build apk --debug` |
| 产物路径 | `build/app/outputs/flutter-apk/app-debug.apk` |
| 版本 | `0.4.3+10` |
| 构建标记 | 无 `DEEPSEEK_EXPERIMENTAL`、无 `DEEPSEEK_REAL_API_DEV_TEST`、无 `DEEPSEEK_NATIVE_BYOK_PERMISSION_GRANTED` |
| 运行模式 | 本地 Mock（默认构建） |

字节数与 SHA256 见构建完成后追加的“产物校验”一节。

## 7. 测试覆盖文件

- `test/ai/deepseek_connection_test.dart`（23 项，本轮新增）
- `test/byok_security_test.dart`（密钥生命周期、日志隔离、SSE、错误映射）
- `test/roleplay/core_test.dart`（存档、取消、预算、校验、重启）
- `test/onboarding/startup_guide_test.dart`（启动与 Mock 测试）
- `test/ui_v04/ui_acceptance_test.dart`（十状态 UI）
- `tool/deepseek_smoke.dart`（开发者手动真实冒烟，不在自动化测试中执行网络请求）

## 8. 仍未验证

1. 真实 DeepSeek 响应内容质量、真实 JSON 合规率。
2. 真实网络下的 SSE 分片、长连接、移动网络切换、后台回收。
3. Android Keystore 真机写入/读取/重启。
4. iOS 构建、Keychain、网络。
5. 真实账单、余额、限流、区域可用性。
6. Release APK 的实际联网行为（本版本 Release 硬锁，不应联网）。
7. 世界建议、故事提取的真实模型输出兼容性（本轮重点为角色扮演主链路）。

## 9. 结论边界

可以说的：

> 真实 API 客户端的请求、SSE、JSON、usage、错误处理已在本地假适配器与虚构密钥下通过契约测试；真实测试模式可在显式 Debug 构建标记下使用 `DeepSeekDialogueEngine`。

不可以说的：

> “真实 DeepSeek 已接通”“手机端真实调用成功”“已产生/验证真实 Token”“正式发行已符合 DeepSeek 条款”。

以上三句均未获得真实证据。
