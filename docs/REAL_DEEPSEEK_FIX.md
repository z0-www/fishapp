# 鱼者文游 · DeepSeek 对话接入（V0.4.8 更新）

## 保存 Key 后仍无法对话的原因

V0.4.6/0.4.7 的实现与 `BYOK_SECURITY.md` 自相矛盾：文档说真实开发测试只要求两个开关、不读取许可标记，但 `DeepSeekConfig` 实际还硬性要求 `DEEPSEEK_NATIVE_BYOK_PERMISSION_GRANTED`。按文档只传两个开关构建的 APK 因此永远停在 `BlockedDialogueEngine`，用户保存了有效 Key 也无法发出真实请求。这是 V0.4.8 修复的直接阻断原因。

| 检查 | 作用 | V0.4.8 状态 |
| --- | --- | --- |
| `DEEPSEEK_EXPERIMENTAL` | 启用原生适配器 | 真实接入测试包显式启用 |
| `DEEPSEEK_REAL_API_DEV_TEST` | 开发者显式选择真实调用 | 真实接入测试包显式启用 |
| `DEEPSEEK_NATIVE_BYOK_PERMISSION_GRANTED` | V0.4.6 的许可门标记 | **已移除**，不再参与任何判断 |
| 构建及平台 | 必须是 Android/iOS 原生 Debug | Android Debug 满足 |
| 接口地址 | 只允许官方 HTTPS 根地址 | 默认满足 |
| 模型 | 必须在支持列表内 | 默认 `deepseek-flash` 满足 |

## 权限、条款与发布范围

这里区分三个问题，不混为一谈：

1. **普通 API 使用权。** 开放平台条款 1.1 授予开发者把模型能力集成进下游应用、服务内部与外部终端用户的权利。用用户自己的 Key、在自己的设备上调用官方 API，属于这一范围，不需要“单独书面特殊授权”。项目不再用一个虚构的许可标记去拦截它。
2. **原生客户端密钥安全。** 条款 2.2 要求不得泄露、分享或公开自己的 API Key，也不得把它暴露在浏览器或客户端代码里。鱼者文游的 Key 由用户在自己设备输入，存于 Android Keystore / iOS Keychain 保护的安全存储，不打包进 APK，不写入日志、诊断、备份或源码。这是满足 2.2 的实现方式，不是“取得特殊授权”。
3. **正式公开发行合规。** 公开分发一个会向终端用户索取 Key 的原生客户端，仍需单独复核条款 2.2 在公开分发场景的适用性、告知与隐私要求。因此 **Profile/Release 构建仍然硬性禁用直连**，这与技术开关无关，是代码级发布决定。不得把公开分发写成“已获 DeepSeek 授权”。

## 对话流程

带 Key 的合格测试构建先准备世界约束、当前说话人的资料及知情范围内的记忆、相关摘要和玩家行动。预算确认后预留本轮编号，从本机安全存储读取 Key，经官方 HTTPS 发送一次请求，解析、校验并保存有效回合。缺少 Key 时，发送显示设置指引并保存未发送草稿。发送失败及取消保留草稿。

已有 NPC 的最新资料用于下一轮请求。剧情位置、当前关系、历史回合、世界快照和记忆仍由当前存档和相应历史节点决定。若预算确认前后设定版本变化，需要重新准备和确认。

已发出或可能发出的对话与连接测试先保存本地待确认用量。有效的服务端用量替换待确认记录。明确的生成前 HTTP 拒绝清除待确认记录。超时、断线、停止或缺失用量时保留“用量未知，可能已产生费用”。相关记录不含 Key、请求头或聊天正文。SQLite 架构版本仍为 6。

生产生成路径只有 `DeepSeekDialogueEngine` 与会明确失败的受限引擎；运行时 Mock 已在 V0.4.7 删除，`lib/` 中不存在 Mock 生成器。旧回合的 `mock` 数据库列仅用于读取并标注历史来源，同时支持历史分支复制。测试替身只存在于 `test/`。

## 构建真实接入测试包

```powershell
flutter build apk --debug `
  --dart-define=DEEPSEEK_EXPERIMENTAL=true `
  --dart-define=DEEPSEEK_REAL_API_DEV_TEST=true
```

这是私下验收构建，不是正式发行包。默认 `flutter build apk --debug`（不带开关）仍然不会发出任何真实请求。正式发行直连需要先完成第 3 点的条款复核，并以经评审的代码修改开启，不能用构建参数解锁。

## 官方接口

官方 `POST /chat/completions` 当前支持 `deepseek-flash` 与 `deepseek-v4-pro`，支持流式 SSE、JSON Output、`thinking` 开关与 `stream_options.include_usage`。用量字段为 `prompt_tokens`、`completion_tokens`、`prompt_cache_hit_tokens`、`prompt_cache_miss_tokens`、`total_tokens`。 [Chat Completions](https://api-docs.deepseek.com/api/create-chat-completion/) · [模型和价格](https://api-docs.deepseek.com/quick_start/pricing/)

独立 Windows 验证工具：`tool/Open-DeepSeek-Verify.cmd`（本机遮蔽输入，每次最多一次付费请求）。V0.4.8 已用它取得一次真实 HTTP 200 与 Token 用量，见 [V048_REAL_API_TEST.md](V048_REAL_API_TEST.md)。
