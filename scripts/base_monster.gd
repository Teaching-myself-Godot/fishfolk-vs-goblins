class_name BaseMonster
extends CharacterBody3D

var chest_height = 0.75
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var target : PathFollow3D = null
var speed = 1.0

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * 3 * delta

	if not is_on_wall() and target and is_instance_valid(target):
		var direction = position.direction_to(target.position)
		if position.distance_to(target.position) < speed * 2:
			target.progress += delta * speed
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		$Armature.rotation.y = atan2(velocity.x, velocity.z)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


func _ready():
	add_to_group(Constants.GROUP_NAME_MONSTERS)
	position = target.position


func take_damage(damage : int):
	print("Monster says ouch, cus takes " + str(damage) + " damage")
