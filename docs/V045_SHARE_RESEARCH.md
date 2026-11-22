# 分享接口源码研究（2026-11-17）
已阅读实际源文件，而非仅 README：
- https://github.com/Sillykjs/dsh-share-import/blob/main/lib/share.js SHA 8a3c3ead8da923eaed474c5ffb2470a237e20f93
- https://github.com/OpenGHz/chat-share-skill/blob/main/scripts/fetch_share.py SHA a1bda1521121528667e9c503ad0b1dbcc3a0023d
观察：GET /api/v0/share/content?share_id=...；data.biz_data.messages；USER/ASSISTANT；REQUEST/RESPONSE 正文，THINK 与 SEARCH 非剧情。
本项目独立编写 Dart 实现，不复制社区源码。社区 MIT 许可不等于 DeepSeek 服务访问许可。
匿名无效 ID 探测收到 HTTP 200 application/json，code=0、biz_code=1、biz_msg=share does not exist。没有有效真实分享链接验收。
官方条款 1.6 说明分享可访问，3.5 对自动复制抓取有限制，未取得适用许可；因此下载适配器默认关闭，发行构建关闭。不能把接口可达当作正式集成授权。
https://cdn.deepseek.com/policies/en-US/deepseek-terms-of-use.html
