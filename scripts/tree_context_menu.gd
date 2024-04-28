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
	$BButton.hide()
	$AButton.show()
	$MenuArrow.show()
	$BackdropCircle.show()

func rotate_arrow(angle : float):
	$MenuArrow.rotation = angle

func close():
	is_open = false
	$BButton.show()
	$AButton.hide()
	$MenuArrow.hide()
	$BackdropCircle.hide()
