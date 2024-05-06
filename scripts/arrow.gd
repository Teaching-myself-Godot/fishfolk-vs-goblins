class_name Arrow
extends Area3D

const SPEED = 100.0

var owned_by_player : int = -1
var fired   : bool = false
var damage  : int = 1
var target  : BaseMonster = null
var hit_mark : bool = false

func _physics_process(delta):
	if hit_mark:
		if target and is_instance_valid(target):
			position = Vector3(target.position.x, target.position.y + target.chest_height, target.position.z)
	elif fired:
		if target and is_instance_valid(target):
			position += global_transform.basis.x.normalized() * delta * SPEED
			
	if Vector3.ZERO.distance_to(position) > 250:
		print("Arrow dissapears, cus totally out of map")
		queue_free()


func _on_body_entered(body : Node3D):
	if not fired:
		return

	if body.is_in_group(Constants.GROUP_NAME_MONSTERS):
		(body as BaseMonster).take_damage(damage, global_transform.basis.x.normalized())
		hit_mark = true
		$DespawnTimer.start()

	if body.is_in_group(Constants.GROUP_NAME_TERRAIN) and not hit_mark:
		print("Arrow disappears, cus hit the flo")
		queue_free()


func _on_despawn_timer_timeout():
	queue_free()
