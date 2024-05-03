class_name ArrowTower

extends Node3D

const MY_GENERAL_AREA = 2.5

@export var rotation_speed = .075
var target_position : Vector3 = Vector3.ZERO
var axle_y = $Wheel.position.y + $"Wheel/Wheel_001".position.y + $"Wheel/Wheel_001/Axle".position.y
var built_by_player : int = -1
var current_range : float = 5.0


func _fell_trees_in_my_general_area():
	for tree : MyTree in get_tree().get_nodes_in_group(Constants.GROUP_NAME_TREES):
		if is_instance_valid(tree) and tree.is_within_radius(position, MY_GENERAL_AREA):
			tree.fell()


func _rise_out_of_the_ground(delta):
	if position.y < target_position.y - .1:
		position.y += delta * 2
		position.x = target_position.x + (cos(randf()) * .1)
		position.z = target_position.z + (cos(randf()) * .1)
	else:
		position = target_position


func __handle_debug_inputs():
	if Input.is_action_just_pressed("x-debug-butt"):
		$AnimationPlayer.play("shoot")


func _point_at(pos : Vector3, target_height : float):
	var wheel_angle = (
		-Vector2(position.x, position.z)
				.angle_to_point(Vector2(pos.x, pos.z))
	)
	var axle_angle = (
		Vector2(0, position.y + axle_y)
				.angle_to_point(Vector2(Vector2(position.x, position.z)
				.distance_to(Vector2(pos.x, pos.z)), pos.y + target_height))
	)

	$Wheel.rotation.y = lerp_angle($Wheel.rotation.y, wheel_angle, rotation_speed)
	$"Wheel/Wheel_001/Axle".rotation.z = (
		lerp_angle($"Wheel/Wheel_001/Axle".rotation.z, axle_angle, rotation_speed)
	)


func _is_within_range(target_pos : Vector3) -> bool:
	return (
		Vector2(position.x, position.z)
				.distance_to(Vector2(target_pos.x, target_pos.z)) < current_range
	)


func _point_at_first_monster_within_range():
	# FIXME - the monster will be of a different class than Goblin once we have fishfolk
	for monster : Goblin in get_tree().get_nodes_in_group(Constants.GROUP_NAME_MONSTERS):
		if is_instance_valid(monster) and _is_within_range(monster.position):
			_point_at(monster.position, monster.chest_height)


func _ready():
	_fell_trees_in_my_general_area()


func _process(delta):
	_rise_out_of_the_ground(delta)
	_point_at_first_monster_within_range()
	__handle_debug_inputs()
