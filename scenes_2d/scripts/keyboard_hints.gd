class_name KeyboardHints
extends HintsBase

enum KeyboardHint {
	NONE, W, A, S, D, SHIFT, SPACE, ESC
}

@export var current_hint : KeyboardHint = KeyboardHint.NONE


func _get_hint_icon() -> Control:
	match current_hint:
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
