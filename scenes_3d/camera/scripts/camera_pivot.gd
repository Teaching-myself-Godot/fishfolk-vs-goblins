class_name CameraPivot

extends Node3D

var drag_start_x : float = 0.0

func _process(_delta):
	var goblins = get_tree().get_nodes_in_group(Constants.GROUP_NAME_GOBLINS)
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
		rotate(Vector3.UP, p1_axis * 0.05)
	elif abs(p2_axis) > 0.2:
		rotate(Vector3.UP, p2_axis * 0.05)
	elif abs(p3_axis) > 0.2:
		rotate(Vector3.UP, p3_axis * 0.05)
	elif abs(p4_axis) > 0.2:
		rotate(Vector3.UP, p4_axis * 0.05)

	if Input.is_action_just_pressed("mousewheel_click"):
		drag_start_x = get_viewport().get_mouse_position().x

	if Input.is_action_pressed("mousewheel_click"):
		var mouse_pos = get_viewport().get_mouse_position()
		var delta = drag_start_x - mouse_pos.x
		drag_start_x = mouse_pos.x
		rotate(Vector3.UP, delta * 0.005)

		var viewport_right = get_viewport().size.x - 5
		if mouse_pos.x < 5:
			Input.warp_mouse(Vector2(viewport_right, mouse_pos.y))
			drag_start_x = viewport_right
		elif mouse_pos.x > viewport_right + 1:
			Input.warp_mouse(Vector2(5, mouse_pos.y))
			drag_start_x = 5
