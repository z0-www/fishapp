# 鱼者文游 V0.5.3+28 · 大肥鱼消费管家

本轮从现有 V0.5.2+27 递增版本。移动端新增 Flutter 悬浮球，使用原包已有的 `assets/branding/fish_logo.png`，该文件也是 `flutter_launcher_icons` 配置的图标源。显示时圆形裁切，原图及系统启动图标沿用现有资源。

## 交互

- 悬浮球只放在文游对话的阅读区，输入栏与键盘占据独立区域。位置按可用尺寸计算。拖动松手吸附左右，保存边缘和相对高度。设置可以关闭和重开。
- 点击打开消费卡片，点击空白处关闭，长按打开消费计划。生成中的外围呼吸效果遵循系统减少动态效果设置。
- 余额不足或所有返回币种的余额均偏低时显示橙点。低余额提示阈值为 USD 1 和 CNY 5。预算接近显示橙色边缘，预算用尽显示红点，查询失败显示灰点。

## 数据和预算

| 字段 | 来源 |
| --- | --- |
| 官方余额与更新时间 | 调用 DeepSeek 官方 `GET /user/balance`。使用安全存储密钥，按原币种展示，时间为成功响应时的北京时间。无 Key、发布直连受限或查询失败时显示「暂不可用」。 |
| 当日鱼者消费 | 北京时间当日的本机 SQLite 记录，金额根据服务端实际返回的 Token 和匹配价表估算。费用待确认的请求另外计数。 |
| 峰谷时段 | 官方价格规则和北京时间的节假日范围。定价快照以单独的 JSON 维护，有效期截止北京时间 2026-12-19 00:00。到期显示「价格待核实」。 |
| 预算、单轮提醒及授权 | 本机偏好。每轮生成前读最新预算，校验今日费用加保守估算是否超过预算。单轮提醒超额会恢复手动确认。 |

默认逐轮确认。用户可明确授权当日免确认累计额度，适用范围仅剧情请求。授权在北京时间午夜、价表版本变化、价格不可用或费用记录不确定时停止生效，可随时撤销。模型测试、世界建议和故事整理保留手动确认并受本机预算检查。预算是本机请求控制，DeepSeek 按实际用量收费。

官方余额与价格分别核对自 [余额接口](https://api-docs.deepseek.com/api/get-user-balance/) 和 [模型价格](https://api-docs.deepseek.com/quick_start/pricing/)。节假日依据 [国务院办公厅 2026 年安排](https://www.gov.cn/zhengce/zhengceku/202511/content_7047091.htm)。

## 修改文件

- `assets/pricing/deepseek_wallet_prices.json`
- `lib/features/wallet/application/{wallet_controller,wallet_limits}.dart`
- `lib/features/wallet/presentation/{floating_wallet_ball,wallet_overlay_card,wallet_plan_page}.dart`
- `lib/features/usage/{price_schedule,price_schedule_provider,usage_repository}.dart`
- `lib/features/ai/data/{deepseek_balance,deepseek_api_client,deepseek_http_protocol}.dart`
- `lib/features/ai/presentation/{ai_settings_page,connection_consent}.dart`
- `lib/features/roleplay/application/turn_coordinator.dart`
- `lib/features/roleplay/presentation/roleplay_page.dart`
- `lib/features/story_world/application/{extraction_pipeline,story_world_engine}.dart`
- `lib/features/story_world/presentation/recovery_page.dart`
- `lib/features/world_creator/application/world_suggestion_engine.dart`
- `lib/features/world_creator/presentation/world_creator_page.dart`
- `lib/features/settings/settings_page.dart`、`lib/shared/widgets/turn_budget_sheet.dart`、`lib/app/router.dart`
- `lib/core/app_version.dart`、`pubspec.yaml`
- `test/wallet/wallet_test.dart`、`test/ai/deepseek_connection_test.dart`、`test/byok_security_test.dart`、`test/ui_v04/chat_actions_test.dart`

## 实际验收

- Flutter 依赖解析通过，静态分析无问题，284 项测试全部通过。新增专项覆盖官方余额协议成功与错误、真实用量汇总、价表过期、节假日、预算暂停、授权边界、并发拦截和小屏大字号布局。
- Android Debug APK 完成构建和签名校验。包名 com.yuzhe.fishtextadventure，版本名称 0.5.3，版本代码 28。SHA-256 为 8B8E869605B179966C5BC159C93FFA7128F40E923FD7D1C2F8596C5CA21AD36C。
- 已在 Android 模拟器实际安装冷启动，验收点击、点击外侧关闭、长按进入消费计划、拖动左侧吸附、键盘避让和强制重启后的吸附位置恢复。无 Key 尝试发送时明确阻止生成并保留草稿。截图使用临时本地世界，余额显示暂不可用。
- [悬浮球截图](../reports/wallet-ball-v053.png) · [展开卡片截图](../reports/wallet-card-v053.png) · [自动化测试日志](../reports/wallet-v053-test.log)
- [鱼者文游 V0.5.3+28 Debug APK](../build/app/outputs/flutter-apk/鱼者文游-V0.5.3+28-Debug.apk)

余额合同测试使用离线样例验证 HTTPS、认证头、币种及错误状态。此次没有提交真实账户凭据，因此官方余额的认证响应、账户余额提醒和扣费对账仍待现场实测。Android 与 iOS 共用悬浮球、消费卡片和预算代码。当前 Windows 工程只构建并运行了 Android 版本，iOS 编译及真机仍待 macOS/Xcode 验证。

