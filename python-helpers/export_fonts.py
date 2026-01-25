
import os
from PIL import Image, ImageDraw, ImageFont

# === CONFIG ===
FONT_PATH = "/Users/vanessacausemann/Downloads/digital_7/digital-7.ttf"  # change if needed
DISPLAY_SIZES = [208, 218, 240, 260, 280, 360, 390, 416, 454]

# Font size relative to display size
SMALL_SCALE = 0.15
BIG_SCALE   = 0.25

CHARACTERS = "0123456789:|."
SPACING = 1  # pixels between glyphs in the sheet

def render_sheet(px_size: int):
    """Render a sprite sheet where ALL glyphs share the same cell height and are vertically centered."""
    font = ImageFont.truetype(FONT_PATH, px_size)

    # Measure all glyphs precisely (handles negative bearings)
    meas_img = Image.new("L", (1, 1))
    meas = ImageDraw.Draw(meas_img)

    glyphs = []
    max_w = 1
    max_h = 1
    for ch in CHARACTERS:
        left, top, right, bottom = meas.textbbox((0, 0), ch, font=font)
        w = max(1, right - left)
        h = max(1, bottom - top)

        # draw tight glyph
        tight = Image.new("RGBA", (w, h), (0, 0, 0, 0))
        d = ImageDraw.Draw(tight)
        d.text((-left, -top), ch, font=font, fill=(255, 255, 255, 255))

        glyphs.append((ch, tight))
        max_w = max(max_w, w)
        max_h = max(max_h, h)

    # Cell/line height = same for all glyphs; center each glyph inside its cell
    cell_h = max_h
    # Build sheet width using framed widths (we keep per-glyph width, only height is fixed)
    total_w = sum(g.width + SPACING for _, g in glyphs)

    sheet = Image.new("RGBA", (total_w, cell_h), (0, 0, 0, 0))
    metadata = []
    x = 0
    for ch, g in glyphs:
        y = (cell_h - g.height) // 2  # center vertically
        sheet.paste(g, (x, y), g)

        metadata.append({
            "id": ord(ch),
            "x": x,
            "y": 0,                 # top of the glyph region in the sheet
            "width": g.width,
            "height": cell_h,       # IMPORTANT: full cell height (with transparent padding)
            "xoffset": 0,
            "yoffset": 0,           # drawn at the line's top (we control baseline via 'base' below)
            "xadvance": g.width + SPACING,
        })
        x += g.width + SPACING

    # BMFont metrics: baseline at midline so everything is visually centered
    line_height = cell_h
    base = cell_h // 2
    return sheet, line_height, base, metadata

def write_bmfont(out_dir: str, png_name: str, fnt_name: str, px_size: int, sheet, line_height: int, base: int, meta):
    os.makedirs(out_dir, exist_ok=True)
    png_path = os.path.join(out_dir, png_name)
    fnt_path = os.path.join(out_dir, fnt_name)

    sheet.save(png_path)

    font_name = os.path.splitext(os.path.basename(FONT_PATH))[0]
    with open(fnt_path, "w", encoding="utf-8") as f:
        f.write(f'info face="{font_name}" size={px_size} bold=0 italic=0 charset="" unicode=1 stretchH=100 smooth=1 aa=1 padding=1,1,1,1 spacing=1,1\n')
        f.write(f'common lineHeight={line_height} base={base} scaleW={sheet.width} scaleH={sheet.height} pages=1 packed=0\n')
        f.write(f'page id=0 file="{os.path.basename(png_path)}"\n')
        f.write(f'chars count={len(meta)}\n')
        for m in meta:
            f.write(
                f'char id={m["id"]} x={m["x"]} y={m["y"]} width={m["width"]} height={m["height"]} '
                f'xoffset={m["xoffset"]} yoffset={m["yoffset"]} xadvance={m["xadvance"]} page=0 chnl=0\n'
            )

if __name__ == "__main__":
    for disp in DISPLAY_SIZES:
        out_dir = f"resources-round-{disp}x{disp}"
        small_px = max(8, round(disp * SMALL_SCALE))
        big_px   = max(8, round(disp * BIG_SCALE))

        # small
        sheet, line_h, base, meta = render_sheet(small_px)
        write_bmfont(out_dir, "font_small.png", "font_small.fnt", small_px, sheet, line_h, base, meta)
        print(f"Wrote {out_dir}/font_small.png, font_small.fnt (size={small_px}px)")

        # big
        sheet, line_h, base, meta = render_sheet(big_px)
        write_bmfont(out_dir, "font_big.png", "font_big.fnt", big_px, sheet, line_h, base, meta)
        print(f"Wrote {out_dir}/font_big.png, font_big.fnt (size={big_px}px)")

    print("Done.")


