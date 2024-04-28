extends Control

var is_open = false

func show_at(pos : Vector2):
	position = pos
	visible = true

func close_and_hide():
	is_open = false
	visible = false

func open():
	is_open = true

func close():
	is_open = false
