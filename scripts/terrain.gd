extends MeshInstance3D

var tree_locations:PackedVector3Array = []

func _ready():
	var trees = get_tree().get_nodes_in_group("trees")
	for t in trees:
		if tree_locations.size() < 60:
			tree_locations.append(t.position)
			
func _process(_delta):
	$Plane.get_surface_override_material(0).next_pass.set("shader_parameter/range_positions", tree_locations)
	$Plane.get_surface_override_material(0).next_pass.set("shader_parameter/num_active_circles", tree_locations.size())
