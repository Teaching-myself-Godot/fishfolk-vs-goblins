extends Node

var GoblinScene = preload("res://goblin.scn")

func _unhandled_input(event):
	if Input.is_action_just_pressed("start-0") and no_goblin(1):
		add_goblin_to_scene(1)
	if Input.is_action_just_pressed("start-1") and no_goblin(2):
		add_goblin_to_scene(2)

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
