extends Area3D

func _ready():
	$MeshInstance3D.hide()

func _on_area_entered(maybe_monster):
	if maybe_monster.is_in_group(Constants.GROUP_NAME_MONSTERS):
		maybe_monster.attack(
			get_tree()
				.get_first_node_in_group(Constants.GROUP_NAME_CRIBS)
		)
