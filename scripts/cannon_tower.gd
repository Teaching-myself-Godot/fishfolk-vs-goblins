class_name CannonTower
extends BaseTower

signal fire_cannon_ball(cannon_ball : CannonBall)
var CannonBallScene = preload("res://cannon_ball.tscn")

var rotation_speed = .075
var my_cannon_ball : CannonBall = null
var charged = false

func _shoot():
	if _have_valid_target():
		_point_at(current_target.position, current_target.chest_height, false)
		my_cannon_ball = CannonBallScene.instantiate()
		my_cannon_ball.position = (
			Vector3.RIGHT
				.rotated(Vector3.UP, $Wheel.rotation.y)
				.rotated(Vector3.FORWARD, $Wheel.rotation.z)
		) + position + $Wheel/Axle.position 
		my_cannon_ball.owned_by_player = built_by_player
		my_cannon_ball.rotation.y = $Wheel.rotation.y
		my_cannon_ball.rotation.z = $Wheel/Axle.rotation.z
		my_cannon_ball.impulse_dir = (Vector3.RIGHT
				.rotated(Vector3.UP, $Wheel.rotation.y * 1.25)
				.rotated(Vector3.FORWARD, $Wheel.rotation.z)
		)
		fire_cannon_ball.emit(my_cannon_ball)
		ready_to_fire = false
		$ReloadTimer.start()


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
	$ReloadTimer.start()

func _on_reload_timer_timeout():
	print("TODO: light the fuse")
	$ShootTimer.start()


func _on_shoot_timer_timeout():
	ready_to_fire = true
