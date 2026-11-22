# 鱼者文游 · Local BYOK（V0.4.8 更新）

本轮仅增加本地密钥管理、AI 设置和网络接口抽象。首页、世界列表和本地世界继续可用。无鱼者服务器、云网关、账号系统、远程密钥库、请求代理或云存档。

## 默认行为

首次启动只检查系统安全存储是否存在密钥；没有则进入欢迎配置页。已有密钥直接进入首页，不发网络请求。用户也可选择先体验本地世界。设置 → AI 服务设置可更换、删除或手动测试。

**测试连接（Mock）只验证本地流程和输入格式，不验证 DeepSeek 密钥有效性、余额或真实连通性。** 通过后仍需明确确认才保存。取消、异常、后台切换或离开时清除输入框引用。已保存密钥只显示固定掩码，绝不回填到 UI。更换采用单次平台写入，先测试、再确认，不先删除旧密钥；网络失败不修改存储。

## 安全边界

- 所有凭据读写集中在 `lib/core/security/api_key_storage.dart`，使用 flutter_secure_storage 10.3.4。
- Android：Keystore RSA OAEP 包装加密密钥，AES-GCM 保护数据；独立 storageNamespace；resetOnError=false；不使用迁移备份副本。插件底层会把**密文**写入专用 SharedPreferences，这是插件的持久化实现；应用不把**明文 API Key**写入普通 SharedPreferences、SQLite、普通文件或存档。不能把它理解为设备上完全没有密文文件。
- Android allowBackup=false，并为旧版备份、Android 12+ 云备份与设备迁移配置全域排除。
- iOS：unlocked_this_device，解锁时可访问、只限本设备；synchronizable=false，不同步 iCloud Keychain。不共享 Keychain group。
- Dart String 不可原地擦除；本轮清除的是输入框和临时变量引用，不能保证 Dart VM / 操作系统 / 用户键盘对内存的物理清零。系统剪贴板由用户管理；粘贴采用当前操作版本校验，防止后台回来后异步回填。
- UI 默认隐藏输入，显示开关仅作用于用户正在输入的临时值，不会显示已保存密钥。关闭纠错、建议、IME 个性化和自动填充。
- 不提供凭据导出。WorldExportService 仅按白名单序列化世界字段，不打包原始数据库或安全存储。此为序列化边界，不新增完整存档导出页面。
- 删除只操作一个命名安全条目，不调用 deleteAll，也不碰世界数据库。

## 接口模式与许可门

DeepSeekConfig / DeepSeekApiClient / DeepSeekRepository / DeepSeekErrorHandler 独立封装。Base URL 固定为 https://api.deepseek.com，模型默认 deepseek-flash，路径 /chat/completions，使用 Bearer 授权和 SSE / JSON Output。固定官方 HTTPS host 白名单，禁止重定向。Dio 独立实例，不继承日志拦截器，不将授权头放进全局默认 headers。

V0.4.3 明确区分三种状态（V0.4.7 删除运行时 Mock，V0.4.8 移除许可门标记）：

1. **本地模式**：默认构建。不发出网络请求，也不生成任何替代回复；缺 Key、断网或接口失败都显示明确错误。旧存档中的 `mock` 列只用于标注历史来源。
2. **真实 API 开发测试**：仅 Debug + Android/iOS，且必须同时显式传入 `DEEPSEEK_EXPERIMENTAL=true` 与 `DEEPSEEK_REAL_API_DEV_TEST=true`。此模式使用开发者自己的密钥真实请求 DeepSeek，会产生费用；每轮游戏请求仍需预算确认。它不是正式发行能力，不应分发给普通用户。
3. **正式发行限制**：Profile/Release 构建在本版本中固定拒绝真实直连，即使意外传入实验构建标记也不会改变。开启正式发行直连必须经过适用条款复核后的代码修改，而不是构建参数。

`DEEPSEEK_NATIVE_BYOK_PERMISSION_GRANTED` 在 V0.4.8 已从代码中移除。它既不是法律授权，也不再是拦截普通 API 使用的门槛；真实 API 开发测试不读取任何“许可标记”。

