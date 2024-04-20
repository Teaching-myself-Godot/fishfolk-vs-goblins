extends Label



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var goblins = get_tree().get_nodes_in_group("goblins")
	var pos1 = goblins[0].position
	var pos2 = goblins[1].position
	var pos3 = goblins[2].position
	var goblin_center = (pos1 + pos2 + pos3) / 3
	var d = max(pos2.distance_to(goblin_center), max(pos1.distance_to(goblin_center), pos3.distance_to(goblin_center)))

	var camera = get_tree().get_first_node_in_group("cam")
	text = str(d) + " - " + str(camera.position.y)
