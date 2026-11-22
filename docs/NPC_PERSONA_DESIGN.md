# NPC 人格与决策

CharacterProfile 使用受控的 JSON 档案和只读字段门面；包含 id/name/age/gender/occupation/background/personalityTraits/values/beliefs/personalGoals/fears/desires/likes/dislikes/speechStyle/speechExamples/emotionalState/relationshipToPlayer/currentLocation/currentActivity/privateKnowledge/publicKnowledge/knownCharacters/personalMemories。实际动态个人记忆独立存表，personalMemories 不重复塞全文。

三组场景各三名人物：民国上海（编辑/茶馆老板/巡捕）、现代都市（咖啡店店主/社区医生/大学生）、奇幻村落（守林人/铁匠/学徒）。职业目标、日常活动、背景和示例台词按场景配置，人物之间也有克制、务实、好奇等差异；不是仅替换姓名。年龄/性别可选，示例角色未强行填写性别。

轻量决策根据目标、初始信任、已知资料和请求风险决定追问/保留/交换/一般交谈。没有统一“必须反抗玩家”规则。敏感请求不会因为一句安全保证自动获准。每轮只选一个在场、存活 NPC；无明确对象时确定性轮换，不在场对象不能发言。空场景使用无 NPC 的叙述协议，允许经确认的相邻地点返回。

提示要求简短口语、允许沉默和生活片段、只描写可见动作、不暴露全部心理、不控制玩家意志。本地试玩支持打招呼、沉默、承诺、回忆、风险请求与普通话题，台词只是规则样本，不能代表真实 DeepSeek 自然度。

当前边界：关系信任、职业和核心人格不会被模型任意修改；没有自动好感涨分、成熟的撒谎策略或完整人物日程优化器。privateKnowledge 只发给所属角色，其他 NPC 的原始对话也不进入当前角色上下文。将来若增加传闻传播，需要显式来源和传递事件，不能给全员复制记忆。