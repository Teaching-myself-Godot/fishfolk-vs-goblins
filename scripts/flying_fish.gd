class_name FlyingFish
extends BaseMonster

const SPEED = 2.0

var skel : Skeleton3D = null
var bone_ids = []

func _apply_motion(delta):
	var direction = position.direction_to(target.global_position)
	velocity.x = lerp(velocity.x, direction.x * SPEED, 0.25)
	velocity.z = lerp(velocity.z, direction.z * SPEED, 0.25)

	if $HPBar.hp > 0:
		velocity.y = lerp(velocity.y, direction.y * SPEED, 0.25)
		if position.distance_to(target.global_position) < SPEED * 2:
			target.progress += delta * SPEED
	else:
		velocity.y = lerp(velocity.y, -gravity, 0.1)
		$Armature.rotation.x = lerp_angle($Armature.rotation.x, 0.5 * PI, 0.05)

	$Armature.rotation.z = lerp_angle($Armature.rotation.z, 0, 0.1)
	var target_y_angle = atan2(direction.x, direction.z)
	var lerped_y_angle = lerp_angle($Armature.rotation.y, target_y_angle, 0.025)
	var y_ang_delta = $Armature.rotation.y - lerped_y_angle
	$Armature.rotation.y = lerped_y_angle
	
	for i in range(5):
		skel.set_bone_pose_rotation(bone_ids[i], Quaternion(Vector3.FORWARD, -y_ang_delta * (i * i)))



func _apply_damage_motion(from_direction : Vector3, force : float = 1.0):
	velocity.y = 20.0 * force
	velocity.x = from_direction.x * 2 * force
	velocity.z = from_direction.z * 2 * force
	$Armature.rotation.z = -.5 * PI + randf() * PI

func _ready():
	super._ready()
	chest_height = 0.0
	$HPBar.max_hp = 30
	$HPBar.hp = 30
	add_to_group(Constants.GROUP_NAME_MONSTERS_AIRBORNE)
	skel = $Armature/Skeleton3D
	bone_ids = [
		skel.find_bone("Bone.1"),
		skel.find_bone("Bone.2"),
		skel.find_bone("Bone.3"),
		skel.find_bone("Bone.4"),
		skel.find_bone("Bone.5")
	]
	print(skel)
	print(bone_ids)

func _on_body_entered(body):
	if body.is_in_group(Constants.GROUP_NAME_TERRAIN):
		if $HPBar.hp <= 0:
			_drop_gem()
			_drop_gem()
			queue_free()
