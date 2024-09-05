extends Control

func _ready():
	get_tree().get_root().size_changed.connect(_on_resize)
	_on_resize()


func _process(_delta):
	$debugtext.text = (
		"monsters = " + str(get_tree().get_nodes_in_group(Constants.GROUP_NAME_MONSTERS).size()) + " " +
		"trees = " + str(get_tree().get_nodes_in_group(Constants.GROUP_NAME_TREES).size()) + " " +
		"towers = " + str(get_tree().get_nodes_in_group(Constants.GROUP_NAME_TOWERS).size()) + " " +
		"fps = " + str(Engine.get_frames_per_second()) + " " +
		"viewport = " + str(get_viewport().size) + " " +
		"player_map() = " + str(InputUtil.player_map()) + " " + 
		"cids_registered = " + str(InputUtil.cids_registered)
	)


func _unhandled_input(_event):
	if Input.is_action_just_pressed("open_debug"):
		if visible:
			hide()
		else:
			show()


func _on_resize():
	$debugtext.size.x = get_viewport().size.x
	$overlay.texture.width =  get_viewport().size.x
