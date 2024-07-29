class_name Tutorial

extends Stage

enum TutorialMode { KEYBOARD, GAMEPAD }

var mode : TutorialMode
var main_player_cid : InputUtil.ControllerID
var first_wave : MonsterWave


var _awaiting_goblin = true
var _goblin : Goblin = null
var _keyboard_hints = [
	KeyboardHints.KeyboardHint.W,
	KeyboardHints.KeyboardHint.A,
	KeyboardHints.KeyboardHint.S,
	KeyboardHints.KeyboardHint.D,
	KeyboardHints.KeyboardHint.SPACE
]
var _next_hint_timer_running = false


func _process(_delta):
	if not main_player_cid in goblin_map:
		return

	if _awaiting_goblin:
		_goblin = goblin_map[main_player_cid]
		_awaiting_goblin = false
		$TutorialPlaybook/GoblinIndicator.target = _goblin
		$TutorialPlaybook/GoblinIndicator.start()
		if mode == TutorialMode.KEYBOARD:
			$TutorialPlaybook/ShowKeyboardHintsTimer.start()

	if (
		mode == TutorialMode.KEYBOARD and
		not _is_current_keyboard_hint(KeyboardHints.KeyboardHint.NONE)
	):
		if (
			_should_show_next_keyboard_hint(KeyboardHints.KeyboardHint.W, KEY_W) or
			_should_show_next_keyboard_hint(KeyboardHints.KeyboardHint.A, KEY_A) or
			_should_show_next_keyboard_hint(KeyboardHints.KeyboardHint.S, KEY_S) or
			_should_show_next_keyboard_hint(KeyboardHints.KeyboardHint.D, KEY_D) or
			_should_show_next_keyboard_hint(KeyboardHints.KeyboardHint.SPACE, KEY_SPACE)
		):
			_next_hint_timer_running = true
			$TutorialPlaybook/ShowNextKeyboardHintTimer.start()


func _should_show_next_keyboard_hint(kh : KeyboardHints.KeyboardHint, kp : int) -> bool:
	if _next_hint_timer_running:
		return false
	return Input.is_key_pressed(kp) and _is_current_keyboard_hint(kh)


func _is_current_keyboard_hint(k : KeyboardHints.KeyboardHint) -> bool:
	return $TutorialPlaybook/KeyboardHints.current_hint == k


func _add_goblin_to_scene(num : int, start_pos : Vector3 = Vector3(-15, 5, 11)):
	super._add_goblin_to_scene(num, start_pos)

	if InputUtil.player_map.size() == 1:
		main_player_cid = num as InputUtil.ControllerID
		if num == InputUtil.ControllerID.KEYBOARD:
			mode = TutorialMode.KEYBOARD
		else:
			mode = TutorialMode.GAMEPAD

		for tree in get_tree().get_nodes_in_group(Constants.GROUP_NAME_TREES):
			tree.remove_from_group(Constants.GROUP_NAME_TREES)


func _show_next_keyboard_hint():
	_next_hint_timer_running = false
	if _keyboard_hints.is_empty():
		$TutorialPlaybook/KeyboardHints.current_hint = KeyboardHints.KeyboardHint.NONE
		$TutorialPlaybook/KeyboardHints.fading = true
	else:
		$TutorialPlaybook/KeyboardHints.current_hint = _keyboard_hints.pop_front()
		#$TutorialPlaybook/ShowNextKeyboardHintTimer.start()


func _ready():
	super._ready()
	first_wave = $MonsterSpawner/ChibiWave1
	$GemPouch.remove_from_group(Constants.GROUP_NAME_HUD_ITEM)


func _on_goblin_indicator_done() -> void:
	$TutorialPlaybook/BabyIndicator.start()


func _on_baby_indicator_done() -> void:
	$TutorialPlaybook/FishfolkArrivalIndicator.start()


func _on_show_keyboard_hints_timer_timeout() -> void:
	$TutorialPlaybook/KeyboardHints.fading = false
	$TutorialPlaybook/ShowNextKeyboardHintTimer.start()
