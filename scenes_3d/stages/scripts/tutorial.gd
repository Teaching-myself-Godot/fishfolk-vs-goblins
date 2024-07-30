class_name Tutorial

extends Stage

const LONG_INDICATOR_TIME = 100

enum TutorialMode { KEYBOARD, GAMEPAD }

var mode : TutorialMode
var main_player_cid : InputUtil.ControllerID
var first_wave : MonsterWave


var _awaiting_goblin = true
var _next_hint_timer_running = false

var _goblin : Goblin = null
var _keyboard_run_hints = [
	KeyboardHints.KeyboardHint.S,
	KeyboardHints.KeyboardHint.A,
	KeyboardHints.KeyboardHint.W,
	KeyboardHints.KeyboardHint.D
]
var _awaiting_jump_hint = true
var _awaiting_jump = false

var _mouse_hints = [
	MouseHints.MouseHint.WHEEL_CLICK,
	MouseHints.MouseHint.WHEEL_ROTATE,
	MouseHints.MouseHint.WHEEL_ZOOM
]
var _awaiting_wheel_click = false
var _awaiting_wheel_rotate = false
var _awaiting_wheel_zoom = false
var _init_zoom = null
var _init_rot = 0.0

var _awaiting_goblin_reaches_tree = true
var _tree_menu : TreeContextMenu = null
var _awaiting_tree_menu = true
var _awaiting_tree_sub_menu = false


func _process(_delta):
	if not main_player_cid in goblin_map:
		return

	if _awaiting_goblin:
		_goblin = goblin_map[main_player_cid]
		_tree_menu = _goblin.find_child("TreeContextMenu")
		_awaiting_goblin = false
		$TutorialPlaybook/GoblinIndicator.target = _goblin
		$TutorialPlaybook/GoblinIndicator.start(8)
		_init_zoom = CameraUtil.get_cam().zoom
		_init_rot = CameraUtil.get_cam_pivot().rotation.y
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
		if _awaiting_wheel_click and Input.is_action_just_pressed("mousewheel_click"):
			_awaiting_wheel_click = false
			_awaiting_wheel_rotate = true
			_next_hint_timer_running = true
			$TutorialPlaybook/ShowNextMouseHintTimer.start()
		if (
			_awaiting_wheel_rotate and not _next_hint_timer_running and
			abs(_init_rot - CameraUtil.get_cam_pivot().rotation.y) > 0.1
		):
			_awaiting_wheel_rotate = false
			_awaiting_wheel_zoom = true
			_init_zoom = CameraUtil.get_cam().zoom
			_next_hint_timer_running = true
			$TutorialPlaybook/ShowNextMouseHintTimer.start()
		if (
			_awaiting_wheel_zoom and not _next_hint_timer_running and
			abs(CameraUtil.get_cam().zoom - _init_zoom) > 3.0
		):
			_awaiting_wheel_zoom = false
			_next_hint_timer_running = true
			$TutorialPlaybook/ShowNextMouseHintTimer.start()

	if (
		not $TutorialPlaybook/BabyIndicator.fading
		and _goblin.position.distance_to($TutorialPlaybook/BabyIndicator.target.position) <
				$TutorialPlaybook/BabyIndicator.radius_3d
	):
		$TutorialPlaybook/BabyIndicator.finish()

	if (
		not $TutorialPlaybook/FishfolkArrivalIndicator.fading
		and _goblin.position.distance_to($TutorialPlaybook/FishfolkArrivalIndicator.target.position) <
				$TutorialPlaybook/FishfolkArrivalIndicator.radius_3d
	):
		$TutorialPlaybook/FishfolkArrivalIndicator.finish()

	if (
		_awaiting_goblin_reaches_tree and
		not $TutorialPlaybook/TreeIndicator.fading
		and _goblin.position.distance_to($TutorialPlaybook/TreeIndicator.target.position) <
				$TutorialPlaybook/TreeIndicator.radius_3d
	):
		_awaiting_goblin_reaches_tree = false
		$TutorialPlaybook/TreeIndicator.finish()
		if mode == TutorialMode.KEYBOARD:
			$TutorialPlaybook/ToggleMouseHintClickTimer.start()
			$TutorialPlaybook/MouseHints.fading = false

	if _awaiting_tree_menu and _tree_menu.is_open:
		_awaiting_tree_menu = false
		_awaiting_tree_sub_menu = true
		$TutorialPlaybook/MouseHints.current_hint = MouseHints.MouseHint.NONE
		$TutorialPlaybook/ToggleMouseHintClickTimer.start()

	if (
		_awaiting_tree_sub_menu and _tree_menu.is_open and
		_tree_menu.current_menu != TreeContextMenu.MAIN_MENU_NAME
	):
		_awaiting_tree_sub_menu = false
		$TutorialPlaybook/MouseHints.current_hint = MouseHints.MouseHint.NONE
		$TutorialPlaybook/RightMouseClickHintTimer.start()
		$TutorialPlaybook/BuilderGemIndicator.start(LONG_INDICATOR_TIME)
		for _i in range(10):
			_on_drop_builder_gem(
				$TutorialPlaybook/BuilderGemIndicator.target.position
			)


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


func _show_next_mouse_hint():
	_next_hint_timer_running = false
	if _mouse_hints.is_empty():
		$TutorialPlaybook/MouseHints.current_hint = MouseHints.MouseHint.NONE
		$TutorialPlaybook/MouseHints.fading = true
	else:
		$TutorialPlaybook/MouseHints.current_hint = _mouse_hints.pop_front()


func _ready():
	super._ready()
	first_wave = $MonsterSpawner/ChibiWave1
	$GemPouch.remove_from_group(Constants.GROUP_NAME_HUD_ITEM)


func _on_goblin_indicator_done() -> void:
	$TutorialPlaybook/BabyIndicator.start(LONG_INDICATOR_TIME)


func _on_baby_indicator_done() -> void:
	$TutorialPlaybook/FishfolkArrivalIndicator.start(LONG_INDICATOR_TIME)
	$TutorialPlaybook/MouseHints.fading = false
	$TutorialPlaybook/ShowNextMouseHintTimer.start()
	_awaiting_wheel_click = true


func _on_show_keyboard_hints_timer_timeout() -> void:
	$TutorialPlaybook/KeyboardHints.fading = false
	$TutorialPlaybook/ShowNextKeyboardHintTimer.start()


func _on_fishfolk_arrival_indicator_done() -> void:
	$TutorialPlaybook/TreeIndicator.start(LONG_INDICATOR_TIME)
	$TutorialPlaybook/TreeIndicator.target.add_to_group(Constants.GROUP_NAME_TREES)



func _on_toggle_mouse_hint_click_timer_timeout() -> void:
	$TutorialPlaybook/MouseHints.current_hint = (
		MouseHints.MouseHint.NONE if $TutorialPlaybook/MouseHints.current_hint == MouseHints.MouseHint.LEFT_CLICK
		else MouseHints.MouseHint.LEFT_CLICK
	)


func _on_right_mouse_click_hint_timer_timeout() -> void:
	$TutorialPlaybook/MouseHints.current_hint = MouseHints.MouseHint.RIGHT_CLICK
