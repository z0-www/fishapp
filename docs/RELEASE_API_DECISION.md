> 历史 V0.4.3 报告。V0.4.5 已补回原生适用许可条件；开发开关不能替代许可。当前代码、测试与交付请见 [V0.4.5 审计](DEEPSEEK_REAL_API_AUDIT.md) 和 [交付报告](V045_DELIVERY_REPORT.md)。

# 正式发行 API 决策 · V0.4.3

日期：2026-11-17  
项目：`C:\Users\lin\Desktop\FishTextAdventure`  
决策范围：是否允许正式发行（Profile/Release）构建在用户设备上直接调用 DeepSeek API。

> 本文是工程与产品决策记录，不是法律意见。是否取得适用许可、是否满足 DeepSeek 条款，应由开发者/发布主体向 DeepSeek 或专业法律顾问确认。

## 1. 决策

**V0.4.3 正式发行继续为本地 Mock，真实 DeepSeek 直连关闭。**

具体含义：

- 默认 APK、CI 构建、Profile/Release 构建不向 DeepSeek 发出任何请求。
- 正式发行不使用用户保存的 API Key 生成剧情。
- 真实 API 仅允许在 **Debug + Android/iOS + 显式本地开发测试标记** 下由开发者本人使用自己的密钥测试。
- 开发者测试包不是正式发行能力，不应分发给普通用户、不应上架、不应作为交付包。
- `DEEPSEEK_NATIVE_BYOK_PERMISSION_GRANTED` 未设置；许可标记未被伪造。
- 本决策没有删除发布安全约束；相反，V0.4.3 把 Profile/Release 直连做成了代码级硬锁，构建参数无法解锁。

## 2. 法律与条款风险

DeepSeek Open Platform Terms of Service（Release date 2026-04-22，Effective 2026-04-29）第 2.2 条写明：

> The API key you create through your account is a necessary credential for calling the open platform API interface. Please keep your created API key securely, prevent any form of leakage, do not share or publicly disclose your API key with others, and do not expose it in browser or other client-side code.

对本项目的含义：

- 鱼者文游是安装到用户手机上的客户端。用户在客户端中输入并保存自己的 API Key，属于“client-side”场景。
- 即使密钥只保存在本机安全存储、不上传鱼者服务器，也仍然需要评估第 2.2 条是否允许这种 BYOK 形态。
- 截至本报告，没有取得 DeepSeek 对“原生移动端 BYOK 文字游戏”的书面许可或明确确认。
- 因此不能把“技术可行”当作“条款允许”。
- 正式发行版若直接调用 DeepSeek，存在被认定为不符合平台条款的风险；本版本不承担该风险。

