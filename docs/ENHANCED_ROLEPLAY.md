# 增强演绎运行时与安全边界

FishRoleplayCore 经 RoleplayOrchestrator / TurnCoordinator 运行已有单回合流程：读取独立存档 → 本地选角和记忆检索 → 组装上下文 → 预算确认 → 最多一次生成 → 协议检查 → 权威状态校验 → 原子提交。

保留 CharacterDecisionEngine、KnowledgeBoundary、WorldStateValidator、ResponseIntegrityChecker 和 ToolRegistry。默认直接执行本地检索，不强迫模型每轮 Function Calling。工具包括 world.get_state、character.get_profile、memory.search、timeline.search、lore.search、world.propose_change。最后一个只校验结构化提案，不直接写库；正式提交仍经过回合事务。

角色身份、物品、生死等不允许从模型自然语言随意推断写库；既有状态提案白名单和玩家行动控制保持不变。校验是有限的本地护栏，不能证明所有自然语言隐含矛盾均不存在。

## DeepSeek 适配器

依据 2026-11-17 的[官方模型与价格](https://api-docs.deepseek.com/quick_start/pricing/)及[思考模式说明](https://api-docs.deepseek.com/guides/thinking_mode/)，保留 deepseek-flash、HTTPS /chat/completions、JSON 输出和 SSE usage。请求明确传入 thinking disabled，避免依赖默认思考模式。运行时最多1200输出 Token，分段提取最多1600；没有隐含额外压缩请求。

价格独立管理且带日期/版本；不保证缓存，不把估算当实际账单。真实语义提取或对话一旦失败也可能在服务端产生消耗，重试必须重新确认。

原生 BYOK 直连仍要求既有的调试构建、移动平台、许可编译开关及运行配置同时通过。没有取得适用许可的正式构建不能默认启用。界面简化没有删除这一限制。

API Key 仍只经 ApiKeyStorage 使用 flutter_secure_storage，Android Keystore / iOS 设备绑定 Keychain；不进入 SQLite、日志、世界设置、输入草稿或导出。没有鱼者服务器、代理、云端密钥数据库或账号系统。

没有新增 Living World Engine、后台模拟、NPC 自主日程或复杂多 Agent。默认台词是有限本地 Mock，不能代表真实模型的自然度或人格质量。
