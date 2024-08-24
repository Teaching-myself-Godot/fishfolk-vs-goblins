class_name StageSelectOption
extends Button

signal select_stage(my_stage : PackedScene)

@export var my_stage : PackedScene


func _on_focus_entered():
	select_stage.emit(my_stage)
	$BButton.show()


func _on_focus_exited() -> void:
	$BButton.hide()
