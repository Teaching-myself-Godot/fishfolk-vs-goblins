class_name Arrow
extends Area3D

const SPEED = 80.0

var damage_per_player := {
	InputUtil.ControllerID.KEYBOARD: 0,
	InputUtil.ControllerID.GAMEPAD_1: 0,
	InputUtil.ControllerID.GAMEPAD_2: 0,
	InputUtil.ControllerID.GAMEPAD_3: 0,
	InputUtil.ControllerID.GAMEPAD_4: 0
}
var fired   : bool = false
var damage  : int = 5
var target : BaseMonster = null
var doing_damage : bool = false

func _physics_process(delta):
	if fired:
		position += global_transform.basis.x.normalized() * delta * SPEED
		if is_instance_valid(target) and position.distance_to(target.position) < 0.5:
			_do_damage()

	if Vector3.ZERO.distance_to(position) > 250:
		print("Arrow dissapears, cus totally out of map")
		queue_free()


func _on_body_entered(body : Node3D):
	if not fired:
		return

	if body.is_in_group(Constants.GROUP_NAME_TERRAIN):
		print("Arrow disappears, cus hit the flo")
		queue_free()


func _do_damage():
	if doing_damage:
		return

	if fired and target and is_instance_valid(target):
		doing_damage = true
		target.take_damage(damage, damage_per_player, global_transform.basis.x.normalized())
		$Cylinder.hide()
		fired = false
		$ImpactStreamPlayer.pitch_scale = 1.0 + -(0.25 + randf() * 0.5)
		$ImpactStreamPlayer.play()
		$DespawnTimer.start()


func _on_despawn_timer_timeout():
	queue_free()


func _on_area_entered(area):
	if area.is_in_group(Constants.GROUP_NAME_MONSTERS):
		_do_damage()


func _ready():
	collision_mask = Constants.MONSTER_COLLISION_LAYER
