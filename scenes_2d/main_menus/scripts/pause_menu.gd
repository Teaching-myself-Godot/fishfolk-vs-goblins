class_name PauseMenu
extends Sprite2D


func _toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _unhandled_input(_event):
	if InputUtil.is_just_released("cancel"):
		_close_pause_menu()
	if InputUtil.is_just_released("confirm") or Input.is_action_just_released("jump-k"):
		if $Continue.has_focus():
			_close_pause_menu()
		elif $ToggleFullscreen.has_focus():
			_toggle_fullscreen()
		elif $Quit.has_focus():
			get_tree().quit()

func _close_pause_menu():
	get_tree().paused = false
	hide()
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.show()


func _ready():
	get_tree().get_root().size_changed.connect(_on_resize)
	_on_resize()
	$Continue.grab_focus()


func open_menu():
	show()
	$Continue.grab_focus()


func _on_resize():
	position = get_viewport().size / 2
