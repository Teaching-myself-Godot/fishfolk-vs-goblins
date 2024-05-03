extends Node3D

@export var rotation_speed = .075
var target_position : Vector3 = Vector3.ZERO
var axle_y = $Wheel.position.y + $"Wheel/Wheel_001".position.y + $"Wheel/Wheel_001/Axle".position.y
var built_by_player : int = -1

func _ready():
	for tree in get_tree().get_nodes_in_group(Constants.GROUP_NAME_TREES):
		if is_instance_valid(tree) and Vector2(position.x, position.z).distance_to(Vector2(tree.position.x, tree.position.z)) < 2.5:
			tree.felled = true

func _process(delta):
	if position.y < target_position.y - .1:
		position.y += delta * 2
		position.x = target_position.x + (cos(randf()) * .1)
		position.z = target_position.z + (cos(randf()) * .1)
	else:
		position = target_position

	if Input.is_action_just_pressed("x-debug-butt"):
		$AnimationPlayer.play("shoot")
	if Input.is_action_pressed("z-debug-butt"):
		var monster = get_tree().get_first_node_in_group(Constants.GROUP_NAME_GOBLINS)
		if is_instance_valid(monster):
			point_at(monster.position, 1.2)

func point_at(pos : Vector3, target_height : float):
	var wheel_angle = -Vector2(position.x, position.z).angle_to_point(Vector2(pos.x, pos.z))
	var axle_angle = Vector2(0, position.y + axle_y).angle_to_point(Vector2(Vector2(position.x, position.z).distance_to(Vector2(pos.x, pos.z)), pos.y + target_height))

	$Wheel.rotation.y = lerp_angle($Wheel.rotation.y, wheel_angle, rotation_speed)
	$"Wheel/Wheel_001/Axle".rotation.z = lerp_angle($"Wheel/Wheel_001/Axle".rotation.z, axle_angle, rotation_speed)
