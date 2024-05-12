class_name FishChibi
extends BaseMonster

func _apply_motion(delta):
	var direction = position.direction_to(target.position)
	if flying or $HPBar.hp <= 0:
		velocity.y = lerp(velocity.y, -gravity, 0.1)
		velocity.x = lerp(velocity.x, 0.0, 0.05)
		velocity.z = lerp(velocity.z, 0.0, 0.05)
		$Armature.rotation.x = lerp_angle($Armature.rotation.x, $Armature.rotation.x + randf(), 0.25)
		$Armature.rotation.y = lerp_angle($Armature.rotation.y, $Armature.rotation.y + .5, 0.25)
	elif $HPBar.hp > 0:
		if position.distance_to(target.position) < speed * 2:
			target.progress += delta * speed
		velocity.x = lerp(velocity.x, direction.x * speed, 0.25)
		velocity.z = lerp(velocity.z, direction.z * speed, 0.25)
		if is_on_floor:
			velocity.y = lerp(velocity.y, direction.y * speed, 0.1)
		else:
			velocity.y -= delta * gravity * 3
		$Armature.rotation.x = lerp_angle($Armature.rotation.x, 0, 0.25)
		$Armature.rotation.y = lerp_angle($Armature.rotation.y, atan2(direction.x, direction.z), 0.05)


func _apply_damage_motion(from_direction : Vector3, force : float = 1.0):
	velocity.y = bounce_velocity_on_damage * force
	velocity.x = from_direction.x * 2 * force
	velocity.z = from_direction.z * 2 * force
	$Armature.rotation.y = -$Armature.rotation.y
	flying = true
	add_to_group(Constants.GROUP_NAME_MONSTERS_AIRBORNE)


func _ready():
	super._ready()
	chest_height = 1.0
	speed = 1.2
	$HPBar.max_hp = 10
	$HPBar.hp = 10
	$AnimationPlayer.play("bounce")
	add_to_group(Constants.GROUP_NAME_MONSTERS_GROUNDED)
