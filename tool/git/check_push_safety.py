#!/usr/bin/env python3
"""Pre-push safety scan for a private GitHub repository.

This does not prove the absence of all secrets; it blocks the common accidental
artefacts and obvious credential formats before `git push`.

Usage:
    python tool/git/check_push_safety.py
"""
from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]

FORBIDDEN_SUFFIXES = (
    ".jks",
    ".keystore",
    ".p12",
    ".pfx",
    ".p8",
    ".mobileprovision",
    ".ipa",
    ".xcarchive",
    ".yuzhe",
    ".sqlite",
    ".sqlite3",
    ".db",
    ".env",
)
FORBIDDEN_NAMES = {
    ".env",
    "key.properties",
    "AuthKey.p8",
    "id_rsa",
    "id_ed25519",
}
FORBIDDEN_PATHS = ("reports/", "dist/", "build/", ".dart_tool/", "ios/Pods/")

PATTERNS = [
    (re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----"), "private key block"),
    (re.compile(r"(?<![A-Za-z0-9])sk-[A-Za-z0-9_-]{24,}"), "DeepSeek/OpenAI-style key literal"),
    (re.compile(r"AKIA[0-9A-Z]{16}"), "AWS access key id"),
    (re.compile(r"gh[pousr]_[A-Za-z0-9_]{20,}"), "GitHub token"),
    (re.compile(r"xox[baprs]-[A-Za-z0-9-]{10,}"), "Slack token"),
    (re.compile(r"AIza[0-9A-Za-z_-]{30,}"), "Google API key"),
]
TEXT_SUFFIXES = (
    ".dart",
    ".swift",
    ".m",
    ".h",
    ".kt",
    ".java",
    ".yaml",
    ".yml",
    ".json",
    ".md",
    ".txt",
    ".ps1",
    ".sh",
    ".js",
    ".mjs",
    ".html",
    ".plist",
    ".entitlements",
    ".xml",
    ".gradle",
    ".kts",
    ".properties",
    ".xcconfig",
)
MAX_TEXT = 2 * 1024 * 1024


def tracked_files() -> list[str]:
    output = subprocess.check_output(
        ["git", "ls-files", "-z"], cwd=ROOT, text=False
    )
    return [item.decode("utf-8", "replace") for item in output.split(b"\0") if item]


def main() -> int:
    try:
        files = tracked_files()
    except Exception as error:  # pragma: no cover - git missing
        print(f"FAIL  cannot list tracked files: {error}")
        return 1

    errors: list[str] = []
    warnings: list[str] = []

    for name in files:
        lowered = name.lower()
        base = lowered.rsplit("/", 1)[-1]
        if base in FORBIDDEN_NAMES:
            errors.append(f"{name}: forbidden file name")
        if lowered.endswith(FORBIDDEN_SUFFIXES):
            errors.append(f"{name}: forbidden file type")
        if any(name.startswith(prefix) for prefix in FORBIDDEN_PATHS):
            errors.append(f"{name}: build/report artefact tracked")
        path = ROOT / name
        try:
            size = path.stat().st_size
        except OSError:
            continue
        if size > 20 * 1024 * 1024:
            errors.append(f"{name}: tracked file larger than 20 MiB ({size} bytes)")
        if size > MAX_TEXT or not lowered.endswith(TEXT_SUFFIXES):
            continue
        try:
            text = path.read_text(encoding="utf-8", errors="ignore")
        except OSError:
            continue
        for pattern, label in PATTERNS:
            match = pattern.search(text)
            if match:
                errors.append(
                    f"{name}:{text.count(chr(10), 0, match.start()) + 1}: {label}"
                )
        if re.search(r"C:\\Users\\[^\\\s]+", text) or re.search(r"/Users/[^/\s]+/", text):
            warnings.append(f"{name}: contains a developer-machine path")

    print(f"Tracked files: {len(files)}")
    for warning in sorted(set(warnings))[:20]:
        print(f"WARN  {warning}")
    if warnings:
        print(f"{len(set(warnings))} path warning(s); private repo acceptable, but avoid publishing.")
    if errors:
        print()
        for error in errors:
            print(f"FAIL  {error}")
        print(f"\n{len(errors)} blocker(s). Do not push until resolved.")
        return 1
    print("\nNo credential-like files or literal secrets found in tracked files.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