"""
import os
from PIL import Image, ImageDraw, ImageFont

# === CONFIG ===
FONT_PATH = "/Users/vanessacausemann/Downloads/digital_7/digital-7.ttf"
DISPLAY_SIZES = [208, 218, 240, 260, 280, 360, 390, 416, 454]

# Font size as a fraction of display size (adjust to taste)
SMALL_SCALE = 0.15
BIG_SCALE   = 0.25

CHARACTERS = "0123456789:|"
SPACING = 1  # pixels between glyphs in the sheet
OUTPUT_NAMING = {
    "small": ("font_small.png", "font_small.fnt"),
    "big":   ("font_big.png",   "font_big.fnt"),
}
# ==============

font_name = os.path.splitext(os.path.basename(FONT_PATH))[0]

def render_sheet(px_size: int):
    "Render a single-line sprite sheet and BMFont-style metadata for CHARACTERS at px_size."
    font = ImageFont.truetype(FONT_PATH, px_size)

    bitmaps = []
    max_h = 0

    # Measure and render each glyph tightly using textbbox (handles negative bearings)
    meas_img = Image.new("L", (1, 1))
    meas = ImageDraw.Draw(meas_img)

    for ch in CHARACTERS:
        left, top, right, bottom = meas.textbbox((0, 0), ch, font=font)
        w = max(1, right - left)
        h = max(1, bottom - top)

        glyph = Image.new("RGBA", (w, h), (0, 0, 0, 0))
        dg = ImageDraw.Draw(glyph)
        # draw so that the glyph fits exactly into its bbox
        dg.text((-left, -top), ch, font=font, fill=(255, 255, 255, 255))

        bitmaps.append((ch, glyph))
        max_h = max(max_h, h)

    # Build the sprite sheet row
    total_w = sum(img.width + SPACING for _, img in bitmaps)
    sheet = Image.new("RGBA", (total_w, max_h), (0, 0, 0, 0))

    metadata = []
    x = 0
    for ch, img in bitmaps:
        y = (max_h - img.height) // 2  # vertically center
        sheet.paste(img, (x, y), img)
        metadata.append({
            "id": ord(ch),
            "x": x,
            "y": y,
            "width": img.width,
            "height": img.height,
            "xoffset": 0,
            "yoffset": 0,
            "xadvance": img.width + SPACING,
        })
        x += img.width + SPACING

    return sheet, max_h, metadata

def write_bmfont(out_dir: str, png_name: str, fnt_name: str, px_size: int, sheet, line_height: int, meta):
    os.makedirs(out_dir, exist_ok=True)
    png_path = os.path.join(out_dir, png_name)
    fnt_path = os.path.join(out_dir, fnt_name)

    sheet.save(png_path)

    with open(fnt_path, "w", encoding="utf-8") as f:
        f.write(f'info face="{font_name}" size={px_size} bold=0 italic=0 charset="" unicode=1 stretchH=100 smooth=1 aa=1 padding=1,1,1,1 spacing=1,1\n')
        f.write(f'common lineHeight={line_height} base={line_height} scaleW={sheet.width} scaleH={sheet.height} pages=1 packed=0\n')
        f.write(f'page id=0 file="{png_name}"\n')
        f.write(f'chars count={len(meta)}\n')
        for m in meta:
            f.write(
                f'char id={m["id"]} x={m["x"]} y={m["y"]} width={m["width"]} height={m["height"]} '
                f'xoffset={m["xoffset"]} yoffset={m["yoffset"]} xadvance={m["xadvance"]} page=0 chnl=0\n'
            )

if __name__ == "__main__":
    for disp in DISPLAY_SIZES:
        out_dir = f"resources-round-{disp}x{disp}"
        small_px = max(8, round(disp * SMALL_SCALE))
        big_px   = max(8, round(disp * BIG_SCALE))

        # small
        sheet, line_h, meta = render_sheet(small_px)
        png_name, fnt_name = OUTPUT_NAMING["small"]
        write_bmfont(out_dir, png_name, fnt_name, small_px, sheet, line_h, meta)
        print(f"Wrote {out_dir}/{png_name}, {fnt_name} (size={small_px}px)")

        # big
        sheet, line_h, meta = render_sheet(big_px)
        png_name, fnt_name = OUTPUT_NAMING["big"]
        write_bmfont(out_dir, png_name, fnt_name, big_px, sheet, line_h, meta)
        print(f"Wrote {out_dir}/{png_name}, {fnt_name} (size={big_px}px)")

    print("Done.")
"""