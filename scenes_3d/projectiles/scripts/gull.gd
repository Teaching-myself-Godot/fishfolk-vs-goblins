class_name Gull

extends Area3D

@export var target : Node3D
@export var roost : Node3D
@export var flying := false
@export var base_speed := 7.0
@export var max_speed := 20.0
@export var acceleration := 0.25

@onready var _child_look_at := $ChildLookat
@onready var _skeleton := $gull/Body/Skeleton3D
@onready var _speed := base_speed
@onready var _sounds := [
	$GullCryAudioStreamPlayer1,
	$GullCryAudioStreamPlayer2,
	$GullCryAudioStreamPlayer1,
	$GullCryAudioStreamPlayer2,
	$GullCryAudioStreamPlayer3
]

var _was_flying := false
var _taking_off := false


func _handle_flying(delta: float, target_pos: Vector3) -> void:
	if not _was_flying:
		_was_flying = true
		_taking_off = true
		$gull/AnimationPlayer.play("takeoff")
	var target_rotation = Quaternion(_child_look_at.global_transform.basis)
	var current_rotation = Quaternion(global_transform.basis)
	var next_rotation = current_rotation.slerp(target_rotation, delta * 6.0)
	global_transform.basis = Basis(next_rotation)

	var dir = global_position.direction_to(target_pos)
	if _taking_off:
		position.y += delta * 2.0
		position += dir * delta * base_speed * 0.5
	else:
		position += dir * delta * _speed

	if _speed < max_speed and not _taking_off:
		_speed += acceleration


func _handle_landing():
	flying = false
	_was_flying = false
	global_position = roost.global_position
	rotation = Vector3(0.0, rotation.y, 0.0)
	$gull/AnimationPlayer.play("idle")
	$gull/AnimationPlayer.stop()
	target = null
	_speed = base_speed


func _handle_pecking():
	# attack here
	$GullAttackAudioStreamPlayer.play()
	target = roost


func _process(delta: float) -> void:
	if not is_instance_valid(roost):
		# roost disappeared
		queue_free()
		return

	if is_instance_valid(target):
		var chest_height = target.chest_height if 'chest_height' in target else 0.0
		var target_pos = target.global_position + Vector3.UP * chest_height
		_child_look_at.look_at(target_pos)
		var cur_neck_rotation = _skeleton.get_bone_pose_rotation(_skeleton.find_bone("Neck.001"))
		_skeleton.set_bone_pose_rotation(_skeleton.find_bone("Neck.001"), 
		cur_neck_rotation.slerp(_get_neck_bone_rotation(), delta * 5.0))
		if flying:
			_handle_flying(delta, target_pos)
			if global_position.distance_to(target_pos) < delta * _speed * 2.0:
				if target == roost:
					_handle_landing()
				else:
					_handle_pecking()

	if not flying and global_position.distance_to(roost.global_position) < 0.5:
		global_position = roost.global_position





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
	elif anim_name == "takeoff":
		$gull/AnimationPlayer.play("fly")
		$gull/AnimationPlayer.stop()
		_taking_off = false


func cry():
	if not flying:
		$gull/AnimationPlayer.play("idle_cry")
		_sounds.pick_random().play()


func _on_cry_timer_timeout() -> void:
	if randf() < 0.25:
		cry()


func _on_gull_cry_audio_stream_player_finished() -> void:
	if randf() < 0.4:
		_sounds[0].play()
