# 系统分享与对话迁移设计

## 依赖评估

[receive_sharing_intent_plus 1.0.1](https://pub.dev/packages/receive_sharing_intent_plus) 为 BSD-3-Clause，声明 Android/iOS，提供冷启动读取与热事件流、iOS App Group 集成说明；当前 pub.dev 已明确标记 discontinued。其说明仍列出广泛存储权限，不能仅凭 SDK 下限证明适配 Flutter 3.50 和本轮持久交接要求。本轮不安装该插件，也不安装另一个重复分享接收插件。采用一个项目原生桥接，以满足临时 URI 读取、持久队列、原子确认和无需全盘权限的明确契约；这是工程选择，不声称插件所有功能均不可用。share_plus 不用于接收。

## 数据流与可靠性

系统 SEND/Share Extension → 原生私有/Group 暂存（附件流式复制，随机内部文件名）→ 原子写入 ready.json → ShareIntakeService 轮询/热通知 → PendingShareRepository 事务入库 → ack 原生项 → 识别/解析 → 有警告的预览 → 用户确认 → 对话和世界关联事务提交 → 结果。

原生 ready 项成功写完才可见；半成品不消费。Flutter ack 仅在数据库插入成功后发生。原生 ack 记录已交接标志而不删除仍被队列引用的附件。崩溃后通过原生事件 ID 唯一约束与内容指纹重放，避免重复入库。用户重复分享相同内容可看到已有任务，连续不同内容保留各自任务。原始暂存内容不因取消解析而删除，可重试。应用重启从 SQLite 恢复任务；保存提交是幂等事务。队列有限额，满时显式拒绝，不偷偷清理已暂存项目。

Android 只用 contentResolver.openInputStream 与 URI 临时读授权，在授权有效时复制；不把 content:// 当路径，不申请 READ_EXTERNAL_STORAGE/MANAGE_EXTERNAL_STORAGE。ACTION_OPEN_DOCUMENT 复用相同暂存路径。文件名只用于显示，不拼接文件系统路径。拒绝外部 file://，不读取用户指定任意内部路径。

iOS Swift 扩展只做串行 provider 读取、受限流式复制和原子元数据落盘；App Group 使用 group.com.yuzhe.fishtextadventure。Runner 在激活或 Flutter 请求时读取；不通过未公开 responder-chain 手段强制打开主应用。系统扩展确认页提示“已暂存，请打开鱼者文游继续”。这属于 iOS 支持范围内的体验差异，冷/热主应用激活均检查队列。

## 解析扩展与限制

统一 ConversationParser，独立 PlainTextParser、DeepSeekShareParser、MarkdownParser、JsonConversationParser、ImageAttachmentParser、DeepSeekZipParser。本轮前三种文本/链接解析落地；图片仅识别附件，不做 OCR；JSON/ZIP 先安全保留并显示未支持转换，禁止把文件名或链接假装成完整对话。原始文本及 HTML 不运行脚本，不加载外部资源。

默认上限：文本 512 KiB、单文件 64 MiB、事件总量 128 MiB、16 个文件、原生暂存总量 256 MiB。读取文本前先检查长度，再限流读取；解析可取消。限制为代码/资源配置，不向普通手机用户暴露参数。

## DeepSeek V3 ZIP 后续里程碑

已研究 [chat-demo 历史格式说明](https://github.com/deepseek-ai/chat-demo/blob/main/src/services/chat/history/README.md)、[format.ts](https://github.com/deepseek-ai/chat-demo/blob/main/src/services/chat/history/format.ts) 与 [harness 导入实现说明](https://github.com/deepseek-ai/deepseek-harness/blob/master/packages/experimental/deepseek-chat-import/README.md)。V3 的 manifest/index、每会话 JSON 和附件需分别验证；消息是 parent_id 连接的树，current_message_id 标识选中分支；fragments 与原始未知字段必须保留，附件缺失须告警。

完整实现前必须增加 isolate/流式 ZIP 目录读取、逐会话处理与分批写入、取消令牌、CRC 校验、条目数量/压缩比/累计展开量限制、规范化重复名检测、路径穿越/绝对路径/符号链接拒绝、图片魔数校验、大小/格式/JSON 错误处理。不能一次把全 ZIP 和全图片读入内存。本轮 ZIP 适配器直接返回“暂不支持转换”，因此不会解压不可信归档，也不宣称完整 V3 支持。

AI 整理须另行展示发送内容、Token/费用估算和确认；正式传输仍服从 BYOK 许可门槛。原消息不可被 AI 覆盖；独立 derived 记录保存提取结果。URL 读取后续需要显式确认与 SSRF/登录失效/响应大小限制；本轮仅保存链接，不抓网页。

## 验收计划

Android：备忘录文本、浏览器 URL、相册图片、文件管理器 TXT/JSON/ZIP；各做冷/热启动、多文件、连续不同分享、同内容重复 Intent、撤销读取授权、超限、取消/重试、进程终止后队列恢复、确认前无世界写入。
iOS：同类来源与扩展取消/成功退出、主应用未运行/已运行、App Group 权限、扩展被终止、主应用在 ack 前后崩溃重放、无重复保存。Mac 执行 Xcode build、codesign entitlements 检查、真机分享。Windows 只做配置/工程引用静态检查，不能代替这些验收。