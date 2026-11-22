# 鱼者文游 V0.4.8 · 交付报告

交付时间：2026-11-18。本轮由 DSH 直接检查并修改正式源码，而不是只输出建议。

## 1. DSH 实际修改了哪些代码

| 文件 | 修改内容 |
| --- | --- |
| `lib/features/ai/data/deepseek_config.dart` | 删除 `DEEPSEEK_NATIVE_BYOK_PERMISSION_GRANTED` 许可门与相关字段；`policyAllows` 只保留 Debug + Android/iOS + 两个开发开关；重写限制说明与条款口径 |
| `lib/features/ai/application/ai_providers.dart` | 不再从编译环境读取许可标记 |
| `lib/features/ai/data/deepseek_http_protocol.dart` | `/models` 也上报 HTTP 状态码（验证工具需要） |
| `android/app/src/main/AndroidManifest.xml` | 增加 `android.permission.INTERNET`（原先只有 debug 清单有） |
| `pubspec.yaml` | 版本 `0.4.6+13` → `0.4.8+14` |
| `lib/core/app_version.dart` | 新增统一显示版本常量 |
| `lib/features/settings/settings_page.dart` | 版本标签改为 `V0.4.8`（原硬编码 V0.4.6） |
| `lib/features/settings/feedback_page.dart` | 反馈邮件主题跟随版本常量 |
| `test/ai/deepseek_connection_test.dart` | 更新策略真值表；新增“无需许可标记”回归；provider 测试使用内存 SQLite |
| `test/roleplay_quality_test.dart` | 反馈主题断言跟随版本常量 |
| `tool/deepseek_verify.dart` | 新增真实请求验证工具（stdin 收 Key、单次付费、SSE/JSON/usage、脱敏报告） |
| `tool/DeepSeek-Verify.ps1` / `tool/Open-DeepSeek-Verify.cmd` | 新增本机遮蔽输入 + 费用同意的双击入口 |
| `docs/REAL_DEEPSEEK_FIX.md`、`BYOK_SECURITY.md` | 同步新的两开关构建与无 Mock 状态 |

没有改动：数据库 schema（仍为 6）、世界/存档结构、主导航与页面版式、AI 供应商、服务器架构、历史 `mock` 列的兼容读取。

**根因**：代码硬性要求一个文档声称不读取的许可标记，导致按文档构建的 APK 永远返回 `BlockedDialogueEngine`。这就是“保存有效 Key 后仍无法进入真实模型调用流程”的真实原因，不是 UI 问题。

## 2. Windows 真实请求是否成功

**成功。** 在用户本地窗口输入新 Key 并明确同意一次费用后执行：

| 项目 | 结果 |
| --- | --- |
| 端点 | `https://api.deepseek.com/chat/completions` |
| HTTP | **200** |
| 模型 | `deepseek-flash` |
| 正文 | 真实中文剧情 JSON，结构有效 |
| 耗时 | 1240 ms |
| 报告 | `reports/v048_api_result.json` |

完整证据见 [V048_REAL_API_TEST.md](V048_REAL_API_TEST.md)。

## 3. Android 真实请求是否成功

**未执行实时生成，不能记为成功。**

- `adb devices` 没有检测到用户手机；
- 本轮只授权了一次 Windows 请求；
- 已在 Android 17 模拟器完成可独立验证的部分：APK 安装、启动、**直连开关在 APK 内实际启用**、Key 在 Android Keystore 中保存/重启读取/删除、`shared_prefs` 中无明文 Key。

因此“Android 端 HTTP 200 与真实 Token 用量”仍待用户在手机上完成一次预算确认。详见 [V048_ANDROID_ACCEPTANCE.md](V048_ANDROID_ACCEPTANCE.md)。

## 4. 实际 Token 用量

| 端 | 输入 | 输出 | 缓存命中 | 总计 |
| --- | --- | --- | --- | --- |
| Windows（真实请求） | 83 | 56 | 0 | **139** |
| Android | 未取得 | 未取得 | 未取得 | 未取得 |

按官方公开价推算，本次 Windows 请求约 USD 0.000046（非高峰价），实际以账单为准。

## 5. 当前还有哪些接入限制

1. **正式发行直连仍锁定。** Profile/Release 构建在代码层拒绝直连；公开分发一个向终端用户索取 Key 的原生客户端需单独复核开放平台条款 2.2 的适用性、告知与隐私要求。本轮没有宣称获得 DeepSeek 特殊授权。
2. **交付物是私下验收 Debug 包。** 必须带两个 `--dart-define` 构建；默认构建不发真实请求。
3. **Android 真机端到端未验收。** 需要用户手机输入 Key 后完成一次生成。
4. **分享链接自动读取默认关闭。** 使用许可未确认，入口仍受限。
5. **费用。** 每次真实生成都需用户当次预算确认；本轮只授权一次 Windows 请求。

## 6. 对话导入是否真正取得消息正文

**没有取得真实分享正文。** 本轮只做了：

- 匿名探测 `GET https://chat.deepseek.com/api/v0/share/content?share_id=<随机无效ID>`，得到 HTTP 200 与 `{"code":0,"data":{"biz_code":1,"biz_msg":"share does not exist"}}`，说明端点与错误信封可用；
- 解析器自动化测试覆盖多消息、分支、`message_id`/`parent_id`、`fragments`、重复 ID、循环、无正文拒绝等；
- 没有用户提供的有效公开分享链接，因此**没有把“解析器测试通过”当成“真实导入成功”**。

可靠的备用路径保持不变：DeepSeek 官方 ZIP、TXT、JSON、Markdown、粘贴正文。

## 7. 是否保留旧存档

**保留。** 依据：

- `AppDatabase.schemaVersion` 仍为 6，迁移只 `createTable`，没有 drop/重建；
- 未修改 `worlds`、`roleplay_saves`、`roleplay_turns`、`roleplay_memories` 的表结构或读取逻辑；
- 删除 API Key 的提示与行为都是“只删除密钥，世界和游戏存档会保留”，模拟器实测删除后世界仍在；
- 未删除任何世界或存档文件。

## 8. APK 文件路径

```
C:\Users\lin\Desktop\FishTextAdventure\build\app\outputs\flutter-apk\app-debug.apk
```

- versionName / versionCode：`0.4.8 / 14`
- 大小：180,651,885 字节
- SHA-256：`DFEDC860169649C3EE3A0448480F165F8AF2D1D4986C191170869080E2316222`
- SHA-1：`F20636928C38C479D2B1BE08004B91F112D5F1BD`
- 已确认包含 `android.permission.INTERNET`

## 9. 尚未解决的问题

1. **手机真机实时生成与 Token 用量**：需用户安装 APK、输入 Key、确认一次预算。
2. **公开分发合规**：条款 2.2 在公开分发场景的适用性仍需单独复核；复核前 Release 保持锁定。
3. **有效公开分享链接的真实导入**：缺有效链接，未取得真实正文。
4. **安全事件**：上一轮遗留的明文 Key 已泄露在 `Open-DeepSeek-Input.cmd`，本轮已把该 Key 从文件中移除；用户必须到官方平台撤销它。DSH 未使用它。
5. **Debug APK 体积**：约 172 MiB，安装慢；正式发行需 Release 包，而 Release 目前不能直连。

## 安全事件说明

在 Codex 临时目录发现一个被误粘贴的明文 `sk-` 密钥。DSH 没有使用、没有输出、没有写入任何报告；该文件已重写为无密钥提示。建议立即在 DeepSeek 官方平台删除该 Key，并只通过 App 或本机遮蔽窗口输入新 Key。全项目扫描未发现其他明文密钥。
