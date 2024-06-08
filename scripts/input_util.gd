extends Node

enum ControllerID {
	KEYBOARD,
	GAMEPAD_1,
	GAMEPAD_2,
	GAMEPAD_3,
	GAMEPAD_4,
	NONE
}

const ACTION_NAMES = [
	"confirm",
	"jump",
	"cancel",
	"start",
	"quit"
]

const SUPPORTED_CONTROLLERS = [
	ControllerID.KEYBOARD,
	ControllerID.GAMEPAD_1,
	ControllerID.GAMEPAD_2,
	ControllerID.GAMEPAD_3,
	ControllerID.GAMEPAD_4
]

const MAX_RECORD_TIME = 200

var player_map = {}

var input_map = {
}

func get_player_name(cid : ControllerID):
	if cid in player_map:
		return str(player_map[cid]) + "p"
	return str(cid) + "p"


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


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func get_pressed_ids(basename : String) -> Array:
	var result = []
	if Input.is_action_pressed(basename + "-k"):
		result.append(ControllerID.KEYBOARD)
	if Input.is_action_pressed(basename + "-0"):
		result.append(ControllerID.GAMEPAD_1)
	if Input.is_action_pressed(basename + "-1"):
		result.append(ControllerID.GAMEPAD_2)
	if Input.is_action_pressed(basename + "-2"):
		result.append(ControllerID.GAMEPAD_3)
	if Input.is_action_pressed(basename + "-3"):
		result.append(ControllerID.GAMEPAD_4)
	return result


func _process(_delta):
	for action_name in ACTION_NAMES:
		var pressed_ids = get_pressed_ids(action_name)
		for cid in SUPPORTED_CONTROLLERS:
			if cid in pressed_ids:
				input_map[cid] = input_map[cid] if cid in input_map else {}
				input_map[cid][action_name] = (
					input_map[cid][action_name] if action_name in input_map[cid] else 0
				)
				if input_map[cid][action_name] < 0:
					input_map[cid][action_name] = 0
				input_map[cid][action_name] += (
					1 if input_map[cid][action_name] < MAX_RECORD_TIME else 0
				)
			else:
				if cid in input_map and action_name in input_map[cid]:
					if input_map[cid][action_name] > 0:
						input_map[cid][action_name] = 0
					input_map[cid][action_name] -= (
						1 if input_map[cid][action_name] > -MAX_RECORD_TIME else 0
					)
