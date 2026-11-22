# B站发布用：两个 PWA 入口说明

> 下面两个入口是**网页/PWA 地址**，不是 APK/IPA 下载。  
> 用户打开网址后，按 Android Chrome 或 iPhone Safari 的提示添加到主屏幕即可。
> 未部署前不要填入假地址，也不要把 API Key 写进简介/评论。

## 1. 两个入口

把 `<主程序域名>`、`<转换器域名>` 替换成实际 Cloudflare Pages 域名：

```text
① 鱼者文游 · 主程序（PWA）
https://play.example.com/

② 鱼者文游 · 离线对话转换器（PWA）
https://convert.example.com/
```

建议两个独立域名/项目，例如：

```text
https://fish-text-adventure.pages.dev/
https://fish-converter.pages.dev/
```

不要用同一个域名下的不同路径。

## 2. B站简介短文案

```text
鱼者文游 PWA（手机浏览器直接玩，无需 APK/IPA）

① 主程序：
https://play.example.com/
Android 用 Chrome 打开；iPhone 用 Safari 打开。
菜单/分享 → 添加到主屏幕，像 App 一样使用。

② 离线对话转换器：
https://convert.example.com/
把 Chatbox 对话转换为 .yuzhe，再回主程序：
完整故事备份 → 从 .yuzhe 备份恢复
（不要用「DeepSeek 对话导入」）

首次打开需联网加载；之后可离线打开已缓存界面。
重要世界请及时导出 .yuzhe 备份。
API Key 由用户自己填写，不要把 Key 发到评论区。
```

## 3. 置顶评论模板

```text
两个入口（建议复制到浏览器打开）：
主程序 PWA：https://play.example.com/
对话转换器 PWA：https://convert.example.com/

Android：Chrome 打开 → 菜单 → 安装应用/添加到主屏幕
iPhone：Safari 打开 → 分享 → 添加到主屏幕

主程序需要你自己的 DeepSeek Key；转换器不需要 Key、不联网。
```

## 4. 两个“下载入口”的区别

| 入口 | 用途 | 用户动作 |
| --- | --- | --- |
| 主程序 PWA | 创建/继续世界、备份恢复、AI 文游 | 打开网址 → 添加到主屏幕 |
| 转换器 PWA | Chatbox JSON/Markdown/ZIP → `.yuzhe` | 打开网址 → 转换 → 保存 |

主程序不是“下载后安装”的 APK；它是 HTTPS 网页。iPhone 也不经过 App Store。

## 5. 可选备用入口

如果观众不会用 PWA，可在简介末尾附上：

- Android APK（当前 v1.2 `8CC7…`）；
- 夸克网盘发布包（需你自己上传）。

但不要把 APK 当成 iPhone 入口；iOS 只能 Safari PWA 或原生 IPA。

## 6. 发布前检查

- [ ] 两个 URL 都是 HTTPS，打开无 404/证书错误
- [ ] 两个站点是不同 origin
- [ ] 主程序 Chrome/Safari 可添加到主屏幕
- [ ] 转换器可独立打开
- [ ] B站简介没有 API Key、聊天原文、手机号
- [ ] 两个 URL 都换成真实域名，不用 `example.com`
