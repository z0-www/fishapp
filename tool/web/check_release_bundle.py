#!/usr/bin/env python3
"""Pre-release audit for the static Web bundle.

Checks a zip (or an extracted directory) for:
  * a deployable root (index.html, manifest, wasm runtime, PWA worker)
  * debug/source artefacts that must not be published
  * obvious secrets and developer-machine paths in text files
  * missing security headers

Exit code 0 = safe to upload. This is a static scan, not a substitute for a
browser/Safari acceptance test.
"""
from __future__ import annotations

import argparse
import re
import sys
import zipfile
from pathlib import Path

REQUIRED = [
    "index.html",
    "diagnostics.html",
    "manifest.json",
    "main.dart.js",
    "flutter_bootstrap.js",
    "service_worker.js",
    "sqlite3.wasm",
    "drift_worker.js",
    "_headers",
    "icons/Icon-192.png",
    "icons/Icon-512.png",
    "icons/Icon-180.png",
    "canvaskit/canvaskit.js",
    "canvaskit/canvaskit.wasm",
    "assets/FontManifest.json",
]

FORBIDDEN_SUFFIXES = (
    ".map",
    ".symbols",
    ".dart",
    ".env",
    ".pem",
    ".key",
    ".p12",
    ".pfx",
    ".jks",
    ".keystore",
    ".mobileprovision",
    ".ipa",
    ".yuzhe",
    ".sqlite",
    ".sqlite3",
    ".db",
)
FORBIDDEN_NAMES = {
    ".env",
    ".gitignore",
    ".last_build_id",
    "flutter_service_worker.js",
    "key.properties",
    "package.json",
}

TEXT_SUFFIXES = (".html", ".js", ".mjs", ".json", ".txt", ".css", ".xml")
TEXT_LIMIT = 12 * 1024 * 1024

SECRET_PATTERNS = [
    (re.compile(r"C:\\Users\\", re.I), "Windows user path"),
    (re.compile(r"C:/Users/", re.I), "Windows user path"),
    (re.compile(r"/Users/[^/\s]+/"), "macOS user path"),
    (re.compile(r"/home/runner/"), "CI path"),
    (re.compile(r"BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY"), "private key"),
    (re.compile(r"(?<![A-Za-z0-9])sk-[A-Za-z0-9_-]{20,}"), "API-key-like string"),
    (re.compile(r"Bearer\s+sk-"), "bearer key"),
    (re.compile(r"sourceMappingURL="), "source map reference"),
    (re.compile(r"localhost:\d{4,5}"), "developer localhost"),
    (re.compile(r"127\.0\.0\.1"), "developer loopback address"),
    (re.compile(r"api[_-]?key\s*=\s*['\"][A-Za-z0-9_-]{16,}"), "hard-coded key assignment"),
]


def check(ok: bool, message: str, errors: list[str]) -> None:
    print(f"{'PASS' if ok else 'FAIL'}  {message}")
    if not ok:
        errors.append(message)


def read_bytes(archive: zipfile.ZipFile | None, root: Path | None, name: str) -> bytes:
    if archive is not None:
        return archive.read(name)
    assert root is not None
    return (root / name).read_bytes()


def main() -> int:
    parser = argparse.ArgumentParser()
    source = parser.add_mutually_exclusive_group(required=True)
    source.add_argument("--zip")
    source.add_argument("--dir")
    args = parser.parse_args()

    errors: list[str] = []
    archive: zipfile.ZipFile | None = None
    root: Path | None = None
    if args.zip:
        archive = zipfile.ZipFile(args.zip)
        names = [n for n in archive.namelist() if not n.endswith("/")]
    else:
        root = Path(args.dir)
        names = [p.relative_to(root).as_posix() for p in root.rglob("*") if p.is_file()]

    print(f"Bundle: {args.zip or args.dir}")
    print(f"Files:  {len(names)}")

    if archive is not None:
        bad_entry_names = [
            info.orig_filename for info in archive.infolist()
            if "\\" in info.orig_filename
        ]
        check(not bad_entry_names, "ZIP entry names use forward slashes", errors)
        for item in bad_entry_names[:5]:
            print(f"      - {item!r}")

    check("index.html" in names, "index.html is at the archive root", errors)
    check(not any(n.startswith(("FishTextAdventure-", "web/", "build/")) for n in names),
          "no redundant top-level folder", errors)
    for required in REQUIRED:
        check(required in names, f"required: {required}", errors)

    bad = []
    for name in names:
        lower = name.lower()
        base = lower.rsplit("/", 1)[-1]
        if base in FORBIDDEN_NAMES:
            bad.append(f"{name} (forbidden name)")
        if base != "main.dart.js" and lower.endswith(FORBIDDEN_SUFFIXES):
            bad.append(f"{name} (forbidden suffix)")
        if any(part in name for part in ("../", "..\\")):
            bad.append(f"{name} (path traversal)")
    check(not bad, "no debug/source/secret file types", errors)
    for item in bad:
        print(f"      - {item}")

    # String scan of text assets (main.dart.js, bootstrap, HTML, manifest...).
    text_hits: list[str] = []
    for name in names:
        if not name.lower().endswith(TEXT_SUFFIXES):
            continue
        try:
            data = read_bytes(archive, root, name)
        except Exception as exc:  # pragma: no cover - corrupt zip
            text_hits.append(f"{name}: unreadable ({exc})")
            continue
        if len(data) > TEXT_LIMIT:
            continue
        text = data.decode("utf-8", "ignore")
        for pattern, label in SECRET_PATTERNS:
            match = pattern.search(text)
            if match:
                excerpt = text[max(0, match.start() - 40) : match.end() + 40]
                text_hits.append(f"{name}: {label}: {excerpt!r}"[:300])
    check(not text_hits, "no secrets or developer paths in text assets", errors)
    for item in text_hits[:10]:
        print(f"      - {item}")

    # PWA runtime sanity.
    if "service_worker.js" in names:
        sw = read_bytes(archive, root, "service_worker.js").decode("utf-8", "ignore")
        check("CACHE_VERSION" in sw, "service worker has a cache version", errors)
        check("sqlite3.wasm" in sw and "drift_worker.js" in sw,
              "service worker precaches the database runtime", errors)
        check("api.deepseek.com" not in sw, "service worker does not touch the AI API", errors)
    if "index.html" in names:
        html = read_bytes(archive, root, "index.html").decode("utf-8", "ignore")
        check("service_worker.js" in html, "index.html registers the service worker", errors)
        check("google-analytics" not in html.lower() and "googletagmanager" not in html.lower(),
              "no third-party analytics in index.html", errors)
        check("viewport-fit=cover" in html, "iPhone safe-area viewport metadata", errors)
    if "_headers" in names:
        headers = read_bytes(archive, root, "_headers").decode("utf-8", "ignore")
        check("X-Content-Type-Options: nosniff" in headers, "security header: nosniff", errors)
        check("Cache-Control:" in headers, "cache revalidation header present", errors)

    if archive is not None:
        total = sum(info.file_size for info in archive.infolist() if not info.is_dir())
    else:
        assert root is not None
        total = sum((root / n).stat().st_size for n in names)
    print(f"Total:  {total / (1024 * 1024):.1f} MiB")
    check(total < 40 * 1024 * 1024, "bundle is below 40 MiB", errors)
    check(len(names) < 120, "file count is reasonable", errors)

    print()
    if errors:
        print(f"{len(errors)} check(s) failed.")
        return 1
    print("All release-bundle checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
