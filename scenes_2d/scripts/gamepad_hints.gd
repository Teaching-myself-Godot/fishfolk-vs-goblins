class_name GamepadHints
extends HintsBase

enum GamepadIcons {
	NONE, L_STICK_UP, L_STICK_LEFT, L_STICK_RIGHT, L_STICK_DOWN, A_PRESSED,
	R_STICK_UP, R_STICK_LEFT, R_STICK_RIGHT, R_STICK_DOWN
}

@export var current_icon : GamepadIcons = GamepadIcons.NONE

func _get_hint_icon() -> Control:
	match current_icon:
		GamepadIcons.L_STICK_UP:
			return $LStickUp
		GamepadIcons.L_STICK_LEFT:
			return $LStickLeft
		GamepadIcons.L_STICK_RIGHT:
			return $LStickRight
		GamepadIcons.L_STICK_DOWN:
			return $LStickDown
		GamepadIcons.A_PRESSED:
			return $APressed
		GamepadIcons.R_STICK_UP:
			return $RStickUp
		GamepadIcons.R_STICK_LEFT:
			return $RStickLeft
		GamepadIcons.R_STICK_RIGHT:
			return $RStickRight
		GamepadIcons.R_STICK_DOWN:
			return $RStickDown
		GamepadIcons.NONE:
			return $"Gamepad-base"
		_:
			return $"Gamepad-base"
