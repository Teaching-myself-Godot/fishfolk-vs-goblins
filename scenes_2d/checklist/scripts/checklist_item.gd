extends Control

@export var informative_text : String = ""

func set_checked(flag : bool) -> void:
	if flag:
		$Checkmark.show()
		modulate.a = 1.0
		$Outline.modulate.a = 1.0
		grab_focus()
	else:
		$Checkmark.hide()
		modulate.a = 0.7
		$Outline.modulate.a = 0.7


func _ready() -> void:
	set_checked(false)
	$InfoText.text = informative_text
	$InfoText.hide()


func _on_checklist_box_toggled(toggled_on: bool) -> void:
	set_checked(toggled_on)


func _on_mouse_entered() -> void:
	if get_tree().paused:
		$InfoText.show()


func _on_mouse_exited() -> void:
	$InfoText.hide()

