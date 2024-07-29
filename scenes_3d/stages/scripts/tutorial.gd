class_name Tutorial

extends Stage

enum TutorialMode { KEYBOARD, GAMEPAD }

var mode : TutorialMode
var main_player_cid : InputUtil.ControllerID
var first_wave : MonsterWave


var _awaiting_goblin = true
var _goblin : Goblin = null
var _keyboard_run_hints = [
	KeyboardHints.KeyboardHint.S,
	KeyboardHints.KeyboardHint.A,
	KeyboardHints.KeyboardHint.W,
	KeyboardHints.KeyboardHint.D
]
var _next_hint_timer_running = false
var _awaiting_jump_hint = true
var _awaiting_jump = false


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

	if mode == TutorialMode.KEYBOARD:
		if not _is_current_keyboard_hint(KeyboardHints.KeyboardHint.NONE) and (
			_should_show_next_keyboard_hint(KeyboardHints.KeyboardHint.W, KEY_W) or
			_should_show_next_keyboard_hint(KeyboardHints.KeyboardHint.A, KEY_A) or
			_should_show_next_keyboard_hint(KeyboardHints.KeyboardHint.S, KEY_S) or
			_should_show_next_keyboard_hint(KeyboardHints.KeyboardHint.D, KEY_D)
		):
			_next_hint_timer_running = true
			$TutorialPlaybook/ShowNextKeyboardHintTimer.start()

		if _awaiting_jump_hint and Input.get_vector("a", "d", "w", "s") and not _goblin.velocity:
			_awaiting_jump = true
			_awaiting_jump_hint = false
			$TutorialPlaybook/KeyboardHints.current_hint = KeyboardHints.KeyboardHint.SPACE
		if _awaiting_jump and Input.is_key_pressed(KEY_SPACE):
			_awaiting_jump = false
			$TutorialPlaybook/KeyboardHints.current_hint = KeyboardHints.KeyboardHint.NONE
			$TutorialPlaybook/KeyboardHints.fading = true

	if (
		not $TutorialPlaybook/BabyIndicator.fading
		and _goblin.position.distance_to($TutorialPlaybook/BabyIndicator.target.position) <
				$TutorialPlaybook/BabyIndicator.radius_3d
	):
		$TutorialPlaybook/BabyIndicator.finish()


func _should_show_next_keyboard_hint(kh : KeyboardHints.KeyboardHint, kp : int) -> bool:
	if _next_hint_timer_running:
		return false
	return Input.is_key_pressed(kp) and _is_current_keyboard_hint(kh)


func _is_current_keyboard_hint(k : KeyboardHints.KeyboardHint) -> bool:
	return $TutorialPlaybook/KeyboardHints.current_hint == k


func _add_goblin_to_scene(num : int, _start_pos : Vector3 = Vector3.ZERO):
	super._add_goblin_to_scene(num, $GoblinSpawnPoint.position)

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
	if _keyboard_run_hints.is_empty():
		$TutorialPlaybook/KeyboardHints.current_hint = KeyboardHints.KeyboardHint.NONE
	else:
		$TutorialPlaybook/KeyboardHints.current_hint = _keyboard_run_hints.pop_front()


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
