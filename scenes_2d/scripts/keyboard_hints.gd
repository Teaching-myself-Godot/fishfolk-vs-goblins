class_name KeyboardHints
extends MarginContainer

enum KeyboardHint {
	NONE, W, A, S, D, SHIFT, SPACE, ESC
}

@export var fading : bool = true
@export var current_hint : KeyboardHint = KeyboardHint.NONE


func _get_hint_icon(for_hint : KeyboardHint) -> Control:
	match for_hint:
		KeyboardHint.W:
			return $"W-down"
		KeyboardHint.A:
			return $"A-down"
		KeyboardHint.S:
			return $"S-down"
		KeyboardHint.D:
			return $"D-down"
		KeyboardHint.SPACE:
			return $"Space-down"
		KeyboardHint.SHIFT:
			return $"Shift-down"
		KeyboardHint.ESC:
			return $"Esc-down"
		KeyboardHint.NONE:
			return $"Keyboard-base"
		_:
			return $"Keyboard-base"


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
