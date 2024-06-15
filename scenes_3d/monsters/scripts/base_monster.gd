class_name BaseMonster
extends Area3D

@export var thumbnail : Resource

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


func take_damage(damage : int, from_direction : Vector3, force : float = 1.0):
	var actual_damage = damage if $HPBar.hp >= damage else $HPBar.hp
	$HPBar.hp -= actual_damage 
	$HPBar.draw_damage(actual_damage)
	$HPBar.queue_redraw()
	_apply_damage_motion(from_direction, force)


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

