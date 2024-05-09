class_name BaseMonster
extends Area3D

var chest_height = 0.75
var target : PathFollow3D = null
var speed = 1.0
var bounce_velocity_on_damage = 45
var velocity = Vector3.ZERO
var flying = false

var is_on_floor = false

func _physics_process(delta):
	var direction = position.direction_to(target.position)

	if flying or $HPBar.hp <= 0:
		velocity.y = lerp(velocity.y, -gravity, 0.1)
		velocity.x = lerp(velocity.x, 0.0, 0.05)
		velocity.z = lerp(velocity.z, 0.0, 0.05)
		$Armature.rotation.x = lerp_angle($Armature.rotation.x, $Armature.rotation.x + randf(), 0.25)
		$Armature.rotation.y = lerp_angle($Armature.rotation.y, $Armature.rotation.y + .5, 0.25)
	elif $HPBar.hp > 0:
		if position.distance_to(target.position) < speed * 2:
			target.progress += delta * speed
		velocity.x = lerp(velocity.x, direction.x * speed, 0.25)
		velocity.z = lerp(velocity.z, direction.z * speed, 0.25)
		if is_on_floor:
			velocity.y = lerp(velocity.y, direction.y * speed, 0.1)
		else:
			velocity.y -= delta * gravity * 3
		$Armature.rotation.x = lerp_angle($Armature.rotation.x, 0, 0.25)
		$Armature.rotation.y = lerp_angle($Armature.rotation.y, atan2(direction.x, direction.z), 0.05)

	$HPBar.position = CameraUtil.get_label_position(position, Vector3(0.5, 0, 0.1))
	position += velocity * delta

func _ready():
	add_to_group(Constants.GROUP_NAME_MONSTERS)
	position = target.position


func get_hp():
	return $HPBar.hp


func take_damage(damage : int, from_direction : Vector3):
	$HPBar.hp -= damage if $HPBar.hp >= damage else $HPBar.hp
	$HPBar.queue_redraw()
	velocity.y = bounce_velocity_on_damage
	velocity.x = from_direction.x * 2
	velocity.z = from_direction.z * 2
	$Armature.rotation.y = -$Armature.rotation.y
	flying = true


func _on_body_exited(body):
	if body.is_in_group(Constants.GROUP_NAME_TERRAIN):
		is_on_floor = false


func _on_body_entered(body):
	if body.is_in_group(Constants.GROUP_NAME_TERRAIN):
		is_on_floor = true
		if $HPBar.hp <= 0:
			queue_free()
		else:
			flying = false
			velocity.y = 0
			target.progress = (target.get_parent() as Path3D).curve.get_closest_offset(position) + speed * 2
