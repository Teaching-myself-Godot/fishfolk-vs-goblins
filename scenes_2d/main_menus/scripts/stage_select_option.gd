class_name StageSelectOption
extends Button

signal select_stage(my_stage : PackedScene, description : String)

@export var my_stage : PackedScene
@export_multiline var description := "[Enter a stage description here]"

func _on_focus_entered():
	select_stage.emit(my_stage, description)
	$BButton.show()


func _on_focus_exited() -> void:
	$BButton.hide()


func _on_mouse_entered() -> void:
	grab_focus()
