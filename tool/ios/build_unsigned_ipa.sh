#!/usr/bin/env bash
# Build an unsigned iOS IPA for personal signing (Sideloadly / SideStore).
#
# Must run on macOS with Xcode and Flutter 3.50+. The resulting .ipa is NOT
# installable until it is signed with a certificate/provisioning profile.
#
# Usage:
#   bash tool/ios/build_unsigned_ipa.sh
#
# Environment:
#   FISH_VERSION   optional override for the artifact name
#   FLUTTER_BIN    optional path to the flutter executable
set -euo pipefail

cd "$(dirname "$0")/../.."
FLUTTER_BIN="${FLUTTER_BIN:-flutter}"
VERSION="${FISH_VERSION:-$(sed -n 's/^version: \([0-9.]*\).*/\1/p' pubspec.yaml | head -n1)}"
VERSION="${VERSION:-0.5.8}"

echo "== Flutter / Xcode =="
"$FLUTTER_BIN" --version
xcodebuild -version

# This project keeps the Swift Package Manager integration (ios/Flutter/
# ephemeral/Packages). Enable it explicitly so a fresh macOS checkout produces
# the same build as the committed Xcode project.
"$FLUTTER_BIN" config --enable-swift-package-manager

echo "== Dependencies =="
"$FLUTTER_BIN" pub get

echo "== Static iOS project audit =="
if command -v python3 >/dev/null 2>&1; then
  python3 tool/ios/check_ios_project.py
fi

echo "== Build (no codesign) =="
# FISH_IOS_BYOK enables the real DeepSeek transport for a personally signed
# build. App Store/TestFlight builds must go through the separate review
# workflow instead.
"$FLUTTER_BIN" build ios \
  --release \
  --no-codesign \
  --dart-define=FISH_IOS_BYOK=true

APP="build/ios/iphoneos/Runner.app"
if [[ ! -d "$APP" ]]; then
  echo "Build finished without $APP" >&2
  exit 1
fi

# --- Validate the produced app before packaging a misleading IPA ----------
BUILD_NUMBER="${FISH_BUILD_NUMBER:-$(sed -n 's/^version: [0-9.]*+\([0-9]*\).*/\1/p' pubspec.yaml | head -n1)}"
BUILD_NUMBER="${BUILD_NUMBER:-34}"
INFO="$APP/Info.plist"
BUNDLE_ID=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$INFO")
SHORT_VERSION=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$INFO")
APP_BUILD=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleVersion' "$INFO")
[[ "$BUNDLE_ID" == "com.yuzhe.fishtextadventure" ]] || {
  echo "Unexpected bundle id: $BUNDLE_ID" >&2; exit 1;
}
[[ "$SHORT_VERSION" == "$VERSION" ]] || {
  echo "Unexpected version: $SHORT_VERSION (expected $VERSION)" >&2; exit 1;
}
[[ "$APP_BUILD" == "$BUILD_NUMBER" ]] || {
  echo "Unexpected build number: $APP_BUILD (expected $BUILD_NUMBER)" >&2; exit 1;
}
[[ -f "$APP/Runner" ]] || { echo "Runner binary missing" >&2; exit 1; }
[[ -f "$APP/Frameworks/App.framework/App" ]] || {
  echo "Flutter App.framework missing" >&2; exit 1;
}
[[ -f "$APP/PrivacyInfo.xcprivacy" ]] || {
  echo "Runner PrivacyInfo.xcprivacy missing" >&2; exit 1;
}
EXT_INFO="$APP/PlugIns/ShareExtension.appex/Info.plist"
[[ -f "$EXT_INFO" ]] || { echo "ShareExtension.appex missing" >&2; exit 1; }
[[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$EXT_INFO")" == \
  "com.yuzhe.fishtextadventure.ShareExtension" ]] || {
  echo "Unexpected ShareExtension bundle id" >&2; exit 1;
}
[[ -f "$APP/PlugIns/ShareExtension.appex/PrivacyInfo.xcprivacy" ]] || {
  echo "ShareExtension PrivacyInfo.xcprivacy missing" >&2; exit 1;
}
echo "App: $BUNDLE_ID $SHORT_VERSION ($APP_BUILD), extension embedded, privacy manifests present"
file "$APP/Runner" || true
lipo -info "$APP/Runner" || true
du -sh "$APP"

OUT="dist/ios"
rm -rf "$OUT/Payload"
mkdir -p "$OUT/Payload"
# ditto preserves symlinks, permissions and extended attributes needed by
# Frameworks/*.framework inside an .app bundle.
ditto "$APP" "$OUT/Payload/Runner.app"

IPA="$OUT/FishTextAdventure-${VERSION}-unsigned.ipa"
rm -f "$IPA"
(
  cd "$OUT"
  zip -qry "$(basename "$IPA")" Payload
)

# Verify the archive actually contains the installable app layout.
for entry in \
  "Payload/Runner.app/Info.plist" \
  "Payload/Runner.app/Runner" \
  "Payload/Runner.app/Frameworks/App.framework/App" \
  "Payload/Runner.app/PlugIns/ShareExtension.appex/Info.plist"; do
  unzip -l "$IPA" | grep -Fq "$entry" || {
    echo "IPA missing $entry" >&2; exit 1;
  }
done

echo "== Artifact =="
ls -lh "$IPA"
unzip -l "$IPA" | head -n 12
echo
echo "Unsigned IPA ready: $IPA"
echo "It still needs a signature (see docs/cross-platform/IOS_BUILD_AND_SIDELOAD.md)."
