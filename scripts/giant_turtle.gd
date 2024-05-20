class_name GiantTurtle
extends BaseMonster

const BOUNCE_FORCE_ON_DAMAGE = 8.0
const SPEED = 1.2
var is_on_floor = false


func _apply_motion(delta):
	var direction = position.direction_to(target.global_position)
	if $HPBar.hp > 0:
		if position.distance_to(target.global_position) < SPEED * 2:
			target.progress += delta * SPEED
		velocity.x = lerp(velocity.x, direction.x * SPEED, 0.25)
		velocity.z = lerp(velocity.z, direction.z * SPEED, 0.25)
		if is_on_floor:
			velocity.y = lerp(velocity.y, direction.y * SPEED, 0.1)
		else:
			velocity.y -= delta * gravity * 3
		rotation.x = lerp_angle(rotation.x, 0, 0.25)
		rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z) + 0.5 * PI, 0.05)
	else:
		velocity = Vector3(0.0, velocity.y, 0.0)


func _apply_damage_motion(from_direction : Vector3, force : float = 1.0):
	if $HPBar.hp > 0:
		velocity.y = BOUNCE_FORCE_ON_DAMAGE * force
		rotation.y -= randf() * 0.1
	else:
		velocity.y = -1.0

func _ready():
	super._ready()
	chest_height = 1.0
	$HPBar.max_hp = 30
	$HPBar.hp = 30
	$AnimationPlayer.play("slide")
	add_to_group(Constants.GROUP_NAME_MONSTERS_GROUNDED)


func take_damage(damage : int, from_direction : Vector3, force : float = 1.0):
	super.take_damage(damage, from_direction, force)
	if $HPBar.hp <= 0:
		_drop_gem()
		$DespawnTimer.start()


func _on_body_exited(body):
	if body.is_in_group(Constants.GROUP_NAME_TERRAIN):
		is_on_floor = false


func _on_body_entered(body):
	if body.is_in_group(Constants.GROUP_NAME_TERRAIN):
		is_on_floor = true
		velocity.y = 0
		target.progress = (target.get_parent() as Path3D).curve.get_closest_offset(position) + SPEED * 2


func _on_despawn_timer_timeout():
	queue_free()


func _on_trail_timer_timeout():
	Globals.add_landscape_coloration(
		LandscapeColoration.new(
			3.0,
			Color.BLACK,
			position,
			0.001
		)
	)
