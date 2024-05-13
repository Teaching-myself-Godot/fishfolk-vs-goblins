class_name FishChibi
extends BaseMonster

const BOUNCE_FORCE_ON_DAMAGE = 45.0
const SPEED = 1.2
var flying = false
var is_on_floor = false


func _apply_motion(delta):
	var direction = position.direction_to(target.global_position)
	if flying or $HPBar.hp <= 0:
		velocity.y = lerp(velocity.y, -gravity, 0.1)
		velocity.x = lerp(velocity.x, 0.0, 0.05)
		velocity.z = lerp(velocity.z, 0.0, 0.05)
		$Armature.rotation.x = lerp_angle($Armature.rotation.x, $Armature.rotation.x + randf(), 0.25)
		$Armature.rotation.y = lerp_angle($Armature.rotation.y, $Armature.rotation.y + .5, 0.25)
	elif $HPBar.hp > 0:
		if position.distance_to(target.global_position) < SPEED * 2:
			target.progress += delta * SPEED
		velocity.x = lerp(velocity.x, direction.x * SPEED, 0.25)
		velocity.z = lerp(velocity.z, direction.z * SPEED, 0.25)
		if is_on_floor:
			velocity.y = lerp(velocity.y, direction.y * SPEED, 0.1)
		else:
			velocity.y -= delta * gravity * 3
		$Armature.rotation.x = lerp_angle($Armature.rotation.x, 0, 0.25)
		$Armature.rotation.y = lerp_angle($Armature.rotation.y, atan2(direction.x, direction.z), 0.05)


func _apply_damage_motion(from_direction : Vector3, force : float = 1.0):
	velocity.y = BOUNCE_FORCE_ON_DAMAGE * force
	velocity.x = from_direction.x * 2 * force
	velocity.z = from_direction.z * 2 * force
	$Armature.rotation.y = -$Armature.rotation.y
	flying = true
	add_to_group(Constants.GROUP_NAME_MONSTERS_AIRBORNE)


func _ready():
	super._ready()
	chest_height = 1.0
	$HPBar.max_hp = 10
	$HPBar.hp = 10
	$AnimationPlayer.play("bounce")
	add_to_group(Constants.GROUP_NAME_MONSTERS_GROUNDED)


func _on_body_exited(body):
	if body.is_in_group(Constants.GROUP_NAME_TERRAIN):
		is_on_floor = false


func _on_body_entered(body):
	if body.is_in_group(Constants.GROUP_NAME_TERRAIN):
		is_on_floor = true
		if $HPBar.hp <= 0:
			_spawn_dust()
			_drop_gem()
			queue_free()
		else:
			flying = false
			remove_from_group(Constants.GROUP_NAME_MONSTERS_AIRBORNE)
			velocity.y = 0
			target.progress = (target.get_parent() as Path3D).curve.get_closest_offset(position) + SPEED * 2
