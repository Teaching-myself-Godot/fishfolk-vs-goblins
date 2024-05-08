class_name Arrow
extends Area3D

const SPEED = 100.0

var owned_by_player : int = -1
var fired   : bool = false
var damage  : int = 5


func _physics_process(delta):
	if fired:
		position += global_transform.basis.x.normalized() * delta * SPEED
			
	if Vector3.ZERO.distance_to(position) > 250:
		print("Arrow dissapears, cus totally out of map")
		queue_free()


func _on_body_entered(body : Node3D):
	if not fired:
		return

	if body.is_in_group(Constants.GROUP_NAME_TERRAIN):
		print("Arrow disappears, cus hit the flo")
		queue_free()


func _on_area_entered(area):
	if area.is_in_group(Constants.GROUP_NAME_MONSTERS):
		(area as BaseMonster).take_damage(damage, global_transform.basis.x.normalized())
		queue_free()
