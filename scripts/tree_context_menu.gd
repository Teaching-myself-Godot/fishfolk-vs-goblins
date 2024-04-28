extends Control

var is_open = false

func show_at(pos : Vector2):
	position = pos
	visible = true

func close_and_hide():
	close()
	visible = false

func open():
	is_open = true
	$HighlightCircle.visible = false

func close():
	is_open = false
	$HighlightCircle.visible = true
