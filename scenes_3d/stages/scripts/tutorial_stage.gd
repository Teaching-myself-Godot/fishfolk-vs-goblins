class_name TutorialStage

extends Stage

var MainGame = preload("res://goblins_vs_fishfolk.tscn")

enum TutorialMode { KEYBOARD, GAMEPAD }

var message_suite = {
	TutorialMode.KEYBOARD: [
		"To RUN, use arrow-buttons or 'w', 'a', 's', 'd'",
		"Up to 4 gamepads can join the keyboard player",
		"To JUMP, press SPACEBAR",
		"To ZOOM and LOOK AROUND, click and drag MOUSEWHEEL"
	],
	TutorialMode.GAMEPAD: [
		"To RUN, use L-stick",
		"Up to 4 gamepads can join and one keyboard player",
		"To JUMP, press A (Nintendo B)",
		"To ZOOM and LOOK AROUND, use R-stick"
	]
}

var mode : TutorialMode
var main_player_cid : InputUtil.ControllerID

var check_running = true
var check_jumping = true

func _process(delta):
	if not main_player_cid in goblin_map:
		return

	if check_running:
		var pos = goblin_map[main_player_cid].position
		if pos.x != 0 or pos.z != 0:
			check_running = false
			_mk_toast(message_suite[mode][2], 10.0, true)
	elif check_jumping:
		if InputUtil.is_just_released("jump"):
			check_jumping = false
			_mk_toast(message_suite[mode][3], 10.0, true)

func _add_goblin_to_scene(num : int, start_pos : Vector3 = Vector3(0, 4, 0)):
	super._add_goblin_to_scene(num, start_pos)

	if InputUtil.player_map.size() == 0:
		main_player_cid = num

	if InputUtil.player_map.size() == 1:
		if num == InputUtil.ControllerID.KEYBOARD:
			mode = TutorialMode.KEYBOARD
		else:
			mode = TutorialMode.GAMEPAD
		_mk_toast(message_suite[mode][0], 10.0, true)
	else:
		_mk_toast(message_suite[mode][1], 10.0, true)



func _ready():
	super._ready()
	_mk_toast("To JOIN, press either gamepad START or keyboard SPACEBAR", 4, true)


func _on_open_pause_menu():
	# TODO confirm end tutorial in pause mode
	get_tree().change_scene_to_packed(MainGame)
