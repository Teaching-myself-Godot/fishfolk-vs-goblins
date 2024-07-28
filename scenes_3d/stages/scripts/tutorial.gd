class_name Tutorial

extends Stage

enum TutorialMode { KEYBOARD, GAMEPAD }

var mode : TutorialMode
var main_player_cid : InputUtil.ControllerID
var first_wave : MonsterWave


var _awaiting_goblin = true
var _goblin : Goblin = null


func _process(_delta):
	if not main_player_cid in goblin_map:
		return

	if _awaiting_goblin:
		_goblin = goblin_map[main_player_cid]
		_awaiting_goblin = false
		$TutorialPlaybook/GoblinIndicator.target = _goblin
		$TutorialPlaybook/GoblinIndicator.start()
		$TutorialPlaybook/ShowKeyboardHintsTimer.start()

func _add_goblin_to_scene(num : int, start_pos : Vector3 = Vector3(-15, 5, 11)):
	super._add_goblin_to_scene(num, start_pos)

	if InputUtil.player_map.size() == 1:
		_hide_help_message()
		main_player_cid = num as InputUtil.ControllerID
		if num == InputUtil.ControllerID.KEYBOARD:
			mode = TutorialMode.KEYBOARD
		else:
			mode = TutorialMode.GAMEPAD

		for tree in get_tree().get_nodes_in_group(Constants.GROUP_NAME_TREES):
			tree.remove_from_group(Constants.GROUP_NAME_TREES)


func _hide_help_message():
	for toasted : Toast in (
			get_tree().get_nodes_in_group(Constants.GROUP_NAME_TOASTS)
	):
		toasted.fading = true


func _show_help_message(text : String):
	var toast : Toast = _mk_toast(
			text,
			100,
			true
	)
	toast.set_anchors_preset(Control.PRESET_CENTER)


func _ready():
	super._ready()
	first_wave = $MonsterSpawner/ChibiWave1
	$GemPouch.remove_from_group(Constants.GROUP_NAME_HUD_ITEM)


func _on_goblin_indicator_done() -> void:
	$TutorialPlaybook/BabyIndicator.start()


func _on_baby_indicator_done() -> void:
	$TutorialPlaybook/FishfolkArrivalIndicator.start()


func _on_show_keyboard_hints_timer_timeout() -> void:
	$TutorialPlaybook/KeyboardHints.show()
