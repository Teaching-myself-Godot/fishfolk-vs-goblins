class_name GullTower
extends BaseTower

var GullScene := preload("res://scenes_3d/projectiles/gull.tscn")
@onready var roosts := find_children("Roost*")
var gulls : Array[Gull] = []

var current_gull_index = 0

func _init_gulls():
	for roost in roosts:
		var gull : Gull = GullScene.instantiate()
		gull.roost = roost
		gull.target = roost
		gull.position = (rise_target_position + 
			Vector3(randf_range(-20, 20), 20, randf_range(-20, 20))
		)
		add_child.call_deferred(gull)
		gulls.append(gull)


func _shoot():
	if _have_valid_target():
		ready_to_fire = false
		gulls[current_gull_index].flying = true
		gulls[current_gull_index].damage_per_player = damage_per_player
		gulls[current_gull_index].damage = current_damage
		current_gull_index = current_gull_index + 1 if current_gull_index < 3 else 0
		if current_gull_index == 0:
			$ShootTimer.wait_time = current_reload_time
		else:
			$ShootTimer.wait_time = 0.1
		$ShootTimer.start()


func  _is_valid_target(potential_target) -> bool:
	return (
		super._is_valid_target(potential_target) and
		potential_target.is_in_group(Constants.GROUP_NAME_MONSTERS_AIRBORNE)
	)


func _point_at(_pos : Vector3, _chest : float, _interpolate : bool = false) -> void:
	for gull in gulls:
		gull.target = current_target


func _is_charged() -> bool:
	return gulls.all(func(gull): return not gull.target == gull.roost)


func _idle_rotate():
	pass


func _ready() -> void:
	super()
	_init_gulls()
	current_range = Constants.GULL_TOWER_BASE_RANGE if current_range == -1 else current_range
	current_damage = Constants.GULL_TOWER_BASE_DAMAGE if current_damage == -1 else current_damage
	current_reload_time = Constants.GULL_TOWER_BASE_RELOAD_TIME if current_reload_time == -1 else current_reload_time
	drop_gem_amount = 9
	$ShootTimer.wait_time = current_reload_time
	ready_to_fire = true
	damage_per_player[_builder_cid] = current_damage


func _on_shoot_timer_timeout() -> void:
	ready_to_fire = true
