# Fish Roleplay Core 开源研究

核查日期：2026-11-17。六个指定仓库均可访问。通过 GitHub API 核对默认分支、目录树与许可证，并下载/阅读下面的实际源码；未运行其后端、未复制实现代码进入 Flutter。研究快照留在开发工作目录，不作为运行依赖或随 APK 分发。

| 来源与实际阅读文件 | 机制与取舍 | 许可证核查 |
| --- | --- | --- |
| [SillyTavern](https://github.com/SillyTavern/SillyTavern)：release/public/scripts/world-info.js（getWorldInfoPrompt/checkWorldInfo）、group-chats.js、personas.js、extensions/memory/index.js | 参考角色资料、知识激活预算、发言者控制的分层思路。Dart 独立实现固定发言上限、角色卡和条件记忆；不移植 Node 后端或扩展 API | 根 LICENSE 为 AGPL-3.0；仅研究理念，不复制代码 |
| [RisuAI](https://github.com/risuai/RisuAI)：main/src/ts/process/lorebook.svelte.ts（loadLoreBookV3Prompt）、characterCards.ts、characters.ts、persona.ts | 参考角色/当前会话知识组合、扫描深度和 Token 预算。首版用本地关键词检索，不实现完整递归世界书语言或触发脚本 | 根 LICENSE 为 GPL-3.0；不复制实现 |
| [Generative Agents](https://github.com/joonspk-research/generative_agents)：main/reverie/backend_server/persona/cognitive_modules/retrieve.py、reflect.py | 研究事件与想法分开检索、重要性和近期性、反思需证据的设计。V0.2 不逐轮调用 Reflector，不引入 Python、向量服务或常驻多 Agent | 根 LICENSE 为 Apache-2.0；依然独立实现，不集成其运行时。首次递归目录结果被大量前端资源占满，随后按具体源码路径读取 |
| [Quilltale](https://github.com/Aeesh/quilltale)：main/src/world/state.py | 研究权威世界状态、NPC 私有经历、按重要度截取记忆。采用本地事务、白名单提案与整轮拒绝策略，不复制 dataclass 或服务端代码 | API license=null，根目录未发现 LICENSE/COPYING；许可不明，按不可直接复用处理 |
| [OpenNPC](https://github.com/LISK819129/OpenNPC)：main/backend/opennpc/persona.py、personality.py、memory.py | 研究职业/观点/说话方式、按话题选择资料、每 NPC 独立记忆。Dart 采用身份档案与来源标签，不导入其 Python 服务 | API 标为 NOASSERTION，但实际根 LICENSE 文本为 MIT；记录差异，实际文件优先，未复制代码 |
| [ai-npc-agent](https://github.com/SeupLio/ai-npc-agent)：main/npc_agent/modules/persona.py、memory.py、lore.py | 研究人格边界、记忆分层、严重错误与普通语言评分分开。首版保守验证世界提案、维护发言配额，不采用多模型评审链 | 根 LICENSE 为 MIT；不复制算法实现与权重 |

本轮只借鉴机制，不宣称这些项目能直接保证人物自然度。WorldContextBuilder / MemoryEngine / Validator 均为本项目独立 Dart 实现。GPL/AGPL 项目没有作为库、子模块或源码片段进入交付，许可不明项目同样不复制。

官方接口研究：[模型与价格](https://api-docs.deepseek.com/quick_start/pricing/)、[JSON Output](https://api-docs.deepseek.com/guides/json_mode/)、[Token Usage](https://api-docs.deepseek.com/quick_start/token_usage/)、[开放平台条款](https://cdn.deepseek.com/policies/en-US/deepseek-open-platform-terms-of-service.html)。核实 deepseek-flash、HTTPS /chat/completions、response_format=json_object、thinking disabled 和服务端 usage 字段。条款限制客户端密钥暴露，未获得适用许可，因此交付默认使用本地 Mock，正式发布构建继续禁止直连。