extends Node

enum ControllerID {
	NONE,
	KEYBOARD,
	GAMEPAD_1,
	GAMEPAD_2,
	GAMEPAD_3,
	GAMEPAD_4
}

func is_just_released(basename : String) -> bool:
	return (
		Input.is_action_just_released(basename + "-k")
			or Input.is_action_just_released(basename + "-0")
			or Input.is_action_just_released(basename + "-1")
			or Input.is_action_just_released(basename + "-2")
			or Input.is_action_just_released(basename + "-3")
	)

func get_just_released_id(basename : String) -> ControllerID:
	if Input.is_action_just_released(basename + "-k"):
		return ControllerID.KEYBOARD

	if Input.is_action_just_released(basename + "-0"):
		return ControllerID.GAMEPAD_1

	if Input.is_action_just_released(basename + "-1"):
		return ControllerID.GAMEPAD_2

	if Input.is_action_just_released(basename + "-2"):
		return ControllerID.GAMEPAD_3

	if Input.is_action_just_released(basename + "-3"):
		return ControllerID.GAMEPAD_4

	return ControllerID.NONE
