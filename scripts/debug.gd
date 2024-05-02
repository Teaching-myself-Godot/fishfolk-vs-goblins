extends Node

var GoblinScene = preload("res://goblin.scn")
var ArrowTowerScene = preload("res://arrow_tower.scn")

var goblin_map = {}

func _unhandled_input(_event):
	if Input.is_action_just_pressed("quit") and get_tree().get_nodes_in_group("goblins").is_empty():
		get_tree().quit()

	if Input.is_action_just_released("f11"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
	if Input.is_action_just_released("start-k"):
		add_goblin_to_scene(0)
	if Input.is_action_just_released("start-0"):
		add_goblin_to_scene(1)
	if Input.is_action_just_released("start-1"):
		add_goblin_to_scene(2)
	if Input.is_action_just_released("start-2"):
		add_goblin_to_scene(3)
	if Input.is_action_just_released("start-3"):
		add_goblin_to_scene(4)

func add_goblin_to_scene(num : int):
	if num in goblin_map:
		if goblin_map[num] and is_instance_valid(goblin_map[num]):
			return
		else: 
			goblin_map.erase(num)
		
	var new_goblin = GoblinScene.instantiate()
	goblin_map[num] = new_goblin
	new_goblin.player_num = num
	new_goblin.position = Vector3(0, 4, 0)

	var goblin = get_tree().get_first_node_in_group("goblins")
	if goblin and is_instance_valid(goblin):
		new_goblin.position.x = goblin.position.x + (-2 + randf() * 4)
		new_goblin.position.z = goblin.position.z + (-2 + randf() * 4)
		new_goblin.position.y = goblin.position.y + 4
	new_goblin.build_arrow_tower.connect(_on_goblin_build_arrow_tower)
	add_child.call_deferred(new_goblin)


func _on_goblin_build_arrow_tower(player_num : int, pos : Vector3):
	var new_tower = ArrowTowerScene.instantiate()
	new_tower.position = Vector3(pos.x, pos.y - 4, pos.z)
	new_tower.target_y = pos.y - .5
	add_child.call_deferred(new_tower)
