# 鱼者文游 Android 原生 BYOK 接入许可咨询

收件渠道为 DeepSeek 开放平台「联系我们」或 `api-service@deepseek.com`。 [开放平台条款第 11.2 条](https://cdn.deepseek.com/policies/en-US/deepseek-open-platform-terms-of-service.html)

**建议主题**　请确认鱼者文游 Android 原生 BYOK 接入方式的适用条件

DeepSeek 开放平台团队您好：

我们正在开发鱼者文游（FishTextAdventure），一款原生 Android 文字角色扮演应用，包名为 `com.yuzhe.fishtextadventure`。想请贵方就开放平台条款第 2.2 条确认以下 BYOK（用户自带密钥）接入方式。

- 每位用户在自己的设备内输入由其 DeepSeek 开放平台账户生成的 API Key，并可随时删除。
- App 使用 Android 系统安全存储。Key 只在设备内用于请求鉴权，不打包入 APK，也不写入日志、诊断或备份。
- 经用户确认后，App 从设备通过 HTTPS 直连官方 Chat Completions API，在 Authorization 请求头中使用用户自己的 Key。
- 鱼者文游没有承接请求或保存密钥的服务器。DeepSeek 直接向用户的开放平台账户计费，鱼者文游不收取 API 费用。

烦请分别确认以下范围是否允许，以及分别适用的要求。

1. 开发者与受邀测试者使用自己的 Key，在私下分发的 Android Debug 测试包中验证上述流程。
2. 未来公开分发的 Android 正式版，在同样的安全措施下使用该流程。请指出是否需要另外的协议、审核、适用地区限制、用户告知或特定鉴权机制。

如上述方式有部分不符合当前要求，也请告知是否存在适用于原生客户端的官方授权方式。我们会按贵方明确的范围安排测试及发布。

感谢协助。

鱼者文游项目团队
