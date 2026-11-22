# V0.5.7 安全、隐私与渠道复核

| 项目 | 状态 | 说明 |
| --- | --- | --- |
| 设备凭据 | 自动化测试通过 | Android Keystore 保护的加密存储与 Apple Keychain 仅本机选项。设备 Key 不在 SQLite、日志和故事备份中，Android 禁用自动数据备份。 |
| 网络 | 已实现，已核验 | Android 主 Manifest 显式禁止明文访问，客户端限制官方 HTTPS 地址。余额只触发已配置账户的实际查询，失败显示未知。 |
| 隐私告知 | 已实现，本地可查 | 说明本机资料、向第三方发送范围、用量、剪贴板、导出、删除及联络邮箱。 [拟发布的隐私政策网页](privacy-policy.html) |
| 分发签名 | BLOCKED | 没有发现正式签名配置。未生成正式密钥、正式签名 APK 或 AAB。 |
| 消费数据 | 自动化测试通过 | 按已返回的 Token 与价格记录估算。无用量时不写成零。正式账户余额、实际扣费与 Release 成功记录未实测。 |
| 普通反馈 | 自动化测试通过 | 只显示和复制邮箱，没有邮件发送服务。 |
| 依赖许可证 | 已实现，需渠道复核 | Flutter 打包的第三方声明可从「关于鱼者 → 开源许可」打开。商店所需的依赖与材料终审待做。 |
| iOS | 已准备，待构建 | 原有 Files 文档选择器、Share Extension、App Group 接收桥和 Keychain entitlement 继续使用。归档与 SQLite 迁移逻辑共用。 |

**Google Play 发布暂不可行。** 公开可访问的隐私政策地址、Data safety、目标年龄及内容评级问卷待提交。用户还需能在应用内举报 AI 生成内容，且开发者可处理。可行的无自建服务器方式是使用经开发者核准的托管举报服务。用户在聊天内选中回复和原因，预览并同意最少必要内容后，App 发送到经验证的 HTTPS 接收端。服务须返回可核对的回执，开发者须能在后台看到并处理；失败时显示发送失败。当前无已核准的接收端、处理流程和成功回执，因此普通反馈入口不计为举报。未向外部服务发送数据。 [Google Play 生成式 AI 内容](https://support.google.com/googleplay/android-developer/answer/13985936) · [Google Play 用户数据](https://support.google.com/googleplay/android-developer/answer/10144311) · [商店审核资料](https://support.google.com/googleplay/android-developer/answer/9859455)

中国大陆公开发行前，依据实际分发渠道、开发主体和服务方式核对备案、内容及投诉举报等适用义务。未完成具体渠道复核。iOS 需在 macOS 上验证 App Group 签名、合并后的隐私清单和 Required Reason API 声明、评级及实际分享。 [生成式人工智能服务管理暂行办法](https://www.cac.gov.cn/2023-07/13/c_1690898327029107.htm) · [Apple 隐私清单](https://developer.apple.com/documentation/bundleresources/privacy-manifest-files)

### iOS 交接

在 macOS/Xcode 配置 Runner 与 Share Extension 的配套签名和同一 App Group。先构建无签名的 Release 检查插件和合并隐私报告，再在真机验证 Keychain、Files 导入／导出、冷启动与后台分享、Android 到 iOS 归档恢复。iOS 公开 BYOK 的审核记录须独立核对。
