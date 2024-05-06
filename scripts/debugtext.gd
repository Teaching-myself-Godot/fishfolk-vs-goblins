extends Label


func _process(_delta):
	var monster : BaseMonster = get_tree().get_first_node_in_group(Constants.GROUP_NAME_MONSTERS)
	if monster and is_instance_valid(monster):
		text = str(monster.position) + " / " + str(monster.target.position)
