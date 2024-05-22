extends Control

func _unhandled_input(_event):
	if (
		Input.is_action_just_released("start-k")
			or Input.is_action_just_released("start-0")
			or Input.is_action_just_released("start-1")
			or Input.is_action_just_released("start-2")
			or Input.is_action_just_released("start-3")
	):
		get_tree().paused = false
		hide()
		for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
			hud_item.show()


func _ready():
	get_tree().get_root().size_changed.connect(_on_resize)
	_on_resize()

func _on_resize():
	position = get_viewport().size / 2
