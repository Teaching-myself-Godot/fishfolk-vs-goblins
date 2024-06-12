extends Area3D

func _ready():
	$MeshInstance3D.hide()

func _on_area_entered(maybe_monster):
	if maybe_monster.is_in_group(Constants.GROUP_NAME_MONSTERS):
		for crib : Crib in get_tree().get_nodes_in_group(Constants.GROUP_NAME_CRIBS):
			if not is_instance_valid(crib.my_attacker) and crib.visible:
				maybe_monster.attack(crib)
				crib.my_attacker = maybe_monster
				return
		# if no crib not being attacked was found, just go away
		queue_free()
