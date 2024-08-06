class_name Terrain
extends Node3D


func _on_range_rings_changed():
	var range_rings : Array[Vector3] = []
	var range_ring_radiuses : Array[float]   = []

	for range_ring : RangeRing in TerrainShaderParams.range_rings:
		range_rings.append(range_ring.position)
		range_ring_radiuses.append(range_ring.radius)

	for i in range($Landscape.get_surface_override_material_count()):
		$Landscape.get_surface_override_material(i).next_pass.set_shader_parameter("num_active_circles", range_rings.size())
		$Landscape.get_surface_override_material(i).next_pass.set_shader_parameter("range_positions", range_rings)
		$Landscape.get_surface_override_material(i).next_pass.set_shader_parameter("range_radiuses", range_ring_radiuses)


func _process(_delta):
	var landscape_colorations : Array[Vector3] = []
	var landscape_coloration_radiuses : Array[float] = []
	var landscape_coloration_fades : Array[float] = []
	var landscape_coloration_colors : Array[Color] = []

	var marked_for_removal = []
	for landscape_coloration : LandscapeColoration in TerrainShaderParams.landscape_colorations:
		landscape_coloration.fade += landscape_coloration.fade_progression
		if landscape_coloration.fade <= 1.0:
			landscape_colorations.append(landscape_coloration.position)
			landscape_coloration_radiuses.append(landscape_coloration.radius)
			landscape_coloration_fades.append(landscape_coloration.fade)
			landscape_coloration_colors.append(landscape_coloration.color)
		else:
			marked_for_removal.append(landscape_coloration)

	for lc : LandscapeColoration in marked_for_removal:
		TerrainShaderParams.drop_landscape_coloration(lc)

	for i in range($Landscape.get_surface_override_material_count()):
		$Landscape.get_surface_override_material(i).next_pass.next_pass.set_shader_parameter("range_positions", landscape_colorations)
		$Landscape.get_surface_override_material(i).next_pass.next_pass.set_shader_parameter("range_radiuses", landscape_coloration_radiuses)
		$Landscape.get_surface_override_material(i).next_pass.next_pass.set_shader_parameter("range_colors", landscape_coloration_colors)
		$Landscape.get_surface_override_material(i).next_pass.next_pass.set_shader_parameter("fades", landscape_coloration_fades)
		$Landscape.get_surface_override_material(i).next_pass.next_pass.set_shader_parameter("num_active_circles", landscape_colorations.size())


func _ready():
	TerrainShaderParams.range_rings_changed.connect(_on_range_rings_changed)
	$Landscape/StaticBody3D.add_to_group(Constants.GROUP_NAME_TERRAIN)
