extends Label


func _process(_delta):
	var monsters = get_tree().get_nodes_in_group(Constants.GROUP_NAME_MONSTERS)
	text = str(Engine.get_frames_per_second()) + " fps  - "  + str(monsters.size()) + " monsters - " + str(Globals.landscape_colorations.size()) + " landscape coloration rings"
