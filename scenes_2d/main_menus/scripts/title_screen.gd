class_name TitleScreen
extends Sprite2D

signal close_title_screen()
signal toggle_stage_select_test()

func _ready():
	get_tree().get_root().size_changed.connect(_on_resize)
	_on_resize()

func _unhandled_input(_event):
	var c_id = InputUtil.get_just_released_id("start")
	if not c_id == InputUtil.ControllerID.NONE:
		InputUtil.player_map[c_id] = 1
		close_title_screen.emit()

	if Input.is_action_just_released("ui_focus_next"):
		toggle_stage_select_test.emit()

	if InputUtil.is_just_released("quit"):
		toggle_stage_select_test.emit()



func _on_resize():
	texture.width = get_viewport().size.x
	texture.height = get_viewport().size.y
	$Splash.position = get_viewport().size / 2
	
