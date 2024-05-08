class_name CannonBall
extends RigidBody3D

var owned_by_player : int = -1
var impulse_dir : Vector3 = Vector3.ZERO
var damage = 5
var explosion_range = 4

func _ready():
	apply_impulse(impulse_dir * 5)
	contact_monitor = true
	max_contacts_reported = 5

func _deal_damage():
	var monsters = (
		get_tree()
		.get_nodes_in_group(Constants.GROUP_NAME_MONSTERS)
	)
	for monster : BaseMonster in monsters:
		if (
			is_instance_valid(monster) and 
			position.distance_to(monster.position) < explosion_range
		):
			monster.take_damage(damage, position.direction_to(monster.position))

func _on_body_entered(body):
	if body.is_in_group(Constants.GROUP_NAME_TERRAIN):
		_deal_damage()
		$DespawnTimer.start()


func _on_despawn_timer_timeout():
	queue_free()
