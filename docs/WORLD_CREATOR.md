> 历史实现记录。V0.4.5+12 的现行行为与测试见 [运行时整改报告](MOCK_REMOVAL_REPORT.md)。本文中旧版演示流程已停用。

# 自定义世界与现有聊天的连接

V0.4 主入口是主页自然语言输入 → 本地轻量确认 → 进入世界。世界名称可稍后补充；继续编辑高级设定仍使用 Chatform，默认只有名称、背景、玩家身份、初始场景，其余在“更多设定”。填写与本地保存不调用 AI。

WorldDefinition 的 schemaVersion 当前为1，字段为：

```text
id, title, description, genreTags, era, calendarSystem, worldDateTime,
startingLocation, playerProfile, worldRules, characterProfiles,
locationProfiles, relationships, narrativePreferences, openingScene,
customFields, createdAt, updatedAt, schemaVersion
```

时代、类型、历法、能力体系、地点和规则均支持自由文本，不用固定世界类型枚举。未填写内容保持 null/未设定，不补造日期、地点、人物或身份。自定义历法不强制转成公历；内部回合计时不作为世界日期展示。

PlayerEditor 的姓名、年龄、外貌、身份、职业、背景、能力、物品、目标和补充设置均可留空。CharacterEditor 直接编辑原 V0.2 CharacterProfile，包括性格、语言风格、秘密、示例台词、关系和明确的初始在场状态；没有另建第二套人物模型。

WorldRuleEditor 区分事实、偏好、开放设定。LocationEditor 提供列表、搜索和编辑，不做地图。普通创造性补充不会因为类别不同而被判为规则冲突。

DefinitionStateBuilder 在首次进入自定义世界时从正式设定构建状态与上下文，不套用三种试玩模板。旧世界已有状态优先原样读取。每个世界的历史、人物记忆和输入草稿按世界 ID 隔离；路由页面也按世界 ID 创建，避免切换世界保留旧页面状态。

自动草稿使用本地 WorldDrafts。主页输入、高级灵感、各世界聊天分别使用不同命名空间；不同灵感按内容摘要隔离，不覆盖未完成的其他草稿。

设定可复制、编辑、删除确认、版本恢复、导入和导出。导出使用受限的世界设定封装，可复制分享并在手机粘贴导入，无需用户手改 JSON；也能读取对应文件。它不包含 API Key 或剧情历史；人物私人秘密导出前有确认说明。删除世界不会删除其他世界或原始导入档案。

“AI 帮我完善世界/开场”保留范围与预算确认、默认未勾选的逐项建议审核；当前 Mock 建议有限，真实适配器受许可限制。建议不能自动覆盖原设定。
