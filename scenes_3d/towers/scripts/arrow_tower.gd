class_name ArrowTower
extends BaseTower

signal load_arrow(arrow : Arrow)

var ArrowScene = preload("res://scenes_3d/projectiles/arrow.scn")
var rotation_speed = .075
var axle_y = 0.0
var arrow_y = 0.0
var my_arrow : Arrow = null


func _is_charged() -> bool:
	return my_arrow and is_instance_valid(my_arrow) and not my_arrow.fired


func _shoot():
	if  my_arrow and is_instance_valid(my_arrow) and _have_valid_target():
		_point_at(current_target.position, current_target.chest_height, false)
		$AnimationPlayer.play("shoot")
		my_arrow.damage = current_damage
		my_arrow.target = current_target
		my_arrow.fired = true
		my_arrow = null
		ready_to_fire = false
		$ReloadTimer.start()


func _idle_rotate():
	$"Wheel/Wheel_001/Axle".rotation.z = lerp_angle(
			$"Wheel/Wheel_001/Axle".rotation.z,
			-0.1,
			rotation_speed
	)
	if my_arrow and is_instance_valid(my_arrow):
		my_arrow.rotation.y = $Wheel.rotation.y
		my_arrow.rotation.z = $"Wheel/Wheel_001/Axle".rotation.z


func _point_at(pos : Vector3, target_height : float, interpolate : bool = true):
	var wheel_angle = (
		-Vector2(position.x, position.z)
				.angle_to_point(Vector2(pos.x, pos.z))
	)
	var axle_angle = (
		Vector2(0, position.y + axle_y)
				.angle_to_point(Vector2(Vector2(position.x, position.z)
				.distance_to(Vector2(pos.x, pos.z)), pos.y + target_height))
	)

	$Wheel.rotation.y = (
			lerp_angle($Wheel.rotation.y, wheel_angle, rotation_speed) if interpolate
			else wheel_angle
	)
	$"Wheel/Wheel_001/Axle".rotation.z = (
		lerp_angle($"Wheel/Wheel_001/Axle".rotation.z, axle_angle, rotation_speed) if interpolate
		else axle_angle
	)

	if my_arrow and is_instance_valid(my_arrow):
		my_arrow.rotation.y = $Wheel.rotation.y
		my_arrow.rotation.z = $"Wheel/Wheel_001/Axle".rotation.z


func _rise_out_of_the_ground(delta):
	super._rise_out_of_the_ground(delta)
	if my_arrow and is_instance_valid(my_arrow):
		my_arrow.position.y = position.y + arrow_y


func _load_new_arrow():
	my_arrow = ArrowScene.instantiate()
	my_arrow.position = Vector3(position.x, position.y + arrow_y, position.z)
	my_arrow.rotation.y = $Wheel.rotation.y
	my_arrow.rotation.z = $"Wheel/Wheel_001/Axle".rotation.z
	my_arrow.damage_per_player = damage_per_player
	load_arrow.emit(my_arrow)
	$ShootTimer.start()


func _ready():
	super._ready()
	axle_y = $Wheel.position.y + $"Wheel/Wheel_001".position.y + $"Wheel/Wheel_001/Axle".position.y
	arrow_y = axle_y + 0.2
	current_range = Constants.ARROW_TOWER_BASE_RANGE if current_range == -1 else current_range
	current_damage = Constants.ARROW_TOWER_BASE_DAMAGE if current_damage == -1 else current_damage
	current_reload_time = Constants.ARROW_TOWER_BASE_RELOAD_TIME if current_reload_time == -1 else current_reload_time
	$ReloadTimer.wait_time = current_reload_time - 1
	drop_gem_amount = 7
	_load_new_arrow()
	damage_per_player[_builder_cid] = current_damage


func _on_reload_timer_timeout():
	_load_new_arrow()


func _on_shoot_timer_timeout():
	ready_to_fire = true


func dismantle():
	super.dismantle()
	if is_instance_valid(my_arrow):
		my_arrow.queue_free()


func upgrade_reload_time():
	super.upgrade_reload_time()
	$ReloadTimer.wait_time = current_reload_time


func upgrade_damage(upgraded_by : InputUtil.ControllerID):
	super.upgrade_damage(upgraded_by)
	current_damage += 1
	damage_per_player[upgraded_by] += 1
