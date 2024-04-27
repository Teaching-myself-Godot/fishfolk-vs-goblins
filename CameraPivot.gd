extends Node3D

func _process(_delta):
	var goblins = get_tree().get_nodes_in_group("goblins")
	var position_sum = Vector3.ZERO
	for g in goblins:
		position_sum += g.position

	var goblin_center = Vector3.ZERO if goblins.is_empty() else position_sum / goblins.size()
	position = goblin_center

	var p1_axis = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	if abs(p1_axis) > 0.2:
		rotate(Vector3.UP, p1_axis * 0.02)

