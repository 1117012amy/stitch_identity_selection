from pathlib import Path

from PIL import Image, ImageDraw, ImageEnhance, ImageFilter, ImageFont


ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "vlog_cover_work" / "source_thumbnail.jpg"
OUT = ROOT / "vlog_cover_work" / "vlog_cover_myacg.jpg"
FONT_BOLD = Path("C:/Windows/Fonts/NotoSansTC-VF.ttf")


def font(size):
    return ImageFont.truetype(str(FONT_BOLD), size=size)


def draw_text_with_shadow(draw, xy, text, fnt, fill, stroke_width=8, stroke_fill=(25, 25, 25)):
    x, y = xy
    draw.text((x + 5, y + 7), text, font=fnt, fill=(0, 0, 0, 150), stroke_width=stroke_width, stroke_fill=(0, 0, 0, 150))
    draw.text((x, y), text, font=fnt, fill=fill, stroke_width=stroke_width, stroke_fill=stroke_fill)


def fit_font(text, max_width, start_size, min_size=24):
    size = start_size
    while size >= min_size:
        fnt = font(size)
        box = ImageDraw.Draw(Image.new("RGBA", (10, 10))).textbbox((0, 0), text, font=fnt, stroke_width=10)
        if box[2] - box[0] <= max_width:
            return fnt
        size -= 2
    return font(min_size)


def main():
    img = Image.open(SRC).convert("RGB")

    # Crop to thumbnail-friendly 16:9 while keeping the person and the autograph wall.
    crop = img.crop((0, 115, 1600, 1015)).resize((1280, 720), Image.LANCZOS)
    crop = ImageEnhance.Color(crop).enhance(1.24)
    crop = ImageEnhance.Contrast(crop).enhance(1.18)
    crop = ImageEnhance.Sharpness(crop).enhance(1.35)

    canvas = crop.convert("RGBA")
    draw = ImageDraw.Draw(canvas)

    # Subtle focus treatment: darken the text area and add a warm highlight near the subject.
    overlay = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    od = ImageDraw.Draw(overlay)
    for x in range(1280):
        alpha = int(max(0, (x - 540) / 740) * 115)
        od.line([(x, 0), (x, 720)], fill=(0, 0, 0, alpha))
    for y in range(720):
        alpha = int(max(0, (y - 440) / 280) * 85)
        od.line([(0, y), (1280, y)], fill=(0, 0, 0, alpha))
    od.ellipse((220, 230, 620, 670), fill=(255, 221, 71, 28))
    overlay = overlay.filter(ImageFilter.GaussianBlur(18))
    canvas = Image.alpha_composite(canvas, overlay)
    draw = ImageDraw.Draw(canvas)

    # White/yellow sticker outline around the subject area, common in vlog covers.
    draw.rounded_rectangle((277, 228, 560, 668), radius=28, outline=(255, 255, 255, 220), width=7)
    draw.rounded_rectangle((287, 238, 550, 658), radius=24, outline=(255, 205, 52, 210), width=4)

    # Top tag.
    draw.rounded_rectangle((42, 36, 222, 104), radius=14, fill=(255, 46, 77, 245))
    draw.polygon([(65, 57), (65, 83), (89, 70)], fill=(255, 255, 255, 255))
    draw.text((102, 47), "VLOG", font=font(36), fill=(255, 255, 255, 255))
    draw.rounded_rectangle((238, 40, 460, 102), radius=12, fill=(255, 207, 42, 245))
    draw.text((265, 50), "MyACG 探店", font=font(30), fill=(20, 34, 55, 255))

    # Main headline.
    big1 = fit_font("動漫店", 455, 114)
    big2 = fit_font("太好逛!", 505, 106)
    draw_text_with_shadow(draw, (726, 210), "動漫店", big1, (255, 230, 58, 255), stroke_width=10)
    draw_text_with_shadow(draw, (707, 340), "太好逛!", big2, (255, 255, 255, 255), stroke_width=10)

    # Accent burst and side label.
    draw.rounded_rectangle((740, 514, 1168, 596), radius=18, fill=(0, 150, 255, 238), outline=(255, 255, 255, 255), width=5)
    draw.text((770, 528), "滿牆簽名直接朝聖", font=font(38), fill=(255, 255, 255, 255))

    # Arrow toward the autograph wall.
    draw.line((935, 176, 1035, 116), fill=(255, 57, 80, 255), width=12)
    draw.polygon([(1035, 116), (1002, 113), (1020, 144)], fill=(255, 57, 80, 255))
    draw.line((935, 176, 1035, 116), fill=(255, 255, 255, 230), width=4)

    # Frame border.
    draw.rectangle((8, 8, 1272, 712), outline=(255, 255, 255, 230), width=8)
    draw.rectangle((18, 18, 1262, 702), outline=(255, 207, 42, 230), width=4)

    canvas.convert("RGB").save(OUT, quality=94, subsampling=0)
    print(OUT)


if __name__ == "__main__":
    main()
