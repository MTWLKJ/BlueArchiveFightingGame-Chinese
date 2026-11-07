extends SceneTree
## Checks that the subset Chinese fonts cover every character the translation table uses.
## Run: godot --headless --path . --script res://tools/check_glyphs.gd

func _init() -> void:
	var files := ["Regular", "Medium", "SemiBold", "Bold", "ExtraBold", "Black"]
	var data = JSON.parse_string(FileAccess.get_file_as_string("res://assets/locale/zh_cn.json"))
	var chars := {}
	for k in data.keys():
		for s in [String(k), String(data[k])]:
			for i in s.length():
				chars[s.unicode_at(i)] = true
	var total := 0
	for name in files:
		var path := "res://assets/fonts/NotoSansSC-%s.ttf" % name
		if not ResourceLoader.exists(path):
			print("MISSING FONT ", path)
			continue
		var font: Font = load(path)
		var lost := []
		for c in chars.keys():
			if not font.has_char(int(c)):
				lost.append(char(c))
		print("  %-10s chars=%d missing=%d %s" % [name, chars.size(), lost.size(), "" if lost.is_empty() else str(lost)])
		total += lost.size()
	print("TOTAL MISSING GLYPHS: ", total)
	quit(0 if total == 0 else 1)
