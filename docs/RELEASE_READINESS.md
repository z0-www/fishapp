> 历史实现记录。V0.4.5+12 的现行行为与测试见 [运行时整改报告](MOCK_REMOVAL_REPORT.md)。本文中旧版演示流程已停用。

# 发布准备审计 · V0.4.5

**结论：仅本地开发测试交付，未满足公开发布条件；未发布。** 构建成功不等于许可、内容、隐私和商店审核完成。

| 项目 | 状态 |
|---|---|
| Android Debug | 成功，已核实实际 APK 存在，默认 Mock，无实验/许可标记 |
| Android Release 检查 | 成功，仅技术审计，仍为测试签名，只用于技术审计 |
| 发布签名 | build.gradle.kts 仍使用 debug 签名，未生成/导入用户发布私钥 |
| 包名/版本 | com.yuzhe.fishtextadventure / 0.4.5+11 |
| 包体与证书 | 实际大小、SHA-256、签名信息见产物清单 |
| 本地资料/密钥 | schema 6 不变；安全存储、备份排除与导出隔离回归 |
| 原生 DeepSeek BYOK | 适用许可未确认，默认禁止；Profile / Release 硬关闭 |
| 分享内容接口 | 使用条件未确认，默认关闭；没有有效分享下载正例验收 |
| 隐私 | 更新本地原始档案、匿名分享、诊断及邮件反馈说明；商店政策和留存审查未完成 |
| 年龄分级 | 未获得渠道正式分级；不能将“成熟题材”当作分级认证 |
| 反馈 | 用户提供邮箱已配置；预览后由用户打开邮件并发送，收件可用性和响应流程未验收 |
| Google Play 举报 | 邮件会离开应用，尚未验收其“不离开应用”的要求，不能宣称达标 |
| 手机/ColorOS | 本轮 ADB 无连接设备，旧 OPPO 性能、键盘、Keystore 和长连接待真机验证 |
| iOS | 共享 Dart 逻辑保留；Windows 未构建 iOS 或验证 Keychain / 分享扩展真机流程 |

## 构建过程记录

首次 Release 失败地址：

`https://storage.googleapis.com/download.flutter.io/io/flutter/x86_64_release/1.0.0-371f77202a73e8dff57a8b3bff75bca55c090aee/x86_64_release-1.0.0-371f77202a73e8dff57a8b3bff75bca55c090aee.jar`

Gradle 报 `Remote host terminated the handshake`，初次失败后自动重试仍停滞，已停止该构建客户端。用现有本机代理对同一官方地址检查，HEAD 返回 200、长度 42919914 字节。随后临时设置 Gradle 系统代理及 20/30 秒网络超时，重试成功；原项目 gradle.properties 已逐字节恢复。未降低 TLS 校验、未更换 Gradle、未更换来源。

Release 日志还提示 `packages/cupertino_icons/CupertinoIcons` 字体未包含。现有页面使用 Material 图标，Widget 截图通过；尚未证明所有 iOS 自适应控件不受影响，该警告保留为 iOS/发行前检查项。没有将“编译通过”视为消除了警告或完成真机验收。

## 发布前必须完成

取得适用 DeepSeek 原生调用及分享接口许可，确认公开发行接入方式；真实费用授权后完成手机连续对话与模型质量验收；配置正式签名和可运作的举报处理流程；核对隐私、年龄分级、AI 生成标识、资料导出/删除及渠道申报要求。不要将测试开关复制到发行流程。没有新增服务器或代理。

中国大陆及其他地区的适用范围需要结合实际发行方式和运营主体评审。本次未将本地 BYOK 自动认定为豁免，也不把网盘分发视作合规完成。参考官方资料（截至本次审计，不构成对本应用的备案或审批结论）：

- [生成式人工智能服务管理暂行办法](https://www.cac.gov.cn/2023-07/13/c_1690898327029107.htm)
- [生成合成内容标识办法](https://www.cac.gov.cn/2025-03/14/c_1743654684782215.htm)
- [移动互联网应用程序备案通知](https://www.miit.gov.cn/zwgk/zcwj/wjfb/tz/art/2023/art_920db564162e4312916a01bed6540ad8.html)
- [Google Play 生成式 AI 政策](https://support.google.com/googleplay/android-developer/answer/13985936?hl=en)
- [DeepSeek 开放平台条款](https://cdn.deepseek.com/policies/en-US/deepseek-open-platform-terms-of-service.html)
- [DeepSeek 用户条款](https://cdn.deepseek.com/policies/en-US/deepseek-terms-of-use.html)
