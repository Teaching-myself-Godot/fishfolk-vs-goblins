class_name HintsBase
extends MarginContainer

@export var fading : bool = true


func _get_hint_icon() -> Control:
	printerr("_get_hint_icon must be overridden")
	return null


func _process(_delta: float) -> void:
	var current_hint_icon = _get_hint_icon()

	for hint in get_children():
		if hint != current_hint_icon and hint.modulate.a > 0:
			hint.modulate.a -= 0.125

	if current_hint_icon.modulate.a < 1:
		current_hint_icon.modulate.a += 0.25

	if fading:
		if modulate.a > 0.0:
			modulate.a -= 0.05
		else:
			hide()
	else:
		show()
		if modulate.a < 1.0:
			modulate.a += 0.05


func _ready() -> void:
	modulate.a = 0
