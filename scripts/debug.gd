extends Node

var GoblinScene = preload("res://goblin.scn")
var adding_state = []

func _unhandled_input(_event):
	if Input.is_action_just_pressed("quit") and get_tree().get_nodes_in_group("goblins").is_empty():
		get_tree().quit()

	if Input.is_action_just_released("f11"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
	if Input.is_action_just_released("start-k") and no_goblin(0):
		add_goblin_to_scene(0)
	if Input.is_action_just_released("start-0") and no_goblin(1):
		add_goblin_to_scene(1)
	if Input.is_action_just_released("start-1") and no_goblin(2):
		add_goblin_to_scene(2)
	if Input.is_action_just_released("start-2") and no_goblin(3):
		add_goblin_to_scene(3)
	if Input.is_action_just_released("start-3") and no_goblin(4):
		add_goblin_to_scene(4)

func add_goblin_to_scene(num : int):
	adding_state.append(num)
	var new_goblin = GoblinScene.instantiate()
	new_goblin.player_num = num
	new_goblin.position = Vector3(0, 4, 0)

	var goblin = get_tree().get_first_node_in_group("goblins")
	if goblin and is_instance_valid(goblin):
		new_goblin.position.x = goblin.position.x + (1 + randf()) * 2
		new_goblin.position.z = goblin.position.z + (1 + randf()) * 2
		new_goblin.position.y = goblin.position.y + 4

	add_child.call_deferred(new_goblin)
	adding_state.erase(num)

func no_goblin(num : int) -> bool:
	if num in adding_state:
		return false
	var goblins = get_tree().get_nodes_in_group("goblins")
	for g in goblins:
		if g.player_num == num:
			return false
	return true
