class_name Terrain
extends MeshInstance3D


func _process(_delta):
	var range_rings : Array[Vector3] = []
	var range_ring_radiuses : Array[float]   = []
	var explosion_rings : Array[Vector3] = []
	var explosion_ring_radiuses : Array[float] = []

	for ranged_ringed_thing in get_tree().get_nodes_in_group(Constants.GROUP_NAME_RANGE_RINGED_7M):
		if is_instance_valid(ranged_ringed_thing):
			range_rings.append(ranged_ringed_thing.position)
			range_ring_radiuses.append(7.0)

	for ranged_ringed_thing in get_tree().get_nodes_in_group(Constants.GROUP_NAME_RANGE_RINGED_5M):
		if is_instance_valid(ranged_ringed_thing):
			range_rings.append(ranged_ringed_thing.position)
			range_ring_radiuses.append(5.0)

	for explosion : ExplosionRing in get_tree().get_nodes_in_group(Constants.GROUP_NAME_EXPLOSION_RINGS):
		if is_instance_valid(explosion):
			explosion_rings.append(explosion.position)
			explosion_ring_radiuses.append(1.0)


	$Plane.get_surface_override_material(0).next_pass.set_shader_parameter("num_active_circles", range_rings.size())
	$Plane.get_surface_override_material(0).next_pass.set_shader_parameter("range_positions", range_rings)
	$Plane.get_surface_override_material(0).next_pass.set_shader_parameter("range_radiuses", range_ring_radiuses)

	$Plane.get_surface_override_material(0).next_pass.next_pass.set_shader_parameter("range_positions", explosion_rings)
	$Plane.get_surface_override_material(0).next_pass.next_pass.set_shader_parameter("range_radiuses", explosion_ring_radiuses)
	$Plane.get_surface_override_material(0).next_pass.next_pass.set_shader_parameter("num_active_circles", explosion_rings.size())

func _ready():
	$Plane/StaticBody3D.add_to_group(Constants.GROUP_NAME_TERRAIN)
