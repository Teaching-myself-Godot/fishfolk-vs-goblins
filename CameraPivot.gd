extends Node3D




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var goblins = get_tree().get_nodes_in_group("goblins")
	var pos1 = goblins[0].position
	var pos2 = goblins[1].position
	var pos3 = goblins[2].position
	var goblin_center = (pos1 + pos2 + pos3) / 3
	position.x = goblin_center.x
	position.z = goblin_center.z
	var d = max(pos1.distance_to(goblin_center), max(pos2.distance_to(goblin_center), pos3.distance_to(goblin_center)))
	
	position.y = 6 + d*3 - 9 if d > 3 else 6
