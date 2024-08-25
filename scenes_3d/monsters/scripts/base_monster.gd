class_name BaseMonster
extends Area3D

signal killed(player_cid : int, type : Constants.MonsterType)
signal damaged(player_cid : int, type : Constants.MonsterType, dmg : int)
signal overkilled(player_cid : int, type : Constants.MonsterType)

@export var thumbnail : Resource

var type := Constants.MonsterType.UNKNOWN
var chest_height = 0.75
var target : PathFollow3D = null
var velocity = Vector3.ZERO
var speed : float = 0.0
var hp : int = 10
var gems : int = 1
var drop_crystal : bool = false
var attacking : bool = false
var attack_target : Vector3 = Vector3.ZERO
var crib_under_attack : Crib

signal drop_magical_crystal(pos : Vector3)
signal drop_builder_gem(pos : Vector3)
signal spawn_dust_particles(pos : Vector3)
signal kill_your_darling(crib : Crib)

var my_frame_cycle : int = 0
var limit_frames : bool = false
func _apply_motion(_delta):
	printerr("_apply_motion(...) should be overridden!")


func _apply_damage_motion(_from_direction : Vector3, _force : float = 1.0):
	printerr("_apply_damage_motion(...) should be overridden!")


func handle_update(delta, frame):
	if frame == my_frame_cycle or not limit_frames:
		_apply_motion(delta)

	if attacking and position.distance_to(attack_target) < 1.0:
		kill_your_darling.emit(crib_under_attack)
		queue_free()

	$HPBar.position = (
		CameraUtil.get_label_position(position, Vector3(0, 2.2, 0)) -
		Vector2(abs($HPBar.max_hp * 0.5), 14)
	)

	var pos_2d = CameraUtil.get_label_position(position)
	if not get_viewport().get_visible_rect().has_point(pos_2d):
		if CameraUtil.is_behind_camera(position):
			var vp = get_viewport().get_visible_rect().size
			$MonsterIndicator.position = Vector2(vp.x * 0.5, vp.y - 50)
			$"MonsterIndicator/Arrow-point".rotation_degrees = 90
		else:
			var edge_pos = CameraUtil.keep_in_viewport(pos_2d)
			var ang = edge_pos.angle_to_point(pos_2d)
			$"MonsterIndicator/Arrow-point".rotation = ang
			$MonsterIndicator.position = edge_pos - Vector2.RIGHT.rotated(ang) * 50
		$MonsterIndicator.show()
	else:
		$MonsterIndicator.hide()

	position += velocity * delta


func _ready():
	add_to_group(Constants.GROUP_NAME_MONSTERS)
	$HPBar.max_hp = hp
	$HPBar.hp = hp
	if is_instance_valid(target):
		position = target.global_position
	$HPBar.position = (
		CameraUtil.get_label_position(position, Vector3(0, 2.2, 0)) -
			Vector2(abs($HPBar.max_hp * 0.5), 14)
	)
	collision_layer = Constants.MONSTER_COLLISION_LAYER


func get_hp():
	return $HPBar.hp


func take_damage(damage : int, dealt_by_player : int, from_direction : Vector3, force : float = 1.0):
	if attacking:
		# Monster is immune now
		return

	var actual_damage = damage if $HPBar.hp >= damage else $HPBar.hp
	$HPBar.hp -= actual_damage
	$HPBar.draw_damage(actual_damage)
	$HPBar.queue_redraw()
	_apply_damage_motion(from_direction, force)
	damaged.emit(dealt_by_player, type, actual_damage)
	if $HPBar.hp == 0:
		killed.emit(dealt_by_player,type)
	if actual_damage < damage:
		overkilled.emit(dealt_by_player, type)


func _spawn_dust():
	spawn_dust_particles.emit(position)


func _drop_gem():
	for _i in range(gems):
		drop_builder_gem.emit(position)

	if drop_crystal:
		drop_magical_crystal.emit(position)

func attack(crib : Crib):
	if is_instance_valid(crib):
		attacking = true
		attack_target = crib.position
		crib_under_attack = crib
		speed *= 4
	else:
		# player must be game over, no more cribs to attack
		queue_free()
