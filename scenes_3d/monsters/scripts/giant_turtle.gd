class_name GiantTurtle
extends BaseMonster

const BOUNCE_FORCE_ON_DAMAGE = 8.0
var is_on_floor = false
var right_flipper_dust = true
signal spawn_turtle_flipper_dust_particles(pos : Vector3)

func _apply_motion(delta):
	var direction = (
		position.direction_to(attack_target) if attacking else
		position.direction_to(target.global_position)
	)
	if $HPBar.hp > 0:
		if position.distance_to(target.global_position) < speed * 2:
			target.progress += delta * speed
		velocity.x = lerp(velocity.x, direction.x * speed, 0.25)
		velocity.z = lerp(velocity.z, direction.z * speed, 0.25)
		if is_on_floor:
			velocity.y = lerp(velocity.y, direction.y * speed, 0.1)
		else:
			velocity.y -= delta * gravity * 3
		var target_z_angle = abs(atan2(direction.x, direction.y)) + 1.6 * PI
		target_z_angle = rotation.z if abs(target_z_angle)  < 6.0 else target_z_angle
		rotation.z = lerp_angle(rotation.z, target_z_angle, 0.1) 
		rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z) + 0.5 * PI, 0.05) 
	else:
		velocity = Vector3(0.0, velocity.y, 0.0)


func _apply_damage_motion(_from_direction : Vector3, force : float = 1.0):
	if $HPBar.hp > 0:
		velocity.y = BOUNCE_FORCE_ON_DAMAGE * force
		rotation.y -= randf() * 0.1
	else:
		velocity.y = -1.0


func _ready():
	super._ready()
	speed = 2.0 if speed == 0.0 else speed
	right_flipper_dust = true
	chest_height = 1.0
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

	if body.is_in_group(Constants.GROUP_NAME_GOBLINS):
		(body as Goblin).my_riding_monster = null

func _on_body_entered(body):
	if body.is_in_group(Constants.GROUP_NAME_TERRAIN):
		is_on_floor = true
		if $HPBar.hp > 0:
			velocity.y = 0
		target.progress = (target.get_parent() as Path3D).curve.get_closest_offset(position) + speed * 2
	
	if body.is_in_group(Constants.GROUP_NAME_GOBLINS):
		(body as Goblin).my_riding_monster = self

func _on_despawn_timer_timeout():
	queue_free()


func _on_trail_timer_timeout():
	TerrainShaderParams.add_landscape_coloration(
		LandscapeColoration.new(
			3.0,
			Color.BLACK,
			position,
			0.001
		)
	)


func _on_flipper_dust_timer_timeout():
	if right_flipper_dust == true:
		spawn_turtle_flipper_dust_particles.emit(
			position + Vector3(-2.0, 0.0, 2.75).rotated(Vector3.UP, rotation.y)
		)
		right_flipper_dust = false
	else:
		spawn_turtle_flipper_dust_particles.emit(
			position + 	Vector3(-2.0, 0.0, -2.75).rotated(Vector3.UP, rotation.y)
		)
		right_flipper_dust = true
