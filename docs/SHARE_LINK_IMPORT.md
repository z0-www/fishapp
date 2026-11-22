# 公开分享链接导入

V0.4.5 新增 DeepSeekShareImportService，并接入既有极简导入预览。

用户粘贴或系统分享 `https://chat.deepseek.com/share/<id>` 后先看到链接占位。点击“读取公开分享内容”，确认匿名访问范围后才尝试读取。**本轮默认关闭下载**：尚未确认接口使用条件。界面明确提示改用官方 ZIP、JSON 或正文，不把链接当完整聊天。

## 实际研究与探测

阅读了实际源码：[Sillykjs share.js](https://github.com/Sillykjs/dsh-share-import/blob/main/lib/share.js)（SHA 8a3c3ead8da923eaed474c5ffb2470a237e20f93）与 [OpenGHz fetch_share.py](https://github.com/OpenGHz/chat-share-skill/blob/main/scripts/fetch_share.py)（SHA a1bda1521121528667e9c503ad0b1dbcc3a0023d）。本项目独立编写 Dart 代码，未执行社区脚本。

接口为匿名 GET `/api/v0/share/content?share_id=...`，社区响应结构为 code → data.biz_code / biz_data → messages。用无效测试 ID 探测收到 HTTP 200、code=0、biz_code=1、`share does not exist`；**没有有效真实分享下载验收**。

社区源码许可不等于网站接口授权。官方[条款](https://cdn.deepseek.com/policies/en-US/deepseek-terms-of-use.html)说明分享访问，也对自动复制抓取有限制；在使用条件未确认前，组合根只允许默认 false 的许可标记，且仅 Debug 可用；Release 不开放。未使用登录 Cookie、验证码、反爬绕过或私有会话。

## 解析与保存

- USER / ASSISTANT、消息 ID、父 ID、当前节点、分支。
- REQUEST / RESPONSE 是正文；THINK、SEARCH、其他片段仅留在原始 JSON，不拼成剧情。
- 时间、附件元数据及未知字段保留在每条 rawJson，完整响应文本另存本机派生档案。不会跟随附件、引用或搜索 URL 下载资源。
- 缺失父节点标为分享边界并提示；循环、重复 ID、无效当前节点拒绝，失败不改旧档案。
- 始终标明“不完整导入：仅含分享快照”；没有证据能认定为全部历史。
- 预览提供保存历史、创建新世界并进入恢复审核、关联已有世界。关联只是背景档案，不自动改写当前事实。
- 原文独立保存；重复确认使用同一会话，不复制收费整理。恢复、AI 整理仍走独立范围及预算确认。

## 访问安全

精确官方 HTTPS 域名、固定分享路径、6–64 位 URL-safe ID；拒绝用户信息、其他端口、查询跳转、片段、伪造子域与私有会话路径。固定构造唯一 GET 地址，不跟随重定向，不继承 API 鉴权或日志拦截器。8 MB、连接/读取/总时长边界，取消和异常使用固定中文提示。不自动重试。

保留 TXT、Markdown、JSON、DeepSeek 官方 V3 ZIP、剪贴板及手机文件选择器。用户提供的分享响应 JSON 也可离线导入，保留原始响应。所有导入内容视为剧情数据，不可执行为系统指令。

自动化覆盖正常模拟响应、失效/私有会话、URL 白名单、重定向、大小限制、分支、推理隔离、重复保存、原文及选择分支恢复。详见测试日志；网络下载正例仍待许可与真实链接验证。
