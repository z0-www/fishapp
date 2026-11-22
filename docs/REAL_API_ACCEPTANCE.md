# V0.4.5+12 真实 API 验收

开发环境已执行本地 HTTP 和 SSE 契约测试。测试覆盖确认预算、发送原始上下文、校验模型 JSON、写入回复及服务返回的 Token，并验证 401、402、网络中断、内容过滤、解析失败及取消。测试使用合成传输数据。真实鉴权及生成没有执行，真实费用和在线返回的 Token 暂无记录。

对话链路为玩家行动 → 费用确认 → DeepSeek SSE → 世界状态验证 → 保存正式回合。若返回用量，即使随后校验失败，也可记录已经发生的请求用量。若没有返回用量，应用不编造数值。连接测试只在官方返回有效响应后标为成功。模型拒答、网络失败和 JSON 错误不会生成替代回复。

| 检查项 | 当前阻碍 |
| --- | --- |
| DEEPSEEK_EXPERIMENTAL | 默认 false，测试 APK 没有启用原生实验调用。 |
| DEEPSEEK_NATIVE_BYOK_PERMISSION_GRANTED | 默认 false，未确认原生直连适用许可。 |
| DEEPSEEK_REAL_API_DEV_TEST | 默认 false，测试 APK 没有启用真实调用开发配置。 |
| DeepSeekConfig.permitsDirectCalls | 需同时满足 Debug、非 Web、Android 或 iOS、上述标志、精确官方 HTTPS 端点和受支持模型。Profile 和 Release 保持禁用。 |

设置显示未配置、等待连接、已连接、网络不可用、密钥无效、额度不足、接口异常或许可及发布配置限制。没有密钥或许可的用户仍可使用世界编辑、历史与本地导入。手动测试只有在构建条件满足时才出现，并要求确认费用。

本轮匿名探测与开发工具拒绝路径见 `api-probe.log`。Windows 独立工具 `dart run tool/deepseek_smoke.dart --confirm-cost` 需要开发者在本机交互确认费用，并隐藏输入自己的密钥。手机真实调用还需适用许可及 Android 测试设备。

- [DeepSeek 开放平台条款](https://cdn.deepseek.com/policies/en-US/deepseek-open-platform-terms-of-service.html)
- [DeepSeek Chat Completions](https://api-docs.deepseek.com/api/create-chat-completion/)

