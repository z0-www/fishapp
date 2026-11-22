# 鱼者文游 V0.5.6+31 功能整改

| 模块 | 状态 | 修改前与修改后 |
| --- | --- | --- |
| 目标字数 | 已实现，已测试 | 由固定 1200 Token 改为 100–3000 字的叙事目标，默认 800 字。实际请求和预算使用同一输出 Token 上限。四个边界与常用档通过 HTTP 请求体契约测试。 |
| 人称与风格 | 已实现，已测试 | 可切换第一、第二、第三人称，以及小说、沉浸、快节奏模式。仅指示旁白视角，保留 NPC 人格、台词人称和玩家的行动决定权。 |
| 设置优先级 | 已实现，已测试 | 应用默认值、全局偏好、世界覆盖、本次聊天临时设置依次覆盖。全局与世界覆盖持久化。聊天临时调整在当前聊天页生效，可随时清空。 |
| 世界故事预览 | 已实现，已测试 | 用已完成回合的真实正文或玩家行动摘要替换占位文字。无在线回合时检查恢复节点和旧存档修订。从已知时间显示最后游玩时间，原始分享未提供可靠时间则省略。 |
| 叙事中断 | 已实现，已测试 | 服务返回长度上限时提示剧情未写完，保留草稿和已有故事。已返回的用量按原流程登记。 |
| 模型选择 | 已实现，已测试 | 可保存官方模型 `deepseek-flash` 或 `deepseek-v4-pro`。原有发布限制和端点校验仍由客户端执行。 |
| 分享导入 | 已实现，已测试，公网仍存在问题 | Android 接收与本地导入继续使用原有已验证路径。区分链接、有正文、解析、恢复。默认 APK 的网络适配仍由既有授权开关控制。此前授权脱敏样本返回 429，取得 0 条，本轮公网正文未验收。 |
| 完整归档 | 已实现，已测试 | 沿用 `.yuzhe` 格式和原有归档读写，增加设置入口。覆盖原文、NPC、关系、记忆、世界状态、剧情节点、检查点和分支。防止凭据进入归档。 |

## 字数与 Token

汉字、标点各一单位，连续英文单词或数字各一单位，空白不计。有效 JSON 中的旁白与台词可通过 3000 字档的结构检查。App 为 100、800、1500、3000 字分配 712、2112、3512、6512 最大输出 Token，作为本轮请求的预算输入。模型决定实际输出长度，完整性检查与真实用量记录沿用原有机制。未完成输出不发起自动补写。

2026-11-19 查验的官方 Chat Completions 文档列出两种模型、输出参数及长度截断语义。峰谷价格继续使用现有带有效期的价格配置。 [Chat Completions](https://api-docs.deepseek.com/api/create-chat-completion/) · [模型与价格](https://api-docs.deepseek.com/quick_start/pricing/)

## 存储与回滚

SQLite schema 保持版本 6。全局偏好与模型使用既有本地草稿表中的独立键，世界覆盖使用版本化的 `narrativePreferences` JSON。没有新增表、删除旧草稿、重写历史消息或运行破坏性迁移。旧数据缺少这些字段时按默认规则读取。

项目的 `master` 尚无首次提交。本轮修改前保存了 V0.5.5+30 的源码快照，在 Windows 工作区的 `fishtextadventure-v056-source-baseline.tar.gz`。其 SHA-256 为 `F75FE6E41A2F868D4102781AD3E6F5D3878EEE22587521001B3F3AA211D7DFCD`。快照不含设备存档和构建缓存。

## 修改文件

- [lib/app/router.dart](../lib/app/router.dart)
- [lib/core/app_version.dart](../lib/core/app_version.dart)
- [lib/features/ai/application/ai_providers.dart](../lib/features/ai/application/ai_providers.dart)
- [lib/features/ai/data/deepseek_config.dart](../lib/features/ai/data/deepseek_config.dart)
- [lib/features/ai/data/deepseek_http_protocol.dart](../lib/features/ai/data/deepseek_http_protocol.dart)
- [lib/features/ai/presentation/ai_settings_page.dart](../lib/features/ai/presentation/ai_settings_page.dart)
- [lib/features/import_center/data/pending_share_repository.dart](../lib/features/import_center/data/pending_share_repository.dart)
- [lib/features/import_center/presentation/import_result_page.dart](../lib/features/import_center/presentation/import_result_page.dart)
- [lib/features/roleplay/application/narrative_settings.dart](../lib/features/roleplay/application/narrative_settings.dart)
- [lib/features/roleplay/application/turn_coordinator.dart](../lib/features/roleplay/application/turn_coordinator.dart)
- [lib/features/roleplay/data/roleplay_repository.dart](../lib/features/roleplay/data/roleplay_repository.dart)
- [lib/features/roleplay/domain/models.dart](../lib/features/roleplay/domain/models.dart)
- [lib/features/roleplay/domain/narrative_preferences.dart](../lib/features/roleplay/domain/narrative_preferences.dart)
- [lib/features/roleplay/domain/world_context_builder.dart](../lib/features/roleplay/domain/world_context_builder.dart)
- [lib/features/roleplay/presentation/narration_controls.dart](../lib/features/roleplay/presentation/narration_controls.dart)
- [lib/features/roleplay/presentation/narrative_settings_page.dart](../lib/features/roleplay/presentation/narrative_settings_page.dart)
- [lib/features/roleplay/presentation/roleplay_page.dart](../lib/features/roleplay/presentation/roleplay_page.dart)
- [lib/features/settings/settings_page.dart](../lib/features/settings/settings_page.dart)
- [lib/features/story_world/application/context_engine.dart](../lib/features/story_world/application/context_engine.dart)
- [lib/features/wallet/presentation/floating_wallet_ball.dart](../lib/features/wallet/presentation/floating_wallet_ball.dart)
- [lib/features/world_backup/presentation/backup_pages.dart](../lib/features/world_backup/presentation/backup_pages.dart)
- [lib/features/world_creator/presentation/narrative_preferences_editor.dart](../lib/features/world_creator/presentation/narrative_preferences_editor.dart)
- [lib/features/world_creator/presentation/world_creator_page.dart](../lib/features/world_creator/presentation/world_creator_page.dart)
- [lib/features/worlds/application/world_story_preview.dart](../lib/features/worlds/application/world_story_preview.dart)
- [lib/features/worlds/presentation/world_page.dart](../lib/features/worlds/presentation/world_page.dart)
- [pubspec.yaml](../pubspec.yaml)
- [test/ai/deepseek_connection_test.dart](../test/ai/deepseek_connection_test.dart)
- [test/onboarding/startup_guide_test.dart](../test/onboarding/startup_guide_test.dart)
- [test/roleplay/narrative_preferences_test.dart](../test/roleplay/narrative_preferences_test.dart)
- [test/ui_v04/ui_acceptance_test.dart](../test/ui_v04/ui_acceptance_test.dart)
- [test/wallet/wallet_test.dart](../test/wallet/wallet_test.dart)
- [test/widget_test.dart](../test/widget_test.dart)
