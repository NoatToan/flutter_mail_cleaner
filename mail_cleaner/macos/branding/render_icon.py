#!/usr/bin/env python3
"""Render the AI Smart Mail macOS app icon.

Draws the design described in app_icon.svg at 4x supersampling, then produces
every size referenced from Assets.xcassets/AppIcon.appiconset/Contents.json.

Run from repo root:
    python3 macos/branding/render_icon.py

Requires: Pillow (`pip3 install Pillow`).
"""
from __future__ import annotations

import os
from pathlib import Path

from PIL import Image, ImageDraw

HERE = Path(__file__).resolve().parent
APP_ROOT = HERE.parent.parent
APPICON_DIR = APP_ROOT / "macos" / "Runner" / "Assets.xcassets" / "AppIcon.appiconset"
MASTER_PATH = HERE / "app_icon_1024.png"

CANVAS = 1024
SUPER = 4  # supersampling factor
S = CANVAS * SUPER

# --- design tokens -------------------------------------------------------
ACCENT = (0x0A, 0x66, 0xD6)      # #0A66D6
TEAL = (0x0B, 0x7A, 0x8C)        # #0B7A8C
GREEN = (0x15, 0x7A, 0x41)       # #157A41
WHITE = (0xFF, 0xFF, 0xFF)
FLAP_DARK = (0x06, 0x3B, 0x7A)   # #063B7A

# tile: 100-924 (824x824), radius 184 — Big Sur safe inset at 1024 canvas
TILE_INSET = 100
TILE_RADIUS = 184

# envelope body
ENV_LEFT, ENV_TOP = 272, 380
ENV_RIGHT, ENV_BOTTOM = 752, 720
ENV_RADIUS = 32
FLAP_CENTER = (512, 620)

# badge
BADGE_CENTER = (740, 740)
BADGE_RADIUS = 112


def _scale(xy):
    """Scale a coord/sequence to the supersampled canvas."""
    if isinstance(xy, (int, float)):
        return xy * SUPER
    return tuple(v * SUPER for v in xy)


def diagonal_gradient(size: int, c0: tuple[int, int, int], c1: tuple[int, int, int]) -> Image.Image:
    """Top-left → bottom-right linear gradient."""
    grad = Image.new("RGB", (size, size), c0)
    px = grad.load()
    diag = (size - 1) + (size - 1)
    for y in range(size):
        for x in range(size):
            t = (x + y) / diag
            r = round(c0[0] + (c1[0] - c0[0]) * t)
            g = round(c0[1] + (c1[1] - c0[1]) * t)
            b = round(c0[2] + (c1[2] - c0[2]) * t)
            px[x, y] = (r, g, b)
    return grad


def top_highlight(size: int) -> Image.Image:
    """Soft top-to-bottom white highlight for the tile."""
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    px = img.load()
    # highlight spans y ∈ [100*SUPER, 600*SUPER] in design coords
    y0, y1 = int(100 * SUPER), int(600 * SUPER)
    max_a = int(0.18 * 255)
    for y in range(y0, y1):
        t = 1.0 - (y - y0) / (y1 - y0)
        a = int(max_a * t)
        if a <= 0:
            continue
        for x in range(size):
            px[x, y] = (255, 255, 255, a)
    return img


def render_master() -> Image.Image:
    big = Image.new("RGBA", (S, S), (0, 0, 0, 0))

    # tile mask
    tile_mask = Image.new("L", (S, S), 0)
    md = ImageDraw.Draw(tile_mask)
    md.rounded_rectangle(
        [_scale(TILE_INSET), _scale(TILE_INSET),
         _scale(CANVAS - TILE_INSET) - 1, _scale(CANVAS - TILE_INSET) - 1],
        radius=_scale(TILE_RADIUS), fill=255,
    )

    # tile gradient
    grad = diagonal_gradient(S, ACCENT, TEAL).convert("RGBA")
    big.paste(grad, (0, 0), tile_mask)

    # top highlight — only inside tile
    hl = top_highlight(S)
    hl.putalpha(Image.eval(hl.split()[3], lambda v: v))  # keep alpha
    big = Image.alpha_composite(big, Image.composite(hl, Image.new("RGBA", (S, S)), tile_mask))

    # envelope body (white rounded rect)
    env_layer = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    ed = ImageDraw.Draw(env_layer)
    ed.rounded_rectangle(
        [_scale(ENV_LEFT), _scale(ENV_TOP), _scale(ENV_RIGHT), _scale(ENV_BOTTOM)],
        radius=_scale(ENV_RADIUS), fill=WHITE,
    )
    big = Image.alpha_composite(big, env_layer)

    # flap triangle — semi-dark overlay for the fold
    flap_layer = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    fd = ImageDraw.Draw(flap_layer)
    tri = [
        _scale((ENV_LEFT, ENV_TOP)),
        _scale(FLAP_CENTER),
        _scale((ENV_RIGHT, ENV_TOP)),
    ]
    fd.polygon(tri, fill=(*FLAP_DARK, int(0.22 * 255)))
    # fold lines (V) in accent blue
    fd.line(
        [_scale((ENV_LEFT, ENV_TOP)), _scale(FLAP_CENTER)],
        fill=(*ACCENT, int(0.70 * 255)), width=_scale(10),
    )
    fd.line(
        [_scale(FLAP_CENTER), _scale((ENV_RIGHT, ENV_TOP))],
        fill=(*ACCENT, int(0.70 * 255)), width=_scale(10),
    )
    big = Image.alpha_composite(big, flap_layer)

    # badge
    badge_layer = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    bd = ImageDraw.Draw(badge_layer)
    cx, cy = _scale(BADGE_CENTER)
    r = _scale(BADGE_RADIUS)
    bd.ellipse([cx - r, cy - r, cx + r, cy + r], fill=GREEN)
    # thin white ring
    bd.ellipse([cx - r, cy - r, cx + r, cy + r], outline=WHITE, width=_scale(8))
    # check mark
    bd.line(
        [_scale((686, 742)), _scale((724, 782)), _scale((798, 702))],
        fill=WHITE, width=_scale(26), joint="curve",
    )
    big = Image.alpha_composite(big, badge_layer)

    # downsample 4x → 1024
    return big.resize((CANVAS, CANVAS), Image.LANCZOS)


def main() -> None:
    APPICON_DIR.mkdir(parents=True, exist_ok=True)
    master = render_master()
    master.save(MASTER_PATH, format="PNG", optimize=True)
    print(f"wrote {MASTER_PATH}")

    for size in (16, 32, 64, 128, 256, 512, 1024):
        out = APPICON_DIR / f"app_icon_{size}.png"
        if size == CANVAS:
            img = master
        else:
            img = master.resize((size, size), Image.LANCZOS)
        img.save(out, format="PNG", optimize=True)
        print(f"wrote {out} ({size}×{size})")


if __name__ == "__main__":
    main()
