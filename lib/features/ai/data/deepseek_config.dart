import 'package:flutter/foundation.dart';

import '../../../core/release_access.dart';
import 'deepseek_models.dart';

/// Native BYOK policy.
///
/// Build controls select a request path. The Open Platform terms permit
/// downstream integration subject to their conditions, including protection
/// against key exposure. Public distribution requires its own scoped review.
class DeepSeekConfig {
  const DeepSeekConfig({
    this.baseUrl = 'https://api.deepseek.com',
    this.model = DeepSeekModels.defaultModel,
    this.thinking = false,
    this.enableExperimental = false,
    this.devRealApiTestEnabled = false,
    this.androidReleaseValidationEnabled = false,
    this.androidReleaseByokEnabled = false,
  });

  static const applicationBuild = DeepSeekConfig(
    enableExperimental: bool.fromEnvironment(
      'DEEPSEEK_EXPERIMENTAL',
      defaultValue: true,
    ),
    devRealApiTestEnabled: bool.fromEnvironment(
      'DEEPSEEK_REAL_API_DEV_TEST',
      defaultValue: true,
    ),
    androidReleaseValidationEnabled: bool.fromEnvironment(
      'FISH_ANDROID_RELEASE_BYOK_VALIDATION',
    ),
    androidReleaseByokEnabled: bool.fromEnvironment(
      'FISH_ANDROID_RELEASE_BYOK',
    ),
  );

  final String baseUrl, model;
  final bool thinking;

  DeepSeekConfig withModel(String selected) => DeepSeekConfig(
    baseUrl: baseUrl,
    model: selected,
    thinking: thinking,
    enableExperimental: enableExperimental,
    devRealApiTestEnabled: devRealApiTestEnabled,
    androidReleaseValidationEnabled: androidReleaseValidationEnabled,
    androidReleaseByokEnabled: androidReleaseByokEnabled,
  );

  static const blockedMessage = '当前版本暂未启用 DeepSeek 在线服务。';

  /// Debug-only opt-in for the native adapter. Never an end-user setting.
  final bool enableExperimental;

  /// Debug-only local developer opt-in. It is not a release capability and
  /// is never read from end-user settings.
  final bool devRealApiTestEnabled;

  /// Android Gradle gives this build a separate application ID. This switch
  /// is for local acceptance and carries no public distribution decision.
  final bool androidReleaseValidationEnabled;

  /// Selects the real transport for the original Android Release package.
  /// Public distribution is verified against the final signed APK separately.
  final bool androidReleaseByokEnabled;

  /// Pure policy for native Debug controls.
  ///
  /// The developer opt-in is a cost/scope safety control, not a licence
  /// claim. There is deliberately no "permission granted" input: no marker
  /// here can assert a special authorization that was never issued.
  static bool policyAllows({
    required bool debug,
    required bool web,
    required bool nativeMobile,
    required bool experimental,
    required bool devTestEnabled,
  }) {
    if (web || !nativeMobile) return false;
    if (!debug) return false;
    return experimental && devTestEnabled;
  }

  bool get nativeMobile =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  /// Debug + native + both local developer opt-ins. Additionally:
  /// [permitsDirectCalls] also requires the fixed official HTTPS endpoint and
  /// a documented model, so a mistyped build flag cannot redirect the key.
  bool get devTestAllowed => policyAllows(
    debug: kDebugMode,
    web: kIsWeb,
    nativeMobile: nativeMobile,
    experimental: enableExperimental,
    devTestEnabled: devRealApiTestEnabled,
  );

  @visibleForTesting
  static bool permitsAndroidRelease({
    required bool release,
    required bool web,
    required TargetPlatform platform,
    required bool enabled,
  }) => release && !web && platform == TargetPlatform.android && enabled;

  bool get isAndroidReleaseValidation => permitsAndroidRelease(
    release: kReleaseMode,
    web: kIsWeb,
    platform: defaultTargetPlatform,
    enabled: androidReleaseValidationEnabled,
  );

  bool get showsConnectionDiagnostics =>
      kDebugMode || isAndroidReleaseValidation;

  bool get androidReleaseByokAllowed => permitsAndroidRelease(
    release: kReleaseMode,
    web: kIsWeb,
    platform: defaultTargetPlatform,
    enabled: androidReleaseByokEnabled,
  );

  bool get releaseAllowed =>
      androidReleaseByokAllowed ||
      ReleaseAccess.current.permits(ReleaseService.deepSeekByok);

  bool get permitsDirectCalls =>
      (devTestAllowed || isAndroidReleaseValidation || releaseAllowed) &&
      hasSafeEndpoint &&
      DeepSeekModels.supported.contains(model);

  List<String> get restrictions => [
    if (kProfileMode) '性能分析构建未启用真实直连。',
    if (kReleaseMode &&
        !releaseAllowed &&
        !isAndroidReleaseValidation &&
        defaultTargetPlatform == TargetPlatform.android)
      'Android 正式版采用独立发布审核；当前发布配置未启用直连。',
    if (kReleaseMode &&
        !releaseAllowed &&
        defaultTargetPlatform == TargetPlatform.iOS)
      'iOS 发布接入待独立审核，包括原生 BYOK 适用范围及 App Store 分发。',
    if (kReleaseMode && !nativeMobile) '当前平台的正式版未启用直连。',
    if (kIsWeb || !nativeMobile) '直连开发测试仅支持 Android 和 iOS。',
    if (kDebugMode && !enableExperimental) 'DEEPSEEK_EXPERIMENTAL 未启用。',
    if (kDebugMode && !devRealApiTestEnabled) 'DEEPSEEK_REAL_API_DEV_TEST 未启用。',
    if (!hasSafeEndpoint) '服务地址不符合官方 HTTPS 端点要求。',
    if (!DeepSeekModels.supported.contains(model)) '当前模型不在支持列表中。',
  ];

  bool get hasSafeEndpoint {
    final uri = Uri.tryParse(baseUrl);
    return uri != null &&
        uri.scheme == 'https' &&
        uri.host == 'api.deepseek.com' &&
        uri.userInfo.isEmpty &&
        (!uri.hasPort || uri.port == 443) &&
        (uri.path.isEmpty || uri.path == '/') &&
        !uri.hasQuery &&
        !uri.hasFragment;
  }
}
