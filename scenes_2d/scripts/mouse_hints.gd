class_name MouseHints
extends HintsBase

enum MouseHint {
	NONE, LEFT_CLICK, RIGHT_CLICK, WHEEL_CLICK, WHEEL_ZOOM, WHEEL_ROTATE
}

@export var current_hint : MouseHint = MouseHint.NONE


func _get_hint_icon() -> Control:
	match current_hint:
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

