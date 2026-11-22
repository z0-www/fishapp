# 鱼者文游 V0.4.6+13 · API 测试结果

| 项目 | 实际执行 | 结果 |
| --- | --- | --- |
| Windows 官方接口探测 | 一次不带 Authorization 的 HTTPS POST 到 `https://api.deepseek.com/chat/completions` | HTTP 401，`application/json`，收到真实认证拒绝 |
| Windows 持有效凭据生成 | 未执行 | 无真实模型输出及用量 |
| Android 真机请求 | 未执行，ADB 设备列表为空 | 无真实认证、生成、Token 或落库证据 |
| `flutter pub get` | Windows | 通过 |
| `flutter analyze` | Windows | 通过，无问题 |
| `flutter test` | Windows | 259 项通过 |
| `flutter build apk --debug` | Windows | 通过，APK 已核验版本、签名及文件哈希 |

契约测试在 Dart 测试环境使用测试专用传输替身与合成凭据，覆盖请求地址和参数、HTTP 错误映射、SSE 任意分片、JSON 异常、终止原因、用户取消、费用确认、重发防护、正式构建限制及 SQLite 持久化。专项回归覆盖缺少 Key 时零请求并恢复草稿，401 清除待确认记录，超时保留用量未知，响应提供的 Token 替换待确认记录，改动 NPC 后仅把新人物资料用于新回合。

本轮无成功的真实生成请求。实际输入、输出和缓存命中 Token 均未获得。没有可报告的真实模型账单金额。Windows 401 可验证官方端点回应，仅证明认证拒绝路径。
