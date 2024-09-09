class_name Gull

extends Area3D

@export var target : Node3D
@export var roost : Node3D
@export var flying := false
@export var base_speed := 7.0
@export var max_speed := 20.0
@onready var _child_look_at := $ChildLookat
@onready var _skeleton := $gull/Body/Skeleton3D
@onready var _speed := base_speed
var _was_flying := false

func _process(delta: float) -> void:
	if is_instance_valid(target):
		var chest_height = target.chest_height if 'chest_height' in target else 0.0
		var target_pos = target.global_position + Vector3.UP * chest_height
		_child_look_at.look_at(target_pos)

		if flying:
			if not _was_flying:
				_was_flying = true
				$gull/AnimationPlayer.play("fly")
				$gull/AnimationPlayer.stop()
			var target_rotation = Quaternion(_child_look_at.global_transform.basis)
			var current_rotation = Quaternion(global_transform.basis)
			var next_rotation = current_rotation.slerp(target_rotation, delta * 3.0)
			global_transform.basis = Basis(next_rotation)
			var dir = global_position.direction_to(target_pos)
			position += dir * delta * _speed
			if _speed < max_speed:
				_speed += .1

			if global_position.distance_to(target_pos) < delta * _speed * 2.0:
				if target == roost:
					flying = false
					_was_flying = false
					global_position = target_pos
					$gull/AnimationPlayer.play("idle")
					$gull/AnimationPlayer.stop()
					target = null
					_speed = base_speed
				else:
					# attack here
					target = roost
		var cur_neck_rotation = _skeleton.get_bone_pose_rotation(_skeleton.find_bone("Neck.001"))
		
		_skeleton.set_bone_pose_rotation(_skeleton.find_bone("Neck.001"), 
				cur_neck_rotation.slerp(_get_neck_bone_rotation(), delta * 5.0))

func _ready() -> void:
	$gull/AnimationPlayer.play("idle")
	$gull/AnimationPlayer.stop()


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


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "cry":
		if flying:
			$gull/AnimationPlayer.play("fly")
			$gull/AnimationPlayer.stop()
		else:
			$gull/AnimationPlayer.play("idle")
			$gull/AnimationPlayer.stop()
