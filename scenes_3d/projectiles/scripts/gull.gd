class_name Gull

extends Area3D

@export var target : Node3D
@export var flying := false


@onready var _child_look_at := $ChildLookat
@onready var _skeleton := $gull/Body/Skeleton3D


func _process(delta: float) -> void:
	if is_instance_valid(target):
		var chest_height = target.chest_height if 'chest_height' in target else 0.0
		var target_pos = target.global_position + Vector3.UP * chest_height
		_child_look_at.look_at(target_pos)

		if flying:
			var target_rotation = Quaternion(_child_look_at.global_transform.basis)
			var current_rotation = Quaternion(global_transform.basis)
			var next_rotation = current_rotation.slerp(target_rotation, delta * 3.0)
			global_transform.basis = Basis(next_rotation)
			#look_at(target_pos)
			var dir = global_position.direction_to(target_pos)
			position += dir * 0.01

		_skeleton.set_bone_pose_rotation(_skeleton.find_bone("Neck.001"), _get_neck_bone_rotation())


func _get_neck_bone_rotation() -> Quaternion:
	var new_rot := Vector3(
		_child_look_at.rotation.x,
		_child_look_at.rotation.z,
		_child_look_at.rotation.y
	)
	if new_rot.z > 1.3:
		new_rot.z = 1.3
	elif new_rot.z < -1.3:
		new_rot.z = -1.3
	if new_rot.x < -1.0:
		new_rot.x = -1.0
	$Label.text = str(new_rot)

	return Quaternion.from_euler(new_rot)
