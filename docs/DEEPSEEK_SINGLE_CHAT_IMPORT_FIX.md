# 鱼者文游 V0.5.4+29 · DeepSeek 单会话导入

工程从 V0.5.3+28 递增。在文游里点击「导入并继续故事」时，鱼者按所选分支恢复停留的位置，保存可阅读的原文、恢复候选资料和时间线。

## 排查与整改

| 环节 | 源码排查与整改 | 证据 |
| --- | --- | --- |
| A 系统分享菜单 | 原 Manifest 已声明 `ACTION_SEND` 与 `text/plain`。保留此声明，扩展同一处理入口对文字、Intent Data 和 ClipData 的提取。 | Android 系统解析器和实际 SEND 见 Android 验收。 |
| B 自动进入导入页面 | 原队列只从原生暂存读取，从数据库提交且原生已确认之后中断，重启时可能无法自动打开。现在在启动路由完成后继续找本机未完成任务；当前预览不被随后到达的任务替换。主动离开会暂停未提交的任务，任务仍保留在待处理列表。异常中断后则继续预览。 | 冷、热启动、重启重新进入预览。 |
| C 链接识别 | 原检测只覆盖裸网址及两行标题加链接。现识别短分享文案内的单一合法 DeepSeek 链接，使用规范化地址去重，带角色标签的完整对话保持正文导入。 | 包装文本、同一链接、正文含链接专项用例。 |
| D 访问失败 | 公开样本的普通 HTTPS 请求得到 429，返回的是阻断页面。受授权的传输适配器保留错误分类，跳转时停止，失败时提供浏览器复制、粘贴及文件导入。 | 公开样本访问记录及离线网络合同测试分开记录。 |
| E 消息解析 | 已支持的 `message_id/id`、父消息、角色、正文和片段继续使用；父消息先于子消息，保留分支关系。缺少当前节点时标识不确定性，公开快照标记为部分。仅有标签、空正文、链接或不受支持的结构不能完成导入。 | 分支、损坏 JSON、空正文、字段兼容回归。 |
| F 继续故事 | 原创建路径先入历史再进入另一页手动确认。现在一次点击完成本机事务，写入原文、世界、NPC、地点、关系、源消息时间线及当前节点。玩家明确标签用于恢复，模型陈述归为待核对候选。 | 22 条消息、事务回滚、重启保留、重复还原和 Android 实际打开聊天。 |

## 本地与网络边界

- 官方 ZIP 初次只读取版本和会话索引，可按标题搜索并选择。随后只解码所选会话和所需附件。同一 ZIP 的不同会话可以分别导入。TXT、JSON 和剪贴板导入继续可用。
- 导入不会发送付费生成请求。勾选近期原文选项后，后续续写才会在既有费用机制下使用所选分支的近期原文。高级恢复仍可审核资料，也可在世界设定中编辑结果。
- 已公开的链接可能被持有者读取。获准的适配器在首次向用户说明并获得同意后读取。默认 APK 保留平台授权开关。DeepSeek 条款提及分享页反抓取机制。 [DeepSeek 使用条款](https://cdn.deepseek.com/policies/en-US/deepseek-terms-of-use.html)
- 适配器只允许官方 HTTPS 主机与固定路径，拒绝跳转，并限制响应大小、消息数和请求时间。 结构化 JSON 中的登录凭据字段在保存前剔除。测试报告不记录用户正文。

## 主要改动文件

- Android `MainActivity.kt` 和 Dart `share_intake_service.dart`、`share_event_deduplicator.dart`、`share_coordinator.dart`
- `lib/features/import_center/data/` 中的 `share_link.dart`、`quick_import.dart`、`conversation_parsers.dart`、`story_parsers.dart`、`pending_share_repository.dart`、`deepseek_share_import_service.dart`
- `lib/features/import_center/domain/import_models.dart`、`import_preview_page.dart`、`import_result_page.dart`
- `lib/features/story_world/data/story_repository.dart`
- `test/single_conversation_import_test.dart`、`test/share_import_test.dart`、`test/ui_v04/ui_acceptance_test.dart`
- `pubspec.yaml`、`lib/core/app_version.dart`

[Android 分享验收](SHARE_INTENT_ACCEPTANCE.md) · [公网正文测试记录](REAL_CONVERSATION_IMPORT_TEST.md)

