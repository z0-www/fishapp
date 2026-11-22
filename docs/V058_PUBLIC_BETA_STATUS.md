# 鱼者文游 V0.5.8+33 · B 站与夸克网盘公开测试

**发行状态：BLOCKED。** 计划由 B 站账号 z0-www 宣传，夸克网盘分发 Android APK。鱼者文游免费，无会员、无内购，在线模型由用户提供自己的 DeepSeek API Key 并按服务商账单付费。

## 交付与验收

| 项目 | 状态 | 实际证据 |
| --- | --- | --- |
| 工程和发布工具 | 已完成代码 | 版本已递增。新增本机签名和有门槛的发行打包，增强现有 APK 检查。保留 DeepSeek 正式审核开关、预算和存档行为。 |
| Flutter | 自动化测试通过 | 分析无问题，296 项测试通过，Debug 与独立 Release AOT 均构建。 |
| 二进制、16 KB 与密码流程 | 已核验正式签名 APK | APK 证书与开发者公开证书一致，ZIP 及八个 64 位原生库对齐检查通过。模拟器证实 APK 不可调试。16 KB 页大小设备上的运行仍未验证。 |
| Android 换证书与完整归档 | 模拟器实测 | V0.5.7 在 Android 7 将归档保存到 Downloads。不同证书覆盖被系统拒绝，旧版仍在。全新 Android 37 安装正式签名的 V0.5.8 后恢复该归档，预览显示 6 条原始消息，恢复后核对末条正文。真实手机仍未验证。 |
| Android 正式签名 | 已完成，模拟器安装通过 | 开发者在独立终端输入密码，长期签名库留在项目外。正式签名 APK 留在 `build/owner-signed/` 供验收。 |
| DeepSeek 正式版真实请求 | BLOCKED | 未取得本轮费用授权，未发现连接的实体 Android 手机，公开 BYOK 适用范围还未确认。Release 在线服务保持关闭。无实际 HTTP 200、回复或 Token 用量证据。 |
| 中国大陆发行条件 | 尚未全部满足 | 已核对公开条文，未取得本项目适用事项的正式办理结果或结论。 |
| B 站与夸克 | 材料已准备 | 未发布视频、动态或网盘链接。提取码位置留空。 |

## 中国大陆渠道核对

公开资料核对日期为 2026 年 11 月 19 日。

