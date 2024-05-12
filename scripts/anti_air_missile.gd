class_name AntiAirMissile
extends Area3D

signal spawn_explosion(pos : Vector3)

const MAX_SPEED = 20.0
var cur_speed = 7.0
var owned_by_player : int = -1
var damage  : int = 2
var target : BaseMonster = null


func _physics_process(delta):
	if target and is_instance_valid(target):
		var target_heart = Vector3(target.position.x, target.position.y + target.chest_height, target.position.z)
		look_at(target_heart)
		position += position.direction_to(target_heart) * delta * cur_speed
	else:
		position += global_transform.basis.x.normalized() * delta * cur_speed

	if cur_speed < MAX_SPEED:
		cur_speed += 1.0

	if Vector3.ZERO.distance_to(position) > 250:
		print("missile dissapears, cus totally out of map")
		queue_free()


func _ready():
	if target and is_instance_valid(target):
		var target_heart = Vector3(target.position.x, target.position.y + target.chest_height, target.position.z)
		look_at(target_heart)


func _on_body_entered(body : Node3D):
	if body.is_in_group(Constants.GROUP_NAME_TERRAIN):
		print("missile disappears, cus hit the flo")
		queue_free()


func _on_area_entered(area):
	if area.is_in_group(Constants.GROUP_NAME_MONSTERS_AIRBORNE):
		area.take_damage(damage, global_transform.basis.x.normalized(), 0.5)
		spawn_explosion.emit(position)
		queue_free()
