extends Control


func _process(_delta):
	var monsters = get_tree().get_nodes_in_group(Constants.GROUP_NAME_MONSTERS)
	$debugtext.text = str(Engine.get_frames_per_second()) + " fps  - "  + str(monsters.size()) + " monsters - " + str(CameraUtil.get_cam().zoom) + " zoom"