参考：[DeepSeek Open Platform Terms of Service](https://cdn.deepseek.com/policies/en-US/deepseek-open-platform-terms-of-service.html)

## 3. 技术安全门

### 3.1 模式判定

| 构建/条件 | 实际模式 | 是否联网 |
| --- | --- | --- |
| 默认 Debug APK | 本地 Mock | 否 |
| Debug + `DEEPSEEK_EXPERIMENTAL=true`，未开开发测试 | 真实直连未启用（阻断） | 否 |
| Debug + Android/iOS + 两个开发测试标记 | 真实 API 开发测试 | 是（仅开发者本人） |
| Profile/Release | 正式发行限制 | 否（代码硬锁） |
| Web | 本地 Mock | 否 |
| 非 Android/iOS 桌面 | 本地 Mock / 阻断 | 否 |

代码中的发布硬锁：

```dart
static bool policyAllows({
  required bool debug,
  ...
}) {
  if (web || !nativeMobile || !experimental) return false;
  if (!debug) return false; // Profile/Release 固定拒绝
  return devTestEnabled;
}
```

这意味着：

- 不能通过 `--dart-define=DEEPSEEK_NATIVE_BYOK_PERMISSION_GRANTED=true` 解锁 Release。
- 不能通过 `--dart-define=DEEPSEEK_EXPERIMENTAL=true` 解锁 Release。
- 不能在设置页打开一个隐藏开关解锁 Release。
- 要改变正式发行行为，必须修改并评审代码，而不是改构建参数。

### 3.2 默认构建不含真实请求

V0.4.3 的实际 Debug 构建命令：

```powershell
flutter build apk --debug
```

没有传入：

- `DEEPSEEK_EXPERIMENTAL`
- `DEEPSEEK_REAL_API_DEV_TEST`
- `DEEPSEEK_NATIVE_BYOK_PERMISSION_GRANTED`

因此交付 APK 启动时只可能是本地 Mock。

### 3.3 密钥与日志

- 密钥只进入系统安全存储；不写入 SQLite、普通文件、构建参数、测试快照、日志。
- 真实请求的 Authorization 头只在单次 Dio 请求中存在，不进入全局 headers。
- 错误显示使用固定中文白名单；不显示原始响应、请求对象、Authorization。
- 测试使用虚构密钥；仓库没有真实 Key。
- 开发者冒烟工具 `tool/deepseek_smoke.dart` 从进程环境读取密钥，不写盘，且必须显式传 `--confirm-cost`。

## 4. 为什么尚未解锁正式发行

除条款风险外，还缺少以下发布证据：

1. **没有真实 DeepSeek 联网测试证据。** 本报告没有实际 Token、响应时间、错误记录。
2. **没有手机端真实调用验收。** 没有连接 Android 设备，没有真机 Keystore、网络、SSE 长连接测试。
3. **没有 iOS 验收。** 没有 Mac/Xcode。
4. **没有费用与账单对照。** 未验证真实账户余额、缓存命中、峰谷价格。
5. **没有真实模型输出合规率数据。** 本地假适配器不能证明真实模型稳定返回本项目 JSON 协议。
6. **没有完成发布级安全评审。** 包括密钥生命周期、设备丢失、剪贴板、截图、备份、逆向、滥用与内容安全。
7. **没有确认 DeepSeek 对原生 BYOK 的书面态度。**
8. **没有 Release APK 的实际行为验证。** 当前只有代码级硬锁与策略测试。

在这些条件满足前，把真实直连放进正式发行版是不负责任的。

## 5. 解锁正式发行所需条件

建议按顺序完成：

### 5.1 许可与条款

- 向 DeepSeek 确认原生移动端 BYOK 是否被允许；保留书面/邮件/平台答复证据。
- 确认是否需要企业开发者账号、单独协议或额外审批。
- 确认隐私政策、用户告知、AI 生成内容标识、内容安全义务。
- 由发布主体做法律复核，不以工程判断替代。

### 5.2 真实测试证据

- 使用开发者自己的密钥运行 `tool/deepseek_smoke.dart --confirm-cost`，记录模型、耗时、usage、finish_reason。
- 在至少一台 Android 真机完成：
  - 有效 Key 连接测试；
  - 连续 10 轮以上真实对话；
  - 401/402/超时/断网/SSE 中断；
  - 停止生成；
  - 费用确认取消；
  - 重复点击/重复确认防重；
  - 存档关闭重开。
- 记录真实 Token 与本地 usage 表对照。
- 记录真实模型 JSON 协议失败率与错误样本（不记录密钥）。

### 5.3 安全与发布工程

- 复核 `flutter_secure_storage` 真机 Keystore/Keychain 行为。
- 复核 Android `allowBackup=false` 与数据提取规则。
- 复核日志、崩溃上报、截图、剪贴板、输入法缓存。
- 复核网络层证书校验、重定向拒绝、超时、代理。
- 复核错误消息不泄露 Authorization。
- 增加正式发行的用户费用确认与预算上限。
- 通过评审后，单独修改 `policyAllows` 的发布硬锁；不要在构建脚本里加绕过开关。
- Release 构建做 `strings`/`aapt` 检查，确认没有测试标记和密钥。
- 重新跑 `flutter analyze`、`flutter test`、真实设备验收、Release 构建验证。

### 5.4 运营与合规

- 在应用内明确说明：AI 生成内容可能错误；费用由 DeepSeek 账户扣除；密钥仅本机保存；不代管余额。
- 提供删除密钥、清除数据、隐私说明。
- 明确禁止未成年人或未授权场景的滥用。
- 准备内容安全与投诉处理流程。

## 6. 如果只做本地测试，当前允许什么

允许：

- 在开发者自己的 Windows 工作站运行契约测试（假适配器）。
- 在开发者自己的 Android/iOS 设备上，使用自己的 Key，构建带两个 Debug 标记的测试包。
- 使用 `tool/deepseek_smoke.dart` 做最小真实冒烟。
- 记录真实 Token/耗时/错误，写入内部测试文档。

不允许：

- 把带真实直连标记的 Debug APK 交给普通用户。
- 把真实 Key 写入源码、Git、构建参数、测试快照、日志。
- 在正式发行版中打开真实直连。
- 以“测试通过”宣称“正式发行合规”。

## 7. 结论

| 问题 | 回答 |
| --- | --- |
| 真实 API 客户端技术测试是否通过？ | 本地契约测试通过；真实联网未测试 |
| 手机端真实 API 是否实际调用成功？ | 未调用，未验证 |
| 是否仍被许可开关限制？ | 是；正式发行硬锁，默认构建 Mock |
| 正式发行是否已符合适用条款？ | 未确认；按当前条款风险判断，不应解锁 |
| 还需要哪些用户操作？ | 确认 DeepSeek 许可/条款；提供自己的 Key 做本地真实测试；决定是否继续推进正式发行；不要分发开发者测试包 |

**最终决定：V0.4.3 正式发行保持 Mock，真实直连仅限开发者本地 Debug 测试。**
