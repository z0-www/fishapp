# 鱼者文游 · 跨平台开发报告（iOS / Web PWA）

本目录是 DSH 接管后跨平台扩展的独立报告与交付物索引。项目基线为
**V0.5.8+34**（`com.yuzhe.fishtextadventure`，Flutter 3.50.0 / Dart 3.14.0）。

> 结论先行：**Web/PWA 已完成可运行的本地构建，并在真实 Chromium 浏览器中验证了
> 创建世界、`.yuzhe` 导出/加密导出/导入/恢复、API Key 安全存储和 DeepSeek CORS 直连；
> iOS 工程已完成静态审计与构建配置，但当前机器是 Windows，没有 macOS/Xcode，
> 因此 iOS 编译、IPA 生成、签名和真机安装均未执行，不能宣称已可用。**

## 目录

| 文件 | 内容 |
| --- | --- |
| [WEB_PWA_GUIDE.md](WEB_PWA_GUIDE.md) | Web 版架构、功能状态、Safari 安装、部署与限制 |
| [CLOUDFLARE_PAGES_DEPLOY.md](CLOUDFLARE_PAGES_DEPLOY.md) | 最简单的 Cloudflare Pages 上传部署教程 |
| [IPHONE_SAFARI_ACCEPTANCE.md](IPHONE_SAFARI_ACCEPTANCE.md) | 真实 iPhone Safari 验收清单与记录模板 |
| [GITHUB_IOS_ACTIONS.md](GITHUB_IOS_ACTIONS.md) | 私有仓库推送、Actions 构建未签名 IPA、Sideloadly |
| [PHASE2_ACCEPTANCE.md](PHASE2_ACCEPTANCE.md) | 第二阶段逐项结论（部署/真实 AI/Safari/iOS/IPA） |
| [SSE_USAGE_AUDIT.md](SSE_USAGE_AUDIT.md) | SSE、断线、Token Usage 与费用逻辑审计 |
| [CORS_AND_RELAY.md](CORS_AND_RELAY.md) | DeepSeek 浏览器直连实测证据与可选中转方案 |
| [IOS_BUILD_AND_SIDELOAD.md](IOS_BUILD_AND_SIDELOAD.md) | iOS 构建、Sideloadly 安装与四种状态 |
| [TEST_REPORT.md](TEST_REPORT.md) | 已执行/未执行的测试、命令与证据 |
| [ANDROID_REGRESSION.md](ANDROID_REGRESSION.md) | Android 回归结果 |
| [../../converter/README.md](../../converter/README.md) | 独立离线对话转换器（Chatbox/DeepSeek → `.yuzhe`） |
| [../../converter/TEST_REPORT.md](../../converter/TEST_REPORT.md) | 转换器实测、Android debug 导入与限制 |
| [../../converter/android/TEST_REPORT.md](../../converter/android/TEST_REPORT.md) | Android APK V1.2 签名、SAF 保存、模拟器实测与未验证项 |
| [PWA_TWO_SITE_DEPLOY.md](PWA_TWO_SITE_DEPLOY.md) | 主程序/转换器两个独立 PWA 的 Cloudflare Pages 上传说明 |
| [PWA_MOBILE_GUIDE.md](PWA_MOBILE_GUIDE.md) | Android Chrome / iPhone Safari 添加到主屏幕与使用教程 |
| [PWA_IPHONE_STARTUP_FIX.md](PWA_IPHONE_STARTUP_FIX.md) | iPhone Safari 启动卡死根因证据、修复与复测步骤 |
| [PWA_ACCEPTANCE.md](PWA_ACCEPTANCE.md) | PWA 上线验收、浏览器实测、隐私与未通过清单 |
| [PWA_DEEPSEEK_MANUAL_TEST.md](PWA_DEEPSEEK_MANUAL_TEST.md) | 真实 DeepSeek 生成/SSE/Token/费用人工验收步骤 |
| [BILIBILI_PWA_ENTRY.md](BILIBILI_PWA_ENTRY.md) | B站两个 PWA 入口文案与发布检查 |
| [../../converter/PWA_DEPLOYED.md](../../converter/PWA_DEPLOYED.md) | 转换器 PWA 线上地址与部署验证 |
| [DELIVERY_REPORT.md](DELIVERY_REPORT.md) | 最终交付清单与下一步 |

## 构建产物位置

| 产物 | 位置 | 状态 |
| --- | --- | --- |
| Web 构建 | `build/web/` → `dist/web/FishTextAdventure-0.5.8-web/` | 已生成，本地已验证（37 个文件，解压 21.9 MiB） |
| Cloudflare Pages ZIP | `dist/web/FishTextAdventure-0.5.8-cloudflare-pages.zip` | 已生成，9,137,288 字节，SHA-256 `D550A23AD5FD1726A89E2E83B4907651060A2124F4267E02A49E8170D29C9E88` |
| 离线转换器 ZIP | `dist/converter/FishTextAdventure-Converter-1.1.0-mobile-cloudflare-pages.zip` | 已生成，488,681 字节，SHA-256 `8730836A156AB09FF9BB21E09D197102B2545668E953C0CF1FC5686F81490282` |
| 主程序 PWA 上传包 | `dist/pwa/FishTextAdventure-main-PWA-cloudflare-pages.zip` | 已生成，9,137,288 字节，SHA-256 `D550A23AD5FD1726A89E2E83B4907651060A2124F4267E02A49E8170D29C9E88` |
| 转换器 PWA 上传包 | `dist/pwa/FishTextAdventure-converter-PWA-cloudflare-pages.zip` | 已生成，488,681 字节，SHA-256 `8730836A156AB09FF9BB21E09D197102B2545668E953C0CF1FC5686F81490282` |
| 示例 `.yuzhe` | `converter/examples/chatbox-sample.yuzhe` | 已生成，现有 app 测试 + Android debug 客户端导入通过 |
| Android 转换器 APK | `dist/android/鱼者文游-离线对话转换器-v1.2-安卓版.apk` | 已生成，1,177,635 字节，SHA-256 `8CC7990A25A31E4D520AAB89FC7581DF0D3D8D9C28F787DE0A68123618FEFCF7` |
| 夸克发布包 | `dist/android/鱼者文游-离线对话转换器-v1.2-夸克网盘发布包.zip` | 已生成，1,170,545 字节，SHA-256 `5B9F3796F0909C695D3BC26F98D984C488E633FBCCFF31BA3ED2C88A6524C191`；待用户上传到自己的夸克账号 |
| iOS 未签名 IPA | `dist/ios/*.ipa` | **未生成**（需要 macOS CI；当前无 GitHub 仓库/凭据） |
| Android Debug APK | `build/app/outputs/flutter-apk/app-debug.apk` | 已生成（回归用，220,589,337 字节） |
| Android 正式签名 APK | 项目内不存在；未覆盖、未删除 | 保持原状 |

## 基线保护

- 基线提交：`df49fb0 baseline: FishTextAdventure V0.5.8+34 source before cross-platform work`。
- 修改前的源码快照保存在本机工作目录（不随仓库分发，也不写入桌面项目目录）；
  本机没有 D 盘，因此快照放在 C 盘工作目录。
- 没有上传源码、用户故事、API Key 或签名文件；没有部署任何服务器。
