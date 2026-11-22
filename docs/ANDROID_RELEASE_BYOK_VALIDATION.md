# Android Release 的 DeepSeek 接入验收

适用版本为鱼者文游 0.5.8+33。官方资料核对日期为 2026-11-19。

## 技术拦截点

| 路径 | 真正发出请求的条件 |
| --- | --- |
| Android、iOS Debug | 原生移动平台，且 `DEEPSEEK_EXPERIMENTAL` 和 `DEEPSEEK_REAL_API_DEV_TEST` 都启用。 |
| Android Release 本机验收 | 显式使用 `FISH_ANDROID_RELEASE_BYOK_VALIDATION=true`，Gradle 生成独立应用 ID `com.yuzhe.fishtextadventure.byokvalidation`。使用独立应用数据和密钥存储。 |
| Android、iOS 公开 Release | `ReleaseAccess.current` 包含对应平台和服务的公开发行审核记录。现有记录为空，因此默认公开构建会在发出请求前停止。 |

三条路径均要求官方 HTTPS 地址与受支持的模型。密钥通过系统安全存储读取，并仅用于请求的 Bearer 头。验收模式复用原有费用确认、剧情请求、SSE 和用量落库链路。

## 条款核对

DeepSeek 开放平台服务协议第 1.1 条允许依约集成模型服务并面向终端用户。第 2.4 条要求保护账号凭证，禁止共享或公开密钥，并禁止将密钥暴露在浏览器或其他客户端代码里。已核对的公开条款未列明下游集成统一需要另行取得书面许可。原生方案需要结合账号归属、密钥输入和存储、代码与日志暴露风险评估。公开发行审核可依据适用的公开条款及项目证据，仍需核对第 3 条要求的终端用户约定、个人信息、内容安全及标识义务，以及具体渠道的适用条件。[DeepSeek 开放平台服务协议](https://cdn.deepseek.com/policies/zh-CN/deepseek-open-platform-terms-of-service.html)

官方 OpenAI 兼容接口为 `POST https://api.deepseek.com/chat/completions`，当前列出 `deepseek-flash` 和 `deepseek-v4-pro`。流式接口使用 SSE，服务端通过 `usage` 返回输入、输出和缓存用量。[官方接入指南](https://api-docs.deepseek.com/) · [Chat Completions 文档](https://api-docs.deepseek.com/api/create-chat-completion/)

## 本机验收

构建独立验收包可使用下列命令，同时关掉两个 Debug 开关来独立验证 Release 路径。

```powershell
flutter build apk --release --dart-define=FISH_ANDROID_RELEASE_BYOK_VALIDATION=true --dart-define=DEEPSEEK_EXPERIMENTAL=false --dart-define=DEEPSEEK_REAL_API_DEV_TEST=false
```

验收包用本机 Android 调试证书签名，编译模式仍为 Release 且不可调试。公开发行验证脚本校验固定包名和正式签名，验收包无法通过包名校验。旧版可以保留。建议在独立验收包里新建无隐私信息的测试世界。

本轮 `flutter analyze --no-pub` 无问题，`flutter test --no-pub` 通过 298 项。新增回归覆盖平台与构建开关隔离、拒绝非官方端点和未知模型、费用取消时零请求，以及有批准时送出包含世界与 NPC 记忆的单次请求并持久化剧情与 Token。该集成测试使用本地 HTTP 适配器。

隔离构建首次拉取 `https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-3.9.1/libsqlite3.arm.android.so` 超时。复用现有项目同版本、已核对哈希的 SQLite 缓存后构建成功。没有调整依赖或 Gradle 版本。

在 Android API 37 模拟器中，验收包通过签名验证、不可调试检查和安装启动测试。模拟器离线且未配置密钥；页面显示「Android Release 接入验收已启用」及「还没有本机请求记录」。公开发行校验脚本按独立包名拒绝该包。

- APK 路径为 `build/byok-validation/FishTextAdventure-0.5.8+33-Android-Release-BYOK-Validation.apk`。
- SHA-256 为 `9059759C87C1EF6F8B9F097A4BDA99D67B876C16EBBBE48FC277CDCADD410F3B`。

## 真实请求证据

本轮未获得新付费请求确认。真实 HTTP 状态、模型正文和实际 Token Usage 均待验。没有填写测试结果到公开发行验收记录。

费用确认后，只需在验收包里保存账号自己的 Key，并在测试世界确认发送一轮剧情。随后打开「设置 → AI 服务设置 → 接入验收记录」，核对 HTTP 200、响应模型、输入和输出 Token，并在聊天页确认模型正文保存。若只验证这一轮，可以直接发送剧情，无需另做一次手动连接测试。提交证据时只使用可公开的测试剧情和脱敏诊断。
