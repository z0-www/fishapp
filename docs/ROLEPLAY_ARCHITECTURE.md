# V0.2 架构与审计差异

基线：唯一工程 C:\Users\lin\Desktop\FishTextAdventure，Flutter 3.50.0 / Dart 3.14.0，schema 3，0.1.1+3。上轮首页、BYOK、导入中心完整保留。原世界页只有预览，旧 DeepSeekRepository 的 Mock 不生成故事，usage 仅预留；这些缺口未被当作已完成。

新增 features/roleplay/domain、data、application、presentation。FishRoleplayCore 是 TurnCoordinator 的组合入口，分工为 CharacterEngine（角色卡）、CharacterDecisionEngine（风险/目标/发言者）、DialogueEngine（本地或受限 DeepSeek）、MemoryEngine（个人检索）、WorldContextBuilder（预算化上下文）、WorldStateManager/Validator（本地状态描述与白名单校验）、RoleplayRepository（权威存档与事务）、RoleplayEvaluator（确定性严重错误/人工评分汇总）。WorldStateManager 目前是轻量状态描述门面，实际写入集中 Repository，不设第二个事实来源。

原有 /world/:id 增加“进入文游 · V0.2”，新 /play/:id 页面。首次为既有世界附加现代/民国/奇幻场景，而不覆盖原世界 summary 或已导入记录；之后加载原场景，不自动重置。

回合：读取状态/版本 → 选择在场角色 → owner/world 检索记忆和最多三轮本人历史 → 组装提示与保守输入预算 → UI 展示行动、发送资料范围、价格快照和调用上限 → 用户确认 → running 账本占位 → 最多一次生成 → 完整 JSON 解析 → 白名单状态校验 → 同一 SQLite 事务写状态、正式消息和本人经历。

正文不是增量直接展示：生成中只显示状态，先完整缓冲 JSON 后验证；不把 proposal/control 字段展示成台词。提案无效整轮不提交正文或状态。版本不一致、重复预算 ID、同世界已有 running 回合均拒绝。中断账本需手动恢复，不自动重发收费请求。取消令牌传至 Dio CancelToken，未验证状态不得保存。

DeepSeekApiClient 新增结构化消息 SSE 方法，复用原配置/安全存储/错误处理，不更改旧设置接口。实验能力只在已有许可与 debug/移动端门槛通过时创建；默认本地规则引擎明确标注 Mock。角色引擎不需要独立模型会话或服务器。UI 有自由输入、选择交谈对象、人物/世界档案、相邻地点、发送、停止与恢复；不增加战斗属性面板。

限制：本地规则回应是体验与确定性测试支架，不是 LLM 自然语言能力；真实模型语义矛盾无法靠有限规则完全证明，需后续真实输出评测。发布/profile 构建无论开关均不直连。原导入 ZIP/JSON 完整转换仍在原里程碑，没有借开发 V0.2 重写它。