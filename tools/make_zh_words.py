"""Bake the Chinese replacements for the HUD image-font words.

The game's big HUD words (FIGHT, WIN, ROUND 1, JUST GUARD ...) are pictures, not text: BaWords reads
assets/ba/hud/index.json and draws the picture. Chinese needs its own pictures, so this tool writes
assets/ba/hud/words_zh/<word>.png at the same pixel size as the English original (so every existing
layout, which sizes the picture by its aspect, keeps working untouched) and BaWords prefers them
while Chinese is on.

Run from the project root:
    python tools/make_zh_words.py [--font assets/fonts/NotoSansSC-Black.ttf]

The words are white with alpha, like the originals: callers tint them, so colour never bakes in.
vs and ko keep the Latin art on purpose (they read as symbols in the Chinese release too).
"""
import argparse
import io
import json
import os

from PIL import Image, ImageDraw, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
HUD = os.path.join(ROOT, "assets", "ba", "hud")
OUT = os.path.join(HUD, "words_zh")

# word -> Chinese. A word missing here keeps the English picture.
WORDS = {
    "fight": "战斗",
    "start": "开始",
    "win": "胜利",
    "lose": "败北",
    "warning": "警告",
    "block": "格挡",
    "block_resist": "抵抗",
    "miss": "未命中",
    "immune": "免疫",
    "combo": "连击",
    "best_record": "最佳记录",
    "final": "最终回合",
    "super": "必杀",
    "ex_ready": "EX就绪",
    "just_guard": "完美防御",
    "guard_crush": "破防",
    "training": "训练",
    "draw": "平局",
    "time_up": "时间到",
}
for _n in range(1, 10):
    WORDS["round_%d" % _n] = "第%d回合" % _n

# The house slant: BA leans its word art a few degrees, the same "/" the plates use.
SHEAR = 0.12
# The word art is white on transparent, drawn a touch heavy so an outline tint still reads.
STROKE_RATIO = 0.055


def word_size(entry, data):
    """The English picture's pixel size: index.json for BA's own art, the PNG itself for the baked ones."""
    if entry.get("kind") == "ba":
        name = entry["texture"]
        for key in ("sprites", "tex"):
            e = data.get(key, {}).get(name)
            if e:
                return int(e["w"]), int(e["h"])
        raise SystemExit("index.json has no entry for " + name)
    path = os.path.join(HUD, entry["file"])
    with Image.open(path) as im:
        return im.width, im.height


def render(text, width, height, font_path):
    # Draw at 4x and downsample: the game scales these up a lot and hard edges would show.
    ss = 4
    W, H = width * ss, height * ss
    img = Image.new("RGBA", (W, H), (255, 255, 255, 0))
    draw = ImageDraw.Draw(img)
    # the biggest size whose advance fits the box with a shear margin
    margin = int(W * (1.0 - 0.14))
    lo, hi = 8, H * 2
    best = lo
    while lo <= hi:
        mid = (lo + hi) // 2
        f = ImageFont.truetype(font_path, mid)
        tw = draw.textlength(text, font=f)
        if tw <= margin and mid <= H * 0.96:
            best = mid
            lo = mid + 1
        else:
            hi = mid - 1
    f = ImageFont.truetype(font_path, best)
    tw = draw.textlength(text, font=f)
    stroke = max(1, int(best * STROKE_RATIO))
    x = (W - tw) / 2.0
    y = (H - best) / 2.0 - best * 0.12
    draw.text((x, y), text, font=f, fill=(255, 255, 255, 255), stroke_width=stroke, stroke_fill=(255, 255, 255, 255))
    # lean it like the plates: shear about the middle
    img = img.transform((W, H), Image.AFFINE, (1, SHEAR, -SHEAR * H * 0.5, 0, 1, 0), resample=Image.BICUBIC)
    return img.resize((width, height), Image.LANCZOS)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--font", default=os.path.join(ROOT, "assets", "fonts", "NotoSansSC-Black.ttf"))
    ap.add_argument("--dir", default=HUD)
    ap.add_argument("--out", default=OUT)
    args = ap.parse_args()

    data = json.load(io.open(os.path.join(args.dir, "index.json"), encoding="utf-8"))
    os.makedirs(args.out, exist_ok=True)
    made = 0
    for word, text in sorted(WORDS.items()):
        entry = data["words"].get(word)
        if not entry:
            print("  skip %-12s (not in index.json)" % word)
            continue
        w, h = word_size(entry, data)
        img = render(text, w, h, args.font)
        img.save(os.path.join(args.out, word + ".png"))
        made += 1
        print("  %-12s %-6s %4dx%-4d" % (word, text, w, h))
    print("wrote %d pictures to %s" % (made, args.out))


if __name__ == "__main__":
    main()
