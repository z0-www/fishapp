# V0.4.5+12 运行时整改

| 原入口 | 处理结果 |
| --- | --- |
| `lib/features/ai/data/deepseek_repository.dart` | 删除 MockDeepSeekRepository、模拟测试结果和未使用的通用流式入口。连接测试走受许可约束的真实客户端。 |
| `lib/features/roleplay/application/dialogue_engine.dart` | 删除 LocalDialogueEngine 和固定台词生成。生产 Provider 只选择真实引擎或明确拒绝执行的引擎。旧脚本作为测试替身移入 `test/support/scripted_dialogue.dart`。 |
| `lib/features/roleplay/data/scenarios.dart` | 正式运行时文件删除。人物、地点、开场和对话样例移入 `test/support/scenario_fixtures.dart`。旧世界首次打开仅从自身名称与简介初始化，已有存档直接读取。 |
| `lib/features/worlds/data/world_repository.dart` | 本地仓库更名为 SqliteWorldRepository，删除示例世界种子数据和写入方法。 |
| `extraction_pipeline.dart`、`world_suggestion_engine.dart` | 删除模拟整理与建议分支。人工恢复、出处审核、原文节奏统计和手动世界编辑仍支持离线。 |
| 设置、启动与剧情界面 | 保存密钥独立于连接测试。受限制时隐藏连接测试按钮，发送按钮不可用并显示原因。预算与用量不再显示演示数据。 |

数据库 schema 仍为 6。没有删除世界、历史消息、用量、导入档案或角色状态。原 `roleplay_turns.mock` 字段继续用于读取和复制旧回合，新回合写入 false。旧回合标注为「旧版离线记录」。它是来源字段，无法触发生成。

全局扫描见 `runtime-scan.log`。生成的 Drift 代码与上述历史字段有关。其他模拟数据与响应只存在于测试目录。

| 检查 | 实际结果 |
| --- | --- |
| flutter analyze | 无问题。 |
| flutter test | 254 项通过。 |
| flutter build apk --debug | 成功。包名 com.yuzhe.fishtextadventure，版本 0.4.5+12，180644765 字节，签名校验通过。 |
| 设备安装 | ADB 未检测到已授权设备，本轮未进行真机安装。 |

Debug APK 路径为 `C:\Users\lin\Desktop\FishTextAdventure\build\app\outputs\flutter-apk\app-debug.apk`。

真实 DeepSeek 和公开分享验收状态见 [真实 API 验收](REAL_API_ACCEPTANCE.md) 与 [导入验收](IMPORT_ACCEPTANCE.md)。

