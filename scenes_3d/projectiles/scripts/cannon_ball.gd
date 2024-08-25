class_name CannonBall
extends Area3D

var owned_by_player : int = -1
var impulse_dir : Vector3 = Vector3.ZERO
var velocity : Vector3 = Vector3.ZERO
var damage = 3
var explosion_range = 4
var doing_damage = false
var target_distance = 5

signal spawn_explosion(pos : Vector3)

func _ready():
	velocity = impulse_dir * (target_distance * 2)


func _physics_process(delta):
	position += velocity * delta
	velocity.y = lerp(velocity.y, -gravity, 0.1)
	velocity.x = lerp(velocity.x, 0.0, 0.01)
	velocity.z = lerp(velocity.z, 0.0, 0.01)
	if Vector3.ZERO.distance_to(position) > 250:
		print("Cannonball dissapears, cus totally out of map")
		queue_free()

func _deal_damage():
	if doing_damage:
		return
	doing_damage = true
	var monsters = (
		get_tree()
		.get_nodes_in_group(Constants.GROUP_NAME_MONSTERS)
	)
	for monster : BaseMonster in monsters:
		if (
			is_instance_valid(monster) and
			position.distance_to(monster.position) < explosion_range
		):
			monster.take_damage(damage, owned_by_player, position.direction_to(monster.position))

func _on_body_entered(body):
	if body.is_in_group(Constants.GROUP_NAME_TERRAIN) or body.is_in_group(Constants.GROUP_NAME_MONSTER_COLLISION):
		_deal_damage()
		spawn_explosion.emit(position)
		$DespawnTimer.start()


func _on_despawn_timer_timeout():
	queue_free()
