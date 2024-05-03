class_name BaseTower

extends Node3D

var my_general_area = 2.5
var rise_target_position : Vector3 = Vector3.ZERO
var built_by_player : int = -1
var current_range : float = 5.0


func _fell_trees_in_my_general_area():
	for tree : MyTree in get_tree().get_nodes_in_group(Constants.GROUP_NAME_TREES):
		if is_instance_valid(tree) and tree.is_within_radius(position, my_general_area):
			tree.fell()

func _rise_out_of_the_ground(delta):
	if position.y < rise_target_position.y - .1:
		position.y += delta * 2
		position.x = rise_target_position.x + (cos(randf()) * .1)
		position.z = rise_target_position.z + (cos(randf()) * .1)
	else:
		position = rise_target_position

func __handle_debug_inputs():
	pass


func _point_at(_pos : Vector3, _target_height : float):
	printerr("Warning: BaseTower._point_at(...) should be overridden!")


func _is_within_range(target_pos : Vector3) -> bool:
	return (
		Vector2(position.x, position.z)
				.distance_to(Vector2(target_pos.x, target_pos.z)) < current_range
	)


func _point_at_first_monster_within_range():
	# FIXME - the monster will be of a different class than Goblin once we have fishfolk
	for monster : Goblin in get_tree().get_nodes_in_group(Constants.GROUP_NAME_MONSTERS):
		if is_instance_valid(monster) and _is_within_range(monster.position):
			_point_at(monster.position, monster.chest_height)


func _ready():
	_fell_trees_in_my_general_area()


func _process(delta):
	_rise_out_of_the_ground(delta)
	_point_at_first_monster_within_range()
	__handle_debug_inputs()


func toggle_highlight(flag : bool):
	print("TODO: toggle highlight for tower: " + str(flag))
	#for outline in outlines:
		#outline.visible = flag
