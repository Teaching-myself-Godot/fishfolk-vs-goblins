class_name MyTree
extends Node3D

var outlines = []
var felled = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var fall_velocity = 0
var my_range_ring : RangeRing = null

func _ready():
	add_to_group(Constants.GROUP_NAME_TREES)
	$AnimationPlayer.play("idle")
	outlines = find_children("*Outline")
	toggle_highlight(false)


func _physics_process(delta):
	if felled:
		fall_velocity += gravity * delta
		rotation_degrees.x += fall_velocity
		if rotation_degrees.x > 95:
			queue_free()


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


func fell():
	felled = true
	rotation_degrees.y = randi() * 360
