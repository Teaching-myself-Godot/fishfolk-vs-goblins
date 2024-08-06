class_name MouseHints
extends MarginContainer

enum MouseHint {
	NONE, LEFT_CLICK, RIGHT_CLICK, WHEEL_CLICK, WHEEL_ZOOM, WHEEL_ROTATE
}

@export var fading : bool = true
@export var current_hint : MouseHint = MouseHint.NONE


func _get_hint_icon(for_hint : MouseHint) -> Control:
	match for_hint:
		MouseHint.LEFT_CLICK:
			return $"Left-click"
		MouseHint.RIGHT_CLICK:
			return $"Right-click"
		MouseHint.WHEEL_CLICK:
			return $"Wheel-click"
		MouseHint.WHEEL_ZOOM:
			return $"Wheel-hold-and-zoom"
		MouseHint.WHEEL_ROTATE:
			return $"Wheel-hold-and-rotate"
		MouseHint.NONE:
			return $MouseBase
		_:
			return $MouseBase


func _process(_delta: float) -> void:
	var current_hint_icon = _get_hint_icon(current_hint)

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
