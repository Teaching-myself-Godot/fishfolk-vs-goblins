extends Node3D

var drag_start_x : float = 0.0

func _process(_delta):
	var goblins = get_tree().get_nodes_in_group("goblins")
	var position_sum = Vector3.ZERO
	for g in goblins:
		position_sum += g.position

	var goblin_center = Vector3.ZERO if goblins.is_empty() else position_sum / goblins.size()
	position = goblin_center

	var p1_axis = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var p2_axis = Input.get_joy_axis(1, JOY_AXIS_RIGHT_X)
	var p3_axis = Input.get_joy_axis(2, JOY_AXIS_RIGHT_X)
	var p4_axis = Input.get_joy_axis(3, JOY_AXIS_RIGHT_X)	
	if abs(p1_axis) > 0.2:
		rotate(Vector3.UP, p1_axis * 0.02)
	elif abs(p2_axis) > 0.2:
		rotate(Vector3.UP, p2_axis * 0.02)
	elif abs(p3_axis) > 0.2:
		rotate(Vector3.UP, p3_axis * 0.02)
	elif abs(p4_axis) > 0.2:
		rotate(Vector3.UP, p4_axis * 0.02)

	if Input.is_action_just_pressed("mousewheel_click"):
		drag_start_x = get_viewport().get_mouse_position().x
	
	if Input.is_action_pressed("mousewheel_click"):
		var delta = drag_start_x - get_viewport().get_mouse_position().x
		drag_start_x = get_viewport().get_mouse_position().x
		rotate(Vector3.UP, delta / get_viewport().size.x)
