# Mobile First 架构审计与目标

审计日期：2026-11-17。唯一工程 C:\Users\lin\Desktop\FishTextAdventure。基线 0.1.1+2，Flutter 3.50.0 Stable / Dart 3.14.0。保留 app/core/features/shared 现有分层，不为目录示例移动已验收模块。

| 项目 | 当前基线 | 本轮目标 |
| --- | --- | --- |
| 导航 | go_router；启动/首页/创建/世界/设置/BYOK/费用 | 增加导入中心、解析进度、预览、结果 |
| 状态 | Riverpod 3；世界与 AI providers | 独立导入 providers；页面不依赖 Intent/Swift |
| 数据库 | Drift schema 2，worlds/usage_records，app_meta 手工表 | schema 3 增量添加导入队列、原始对话/消息/附件、独立提取结果预留 |
| 世界 | id/title/genre/summary/createdAt，无消息模型 | 不改旧世界；导入对话可选关联新世界或既有世界 |
| 密钥 | ApiKeyStorage + flutter_secure_storage 10.3.4 | 不访问、不复制、不导出到导入模块 |
| AI | DeepSeek 抽象、默认 Mock，发布构建禁直连 | 接收、预览、保存均不调用 AI；AI 整理后续里程碑 |
| Android | 空 FlutterActivity、无接收 Intent | 原生 MethodChannel：SEND/SEND_MULTIPLE/文件选择器、流式私有暂存、冷/热启动 |
| iOS | Runner、SceneDelegate，无 ShareExtension | Swift 扩展 target、App Groups、原子就绪标记、Runner 读取与确认交接 |
| 验证 | 上轮 analyze 零问题、18 项测试通过、Debug APK 成功 | 扩展单测与回归、构建新 APK；无设备不虚报系统分享测试 |

保留 Chatform / Before / Light、蓝白简洁布局、DeepSeek 唯一服务、本地 BYOK 与无自有服务器决策。Android/iOS 是正式产品目标；Windows 上的 widget/SQLite 测试只是开发验证手段，不是桌面产品架构。

新建 platform/share_intake、platform/file_access 和 features/import_center 领域/应用/数据/页面。统一服务隔离平台，原生只接收与暂存，Flutter 负责本地解析/预览/确认提交。URL 默认不抓取。导入只增量添加，不替换现有世界。

本轮交付以需求第十节为边界：文本/URL/TXT/Markdown 的安全基础预览；HTML 仅提取可见文本同时保留原文；图片/JSON/ZIP 接收并暂存，未经可靠转换不显示“已导入对话”。完整 DeepSeek V3 ZIP 转换与 AI 整理明确延期。