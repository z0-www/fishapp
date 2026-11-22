# V0.5.7 单会话导入验收

| 步骤 | 状态 | 证据 |
| --- | --- | --- |
| Android 系统分享识别 | 模拟器实测 | 系统可解析 `ACTION_SEND text/plain`。 |
| 文字入口与真实原文预览 | 模拟器实测 | 给 V0.5.6 通过真实 Android Intent 分享 12 条本机构造消息，预览显示用户、AI 各 6 条。 |
| 创建可继续故事及跨版本恢复 | 模拟器实测 | 同测试证书就地更新至 V0.5.7 Release AOT，重新打开后仍可阅读原始末条消息。 |
| 公开链接实际消息 | 未通过 | 之前一次普通 HTTPS 请求返回 429，本轮公共页面工具仍不可读取。该公开样本累计取得 0 条正文。 |
| DeepSeek 官方 App 真机分享 | 未验证 | 本轮未连接真机。自动化协议样本与 Android 系统收件的本地验收分别记录。 |
| TXT、JSON、粘贴、官方 ZIP 单会话选择 | 自动化测试通过 | 保留预览、用户确认、原始顺序、附件关联及本地恢复。 |
| iOS | 未验证 | Dart 数据解析和归档共用。iOS 原生文件及分享链路仍需真机。 |

公开链接和已取得正文分开显示。无正文的链接不会完成导入，也无法创建世界。未开放公开接口时，预览只提供打开官方浏览器、粘贴正文与文件导入。联网适配仍受各自审核记录约束，Debug 的 `DEEPSEEK_SHARE_ACCESS_PERMISSION_CONFIRMED` 不适用于 Release。分享快照只能建立在实际收到的消息上，并按部分会话标注。未使用登录态、私有 Cookie 或绕过访问限制的方式。 [DeepSeek 用户协议](https://cdn.deepseek.com/policies/zh-CN/deepseek-terms-of-use.html)

[此前公网访问记录](REAL_CONVERSATION_IMPORT_TEST.md) · [V0.5.7 测试及证据](V057_RELEASE_CHECKLIST.md)
