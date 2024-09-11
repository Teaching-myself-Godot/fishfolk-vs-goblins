extends Node3D


func _unhandled_input(_e: InputEvent) -> void:
	var gulls = get_tree().get_nodes_in_group("gulls")
	if Input.is_key_pressed(KEY_1):
		gulls[0].flying = true
	if Input.is_key_pressed(KEY_2):
		gulls[1].flying = true
	if Input.is_key_pressed(KEY_3):
		gulls[2].flying = true
	if Input.is_key_pressed(KEY_4):
		gulls[3].flying = true
	if Input.is_key_pressed(KEY_5):
		for gull : Gull in gulls:
			gull.target = $"flying-fish"
	if Input.is_key_pressed(KEY_6):
		for gull : Gull in gulls:
			gull.target = $goblin

