extends Control

func _ready():
	get_tree().get_root().size_changed.connect(_on_resize)
	_on_resize()


func _process(_delta):
	$debugtext.text = (
		"The Web Demo is _not_ optimized for the web! You can download the .exe or linux binary here for free! (fps: " + str(Engine.get_frames_per_second()) + ")"
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
