class_name BaseTower

extends Node3D

var my_general_area = 2.5
var rise_target_position : Vector3 = Vector3.ZERO
var built_by_player : int = -1
var current_range : float = 5.0
var range_ringed_group_name = Constants.GROUP_NAME_RANGE_RINGED_5M

var outlines = []
var ready_to_fire = false
var current_target : BaseMonster = null

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


func _shoot():
	printerr("Warning: BaseTower._shoot() should be overridden!")

func _is_charged() -> bool:
	printerr("Warning: BaseTower._is_charged() should be overridden!")
	return false

func _point_at(_pos : Vector3, _target_height : float, _interpolate : bool = false):
	printerr("Warning: BaseTower._point_at(...) should be overridden!")

func _idle_rotate():
	printerr("Warning: BaseTower._idle_rotate(...) should be overridden!")

func _is_within_range(target_pos : Vector3) -> bool:
	return (
		Vector2(position.x, position.z)
				.distance_to(Vector2(target_pos.x, target_pos.z)) < current_range
	)


func _point_at_first_monster_within_range():
	for monster : BaseMonster in get_tree().get_nodes_in_group(Constants.GROUP_NAME_MONSTERS):
		if _is_valid_target(monster):
			current_target = monster
			_point_at(monster.position, monster.chest_height)


func _is_valid_target(potential_target) -> bool:
	return  (
			potential_target and 
			is_instance_valid(potential_target) and 
			potential_target.get_hp() > 0 and
			_is_within_range(potential_target.position)
	)


func _have_valid_target() -> bool:
	return _is_valid_target(current_target)


func _ready():
	add_to_group(Constants.GROUP_NAME_TOWERS)
	_fell_trees_in_my_general_area()
	outlines = find_children("*Outline")
	toggle_highlight(false)


func _process(delta):
	_rise_out_of_the_ground(delta)
	if _is_charged():
		if _have_valid_target():
			_point_at(current_target.position, current_target.chest_height)
		else:
			_point_at_first_monster_within_range()
	
	if not _is_charged() or not _have_valid_target():
		_idle_rotate()
	elif ready_to_fire:
		_shoot()

func toggle_highlight(flag : bool):
	for outline in outlines:
		outline.visible = flag
	if flag:
		add_to_group(range_ringed_group_name)
	else:
		remove_from_group(range_ringed_group_name)
