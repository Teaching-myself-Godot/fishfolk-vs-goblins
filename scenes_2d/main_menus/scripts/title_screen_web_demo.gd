extends Sprite2D

signal start()

func _on_button_button_up() -> void:
	start.emit()


func _on_resize():
	texture.width = get_viewport().size.x
	texture.height = get_viewport().size.y
	$Splash.position = get_viewport().size / 2


func _ready() -> void:
	get_tree().get_root().size_changed.connect(_on_resize)
	_on_resize()
