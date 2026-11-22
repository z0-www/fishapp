# Android 系统分享验收

## 构建及产物

- Flutter 静态分析通过，未报告问题。全量自动化测试 290 项通过。构建了 Android Debug APK，校验了包名 `com.yuzhe.fishtextadventure`、显示名称「鱼者文游」、版本名 `0.5.4`、版本号 `29` 和 Debug 签名。
- [可安装 APK](../build/app/outputs/flutter-apk/鱼者文游-V0.5.4+29-Debug.apk) 为 181,700,499 字节。SHA-256 为 `E3A9996683B9475464636EF8099EA1690BC86E4D714C230D3ECEEC6C4D897B1E`。
- [Flutter 测试日志](../reports/single-share-v054-flutter.log) · [Android 操作日志](../reports/single-share-v054-android.log)

## Android 模拟器实测

在 Windows 上安装本次 APK，用 Android 系统发送 `ACTION_SEND`。设备是本机 Android API 37 模拟器，原文样本为本地构造的 22 条消息。

| 场景 | 结果 |
| --- | --- |
| 系统解析 `ACTION_SEND`、`text/plain` | 分享接收目标包含鱼者文游 |
| 冷启动接收链接 | 自动打开预览，显示尚无正文，保存入口不可用 |
| 已打开的 App 进入后台后接收正文 | 唤回预览，显示用户 11 条、AI 11 条及正确的首尾消息 |
| 中途结束进程，原生队列此前已确认 | 重启自动恢复未完成预览 |
| 主动离开链接预览后另行导入，随后重启 | 链接任务留在待处理列表，已恢复故事可从首页进入 |
| 点击「导入并继续故事」 | 创建可打开的世界并恢复原文末尾。无 Key 发送时提示缺少配置 |
| 前台再次收到相同正文 | 打开现有 22 条消息的归档，可继续原世界 |
| 重启并继续原世界 | 最后一条原文仍可阅读 |
| 分享链接位于 Intent Data | 不需要 `EXTRA_TEXT`，可进入链接预览 |

公开样本返回 HTTP 429，实际取得 0 条消息。部分公开快照、协议错误和文件解析另有自动化覆盖。来自 DeepSeek App 的手机真机分享，以及 iOS Share Extension 的签名、编译、启动交接和文件验证仍待实测。iOS 共用 Dart 导入与恢复逻辑。 [真实会话获取记录](REAL_CONVERSATION_IMPORT_TEST.md)
