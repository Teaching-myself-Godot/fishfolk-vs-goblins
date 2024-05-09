class_name MyCamera

extends Camera3D

const MIN_ZOOM = 0.0
const MAX_ZOOM = 100.0

var zoom = 9.0


func change_zoom(amt : float, max_d : float):
	zoom += amt * 0.4
	zoom = max_d if amt > 0 and zoom < max_d else zoom
	zoom = MIN_ZOOM if zoom < MIN_ZOOM else zoom
	zoom = MAX_ZOOM if zoom > MAX_ZOOM else zoom


func _process(_delta):
	var goblins = get_tree().get_nodes_in_group(Constants.GROUP_NAME_GOBLINS)
	var position_sum = Vector3.ZERO
	for g : Goblin in goblins:
		position_sum += g.position

	var goblin_center = Vector3.ZERO if goblins.is_empty() else position_sum / goblins.size()
	var max_d = 0.0
	var max_y = 0.0
	for g in goblins:
		max_d = max(max_d, g.position.distance_to(goblin_center))
		max_y = max(max_y, g.position.y)
	max_d *= 2.5

	var p1_axis = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	var p2_axis = Input.get_joy_axis(1, JOY_AXIS_RIGHT_Y)
	var p3_axis = Input.get_joy_axis(2, JOY_AXIS_RIGHT_Y)
	var p4_axis = Input.get_joy_axis(3, JOY_AXIS_RIGHT_Y)
	if abs(p1_axis) > 0.2:
		change_zoom(p1_axis, max_d)
	elif abs(p2_axis) > 0.2:
		change_zoom(p2_axis, max_d)
	elif abs(p3_axis) > 0.2:
		change_zoom(p3_axis, max_d)
	elif abs(p4_axis) > 0.2:
		change_zoom(p4_axis, max_d)

	if Input.is_action_just_pressed("mousewheel_up"):
		change_zoom(-2.0, max_d)
	elif Input.is_action_just_pressed("mousewheel_down"):
		change_zoom(2.0, max_d)

	position.y = 9 + max_y + max(zoom, max_d)
