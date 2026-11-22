# Story-to-World：导入、提取与审核

截至 2026-11-17。本模块随 V0.3 工作加入，V0.4 仅调整入口与显示层级。

## 源码审计与研究

V0.2 实际已有系统分享收件、手机文件选择、原始文本保存、独立对话和 NPC 记忆；ZIP/JSON 转换当时是占位实现，不能当作已支持。当前已补充解析与恢复闭环。

独立阅读以下参考，未复制其运行实现到 Dart：

- [chat-demo 历史说明](https://github.com/deepseek-ai/chat-demo/blob/main/src/services/chat/history/README.md)、[format.ts](https://github.com/deepseek-ai/chat-demo/blob/main/src/services/chat/history/format.ts)、schema.ts：ZIP 版本、索引、消息树、片段与附件；MIT。
- [deepseek-harness 导入说明](https://github.com/deepseek-ai/deepseek-harness/blob/master/packages/experimental/deepseek-chat-import/README.md)：分段接收、校验与提交的边界；MIT。
- [SillyTavern memory](https://github.com/SillyTavern/SillyTavern/blob/release/public/scripts/extensions/memory/index.js)：摘要更新与上下文预算；AGPL-3.0，不复制代码。
- [RisuAI lorebook](https://github.com/risuai/RisuAI/blob/main/src/ts/process/lorebook.svelte.ts)：知识激活、扫描范围与预算；GPL-3.0，不复制代码。
- [Quilltale world state](https://github.com/Aeesh/quilltale/blob/main/src/world/state.py)：权威状态和个人记忆分离；未确认根许可证，按不可复用处理。

参考机制并不等于这些项目保证了本产品的恢复准确率；目前没有真实模型准确率数据。

## 离线阶段

`ConversationImportService`、`ConversationNormalizer`、`DeepSeekShareParser`、`DeepSeekArchiveParser` 接在原有 ImportParserRegistry / PendingShareRepository 之后。

- 接收系统分享、粘贴、TXT/Markdown、已识别的 DeepSeek 会话 JSON、V3 ZIP，以及应用内已完成对话。
- 文本仅按明确“用户/玩家/User/助手/AI/DeepSeek”等标签识别角色；无法识别时保留 unknown，不猜测。
- 只有链接时明确提示“尚未取得完整聊天内容”，可以作为原文保存；创建世界入口禁用，不自动抓取网页、Cookie 或其他 App 私有数据。
- ZIP 校验 manifest 首条及 `export_format_version=3`、会话索引、消息数、父节点、角色交替和 current_message_id。未知版本、重复条目、不安全路径、加密包或损坏包拒绝转换。
- 限制压缩包64MB、单条目16MB、解压合计128MB、4096条目及压缩比例。手机文件解析在 isolate 运行，结束后再次检查取消状态。
- 全部消息树节点及未知原始字段保存；恢复时只沿用户选定节点追溯当前分支。多会话 ZIP 不丢弃其他会话，默认使用首个会话当前节点，其他节点可选。
- 附件元数据与原 ZIP 保留，缺失原件告警；当前不自动解压成可上传文件、不做 OCR，也不自动向模型发送附件。

原文先保存为只读档案，再进入恢复预览。重复收件以内容指纹去重，正式导入以 jobId 去重。原始物理 ZIP 由既有私有暂存流程保留，不修改原始消息来配合模型。

## 智能整理阶段

`WorldExtractionPipeline.prepare` 将选定分支分段，单段约6000 UTF-8字节；超长消息保留同一出处 ID 后拆段，最多128段。展示总段数、最大请求次数、输入保守估算和输出总上限，再由用户确认。没有隐含的额外合并 API 请求，也不会一次发送完整长历史。

结果是 WorldDraft：背景、规则、玩家身份、NPC/语言风格、关系、事件、承诺、秘密、物品、时间地点、伏笔和未确认内容。每项包含 sourceMessageIds、confidence、kind、visibility、owners，默认不应用。来源必须属于本段/选定分支；人物原话、推测、传闻、冲突和已核实事实分开。数值 confidence 不是经校准的真实概率。

Mock 只提取明确中文标签，并保留选定末节点的原文候选；不具备真实语义理解，不声称识别出所有人物或谎言。真实 DeepSeek 提取适配器已预留但默认受禁用门控制，没有做真实请求成功验收。

用户可查看原文、编辑、核实、勾选、撤销和移除建议。秘密默认不公开，知情人物通过姓名选择。NPC 档案直接使用 V0.2 CharacterProfile。只有明确确认的项目进入新世界；未确定内容继续保持未知。
