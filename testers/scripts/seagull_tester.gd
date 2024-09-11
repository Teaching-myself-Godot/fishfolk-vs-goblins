extends Node3D


func _unhandled_input(_e: InputEvent) -> void:
	var gulls = get_tree().get_nodes_in_group("gulls")
	if Input.is_key_pressed(KEY_1):
		for gull : Gull in gulls:
			gull.target = $goblin
	if Input.is_key_pressed(KEY_2):
		for gull : Gull in gulls:
			gull.flying = true
	if Input.is_key_pressed(KEY_4):
		for gull : Gull in gulls:
			gull.target = $"flying-fish"
	if Input.is_key_pressed(KEY_5):
		for gull : Gull in gulls:
			gull.cry()

