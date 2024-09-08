class_name Gull

extends Area3D

@export var target : Node3D
@onready var _child_look_at := $ChildLookat

func _process(delta: float) -> void:
	if is_instance_valid(target):
		var chest_height = target.chest_height if 'chest_height' in target else 0.0
		var target_pos = target.global_position + Vector3.UP * chest_height
		_child_look_at.look_at(target_pos)
		var target_rotation = Quaternion(_child_look_at.global_transform.basis)
		var current_rotation = Quaternion(global_transform.basis)
		var next_rotation = current_rotation.slerp(target_rotation, delta * 3.0)
		global_transform.basis = Basis(next_rotation)
		#look_at(target_pos)
		var dir = global_position.direction_to(target_pos)
		position += dir * 0.1
