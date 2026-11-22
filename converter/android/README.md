# 鱼者文游 · 离线对话转换器 · Android APK 构建说明

独立包名：`com.yuzhe.converter`
版本：`1.2.1`（versionCode 13）
最低 Android：7.0（API 24）
目标 Android：14（targetSdk 34）
UI：V1.2.1 转换器网页资源（复用解析器、UI、`yuzhe_codec`），原生 WebView 壳。

## 关键约束

- 无 `INTERNET` 权限；WebView 从 APK assets 加载，`setBlockNetworkLoads(true)`。
- 无存储权限；选择文件用 `ACTION_OPEN_DOCUMENT`，保存用 `ACTION_CREATE_DOCUMENT`。
- 独立包名，不覆盖 `com.yuzhe.fishtextadventure`。
- 原版鱼者文游不被修改；转换器只通过 `getLaunchIntentForPackage` 打开它。
- 发布包必须用独立正式签名，不能用 debug 签名。

## 源码

```text
converter/android/
  app/src/main/java/com/yuzhe/converter/MainActivity.java
  app/src/main/assets/converter/        由 dist/converter 复制
  app/src/main/AndroidManifest.xml
  build_apk.ps1                         构建/签名/Quark 打包
  signing/（本机，gitignored）          正式 keystore 与密码
```

## 构建

先构建 V1.2.1 网页资源，再构建 APK：

```powershell
powershell -ExecutionPolicy Bypass -File converter\build.ps1 -SkipPubGet
powershell -ExecutionPolicy Bypass -File converter\android\build_apk.ps1 -SkipWebBuild
```

脚本会：

1. 把 `dist/converter/FishTextAdventure-Converter-1.2.1-mobile` 复制到 assets；
2. Gradle `assembleRelease`；
3. `zipalign -p -f 4`；
4. 用 `converter/signing/fish-converter-release.jks` 做 v2/v3 签名；
5. 校验无 INTERNET / 存储权限；
6. 输出 APK、SHA-256、Quark 发布 ZIP。

签名材料在 `converter/signing/`（已 gitignore），必须离线备份，**不得提交到 GitHub 或公开网盘**。
证书 SHA-256（公钥）：

```text
d1d0130c90a64dbb6e4f4ec6c0776a50762f2db5b66b0aa03ab5501778623893
```
