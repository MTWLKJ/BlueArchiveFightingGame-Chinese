class_name BaWords
extends RefCounted
## BA's image-font words, and our baked stand-ins for the ones BA has no lettering for.
## BA's own: fight, start, win, lose, vs, warning, block, block_resist, miss, immune, combo, best_record.
## Ours (tools/hud_words.py, Chakra Petch, 2x size): round_1 to round_9, final, ko, super, ex_ready, just_guard, guard_crush.
## index.json "words" says which is which; BaArt.data()["words"].keys() lists them all.
##
## Localisation: every word is a picture, so the Chinese set is a second folder of pictures, assets/ba/hud/words_zh/<word>.png,
## baked at the size and shape of the English one (tools/make_zh_words.py). tex() returns those while Chinese is on and falls
## back to the original art for a word the Chinese set does not have (vs and ko stay Latin on purpose).

const ZH_DIR := "res://assets/ba/hud/words_zh/"

static var _zh := {}

## The Chinese picture for `word`, or null when this build has none.
static func tex_zh(word: String) -> Texture2D:
	if _zh.has(word):
		return _zh[word]
	var t: Texture2D = null
	var path := ZH_DIR + word + ".png"
	if ResourceLoader.exists(path):
		t = load(path)
	_zh[word] = t
	return t

static func tex(word: String) -> Texture2D:
	if Loc.zh():
		var zh := tex_zh(word)
		if zh != null:
			return zh
	var w: Dictionary = BaArt.data().get("words", {}).get(word, {})
	if w.is_empty():
		BaArt.warn("word" + word, "unknown word " + word)
		return null
	if w["kind"] == "ba":
		return BaArt.tex(str(w["texture"]))
	return BaArt.file(str(w["file"]))

## The word centred on centre, width px wide, its own aspect.
static func draw(ci: CanvasItem, word: String, centre: Vector2, width: float, tint := Color.WHITE) -> void:
	var t := tex(word)
	if t == null:
		return
	var size := Vector2(width, width * float(t.get_height()) / float(t.get_width()))
	ci.draw_texture_rect(t, Rect2(centre - size * 0.5, size), false, tint)
