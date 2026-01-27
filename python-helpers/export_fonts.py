
import os
from PIL import Image, ImageDraw, ImageFont

FONT_PATH = "/Users/user/Downloads/digital_7/digital-7.ttf"
DISPLAY_SIZES = [208, 218, 240, 260, 280, 360, 390, 416, 454]

# Font size relative to display size
SMALL_SCALE = 0.15
BIG_SCALE   = 0.25

CHARACTERS = "0123456789:|."
SPACING = 1  # pixels between characters in the sheet

def render_sheet(px_size: int):
    """Render a sprite sheet where ALL characters share the same cell height and are vertically centered."""
    font = ImageFont.truetype(FONT_PATH, px_size)

    # Measure all characters
    meas_img = Image.new("L", (1, 1))
    meas = ImageDraw.Draw(meas_img)

    glyphs = []
    max_w = 1
    max_h = 1
    for ch in CHARACTERS:
        left, top, right, bottom = meas.textbbox((0, 0), ch, font=font)
        w = max(1, right - left)
        h = max(1, bottom - top)

        tight = Image.new("RGBA", (w, h), (0, 0, 0, 0))
        d = ImageDraw.Draw(tight)
        d.text((-left, -top), ch, font=font, fill=(255, 255, 255, 255))

        glyphs.append((ch, tight))
        max_w = max(max_w, w)
        max_h = max(max_h, h)

    cell_h = max_h
    # Build sheet width using framed widths (keep per-character width, only height is fixed)
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
            "y": 0,                 # top
            "width": g.width,
            "height": cell_h,
            "xoffset": 0,
            "yoffset": 0,           # drawn at the line's top
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

