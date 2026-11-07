extends Node
## Localisation: the English source strings stay where they are in the scripts, and the Simplified
## Chinese text lives in assets/locale/zh_cn.json as an English -> Chinese table. Loc.t() looks a
## string up and returns it unchanged when the table has no entry, so a missing line can never
## leave a blank label on screen.
##
## Autoload "Loc". Loc.t() is called from the shared text helpers (BaMenu.label / text_width,
## UI.label, HudKit.text, GalleryKit.draw_name, ...), so a screen that draws through those helpers
## is translated without touching every call site. Strings that reach draw_string() directly are
## wrapped by hand at their call site.
##
## The table is a plain JSON file so it can be edited and diffed outside the engine. Keys are the
## English strings exactly as they appear in the code; values are the Chinese text.

signal changed(lang: String)

const DIR := "res://assets/locale/"
const DEFAULT := "zh_cn"
## code -> name shown in Options. The first entry is the one a fresh install starts on.
const LANGS := [["zh_cn", "简体中文"], ["en", "English"]]

var lang := ""

var _table := {}
var _index := {}      # upper-cased key -> key, for lookups of .to_upper()'d text
var _missing := {}    # English strings asked for and not found: the coverage report walks this
var _dump_path := ""  # --dump-missing=<path>: write the missing strings here on exit (see tools/)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--dump-missing="):
			_dump_path = a.substr(15)
	# Game is the autoload before this one, and its Session (which read settings.cfg) already exists, so the saved
	# language is known before the first screen is built. A fresh install has no saved value and starts on Chinese.
	var lang_code := DEFAULT
	var g := get_node_or_null("/root/Game")
	if g != null:
		var s = g.get("session")
		if s != null:
			var saved = s.get("language")
			if saved is String and (saved in codes()):
				lang_code = saved
	set_lang(lang_code)

## All language codes, in menu order.
static func codes() -> Array:
	var out := []
	for l in LANGS:
		out.append(l[0])
	return out

static func label_of(code: String) -> String:
	for l in LANGS:
		if l[0] == code:
			return l[1]
	return code

func set_lang(code: String) -> void:
	if not (code in codes()):
		code = DEFAULT
	lang = code
	_table.clear()
	_index.clear()
	if code != "en":
		_load(code)
	changed.emit(code)

func _load(code: String) -> void:
	var path := DIR + code + ".json"
	if not FileAccess.file_exists(path):
		push_warning("Loc: no table at " + path)
		return
	var data = JSON.parse_string(FileAccess.get_file_as_string(path))
	if data is not Dictionary:
		push_warning("Loc: " + path + " is not a JSON object")
		return
	_table = data
	for k in data.keys():
		var kk := String(k)
		var up := kk.to_upper()
		# Only unambiguous upper-cased keys are indexed: two keys that differ only in case would
		# make .to_upper() lookups a guess.
		if _index.has(up):
			_index[up] = ""
		else:
			_index[up] = kk

## The translation of s, or s itself when the table has no entry (or English is selected).
func t(s: String) -> String:
	if s == "" or lang == "en" or _table.is_empty():
		return s
	if _table.has(s):
		return String(_table[s])
	var up := s.to_upper()
	var key = _index.get(up, "")
	if key != "" and _table.has(key):
		return String(_table[key])
	# Only Latin text is asked for: a string that already holds Chinese came out of the table (it is being drawn or
	# measured a second time) and is not a gap in the coverage.
	if not _has_cjk(s) and _missing.size() < 4000:
		_missing[s] = true
	return s

## True when the string has a CJK character, the same test the gallery's line wrapper uses.
static func _has_cjk(s: String) -> bool:
	for i in s.length():
		var c := s.unicode_at(i)
		if (c >= 0x2E80 and c <= 0x9FFF) or (c >= 0xF900 and c <= 0xFAFF) or (c >= 0xFF00 and c <= 0xFFEF):
			return true
	return false

## Same as t(), for text that is joined from pieces: Loc.t("DUMMY ") + name.
func tf(s: String) -> String:
	return t(s)

## The English strings that had no entry, sorted. Printed by the coverage report.
func missing() -> Array:
	var out := _missing.keys()
	out.sort()
	return out

func clear_missing() -> void:
	_missing.clear()

## True when Chinese is on, for the few places that swap a baked picture rather than text.
func zh() -> bool:
	return lang == "zh_cn"

## Writes the untranslated strings seen this run to `path`, one per line. Used by the coverage pass:
## a capture run walks the screens, then tools/loc_coverage.py diffs this against the table.
func dump_missing(path: String) -> void:
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		push_warning("Loc: cannot write " + path)
		return
	for s in missing():
		f.store_line(s)
	f.close()

func _exit_tree() -> void:
	if _dump_path != "":
		dump_missing(_dump_path)
