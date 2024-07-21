extends Control

@export var checked : bool = false

func _process(_delta: float) -> void:
	if checked:
		$ChecklistBox/Checkmark.show()
		$Text.modulate.a = 1.0
		$ChecklistBox/Outline.modulate.a = 1.0
		$ChecklistBox/Fill.modulate = Color.GREEN
	else:
		$ChecklistBox/Checkmark.hide()
		$Text.modulate.a = 0.7
		$ChecklistBox/Outline.modulate.a = 0.7
		$ChecklistBox/Fill.modulate = Color.BLACK
