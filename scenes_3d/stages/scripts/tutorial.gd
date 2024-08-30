class_name Tutorial

extends Stage

const LONG_INDICATOR_TIME = 100
const MEDIUM_INDICATOR_TIME = 16
const SHORT_INDICATOR_TIME = 8

enum TutorialMode { KEYBOARD, GAMEPAD }

var mode : TutorialMode
var main_player_cid : InputUtil.ControllerID
var first_wave : MonsterWave

var _already_entered = false
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
var _awaiting_sprint = false


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
var _awaiting_tree_menu_closed = false

var _awaiting_goblin_reaches_gems = true
var _awaiting_first_wave = true
var _awaiting_arrow_tower = true
var _awaiting_magical_crystal = true
var _awaiting_crystal_collect = true
var _awaiting_first_upgrade = false

var _awaiting_initial_gamepad_hints = true

var _gamepad_run_hints = [
	GamepadHints.GamepadIcons.L_STICK_DOWN,
	GamepadHints.GamepadIcons.L_STICK_LEFT,
	GamepadHints.GamepadIcons.L_STICK_UP,
	GamepadHints.GamepadIcons.L_STICK_RIGHT,
	GamepadHints.GamepadIcons.L_STICK_DOWN,
	GamepadHints.GamepadIcons.L_STICK_LEFT,
	GamepadHints.GamepadIcons.L_STICK_UP,
	GamepadHints.GamepadIcons.L_STICK_RIGHT
]

var _gamepad_jump_hints = [
	GamepadHints.GamepadIcons.A_PRESSED,
	GamepadHints.GamepadIcons.NONE,
	GamepadHints.GamepadIcons.X_PRESSED,
	GamepadHints.GamepadIcons.X_PRESSED,
	GamepadHints.GamepadIcons.X_PRESSED
]

var _gamepad_zoom_hints = [
	GamepadHints.GamepadIcons.R_STICK_UP,
	GamepadHints.GamepadIcons.R_STICK_DOWN,
	GamepadHints.GamepadIcons.R_STICK_UP,
	GamepadHints.GamepadIcons.R_STICK_DOWN,
	GamepadHints.GamepadIcons.NONE,
	GamepadHints.GamepadIcons.NONE,
	GamepadHints.GamepadIcons.R_STICK_RIGHT,
	GamepadHints.GamepadIcons.R_STICK_LEFT,
	GamepadHints.GamepadIcons.R_STICK_RIGHT,
	GamepadHints.GamepadIcons.R_STICK_LEFT
]


var _gamepad_menu_hints = [
	GamepadHints.GamepadIcons.NONE,
	GamepadHints.GamepadIcons.B_PRESSED,
	GamepadHints.GamepadIcons.B_PRESSED,
	GamepadHints.GamepadIcons.NONE,
	GamepadHints.GamepadIcons.B_PRESSED,
	GamepadHints.GamepadIcons.B_PRESSED
]

var _current_gamepad_hints = _gamepad_run_hints.duplicate()


func _on_gem_pouch_change(_gems : int, crystals : int):
	if crystals > 0 and _awaiting_crystal_collect:
		_awaiting_crystal_collect = false
		$TutorialPlaybook/MagicalCrystalIndicator.finish()
		_awaiting_first_upgrade = true
		$TutorialPlaybook/BuyUpgradeIndicator.start(LONG_INDICATOR_TIME)
	if crystals == 0 and _awaiting_first_upgrade:
		_awaiting_first_upgrade = false
		$TutorialPlaybook/BuyUpgradeIndicator.finish()
		_start_wave(3)
		_mk_toast("New enemies have arrived!", 5, true)
		for _i in range(27):
			$GemPouch.collect_builder_gem()
		for _i in range(4):
			$GemPouch.collect_magical_crystal()
		$TutorialPlaybook/FreePlayIndicator.start(MEDIUM_INDICATOR_TIME)
		$GemPouch/Cribs.show()


func _on_drop_magical_crystal(pos : Vector3):
	var new_crystal = super._on_drop_magical_crystal(pos)
	if _awaiting_magical_crystal:
		_awaiting_magical_crystal = false
		$TutorialPlaybook/StatsIndicator.finish()
		$TutorialPlaybook/MagicalCrystalIndicator.target = new_crystal
		$TutorialPlaybook/MagicalCrystalIndicator.start(LONG_INDICATOR_TIME)
		$GemPouch/MagicalGems.show()


func _handle_goblin_arrival():
	if _awaiting_goblin:
		_goblin = goblin_map[main_player_cid]
		_goblin.floor_max_angle = deg_to_rad(45)
		_tree_menu = _goblin.find_child("TreeContextMenu")
		_awaiting_goblin = false
		$TutorialPlaybook/GoblinIndicator.target = _goblin
		$TutorialPlaybook/GoblinIndicator.start(SHORT_INDICATOR_TIME)
		_init_zoom = CameraUtil.get_cam().zoom
		_init_rot = CameraUtil.get_cam_pivot().rotation.y
		if mode == TutorialMode.KEYBOARD:
			$TutorialPlaybook/ShowKeyboardHintsTimer.start()

