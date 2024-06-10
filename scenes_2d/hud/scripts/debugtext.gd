extends Control

func _ready():
	get_tree().get_root().size_changed.connect(_on_resize)
	_on_resize()

func _process(_delta):
	$debugtext.text = str(InputUtil.cids_registered)

func _on_resize():
	$debugtext.size.x = get_viewport().size.x
	$overlay.texture.width =  get_viewport().size.x
