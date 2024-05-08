class_name CannonBall
extends RigidBody3D

var owned_by_player : int = -1
var impulse_dir : Vector3 = Vector3.ZERO
var damage = 3
var explosion_range = 4

func _ready():
	apply_impulse(impulse_dir * 3)
	contact_monitor = true
	max_contacts_reported = 5

func _on_body_entered(body):
	print ("hello?")
	if body.is_in_group(Constants.GROUP_NAME_TERRAIN):
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
		queue_free()
