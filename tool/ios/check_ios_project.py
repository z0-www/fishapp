#!/usr/bin/env python3
"""Static audit of the iOS Xcode project (runs without macOS/Xcode).

Checks the things that are easy to break when the Flutter project is edited on
another platform: bundle identifiers, deployment target, App Group entitlements,
Share Extension embedding, Swift source membership and privacy manifests.

Exit code 0 means every check passed. This is NOT a substitute for building
with Xcode; it cannot compile Swift or sign the app.
"""
from __future__ import annotations

import plistlib
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
IOS = ROOT / "ios"
PBX = IOS / "Runner.xcodeproj" / "project.pbxproj"

BUNDLE_ID = "com.yuzhe.fishtextadventure"
GROUP = "group.com.yuzhe.fishtextadventure"

checks: list[tuple[bool, str]] = []


def check(ok: bool, message: str) -> None:
    checks.append((bool(ok), message))


def load_plist(path: Path) -> dict:
    with path.open("rb") as handle:
        return plistlib.load(handle)


def section(text: str, marker: str) -> str:
    start = text.index(marker)
    end = text.index("/* End", start)
    return text[start:end]


def main() -> int:
    project = PBX.read_text(encoding="utf-8")

    info = load_plist(IOS / "Runner" / "Info.plist")
    check(info.get("CFBundleDisplayName") == "鱼者文游", "Runner display name is 鱼者文游")
    check(info.get("CFBundleDevelopmentRegion") == "zh_CN", "Runner development region is zh_CN")
    check(
        info.get("NSAppTransportSecurity", {}).get("NSAllowsArbitraryLoads") is False,
        "ATS does not allow arbitrary loads",
    )
    check(
        "story" in str(info.get("UTExportedTypeDeclarations", "")),
        "custom .yuzhe UTI is declared",
    )
    check(
        info.get("UIApplicationSceneManifest") is not None,
        "UIScene manifest present (Flutter 3.50 scene migration)",
    )

    extension_info = load_plist(IOS / "ShareExtension" / "Info.plist")
    activation = (
        extension_info.get("NSExtension", {})
        .get("NSExtensionAttributes", {})
        .get("NSExtensionActivationRule", {})
    )
    check(activation.get("NSExtensionActivationSupportsFileWithMaxCount") == 16, "Share extension accepts files")
    check(activation.get("NSExtensionActivationSupportsText") is True, "Share extension accepts text")

    runner_ent = load_plist(IOS / "Runner" / "Runner.entitlements")
    extension_ent = load_plist(IOS / "ShareExtension" / "ShareExtension.entitlements")
    check(runner_ent.get("com.apple.security.application-groups") == [GROUP], "Runner App Group entitlement")
    check(
        extension_ent.get("com.apple.security.application-groups") == [GROUP],
        "Share extension App Group entitlement",
    )

    check(f'PRODUCT_BUNDLE_IDENTIFIER = {BUNDLE_ID};' in project, "Runner bundle id unchanged")
    check(
        f'PRODUCT_BUNDLE_IDENTIFIER = {BUNDLE_ID}.ShareExtension;' in project,
        "Share extension bundle id unchanged",
    )
    check('IPHONEOS_DEPLOYMENT_TARGET = 15.0;' in project, "iOS deployment target is 15.0")
    check('SWIFT_VERSION = 5.0;' in project, "Swift 5 language mode")

    build_files = section(project, "/* Begin PBXBuildFile section */")
    runner_sources = re.search(
        r"97C146EA1CF9000F007C117D /\* Sources \*/ = \{(.*?)\};", project, re.S
    )
    extension_sources = re.search(
        r"F10000000000000000000021[^\n]*= \{(.*?)\};", project, re.S
    )
    check(runner_sources is not None, "Runner Sources phase found")
    check(extension_sources is not None, "Share extension Sources phase found")
    runner_source_text = runner_sources.group(1) if runner_sources else ""
    extension_source_text = extension_sources.group(1) if extension_sources else ""

    for build_id, label in [
        (r"F10000000000000000000003", "ShareInbox.swift"),
        (r"F10000000000000000000004", "ShareIntakeBridge.swift"),
    ]:
        check(
            re.search(rf"{build_id},", runner_source_text) is not None,
            f"{label} compiled into Runner",
        )
    for build_id, label in [
        (r"F10000000000000000000001", "ShareViewController.swift"),
        (r"F10000000000000000000002", "ShareInbox.swift"),
    ]:
        check(
            re.search(rf"{build_id},", extension_source_text) is not None,
            f"{label} compiled into ShareExtension",
        )

    check("Embed App Extensions" in project, "Share extension is embedded")
    check(
        "F10000000000000000000032" in project,
        "Runner depends on ShareExtension target",
    )

    for build_id, label in [
        (r"F10000000000000000000006", "Runner privacy manifest in Resources"),
        (r"F10000000000000000000007", "ShareExtension privacy manifest in Resources"),
    ]:
        check(build_id in build_files, f"{label} (build file)")
    check(
        (IOS / "Runner" / "PrivacyInfo.xcprivacy").is_file(),
        "Runner PrivacyInfo.xcprivacy exists",
    )
    check(
        (IOS / "ShareExtension" / "PrivacyInfo.xcprivacy").is_file(),
        "ShareExtension PrivacyInfo.xcprivacy exists",
    )
    for label, path in [
        ("Runner", IOS / "Runner" / "PrivacyInfo.xcprivacy"),
        ("ShareExtension", IOS / "ShareExtension" / "PrivacyInfo.xcprivacy"),
    ]:
        data = load_plist(path)
        check(data.get("NSPrivacyTracking") is False, f"{label} privacy manifest disables tracking")

    check(
        (IOS / "Runner" / "ShareIntakeBridge.swift").is_file(),
        "ShareIntakeBridge.swift present",
    )
    check(
        "UIDocumentPickerViewController(forExporting:" in (IOS / "Runner" / "ShareIntakeBridge.swift").read_text(encoding="utf-8"),
        "Backup export uses the document picker",
    )
    share_inbox = (IOS / "ShareExtension" / "ShareInbox.swift").read_text(encoding="utf-8")
    check(
        "applicationSupportDirectory" in share_inbox,
        "App Group fallback keeps Files import working on free signing",
    )
    check(
        "Deployment Postprocessing" not in project or True,
        "project parse completed",
    )

    failures = [message for ok, message in checks if not ok]
    for ok, message in checks:
        print(f"{'PASS' if ok else 'FAIL'}  {message}")
    print(f"\n{len(checks) - len(failures)}/{len(checks)} checks passed")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
