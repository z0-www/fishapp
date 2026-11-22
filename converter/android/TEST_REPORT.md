# 鱼者文游 · Android 离线对话转换器 V1.2.1 · 测试报告

日期：2026-11-22
范围：文件选择 → 解析 → `.yuzhe` → 主 App 真实 `StoryBackup` 恢复
环境：Windows 11；Flutter 3.50 / Dart 3.14；Android 模拟器 Medium Phone API 37

## 1. 交付 APK

```text
dist/android/鱼者文游-离线对话转换器-v1.2.1-安卓版.apk
1,181,731 字节
SHA-256 BE42098D295205F95585094927DC64ADF1628769E09FA3BF9898F488DE99B132
```

- `com.yuzhe.converter`，versionCode 13，versionName 1.2.1；
- release 签名，非 debug；
- 证书 SHA-256 `d1d0130c90a64dbb6e4f4ec6c0776a50762f2db5b66b0aa03ab5501778623893`；
- 无 INTERNET / READ_EXTERNAL_STORAGE / WRITE_EXTERNAL_STORAGE / MANAGE_EXTERNAL_STORAGE。

原 V1.2.0 APK 保留在 `backups/converter-v1.2.0/`，未覆盖：

```text
1,177,635 字节
8CC7990A25A31E4D520AAB89FC7581DF0D3D8D9C28F787DE0A68123618FEFCF7
```

源码备份分支：`backup/converter-v1.2.0`。

## 2. 修复内容

- `customFields.converter.version` / `derived_json.version`：1.1.0 → 1.2.1；
- `.yuzhe` 容器版本仍为 1，与主 App `StoryBackupFormat.version` 一致；
- Service Worker 缓存：`fish-converter-v1.2.1-mobile`；
- 页脚：V1.2.1；
- `created_at` / `saved_at` 由毫秒改为 Unix 秒，修复恢复后 57974 年；
- timeline 恢复 ID 加可排序 ordinal 前缀，修复源消息时间线顺序；
- 多选会话新增“合并为一个 .yuzhe”，主 App 可一次导入多个世界；
- Windows ZIP 改前斜杠，避免 Cloudflare `canvaskit/` 等目录 404；
- APK 构建先写 ASCII 临时签名文件，再生成交付 APK。

## 3. 测试结果

```text
新增 V1.2.1 专项：13 passed / 0 failed
主 App 全量：322 passed / 0 failed
flutter analyze：No issues found
```

测试文件：`test/converter_v121_compat_test.dart`

覆盖：

- 100、1000 条消息；
- 中文/特殊字符/多行；
- 空正文/缺失正文；
- TXT、Markdown、Chatbox JSON/ZIP（既有测试）；
- 多会话 ZIP（3 个独立 `.yuzhe`，共 6 条）；
- 合并 `.yuzhe`（3 个世界、6 条一次恢复）；
- AES-256-GCM；
- 重复导入拒绝；
- 预览后损坏回滚；
- 损坏 JSON/ZIP/UTF-8/33 MiB；
- V1.2.1 元数据；
- APK 实际生成归档在主 App 真实恢复。

## 4. APK 实际流程

模拟器选择 `01-chatbox-single.json`：1 个会话、5 条消息；
生成并保存 `雨夜茶馆 · 测试.yuzhe`，12,377 字节；
该 APK 生成的文件通过主 App 真实 `StoryBackup`：
5 条消息、角色顺序正确、converter 1.2.1、EventTimeline 5 条、日期正常 2026 年。

## 5. Web/PWA

```text
dist/converter/FishTextAdventure-Converter-1.2.1-mobile-cloudflare-pages.zip
SHA-256 EAA0ABED9E859BDDC803D1766F889666A4C2F090489B8ABDED950ACF1D03282C
```

## 6. 未验证

- 真实 Chatbox 用户导出；
- 真实 Android 手机（本次模拟器）；
- 主 App 官方正式签名 APK 的端到端导入；
- 图片/附件/工具参数不写入 `.yuzhe`；
- 多会话 ZIP 本身不是主 App 可直读格式，使用合并 `.yuzhe` 或分别导入。

## 7. 结论

代码、APK 构建和主 App 真实恢复测试达到 V1.2.1 发布条件。
真实 Chatbox 样本/真机仍需验收，不能宣称所有版本兼容。
