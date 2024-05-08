class_name CannonTower
extends BaseTower


var rotation_speed = .075

func _shoot():
	print("TODO: CannonTower._shoot()")

func _is_charged() -> bool:
	# TODO: CannonTower._is_charged()
	return true

func _point_at(pos : Vector3, target_height : float, interpolate : bool = true):
	var wheel_angle = (
		-Vector2(position.x, position.z)
				.angle_to_point(Vector2(pos.x, pos.z))
	)
	var axle_angle = (
			((Vector2(position.x, position.z).distance_to(Vector2(pos.x, pos.z)) / current_range) *
			(0.4 * PI)) - (0.25 * PI)
	)

	$Wheel.rotation.y = (
			lerp_angle($Wheel.rotation.y, wheel_angle, rotation_speed) if interpolate
			else wheel_angle
	)
	$Wheel/Wheel_L.rotation.z = (
			lerp_angle($Wheel/Wheel_L.rotation.z, wheel_angle, rotation_speed) if interpolate
			else wheel_angle
	)
	$Wheel/Wheel_R.rotation.z = (
			lerp_angle($Wheel/Wheel_R.rotation.z, -wheel_angle, rotation_speed) if interpolate
			else -wheel_angle
	)
	$"Wheel/Axle".rotation.z = (
		lerp_angle($"Wheel/Axle".rotation.z, axle_angle, rotation_speed) if interpolate
		else axle_angle
	)


func _idle_rotate():
	print("TODO: CannonTower._idle_rotate()")

func _ready():
	super._ready()
	current_range = 5.0
	range_ringed_group_name = Constants.GROUP_NAME_RANGE_RINGED_5M
