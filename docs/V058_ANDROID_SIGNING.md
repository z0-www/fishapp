# V0.5.8 Android 正式签名

签名使用开发者自己的长期 Android 应用证书。本轮已在项目之外由开发者安全创建签名库并签出 Release。后续更新请复用同一证书。首次创建或从离线备份恢复时，应由开发者在自己的 Windows 终端操作。

## 首次创建

在 Flutter 项目根目录打开 PowerShell 7（`pwsh`），运行以下命令。密码只在本机输入框填写，输入内容不会回显。签名工具通过本机标准输入取得密码。本流程不把密码写入命令参数、环境变量、项目配置或日志。

```powershell
.\tool\Android-OwnerSigning.ps1 -Initialize
```

默认签名库保存在 `%LOCALAPPDATA%\FishTextAdventure\signing\yuzhe-release.p12`，同目录 `.cer` 是可单独保存的公开证书。脚本以 z0-www 作为证书显示名，不覆盖现有签名身份。已有正式证书的发布人应取回原有密钥，使用现成的签名档案。

## 离线备份

将 `.p12` 和证书、证书指纹、密钥别名备份至离线加密介质，至少保存两份。口令保存在可信密码管理器或另外的安全位置，和签名库分开。用备份恢复后比对公开证书的 SHA-256。勿把私钥文件、口令、用户 API Key 或内测存档上传到网盘或提交 Git。未来同一包名的正式升级要保留兼容的签名证书。 [Android 签名与应用升级](https://developer.android.com/studio/publish/app-signing)

## 构建、签名与验收

```powershell
flutter build apk --release
.\tool\Android-OwnerSigning.ps1 -Apk .\build\app\outputs\flutter-apk\app-release.apk
```

构建或签名后重新核对 APK 的版本、包名、证书 SHA-256、AOT、调试标记和 16 KB ZIP／ELF 对齐。签名脚本把通过二进制检查的产物放在 `build/owner-signed/`，用于签名后真机验收。二进制检查与 16 KB 设备上的实际运行是两项不同证据。 [apksigner](https://developer.android.com/tools/apksigner) · [Android 16 KB 兼容检查](https://developer.android.com/guide/practices/page-sizes)

实际安装、真实 HTTP 200 回复和用量、备份恢复及发行范围确认均完成后，才能据实更新 `docs/public-beta-v058/验收记录.json`。记录绑定到同一个 APK SHA-256 和正式证书。然后运行 `tool/New-PublicBetaPackage.ps1 -Apk <已验收的 APK>`。它只复制指定的用户文件，并为最终 APK 生成 `SHA256.txt`。