func _handle_gamepad_running_hints():
	if _awaiting_initial_gamepad_hints:
		_awaiting_initial_gamepad_hints = false
		$TutorialPlaybook/ShowInitialGamepadTimer.start()

	if _current_gamepad_hints.is_empty() and _awaiting_jump_hint and Vector2(
		Input.get_joy_axis(main_player_cid - 1, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(main_player_cid - 1, JOY_AXIS_LEFT_Y)
	) and not _goblin.velocity:
		_awaiting_jump = true
		_awaiting_jump_hint = false
		_current_gamepad_hints = _gamepad_jump_hints.duplicate()
		$TutorialPlaybook/ShowInitialGamepadTimer.start()
		$TutorialPlaybook/GamepadHints.current_icon = GamepadHints.GamepadIcons.A_PRESSED
		$TutorialPlaybook/GamepadHints.fading = false
		await get_tree().create_timer(1).timeout
		_goblin.floor_max_angle = deg_to_rad(60)


func _handle_keyboard_running_hints():
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
		_awaiting_sprint = true
		_goblin.floor_max_angle = deg_to_rad(60)
		$TutorialPlaybook/KeyboardHints.current_hint = KeyboardHints.KeyboardHint.SHIFT
	if _awaiting_sprint and Input.is_key_pressed(KEY_SHIFT) and _goblin.velocity:
		_awaiting_sprint = false
		$TutorialPlaybook/KeyboardHints.current_hint = KeyboardHints.KeyboardHint.NONE
		$TutorialPlaybook/KeyboardHints.fading = true


func _handle_mousewheel_hints():
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


func _spawn_builder_gems():
	for _i in range(10):
		_on_drop_builder_gem.call_deferred(
			$TutorialPlaybook/BuilderGemIndicator.target.position
		)


func _process(_delta):
	if not main_player_cid in goblin_map:
		return
	_handle_goblin_arrival()

	if mode == TutorialMode.KEYBOARD:
		_handle_keyboard_running_hints()
		_handle_mousewheel_hints()
	elif mode == TutorialMode.GAMEPAD:
		_handle_gamepad_running_hints()

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
		if mode == TutorialMode.KEYBOARD:
			$TutorialPlaybook/MouseHints.current_hint = MouseHints.MouseHint.NONE
			$TutorialPlaybook/ToggleMouseHintClickTimer.start()
		else:
			$TutorialPlaybook/GamepadHints.current_icon = GamepadHints.GamepadIcons.B_PRESSED
			$TutorialPlaybook/GamepadHints.fading = false
			_current_gamepad_hints = _gamepad_menu_hints.duplicate()
			$TutorialPlaybook/ShowNextGamepadHintTimer.start()

	if (
		_awaiting_tree_sub_menu and _tree_menu.is_open and
		_tree_menu.current_menu != TreeContextMenu.MAIN_MENU_NAME
	):
		_awaiting_tree_sub_menu = false
		$TutorialPlaybook/ToggleMouseHintClickTimer.stop()
		$TutorialPlaybook/MouseHints.current_hint = MouseHints.MouseHint.NONE
		$TutorialPlaybook/MouseHints.fading = true

	if (
		_awaiting_tree_menu_closed and
		not _tree_menu.is_open
	):
		if mode == TutorialMode.KEYBOARD:
			$TutorialPlaybook/MouseHints.current_hint = MouseHints.MouseHint.NONE
			$TutorialPlaybook/MouseHints.fading = true

	if (
		_awaiting_goblin_reaches_gems and
		_goblin.position.distance_to($TutorialPlaybook/BuilderGemIndicator.target.position) <
				$TutorialPlaybook/BuilderGemIndicator.radius_3d
	):
		$GemPouch.show()
		$GemPouch/Cribs.hide()
		$GemPouch/MagicalGems.hide()
		$GemPouch.add_to_group(Constants.GROUP_NAME_HUD_ITEM)
		$TutorialPlaybook/BuilderGemIndicator.finish()
		$TutorialPlaybook/TreeIndicator.start(LONG_INDICATOR_TIME)
		$TutorialPlaybook/TreeIndicator.target.add_to_group(Constants.GROUP_NAME_TREES)
		_awaiting_tree_menu = true
		_awaiting_goblin_reaches_gems = false

	if (
		_awaiting_first_wave and
		not get_tree().get_nodes_in_group(Constants.GROUP_NAME_MONSTERS).is_empty()
	):
		_awaiting_first_wave = false
		for tree in get_tree().get_nodes_in_group(Constants.GROUP_NAME_TREES_AND_FELLED_TREES):
			tree.add_to_group(Constants.GROUP_NAME_TREES)
		_mk_toast("Two Chibi Fish have arrived!", 3, true)
		$TutorialPlaybook/ArrowTowerIndicatorTimer.start()

	if (
		_awaiting_arrow_tower and
		not get_tree().get_nodes_in_group(Constants.GROUP_NAME_TOWERS).is_empty()
	):
		_awaiting_arrow_tower = false
		var tower_node = get_tree().get_first_node_in_group(Constants.GROUP_NAME_TOWERS)
		$TutorialPlaybook/ArrowTowerIndicator.target = tower_node
		$TutorialPlaybook/StatsIndicator.target = tower_node
		$TutorialPlaybook/BuyUpgradeIndicator.target = tower_node
		$TutorialPlaybook/DismantleIndicator.target = tower_node
		_start_wave(2)

	if (
		not $TutorialPlaybook/FreePlayIndicator.fading
		and _goblin.position.distance_to($TutorialPlaybook/FreePlayIndicator.target.position) <
				$TutorialPlaybook/FreePlayIndicator.radius_3d
	):
		$TutorialPlaybook/FreePlayIndicator.finish()


func _should_show_next_keyboard_hint(kh : KeyboardHints.KeyboardHint, kp : int) -> bool:
	if _next_hint_timer_running:
		return false
	return Input.is_key_pressed(kp) and _is_current_keyboard_hint(kh)


func _is_current_keyboard_hint(k : KeyboardHints.KeyboardHint) -> bool:
	return $TutorialPlaybook/KeyboardHints.current_hint == k


func _add_goblin_to_scene(num : int, _start_pos : Vector3 = Vector3.ZERO):
	if _already_entered:
		return
	_already_entered = true
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
	$GemPouch.liquidity_change.connect(_on_gem_pouch_change)


func _on_goblin_indicator_done() -> void:
	$TutorialPlaybook/BabyIndicator.start(LONG_INDICATOR_TIME)


func _on_baby_indicator_done() -> void:
	$TutorialPlaybook/FishfolkArrivalIndicator.start(LONG_INDICATOR_TIME)
	if mode == TutorialMode.KEYBOARD:
		$TutorialPlaybook/MouseHints.fading = false
		$TutorialPlaybook/ShowNextMouseHintTimer.start()
		_awaiting_wheel_click = true
	else:
		$TutorialPlaybook/GamepadHints.fading = false
		_current_gamepad_hints = _gamepad_zoom_hints.duplicate()
		$TutorialPlaybook/ShowNextGamepadHintTimer.start()


func _on_show_keyboard_hints_timer_timeout() -> void:
	$TutorialPlaybook/KeyboardHints.fading = false
	$TutorialPlaybook/ShowNextKeyboardHintTimer.start()


func _on_fishfolk_arrival_indicator_done() -> void:
	$TutorialPlaybook/BuilderGemIndicator.start(LONG_INDICATOR_TIME)
	_spawn_builder_gems()


func _on_toggle_mouse_hint_click_timer_timeout() -> void:
	$TutorialPlaybook/MouseHints.current_hint = (
		MouseHints.MouseHint.NONE if $TutorialPlaybook/MouseHints.current_hint == MouseHints.MouseHint.LEFT_CLICK
		else MouseHints.MouseHint.LEFT_CLICK
	)


func _on_arrow_tower_indicator_done() -> void:
	$TutorialPlaybook/StatsIndicator.start(LONG_INDICATOR_TIME)


func _on_free_play_indicator_done() -> void:
	$TutorialPlaybook/CribCountIndicator.start(SHORT_INDICATOR_TIME)


func _on_crib_count_indicator_done() -> void:
	$TutorialPlaybook/DismantleIndicator.start(SHORT_INDICATOR_TIME)


func _on_dismantle_indicator_done() -> void:
	_mk_toast("That rounds up the tutorial!", 3, true)


func _on_arrow_tower_indicator_timer_timeout() -> void:
	$TutorialPlaybook/ArrowTowerIndicator.start(SHORT_INDICATOR_TIME)


func _on_show_initial_gamepad_timer_timeout() -> void:
	$TutorialPlaybook/GamepadHints.fading = false
	$TutorialPlaybook/ShowNextGamepadHintTimer.start()


func _on_show_next_gamepad_hint_timer_timeout() -> void:
	if _current_gamepad_hints.is_empty():
		$TutorialPlaybook/GamepadHints.current_icon = GamepadHints.GamepadIcons.NONE
		$TutorialPlaybook/GamepadHints.fading = true
	else:
		$TutorialPlaybook/GamepadHints.current_icon = _current_gamepad_hints.pop_front()
		$TutorialPlaybook/ShowNextGamepadHintTimer.start()
