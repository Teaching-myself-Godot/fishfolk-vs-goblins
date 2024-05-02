extends Node3D

var target_y : float = 0

func _process(delta):
	if position.y < target_y - .1:
		position.y += delta * 3
	elif position.y > target_y + .1:
		position.y -= delta * 3
	else:
		position.y = target_y
