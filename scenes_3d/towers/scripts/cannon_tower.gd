class_name CannonTower
extends BaseTower

signal fire_cannon_ball(cannon_ball : CannonBall)
var CannonBallScene = preload("res://scenes_3d/projectiles/cannon_ball.tscn")

var rotation_speed = .075
var my_cannon_ball : CannonBall = null
var charged = false

func _shoot():
	if _have_valid_target():
		$Wheel/Axle/Barrel/Fuse/Fire.hide()
		_point_at(current_target.position, current_target.chest_height, false)
		my_cannon_ball = CannonBallScene.instantiate()
		my_cannon_ball.position = (
			Vector3.RIGHT
				.rotated(Vector3.UP, $Wheel.rotation.y)
				.rotated(Vector3.FORWARD, $Wheel.rotation.z)
		) + position + $Wheel/Axle.position
		my_cannon_ball.damage_per_player = damage_per_player
		my_cannon_ball.rotation.y = $Wheel.rotation.y
		my_cannon_ball.rotation.z = $Wheel/Axle.rotation.z
		my_cannon_ball.impulse_dir = (Vector3.RIGHT
				.rotated(Vector3.UP, $Wheel.rotation.y)
				.rotated(Vector3.FORWARD, $Wheel.rotation.z)
		)
		my_cannon_ball.target_distance = (
			Vector2(position.x, position.z)
				.distance_to(Vector2(current_target.position.x, current_target.position.z))
		) - (position.y - current_target.position.y)
		my_cannon_ball.damage = current_damage
		fire_cannon_ball.emit(my_cannon_ball)
		ready_to_fire = false
		$ReloadTimer.start()


func _is_charged() -> bool:
	return true


func _point_at(pos : Vector3, _target_height : float, interpolate : bool = true):
	var wheel_angle = (
		-Vector2(position.x, position.z)
				.angle_to_point(Vector2(pos.x, pos.z))
	)
	var axle_angle = (
			((Vector2(position.x, position.z).distance_to(Vector2(pos.x, pos.z)) / current_range) *
			(0.25 * PI)) - (0.125 * PI)
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
	pass

func  _is_valid_target(potential_target) -> bool:
	return (
		super._is_valid_target(potential_target) and
		potential_target.is_in_group(Constants.GROUP_NAME_MONSTERS_GROUNDED)
	)


func _ready():
	super._ready()
	current_range = Constants.CANNON_TOWER_BASE_RANGE if current_range == -1 else current_range
	current_damage = Constants.CANNON_TOWER_BASE_DAMAGE if current_damage == -1 else current_damage
	current_reload_time = Constants.CANNON_TOWER_BASE_RELOAD_TIME if current_reload_time == -1 else current_reload_time
	drop_gem_amount = 8
	$ReloadTimer.wait_time = current_reload_time - 1
	$ShootTimer.start()
	damage_per_player[_builder_cid] = current_damage


func _on_reload_timer_timeout():
	$Wheel/Axle/Barrel/Fuse/Fire.show()
	$ShootTimer.start()


func _on_shoot_timer_timeout():
	ready_to_fire = true


func upgrade_reload_time():
	super.upgrade_reload_time()
	$ReloadTimer.wait_time = current_reload_time


func upgrade_range():
	current_range += 0.5
	range_upgrade_price = (
		range_upgrade_price + 1 if current_range < 10
		else -1
	)
