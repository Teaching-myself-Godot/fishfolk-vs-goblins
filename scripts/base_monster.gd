class_name BaseMonster
extends Area3D

var chest_height = 0.75
var target : PathFollow3D = null
var speed = 1.0
var bounce_velocity_on_damage = 20
var velocity = Vector3.ZERO
var is_on_floor = false
var hp = 10
var max_hp = 10


func _physics_process(delta):
	var direction = position.direction_to(target.position)
	

	if hp > 0 and position.distance_to(target.position) < speed * 2:
		target.progress += delta * speed
		velocity.x = lerp(velocity.x, direction.x * speed, 0.25)
		velocity.z = lerp(velocity.z, direction.z * speed, 0.25)
		velocity.y = lerp(velocity.y, direction.y * gravity * 3, 0.25)
		$Armature.rotation.y = atan2(direction.x, direction.z)

	if hp <= 0:
		velocity.y = lerp(velocity.y, -gravity, 0.1)
		velocity.x = lerp(velocity.x, 0.0, 0.05)
		velocity.z = lerp(velocity.z, 0.0, 0.05)
		$Armature.rotation.x = lerp_angle($Armature.rotation.x, $Armature.rotation.x + randf() * 2, 0.25)
		$Armature.rotation.y = lerp_angle($Armature.rotation.y, $Armature.rotation.y + randf() * 2, 0.25)
		
	$Control/Label.position = CameraUtil.get_label_position(position, Vector3(0.5, 0, 0.1))
	position += velocity * delta

func _ready():
	add_to_group(Constants.GROUP_NAME_MONSTERS)
	position = target.position


func take_damage(damage : int, from_direction : Vector3):
	velocity.y = bounce_velocity_on_damage
	velocity.x = from_direction.x * 20
	velocity.z = from_direction.z * 20
	hp -= damage
	$Control/Label.text = str(hp) + "/" + str(max_hp)
	if hp <= 0:
		velocity.y = bounce_velocity_on_damage * 3
		hp = 0


func _on_body_entered(body):
	if hp <= 0 and body.is_in_group(Constants.GROUP_NAME_TERRAIN):
		queue_free()