错误 400/401/402/403/404/408/413/422/429/500/503/504、超时和网络错误均转换为固定中文提示；不显示原始响应、头、DioException、Authorization 或平台错误。即使其他模块构造含任意文本的 DeepSeekFailure，显示层也只接纳中文消息白名单。真实模型输出为空、截断、finish_reason 异常或 JSON 协议不符时显示明确错误，不会静默切换 Mock、伪造回复或自动重发收费请求。

V0.4.8 交付的私下验收 Debug 包显式启用两个开发开关，并已通过独立 Windows 工具取得一次真实 HTTP 200 与 Token 用量（见 [V048_REAL_API_TEST.md](docs/V048_REAL_API_TEST.md)）。自动化测试使用本地假适配器与虚构密钥，不等同于联网验收；Android 真机真实生成仍待用户侧验收。

## 费用与迁移

数据库文件名保持 fish_text_adventure，schema 从 1 递增到 2，只添加 usage_records，不删除或重建 worlds/app_meta。UsageRepository 预留请求时间、模型、输入/输出/缓存 Token、可空 USD 估算及价格版本。PriceTable 独立记录版本、生效日期和模型。无已核验价格时估算保持 null，页面显示未估价，不能将未知费用当作免费。Mock 不写费用记录，初始化不注入账单。

## 验证

```powershell
flutter pub get
dart run build_runner build
flutter analyze
flutter test --reporter expanded
flutter build apk --debug
```

密钥测试使用虚构夹具、Mock API 与 MethodChannel 假安全存储，不使用真实 Key。插件实例重建后读取得到同一假存储数据，属于重启流程模拟；不等同于 Android 进程强杀或 iOS 重启后的原生存储实测。没有连接设备时，真机 Keystore/Keychain 与重启行为必须保留为未验证。

参考：[DeepSeek 开放平台条款 2.2](https://cdn.deepseek.com/policies/en-US/deepseek-open-platform-terms-of-service.html)、[DeepSeek API 文档](https://api-docs.deepseek.com/)、[flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage/versions/10.3.4)。

## 跨平台补充（2026-11-20，V0.5.8+34 基线）

本节记录 iOS/Web 扩展对 BYOK 边界的影响，不修改上面的历史 Android 结论。

1. **Web 版是官方端点直连。** 经真实浏览器预检与 `fetch` 验证，`api.deepseek.com`
   会回显页面 Origin 并允许 `authorization`/`content-type`，故不需要鱼者中转。
   Key 只存在用户浏览器，只发送给 `api.deepseek.com`；没有鱼者服务器参与。
   证据与可选中转设计见 [docs/cross-platform/CORS_AND_RELAY.md](docs/cross-platform/CORS_AND_RELAY.md)。
2. **Web 密钥存储弱于原生。** `flutter_secure_storage_web` 使用 WebCrypto AES-GCM 加密后写入
   `localStorage`，包装密钥也在同源存储；能避免明文直读，但不能抵御 XSS、恶意扩展或被攻破的浏览器。
   仅 HTTPS/localhost 可用；清除站点数据会删除 Key。UI 已明确提示，不建议在公共电脑保存。
3. **Web 不写入日志/URL/分析。** 没有新增分析 SDK；`DeepSeekHttpProtocol` 的日志边界不变。
   浏览器 DevTools 的 Network 面板仍会显示用户自己的请求，这是浏览器行为。
4. **iOS 个人侧载直连。** IPA 构建脚本传入 `FISH_IOS_BYOK=true`，使个人签名/侧载 Release
   包可以真实调用；不传该标记时保持“iOS 发布待独立审核”的拒绝策略。
   TestFlight/App Store 是否启用必须单独评审，不能沿用侧载结论。
5. **Web 不提供假回复。** AI 失败时仍显示明确错误；没有 Key 时仍可本地世界。
   `Mock` 仅作为历史存档字段存在，运行时不生成替代剧情。
6. **附件边界。** Web 版 `.yuzhe` 保留完整故事数据，但附件原文件只保留元数据，导出/恢复时明确提示；
   不会用其他内容冒充附件。
7. **签名材料。** 本次没有生成、读取或上传任何签名证书、Keystore、Provisioning Profile；
   Android 正式签名 APK 未被覆盖或删除。
