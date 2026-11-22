#!/usr/bin/env python3
"""Generate the PWA / Apple touch icons from the project logo.

Usage (Pillow required):
    python tool/generate_web_icons.py
"""
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "assets" / "branding" / "fish_logo.png"
OUT = ROOT / "web" / "icons"


def main() -> None:
    logo = Image.open(SOURCE).convert("RGB")
    OUT.mkdir(parents=True, exist_ok=True)

    for size in (192, 512):
        logo.resize((size, size), Image.LANCZOS).save(
            OUT / f"Icon-{size}.png", optimize=True
        )
    logo.resize((180, 180), Image.LANCZOS).save(
        OUT / "Icon-180.png", optimize=True
    )

    # Maskable icons need a safe zone: keep the logo inside the inner 80% on a
    # plain white field so Android/iOS masks never crop the fish.
    for size in (192, 512):
        canvas = Image.new("RGB", (size, size), "white")
        inner = int(size * 0.78)
        canvas.paste(
            logo.resize((inner, inner), Image.LANCZOS),
            ((size - inner) // 2, (size - inner) // 2),
        )
        canvas.save(OUT / f"Icon-maskable-{size}.png", optimize=True)

    logo.resize((64, 64), Image.LANCZOS).save(ROOT / "web" / "favicon.png")
    print(f"Wrote PWA icons to {OUT}")


if __name__ == "__main__":
    main()
