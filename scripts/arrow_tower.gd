class_name ArrowTower

extends BaseTower

var rotation_speed = .075
var axle_y = $Wheel.position.y + $"Wheel/Wheel_001".position.y + $"Wheel/Wheel_001/Axle".position.y


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
