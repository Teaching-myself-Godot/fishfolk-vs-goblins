class_name BaseMonster
extends Area3D

var chest_height = 0.75
var target : PathFollow3D = null
var velocity = Vector3.ZERO


signal drop_magical_crystal(pos : Vector3)
signal drop_builder_gem(pos : Vector3)
signal spawn_dust_particles(pos : Vector3)

func _apply_motion(_delta):
	printerr("_apply_motion(...) should be overridden!")


func _apply_damage_motion(_from_direction : Vector3, _force : float = 1.0):
	printerr("_apply_damage_motion(...) should be overridden!")


func _physics_process(delta):
	_apply_motion(delta)
	$HPBar.position = CameraUtil.get_label_position(position, Vector3(-1.0, 2.2, 1.0))
	position += velocity * delta


func _ready():
	add_to_group(Constants.GROUP_NAME_MONSTERS)
	position = target.global_position
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
	if randf() < 0.5:
		drop_builder_gem.emit(position)
	elif randf() < 0.25:
		drop_magical_crystal.emit(position)

