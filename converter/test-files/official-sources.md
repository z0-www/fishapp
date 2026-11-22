# 官方 Chatbox 合成备份夹具（外部来源，未随包分发）

以下是 Chatbox 官方仓库公开的**合成测试夹具**，明确说明不含用户数据。
它们不是本项目的文件，未复制进测试文件包；可通过链接自行下载测试。

来源：

- 仓库说明（所有内容为合成数据，不含用户数据）：
  https://github.com/chatboxai/chatbox/blob/main/packages/chatbox-core/src/testing/fixtures/published-backups/README.md
- V1 正式版本夹具（`configVersion=15`，`chat-sessions-list` + `session:<id>`）：
  https://raw.githubusercontent.com/chatboxai/chatbox/main/packages/chatbox-core/src/testing/fixtures/published-backups/v1-released.json
- V2 正式版本 ZIP 夹具：
  - manifest:
    https://raw.githubusercontent.com/chatboxai/chatbox/main/packages/chatbox-core/src/testing/fixtures/published-backups/v2-released/manifest.json
  - session:
    https://raw.githubusercontent.com/chatboxai/chatbox/main/packages/chatbox-core/src/testing/fixtures/published-backups/v2-released/sessions/released-v1235-session/session.json

这些样本来自 Chatbox v1.23.5 的导出器；V1 夹具 1 个会话、2 条当前消息 + 1 条历史线程消息，
V2 结构相同并有资源去重。内容含中英文和 emoji。

## 本项目的实测结论（2026-11-20）

修复后：

- V1 夹具：识别为“Chatbox JSON（旧版）”，当前时间线 2 条；
  `contentParts` 文本正确；图片/文件/链接计入“不转换”警告；
  历史线程 1 条**不合并**，明确警告，不静默丢失提示。
- V2 夹具组成 ZIP：识别为“Chatbox 备份 ZIP”，当前时间线 2 条；
  历史线程同样只提示、不合并。
- 真实用户数据：未下载、未上传、未使用；只使用官方合成夹具。

注意：官方夹具不等于所有 Chatbox 版本的导出格式；真实 Chatbox 文件仍需用户脱敏样本验收。
