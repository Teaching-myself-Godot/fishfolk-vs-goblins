extends Node

var GoblinScene = preload("res://goblin.scn")

func _unhandled_input(_event):
	if Input.is_action_just_pressed("quit") and get_tree().get_nodes_in_group("goblins").is_empty():
		get_tree().quit()

	if Input.is_action_just_pressed("start-k") and no_goblin(0):
		add_goblin_to_scene(0)
	if Input.is_action_just_pressed("start-0") and no_goblin(1):
		add_goblin_to_scene(1)
	if Input.is_action_just_pressed("start-1") and no_goblin(2):
		add_goblin_to_scene(2)
	if Input.is_action_just_pressed("start-2") and no_goblin(3):
		add_goblin_to_scene(3)
	if Input.is_action_just_pressed("start-3") and no_goblin(4):
		add_goblin_to_scene(4)

func add_goblin_to_scene(num : int):
	var new_goblin = GoblinScene.instantiate()
	new_goblin.player_num = num
	var goblins = get_tree().get_nodes_in_group("goblins")
	for g in goblins:
		if g.position.distance_to(new_goblin.position) < 1:
			new_goblin.position.x += 1
	add_child.call_deferred(new_goblin)

func no_goblin(num : int) -> bool:
	var goblins = get_tree().get_nodes_in_group("goblins")
	for g in goblins:
		if g.player_num == num:
			return false
	return true
