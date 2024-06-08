class_name TitleScreen
extends Sprite2D

signal close_title_screen()


func _ready():
	get_tree().get_root().size_changed.connect(_on_resize)
	_on_resize()
	$"StageSelectMenu/StageSelectMenuOptions/Stage 1-1".call_deferred("grab_focus")


func _unhandled_input(_event):
	if not visible:
		return

	var c_id = InputUtil.get_just_released_id("start")
	if not c_id == InputUtil.ControllerID.NONE:
		InputUtil.player_map[c_id] = 1
		close_title_screen.emit()

	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()


func open_title_screen():
	show()
	$"StageSelectMenu/StageSelectMenuOptions/Stage 1-1".grab_focus()


func _on_resize():
	texture.width = get_viewport().size.x
	texture.height = get_viewport().size.y
	$Splash.position = get_viewport().size / 2
	
