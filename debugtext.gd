extends Label

func _process(_delta):
	var goblins = get_tree().get_nodes_in_group("goblins")
	text = ""
	for g in goblins:
		text += " " + str(g.speed)
	pass