| 范围 | 已核对 | 发布人要完成 |
| --- | --- | --- |
| APP 备案 | 工信部通知面向在境内从事互联网信息服务的 APP 主办者。通过 B 站引流、网盘侧载或用户自带 Key 并不能判断本项目适用结论。 | 以实际主办主体和网络接入方式向属地通管局核对备案及展示要求，确认由谁办理并取得所需编号。 [工信部 APP 备案通知](https://www.miit.gov.cn/jgsj/xgj/wjfb/art/2023/art_dd783a581c9644a4aee10afa582811db.html) |
| 生成式 AI | 网信办公告说明，直接调用已备案模型的生成式 AI 应用或功能存在属地登记路径。模型平台自身备案情况与鱼者适用义务需要分别核对。 | 确认实际模型和对应编号，向属地网信部门核对本服务登记、编号公示、安全管理及投诉处理要求。 [API 应用登记说明](https://www.cac.gov.cn/2026-09/14/c_1791136833136332.htm) · [当前填报平台](https://beian.cac.gov.cn/) |
| 拟人化互动 | 2026 年 7 月 15 日生效的规则按是否向公众提供持续性情感互动判定。鱼者有具有人格、关系和长期记忆的 NPC。仅凭题材名称或架构无法确认适用范围。 | 按实际交互、受众和宣传材料核对是否适用。若适用，确认未成年人保护、风险治理、数据处理以及安全评估和备案义务。 [拟人化互动服务暂行办法](https://www.cac.gov.cn/2026-04/10/c_1777558395078289.htm) |
| AI 标识及游戏属性 | 核对了生成合成标识规范和国产网络游戏出版审批指南。若相应规定适用，公开测试也须按要求办理。 | 向属地主管部门核对生成文本的展示、复制与导出标识，以及产品是否归入须审批的网络游戏。 [AI 生成合成内容标识办法](https://www.cac.gov.cn/2025-03/14/c_1743654684782215.htm) · [国家新闻出版署办事指南](https://www.nppa.gov.cn/bsfw/xksx/cbfxl/wlcbfwspsx/202210/t20221013_600725.html) |
| 个人信息保护 | 本地存档、设备密钥、HTTPS 数据传递及第三方说明已写入文案。第三方处理角色、对话和使用量需以真实在线链路和发布主体为准。 | 明确处理者及权利行使入口，核对数据传输、留存、删除和适用的单独同意。确认面向未成年人等场景的要求后复审隐私政策。 [个人信息保护法](https://gzca.miit.gov.cn/zwgk/zcwj/zcfg/art/2021/art_98dffb76ef944db68c10194618c72559.html) |
| DeepSeek BYOK | 中国版开放平台协议 1.1 节允许按约定集成下游应用，2.4 节限制客户端凭据暴露。app 只保存用户在本机输入的 Key。 | 核对面向公众的原生直连是否适用及其范围，保存能追溯的审查依据。随后才能更新 Android Release 审核记录。 [DeepSeek 开放平台服务协议](https://cdn.deepseek.com/policies/zh-CN/deepseek-open-platform-terms-of-service.html) |
| 渠道发布 | 核对了 B 站协议及夸克网盘官方分享说明。账号、投稿入口及实际网盘分享还未核验。 | 审阅待发布文案及当前投稿入口要求。正式验收后，用指定账号分享并核对链接、提取码、文件名和哈希。 [B 站协议](https://www.bilibili.com/blackboard/protocal/licence.html) · [夸克分享帮助](https://www.quark.cn/documents/help/file-share) |

## 本地材料

`dist/FishTextAdventure-V0.5.8-PublicBeta/` 已预留，发布文件应保持为空直到验收满足。当前验收记录为 `BLOCKED`。打包时必须核对同一份已验收 APK 的 SHA-256 和正式证书。脚本验证文件和记录，真实设备结果与合规证明须由发布人据实提供。

- [签名与离线备份](V058_ANDROID_SIGNING.md)
- [安装使用说明](<public-beta-v058/安装使用说明.txt>) · [DeepSeek API Key 教程](<public-beta-v058/DeepSeek API Key 获取教程.txt>) · [旧版迁移与备份](<public-beta-v058/旧版升级及故事备份教程.txt>)
- [隐私政策与用户须知](<public-beta-v058/隐私政策与用户须知.html>) · [更新日志](<public-beta-v058/更新日志.txt>)
- [B 站发布说明草稿](<public-beta-v058/B站发布说明草稿.txt>) · [待填真实验收记录](<public-beta-v058/验收记录.json>)

## 构建与验收证据

- [Android Debug 内部测试 APK](../build/app/outputs/flutter-apk/鱼者文游-V0.5.8+33-Debug.apk)，181,743,011 字节。SHA-256 `EB43E25DAF2C6010A9EDFEB864D887EC2BA98B48B90AA974A96944FFC38B2242`。
- [Release AOT 未签名核验产物](../build/app/outputs/flutter-apk/鱼者文游-V0.5.8+33-Release-UNSIGNED.apk)，71,487,756 字节。SHA-256 `9F249104233AED1EC7B5F95394BE57D41781A12E7EDA3F4195E62419AF9EBD2F`。
- [开发者正式签名的 Release 验收 APK](../build/owner-signed/FishTextAdventure-0.5.8+33-OwnerSigned-A0E648C5BA17.apk)，71,503,615 字节。SHA-256 `A0E648C5BA17E99CE7C4086DE4021D2711B31BAAF68AC1B7F8DC3F08A4DA9ACE`。证书 SHA-256 `261619CF1EA80929DB0A0D76516E706BF5EA7F6D406169F7BC5C094FBF0C38F4`。 [正式签名包安装及恢复日志](../reports/public-beta-v058/v058-owner-install.log)
- [APK 签名、打包门槛与换签检查](../reports/public-beta-v058/signing-and-gate.log) · [自动化测试](../reports/public-beta-v058/v058-test.log) · [静态分析](../reports/public-beta-v058/v058-analyze.log)
- [旧版导出证据](../reports/public-beta-v058/v058-migration-export-complete.log) · [新版恢复证据](../reports/public-beta-v058/v058-migration-restore.log)
- [旧版导出截图](../reports/public-beta-v058/v058-old-backup-export.png) · [新版恢复预览](../reports/public-beta-v058/v058-new-backup-preview.png) · [恢复后的故事](../reports/public-beta-v058/v058-new-story-restored.png)
- [正式签名包的恢复预览](../reports/public-beta-v058/v058-owner-backup-preview.png) · [正式签名包恢复的故事](../reports/public-beta-v058/v058-owner-story-restored.png)
- [正式签名包的在线服务状态](../reports/public-beta-v058/v058-owner-api-status.png) · [在线状态验收](../reports/public-beta-v058/v058-owner-online.log)

V0.5.7 源码回滚快照的 SHA-256 为 `9760B455199F79935A539C9D5D60EB7ADA1C4392E5330F968898F82857D75D21`。发布人在本机完成创建签名库和 APK 签名的密码输入。签名身份和已验证的 APK 哈希被写入候选验收记录，状态保持 BLOCKED。
