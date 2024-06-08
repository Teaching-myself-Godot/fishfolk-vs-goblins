class_name TitleScreen
extends Sprite2D

signal close_title_screen()
signal select_next_stage()
signal select_previous_stage()

func _ready():
	get_tree().get_root().size_changed.connect(_on_resize)
	_on_resize()

func _unhandled_input(_event):
	if not visible:
		return
	InputUtil.player_map = {}

	var c_id = InputUtil.get_just_released_id("start")
	if not c_id == InputUtil.ControllerID.NONE:
		InputUtil.player_map[c_id] = 1
		close_title_screen.emit()

	if (
		InputUtil.is_just_released("quit") or
		Input.is_action_just_released("d")
	):
		select_next_stage.emit()

	if (
		Input.is_action_just_released("a") or
		Input.is_action_just_released("ui_focus_prev")
	):
		select_previous_stage.emit()

	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()


func _on_resize():
	texture.width = get_viewport().size.x
	texture.height = get_viewport().size.y
	$Splash.position = get_viewport().size / 2
	
