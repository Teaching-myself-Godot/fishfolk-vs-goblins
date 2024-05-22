extends Node3D

func _process(_delta):
	rotation.y = lerp_angle(rotation.y, rotation.y + 0.1, 0.1)
