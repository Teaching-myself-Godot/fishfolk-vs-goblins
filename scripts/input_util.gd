extends Node

enum ControllerID {
	KEYBOARD,
	GAMEPAD_1,
	GAMEPAD_2,
	GAMEPAD_3,
	GAMEPAD_4,
	NONE
}

var _player_names := {}

var cids_registered = []


func player_map():
	var mp = {}
	for i in range(cids_registered.size()):
		mp[cids_registered[i]] = i + 1
	return mp


func get_player_name(cid : ControllerID):
	if cid in player_map():
		if player_map()[cid] in _player_names and not _player_names[player_map()[cid]].is_empty():
			return _player_names[player_map()[cid]]
		return str(player_map()[cid]) + "p"
	return str(cid) + "p"


func set_player_name(cid : ControllerID, new_name : String):
	if cid in player_map():
		_player_names[player_map()[cid]] = new_name


func is_just_released(basename : String) -> bool:
	return (
		Input.is_action_just_released(basename + "-k")
			or Input.is_action_just_released(basename + "-0")
			or Input.is_action_just_released(basename + "-1")
			or Input.is_action_just_released(basename + "-2")
			or Input.is_action_just_released(basename + "-3")
	)


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


func _unhandled_input(_event):
	var pressed_ids = get_pressed_ids("start")
	for cid in pressed_ids:
		if cid not in cids_registered:
			cids_registered.append(cid)
