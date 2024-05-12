class_name BaseMonster
extends Area3D

var chest_height = 0.75
var target : PathFollow3D = null
var speed = 1.0
var bounce_velocity_on_damage = 45.0
var velocity = Vector3.ZERO
var flying = false

var is_on_floor = false

signal drop_magical_crystal(pos : Vector3)
signal drop_builder_gem(pos : Vector3)

func _apply_motion(delta):
	printerr("_apply_motion(...) should be overridden!")

func _apply_damage_motion(from_direction : Vector3, force : float = 1.0):
	printerr("_apply_damage_motion(...) should be overridden!")

func _physics_process(delta):
	_apply_motion(delta)
	$HPBar.position = CameraUtil.get_label_position(position, Vector3(-1.0, 2.2, 1.0))
	position += velocity * delta

func _ready():
	add_to_group(Constants.GROUP_NAME_MONSTERS)
	position = target.position


func get_hp():
	return $HPBar.hp


func take_damage(damage : int, from_direction : Vector3, force : float = 1.0):
	var actual_damage = damage if $HPBar.hp >= damage else $HPBar.hp
	$HPBar.hp -= actual_damage 
	$HPBar.draw_damage(actual_damage)
	$HPBar.queue_redraw()
	_apply_damage_motion(from_direction, force)

func _drop_gem():
	if randf() < 0.5:
		drop_builder_gem.emit(position)
	elif randf() < 0.25:
		drop_magical_crystal.emit(position)


func _on_body_exited(body):
	if body.is_in_group(Constants.GROUP_NAME_TERRAIN):
		is_on_floor = false


func _on_body_entered(body):
	if body.is_in_group(Constants.GROUP_NAME_TERRAIN):
		is_on_floor = true
		if $HPBar.hp <= 0:
			_drop_gem()
			queue_free()
		else:
			flying = false
			remove_from_group(Constants.GROUP_NAME_MONSTERS_AIRBORNE)
			velocity.y = 0
			target.progress = (target.get_parent() as Path3D).curve.get_closest_offset(position) + speed * 2
