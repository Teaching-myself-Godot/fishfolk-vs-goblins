class_name BaseMonster
extends Area3D

var chest_height = 0.75
var target : PathFollow3D = null
var speed = 1.0
var bounce_velocity_on_damage = 20
var velocity = Vector3.ZERO
var is_on_floor = false


func _physics_process(delta):
	if target and is_instance_valid(target):
		var direction = position.direction_to(target.position)
		if position.distance_to(target.position) < speed * 2:
			target.progress += delta * speed
		velocity.x = lerp(velocity.x, direction.x * speed, 0.25)
		velocity.z = lerp(velocity.z, direction.z * speed, 0.25)
		velocity.y = lerp(velocity.y, direction.y * gravity * 3, 0.25)
		$Armature.rotation.y = atan2(direction.x, direction.z)

	position += velocity * delta

func _ready():
	add_to_group(Constants.GROUP_NAME_MONSTERS)
	position = target.position


func take_damage(damage : int, from_direction : Vector3):
	velocity.y = bounce_velocity_on_damage
	velocity.x = from_direction.x * 20
	velocity.z = from_direction.z * 20
	print("Monster says ouch, cus takes " + str(damage) + " damage from " + str(from_direction))

