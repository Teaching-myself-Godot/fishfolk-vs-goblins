extends Control

func _unhandled_input(_event):

	if Input.is_action_just_released("start-k"):
		_close_pause_menu()
	if Input.is_action_just_released("cancel-0"):
		_close_pause_menu()
	if Input.is_action_just_released("cancel-1"):
		_close_pause_menu()
	if Input.is_action_just_released("cancel-2"):
		_close_pause_menu()
	if Input.is_action_just_released("cancel-3"):
		_close_pause_menu()


func _close_pause_menu():
	get_tree().paused = false
	hide()
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.show()


func _ready():
	get_tree().get_root().size_changed.connect(_on_resize)
	_on_resize()

func _on_resize():
	$overlay.position = get_viewport().size / 2
