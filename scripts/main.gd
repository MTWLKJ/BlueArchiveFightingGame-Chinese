extends Control
## Boot: creates the screen host + transition layer, hands them to Game and opens the title (the menu under a step file or a test).
## (The debug harness, scripts/core/dbg.gd, can start somewhere else with --screen=name.)

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_title_bar()
	var host := Control.new()
	host.name = "ScreenHost"
	host.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	host.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(host)
	var tr := preload("res://scripts/ui/transition.gd").new()
	tr.name = "Transition"
	add_child(tr)
	Game.host = host
	Game.transition = tr
	Game.start(Dbg.boot_screen(get_tree().current_scene == self))
	Dbg.ready_to_run.emit()

## The window title keeps the project's own name (so the export's executable name and user:// path are untouched) but shows
## the Chinese title while Chinese is on. Re-applied when the language changes from Options.
func _title_bar() -> void:
	if DisplayServer.get_name() == "headless":
		return
	get_window().title = Loc.t(WINDOW_TITLE)
	Loc.changed.connect(func(_code: String) -> void: get_window().title = Loc.t(WINDOW_TITLE))

const WINDOW_TITLE := "Blue Archive Fighting Game"
