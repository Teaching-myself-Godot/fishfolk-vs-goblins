class_name BaseMonster
extends CharacterBody3D

var chest_height = 0.75
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var target : PathFollow3D = null
var speed = 1.0
var bounce_velocity_on_damage = 12.0


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * 3 * delta

	if target and is_instance_valid(target):
		var direction = position.direction_to(target.position)
		if position.distance_to(target.position) < speed * 2:
			target.progress += delta * speed
		velocity.x = lerp(velocity.x, direction.x * speed, 0.1)
		velocity.z = lerp(velocity.z, direction.z * speed, 0.1)
		$Armature.rotation.y = atan2(velocity.x, velocity.z)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


func _ready():
	add_to_group(Constants.GROUP_NAME_MONSTERS)
	position = target.position


func take_damage(damage : int, from_direction : Vector3):
	velocity.y = bounce_velocity_on_damage
	velocity.x = from_direction.x * 5
	velocity.z = from_direction.z * 5
	print("Monster says ouch, cus takes " + str(damage) + " damage from " + str(from_direction))
