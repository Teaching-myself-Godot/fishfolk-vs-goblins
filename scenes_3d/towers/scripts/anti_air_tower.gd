class_name AntiAirTower
extends BaseTower

signal fire_anti_air_missile(anti_air_missile : AntiAirMissile)
var AntiAirMissileScene = preload("res://scenes_3d/projectiles/anti_air_missile.scn")


var launcher_y = 0.0
var rotation_speed = 0.85
var current_missile_index : int = 0
var missile_clamps : Array[Node3D] = []

func _shoot():
	if _have_valid_target():
		var new_missile : AntiAirMissile = AntiAirMissileScene.instantiate()
		_point_at(current_target.position, current_target.chest_height, false)
		new_missile.target = current_target
		new_missile.owned_by_player = built_by_player
		new_missile.position = missile_clamps[current_missile_index].global_position
		current_missile_index = current_missile_index + 1 if current_missile_index < 3 else 0
		ready_to_fire = false
		fire_anti_air_missile.emit(new_missile)
		if current_missile_index == 0:
			$ShootTimer.wait_time = 2.0
		else:
			$ShootTimer.wait_time = 0.1
		$ShootTimer.start()

func  _is_valid_target(potential_target) -> bool:
	return ( 
		super._is_valid_target(potential_target) and 
		potential_target.is_in_group(Constants.GROUP_NAME_MONSTERS_AIRBORNE)
	)


func _point_at(pos : Vector3, target_height : float, interpolate : bool = true):
	var y_angle = -(
		Vector2(position.x, position.z)
				.angle_to_point(Vector2(pos.x, pos.z))
	) - 0.5 * PI
	var x_angle = (
		Vector2(0, position.y + launcher_y)
				.angle_to_point(Vector2(Vector2(position.x, position.z)
				.distance_to(Vector2(pos.x, pos.z)), pos.y + target_height))
	) 
	
	x_angle = 0.0 if x_angle <= 0.0 else x_angle

	$Launcher.rotation.y = (
			lerp_angle($Launcher.rotation.y, y_angle, rotation_speed) if interpolate
			else y_angle
	)
	$Launcher.rotation.x = (
		lerp_angle($Launcher.rotation.x, x_angle, rotation_speed) if interpolate
		else x_angle
	)


func _idle_rotate():
	$Launcher.rotation.x = lerp_angle(
			$Launcher.rotation.x,
			0.2,
			rotation_speed
	)

	$Launcher.rotation.y = lerp_angle(
			$Launcher.rotation.y,
			$Launcher.rotation.y + 0.01,
			rotation_speed
	)

func _is_charged() -> bool:
	return true


func _ready():
	super._ready()
	current_range = Constants.ANTI_AIR_TOWER_BASE_RANGE
	launcher_y = $Launcher.position.y
	missile_clamps = [
		$Launcher/MissileClamp0,
		$Launcher/MissileClamp1,
		$Launcher/MissileClamp2,
		$Launcher/MissileClamp3
	]
	$ShootTimer.start()


func _on_shoot_timer_timeout():
	ready_to_fire = true

