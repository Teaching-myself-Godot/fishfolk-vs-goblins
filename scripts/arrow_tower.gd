extends Node3D

var target_position : Vector3 = Vector3.ZERO

func _ready():
	for tree in get_tree().get_nodes_in_group("trees"):
		if is_instance_valid(tree) and Vector2(position.x, position.z).distance_to(Vector2(tree.position.x, tree.position.z)) < 2.5:
			tree.felled = true

func _process(delta):
	if position.y < target_position.y - .1:
		position.y += delta * 2
		position.x = target_position.x + (cos(randf()) * .1)
		position.z = target_position.z + (cos(randf()) * .1)
	else:
		position = target_position
