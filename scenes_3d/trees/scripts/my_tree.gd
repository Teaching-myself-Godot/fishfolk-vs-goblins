class_name MyTree
extends Node3D

var outlines = []
var felled = false
var original_rotation = Vector3i.ZERO
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var fall_velocity = 0
var my_range_ring : RangeRing = null

func _ready():
	add_to_group(Constants.GROUP_NAME_TREES)
	add_to_group(Constants.GROUP_NAME_TREES_AND_FELLED_TREES)
	$AnimationPlayer.play("idle")
	outlines = find_children("*Outline")
	toggle_highlight(false)
	original_rotation = rotation_degrees


func _physics_process(delta):
	if felled and visible:
		fall_velocity += gravity * delta
		rotation_degrees.x += fall_velocity
		if rotation_degrees.x > 95:
			remove_from_group(Constants.GROUP_NAME_TREES)
			hide()
			fall_velocity = 0

	if not felled and rotation_degrees.x != original_rotation.x:
		rotation_degrees.x -= 2
		if abs(rotation_degrees.x - original_rotation.x) < 3:
			rotation_degrees.x = original_rotation.x
			rotation_degrees.y = original_rotation.y


func set_range_ring(radius : float):
	my_range_ring = RangeRing.new(position, radius)
	TerrainShaderParams.add_range_ring(my_range_ring)


func drop_range_ring():
	TerrainShaderParams.drop_range_ring(my_range_ring)
	my_range_ring = null


func toggle_highlight(flag : bool):
	if not flag:
		drop_range_ring()

	for outline in outlines:
		outline.visible = flag


func is_within_radius(pos : Vector3, radius : float) -> bool:
	return Vector2(pos.x, pos.z).distance_to(Vector2(position.x, position.z)) < radius


func restore_if_have_room():
	for tower : BaseTower in get_tree().get_nodes_in_group(Constants.GROUP_NAME_TOWERS):
		if position.distance_to(tower.position) <= tower.my_general_area:
			return
	show()
	add_to_group(Constants.GROUP_NAME_TREES)
	felled = false


func fell():
	if not felled:
		felled = true
		rotation_degrees.y = randi() * 360
