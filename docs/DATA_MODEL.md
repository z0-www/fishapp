# 移动导入数据模型

基线 World 和 UsageRecord 不变。schema 3 仅增表；1→2→3 逐级迁移，不 DROP/重建世界。API Key 仅由系统安全存储模块处理，导入模块没有读取它的依赖。

- IncomingShare：原生事件 ID、来源、接收时间、原始文本/MIME、私有暂存附件路径与元数据、内容指纹。
- ShareEventDeduplicator：事件 ID + 标准化内容 SHA256。永久约束防崩溃重放，UI 指向已有任务，不静默吞掉不同内容。
- ImportJob：接收/处理中/预览/失败/取消/已保存状态、阶段进度、安全中文错误；保留 IncomingShare 引用与可重试输入。
- ImportSource：系统分享、文件选择器、粘贴；预览来源描述只声明实际来源，不冒充 DeepSeek 官方导出。
- ConversationDraft：标题、消息数组、附件数组、当前消息 ID、解析警告、是否可确认为对话。
- ImportedMessage：会话局部 ID、parentId、角色（unknown/user/assistant/system）、正文、原始 JSON/片段。纯文本无法可靠识别说话者时标 unknown，不伪造用户/AI 计数。
- ImportedAttachment：内部路径、显示名、MIME、字节数、SHA256；不把原始外部 URI 当永久路径。
- ImportResult：任务 ID、对话 ID、可空世界 ID、保存方式（历史/新世界/已有世界）。

pending_imports 保存持久任务及输入清单；imported_conversations 保存确认后的对话与可空世界关联；imported_messages 保存逐条原始消息及分支字段；imported_attachments 保存附件元数据；derived_import_results 只为将来的 AI 提取预留，与原始记录分表。

确认前不写入正式对话或创建世界；确认事务中插入会话/逐条消息/附件、可选新世界并标记任务已保存。相同任务重复确认直接返回已有结果。原始导入消息没有编辑/覆盖方法。图片/ZIP/JSON 尚未转换时可继续暂存但不能显示完整对话已保存。纯 URL 仅作一个未知角色的链接记录，明确“未读取网页内容”。

持久附件仍放原生应用私有/Group 暂存目录，ack 不删除；本轮不自动清理已交接附件。后续清理必须依据数据库引用计数与用户显式操作，防止误删存档引用。