import 'package:flutter/foundation.dart';

enum ReleaseService { deepSeekByok, deepSeekPublicShare }

/// Records public distribution reviews for each service and platform.
/// A review can reference applicable published terms and supporting evidence.
/// Build defines and user settings cannot populate it.
class ReleaseAccess {
  const ReleaseAccess({
    this.androidByok,
    this.iosByok,
    this.androidPublicShare,
    this.iosPublicShare,
  });

  static const current = ReleaseAccess();
  final String? androidByok, iosByok, androidPublicShare, iosPublicShare;

  bool permits(ReleaseService service) => permitsBuild(
    service,
    release: kReleaseMode,
    web: kIsWeb,
    platform: defaultTargetPlatform,
  );

  bool permitsBuild(
    ReleaseService service, {
    required bool release,
    required bool web,
    required TargetPlatform platform,
  }) {
    if (!release || web) return false;
    final review = switch ((platform, service)) {
      (TargetPlatform.android, ReleaseService.deepSeekByok) => androidByok,
      (TargetPlatform.iOS, ReleaseService.deepSeekByok) => iosByok,
      (TargetPlatform.android, ReleaseService.deepSeekPublicShare) =>
        androidPublicShare,
      (TargetPlatform.iOS, ReleaseService.deepSeekPublicShare) =>
        iosPublicShare,
      _ => null,
    };
    return review?.trim().isNotEmpty == true;
  }
}
