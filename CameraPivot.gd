extends Node3D

func _process(_delta):
	var goblins = get_tree().get_nodes_in_group("goblins")
	var position_sum = Vector3.ZERO
	for g in goblins:
		position_sum += g.position

	var goblin_center = Vector3.ZERO if goblins.is_empty() else position_sum / goblins.size()
	var max_d = 0.0
	var max_y = 0.0
	for g in goblins:
		max_d = max(max_d, g.position.distance_to(goblin_center))
		max_y = max(max_y, g.position.y)
	position.x = goblin_center.x
	position.z = goblin_center.z + 9  + max_d * 1.5
	position.y = 8 + max_y + max_d 
