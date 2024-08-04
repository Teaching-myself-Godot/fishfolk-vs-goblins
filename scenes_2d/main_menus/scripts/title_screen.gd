class_name TitleScreen
extends Sprite2D


signal select_stage(stage : PackedScene)
signal confirm_stage()


func _ready():
	get_tree().get_root().size_changed.connect(_on_resize)
	_on_resize()


func _unhandled_input(_event):
	if not visible:
		return
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()


func open_title_screen():
	InputUtil.player_map = {}
	show()
	$"StageSelectMenu/StageSelectMenuOptions/Tutorial".grab_focus()


func _on_resize():
	texture.width = get_viewport().size.x
	texture.height = get_viewport().size.y
	$Splash.position = get_viewport().size / 2


func _on_prev_button_up():
	var focused = get_viewport().gui_get_focus_owner()
	if is_instance_valid(focused) and focused is StageSelectOption:
		(focused as StageSelectOption).find_prev_valid_focus().grab_focus()


func _on_next_button_up():
	var focused = get_viewport().gui_get_focus_owner()
	if is_instance_valid(focused) and focused is StageSelectOption:
		(focused as StageSelectOption).find_next_valid_focus().grab_focus()


func _on_select_stage(my_stage: PackedScene) -> void:
	select_stage.emit(my_stage)


func _on_stage_confirmed() -> void:
	confirm_stage.emit()
