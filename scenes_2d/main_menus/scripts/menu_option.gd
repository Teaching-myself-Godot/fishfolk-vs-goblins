class_name MenuOption
extends Label


func _on_focus_entered():
	$BButton.show()
	modulate = Color(1, 1, 1, 1)


func _on_focus_exited():
	$BButton.hide()
	modulate = Color(1, 1, 1, 0.4)


func _on_mouse_entered():
	grab_focus()
