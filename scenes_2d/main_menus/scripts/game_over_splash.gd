class_name GameOverSplash
extends Sprite2D


signal close_gameover_splash();


func _ready():
	get_tree().get_root().size_changed.connect(_on_resize)
	_on_resize()


func _unhandled_input(_event):
	if not visible:
		return

	if InputUtil.is_just_released("start") or InputUtil.is_just_released("confirm"):
		close_gameover_splash.emit()


func _on_resize():
	texture.width = get_viewport().size.x
	texture.height = get_viewport().size.y
	$Label.size = get_viewport().size

