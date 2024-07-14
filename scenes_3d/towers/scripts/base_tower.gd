class_name BaseTower

extends Node3D

signal drop_builder_gem(pos : Vector3)

var my_general_area = 2.5
var my_range_ring : RangeRing = null
var rise_target_position : Vector3 = Vector3.ZERO
var built_by_player : int = -1
var current_range : float = 10.0

var outlines = []
var ready_to_fire = false
var current_target : BaseMonster = null
var felled_trees = []
var dismantled = false
var original_y_position = 0.0
var drop_gem_amount = 1


func _fell_trees_in_my_general_area():
	for tree : MyTree in get_tree().get_nodes_in_group(Constants.GROUP_NAME_TREES_AND_FELLED_TREES):
		if is_instance_valid(tree) and tree.is_within_radius(position, my_general_area):
			tree.fell()
			felled_trees.append(tree)


func _rise_out_of_the_ground(delta):
	if position.y < rise_target_position.y - .1:
		position.y += delta * 2
		position.x = rise_target_position.x + (cos(randf()) * .1)
		position.z = rise_target_position.z + (cos(randf()) * .1)
	else:
		position = rise_target_position


func _sink_into_the_ground(delta):
	if position.y > original_y_position + .1:
		position.y -= delta * 4
		position.x = rise_target_position.x + (cos(randf()) * .1)
		position.z = rise_target_position.z + (cos(randf()) * .1)
	else:
		position.y = original_y_position
		queue_free()


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
	original_y_position = position.y


func _process(delta):
	if dismantled:
		_sink_into_the_ground(delta)
		return

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
		if not is_instance_valid(my_range_ring):
			my_range_ring = RangeRing.new(position, current_range)
			TerrainShaderParams.add_range_ring(my_range_ring)
	else:
		TerrainShaderParams.drop_range_ring(my_range_ring)
		my_range_ring = null


func dismantle():
	remove_from_group(Constants.GROUP_NAME_TOWERS)
	for tree : MyTree in felled_trees:
		tree.restore_if_have_room()
	dismantled = true
	for _i in range(drop_gem_amount):
		drop_builder_gem.emit(position + Vector3(0, 2, 0))
