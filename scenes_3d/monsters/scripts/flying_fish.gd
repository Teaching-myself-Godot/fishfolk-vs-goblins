class_name FlyingFish
extends BaseMonster

var skel : Skeleton3D = null
var bone_ids : Array[int] = []
var bend_window_1 : Array[float] = [
	0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0
]
var bend_window_2 : Array[float] = [
	0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0
]


func _apply_motion(delta):
	var direction = (
		position.direction_to(attack_target) if attacking else
		position.direction_to(target.global_position)
	)
	velocity.x = lerp(velocity.x, direction.x * speed, 0.25)
	velocity.z = lerp(velocity.z, direction.z * speed, 0.25)

	if $HPBar.hp > 0:
		velocity.y = lerp(velocity.y, direction.y * speed, 0.25)
		if position.distance_to(target.global_position) < speed * 2:
			target.progress += delta * speed
	else:
		velocity.y = lerp(velocity.y, -gravity, 0.1)
		$Armature.rotation.x = lerp_angle($Armature.rotation.x, 0.5 * PI, 0.05)

	$Armature.rotation.z = lerp_angle($Armature.rotation.z, 0, 0.1)

	var pos = attack_target if attacking else target.global_position
	var target_y_angle = -(
		Vector2(position.x, position.z)
				.angle_to_point(Vector2(pos.x, pos.z))
	) + 0.5 * PI
	#var target_y_angle = atan2(direction.x, direction.z)
	var lerped_y_angle = lerp_angle($Armature.rotation.y, target_y_angle, 0.025)
	var target_x_angle = (
		Vector2(0, position.y)
				.angle_to_point(Vector2(Vector2(position.x, position.z)
				.distance_to(Vector2(pos.x, pos.z)), pos.y))
	)
	var lerped_x_angle = lerp_angle($Armature.rotation.x, -target_x_angle, 0.025)

	bend_window_1.pop_back()
	bend_window_1.push_front((lerped_y_angle - $Armature.rotation.y) * 4.0)
	bend_window_2.pop_back()
	bend_window_2.push_front((lerped_x_angle - $Armature.rotation.x) * 2.5)

	$Armature.rotation.x = lerped_x_angle
	$Armature.rotation.y = lerped_y_angle

	skel.set_bone_pose_rotation(bone_ids[0], Quaternion(Vector3.LEFT, bend_window_2[0]) * Quaternion(Vector3.FORWARD, bend_window_1[0]))
	skel.set_bone_pose_rotation(bone_ids[1], Quaternion(Vector3.LEFT, bend_window_2[4]) * Quaternion(Vector3.FORWARD, bend_window_1[4]))
	skel.set_bone_pose_rotation(bone_ids[2], Quaternion(Vector3.LEFT, bend_window_2[9]) * Quaternion(Vector3.FORWARD, bend_window_1[9]))
	skel.set_bone_pose_rotation(bone_ids[3], Quaternion(Vector3.LEFT, bend_window_2[14]) * Quaternion(Vector3.FORWARD, bend_window_1[14]))
	skel.set_bone_pose_rotation(bone_ids[4], Quaternion(Vector3.LEFT, bend_window_2[16]) * Quaternion(Vector3.FORWARD, bend_window_1[16]))


func _apply_damage_motion(from_direction : Vector3, force : float = 1.0):
	velocity.y = 20.0 * force
	velocity.x = from_direction.x * 2 * force
	velocity.z = from_direction.z * 2 * force
	$Armature.rotation.z = -.5 * PI + randf() * PI


func _ready():
	super._ready()
	speed = 2.0 if speed == 0.0 else speed
	chest_height = 0.0
	add_to_group(Constants.GROUP_NAME_MONSTERS_AIRBORNE)
	$AnimationPlayer.play("fly")
	$AnimationPlayer.speed_scale = 2.5
	skel = $Armature/Skeleton3D
	bone_ids = [
		skel.find_bone("Bone.1"),
		skel.find_bone("Bone.2"),
		skel.find_bone("Bone.3"),
		skel.find_bone("Bone.4"),
		skel.find_bone("Bone.5")
	]


func _on_body_exited(body):
	if body.is_in_group(Constants.GROUP_NAME_GOBLINS):
		(body as Goblin).my_riding_monster = null


func _on_body_entered(body):
	if body.is_in_group(Constants.GROUP_NAME_TERRAIN) and $HPBar.hp <= 0:
		_spawn_dust()
		_drop_gem()
		queue_free()

	if body.is_in_group(Constants.GROUP_NAME_GOBLINS):
		(body as Goblin).my_riding_monster = self
