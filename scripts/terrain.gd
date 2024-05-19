class_name Terrain
extends MeshInstance3D


func _on_range_rings_changed():
	var range_rings : Array[Vector3] = []
	var range_ring_radiuses : Array[float]   = []

	for range_ring : RangeRing in Globals.range_rings:
		range_rings.append(range_ring.position)
		range_ring_radiuses.append(range_ring.radius)

	$Plane.get_surface_override_material(0).next_pass.set_shader_parameter("num_active_circles", range_rings.size())
	$Plane.get_surface_override_material(0).next_pass.set_shader_parameter("range_positions", range_rings)
	$Plane.get_surface_override_material(0).next_pass.set_shader_parameter("range_radiuses", range_ring_radiuses)


func _on_landscape_colorations_changed():
	var landscape_colorations : Array[Vector3] = []
	var landscape_coloration_radiuses : Array[float] = []
	var landscape_coloration_fades : Array[float] = []

	for landscape_coloration : LandscapeColoration in Globals.landscape_colorations:
		landscape_colorations.append(landscape_coloration.position)
		landscape_coloration_radiuses.append(landscape_coloration.radius)
		landscape_coloration_fades.append(landscape_coloration.fade)

	$Plane.get_surface_override_material(0).next_pass.next_pass.set_shader_parameter("range_positions", landscape_colorations)
	$Plane.get_surface_override_material(0).next_pass.next_pass.set_shader_parameter("range_radiuses", landscape_coloration_radiuses)
	$Plane.get_surface_override_material(0).next_pass.next_pass.set_shader_parameter("fades", landscape_coloration_fades)
	$Plane.get_surface_override_material(0).next_pass.next_pass.set_shader_parameter("num_active_circles", landscape_colorations.size())


func _ready():
	Globals.range_rings_changed.connect(_on_range_rings_changed)
	Globals.landscape_colorations_changed.connect(_on_landscape_colorations_changed)
	$Plane/StaticBody3D.add_to_group(Constants.GROUP_NAME_TERRAIN)
