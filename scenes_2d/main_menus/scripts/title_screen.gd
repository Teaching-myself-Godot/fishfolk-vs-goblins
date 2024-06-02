class_name TitleScreen
extends Sprite2D

signal close_title_screen()

func _ready():
	get_tree().get_root().size_changed.connect(_on_resize)
	_on_resize()

func _unhandled_input(_event):
	var c_id = InputUtil.get_just_released_id("start")
	if not c_id == InputUtil.ControllerID.NONE:
		print("Start button caught for controller id: " + str(c_id))
		close_title_screen.emit()

func _on_resize():
	position = get_viewport().size / 2
