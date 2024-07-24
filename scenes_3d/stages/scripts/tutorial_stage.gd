class_name TutorialStage

extends Stage

var MainGame = preload("res://goblins_vs_fishfolk.tscn")
var ArrowScene = preload("res://scenes_2d/hud/pointing_arrow.tscn")
enum TutorialMode { KEYBOARD, GAMEPAD }

var range_ring : RangeRing = RangeRing.new(Vector3.ZERO, 2)

const ONE_SECOND = 60
const POINTING_AT_TIME = ONE_SECOND * 5
const MAX_CHECKBOX_WAIT_TIME = ONE_SECOND
const GEM_SPAWN = Vector3(0, 0, 0)

var mode : TutorialMode
var main_player_cid : InputUtil.ControllerID

# Basic controls
var check_running = true
var check_jumping = true
var check_zooming = true
var check_looking = true

# Gameplay intro
var check_gameplay_intro = true
var show_explain_goblin = false
var show_goblin_arrow_frames = POINTING_AT_TIME
var show_babies_arrow_frames = POINTING_AT_TIME
var show_monster_spawn_arrow_frames = POINTING_AT_TIME
var show_trees_arrow_frames = POINTING_AT_TIME
var show_gem_arrow_frames = -1
var show_collected_gem_arrow_frames = POINTING_AT_TIME * 2
var show_trees_arrow_frames_again = POINTING_AT_TIME * 2
var hide_gameplay_intro_frames = ONE_SECOND * 2

# Gameplay checklist
var show_gameplay_explainer_delay = ONE_SECOND
var check_tree_hugging = true
var check_menu_open = true
var check_submenu = true
var check_cancel = true
var check_collect_gems = true
var check_build = true
var first_wave : MonsterWave = null

# Upgrade tutorial
var awaiting_monster_wave_1 = true
var awaiting_upgrade_tutorial = true
var check_upgrade = true

var current_checklist : FadingPanel = null
var waiting_for_checkbox = MAX_CHECKBOX_WAIT_TIME

var _init_pos = Vector2.ZERO
var _init_zoom = null
var _init_rot = 0.0
var _cooldown_pause = 20


func _on_gem_pouch_change(gems : int, crystals : int):
	if gems > 0 and not $GemPouch/BuilderGems.visible:
		show_gem_arrow_frames = -1
		_destroy_arrow()
		TerrainShaderParams.drop_range_ring(range_ring)
		TerrainShaderParams.range_rings_changed.emit()
		$GemPouch/BuilderGems.show()
		$ExplanationText/Body.text += "\nYou can see your collected BUILDER GEMS here\n"
		_mk_arrow($ExplanationText.position + Vector2(5, 164), $GemPouch.position + Vector2(224, -168))
		show_collected_gem_arrow_frames = POINTING_AT_TIME
	if gems >= 100:
		check_collect_gems = false
		_check_checkbox("CheckCollectGems")
		$ExplanationText/Body.text += "\nNow go and convert a TREE into an ARROW TOWER\n"


func _learning_controls() -> bool:
	return check_jumping or check_running or check_zooming or check_looking


func _learning_gameplay() -> bool:
	return (
		check_menu_open or check_submenu or check_cancel or
		check_build or check_collect_gems or check_tree_hugging
	)


func _learning_upgrades() -> bool:
	return check_upgrade


func _get_goblin_pointer_pos() -> Vector2:
	return CameraUtil.get_label_position(
			goblin_map[main_player_cid].position,
			Vector3(0, 2.0, 0)
	) + Vector2(7, 0)


func _update_arrow_to(to : Vector2) -> void:
	for arrow in get_tree().get_nodes_in_group(Constants.GROUP_NAME_ARROW_2D):
		arrow.to = to


func _show_extra_hint():
	if not is_instance_valid(current_checklist):
		return
	for item : ChecklistItem in current_checklist.find_children("*", "ChecklistItem"):
		if not item._checked:
			_show_help_message(item.informative_text)
			break


func _handle_extra_hint_timer():
	if waiting_for_checkbox > 0:
		waiting_for_checkbox -= 1
	elif waiting_for_checkbox == 0:
		waiting_for_checkbox = -1
		_show_extra_hint()


func _check_checkbox(checkbox_name : String):
	if is_instance_valid(current_checklist):
		waiting_for_checkbox = MAX_CHECKBOX_WAIT_TIME
		_hide_help_message()
		current_checklist.find_child(checkbox_name).set_checked(true)


func _handle_learning_controls_frame():
	_handle_extra_hint_timer()

	if false in [check_running, check_jumping, check_zooming, check_looking]:
		$ExplanationText.fading = true
		_destroy_arrow()
	if check_running:
		var pos = Vector2(
			goblin_map[main_player_cid].position.x,
			goblin_map[main_player_cid].position.z,
		)
		if pos.distance_to(_init_pos) > 3.0:
			check_running = false
			_check_checkbox("CheckRunning")
	if check_jumping and _cooldown_pause == 0:
		if InputUtil.is_just_released("jump"):
			check_jumping = false
			_check_checkbox("CheckJumping")
	if check_zooming:
		if abs(CameraUtil.get_cam().zoom - _init_zoom) > 3.0:
			check_zooming = false
			_check_checkbox("CheckZooming")
	if check_looking:
		if abs(_init_rot - CameraUtil.get_cam_pivot().rotation.y) > 0.1:
			check_looking = false
			_check_checkbox("CheckLooking")


func _handle_gameplay_introduction():
	if not show_explain_goblin:
		show_explain_goblin = true
		$ExplanationText.fading = false
		$ExplanationText/Title.text = "The Humble Goblin"
		$ExplanationText/Body.text = "This is YOU, the humble Goblin.\n"
		_mk_arrow(
				$ExplanationText.position + Vector2(5, 72),
				_get_goblin_pointer_pos()
		)
		TerrainShaderParams.add_range_ring(range_ring)
		range_ring.position = goblin_map[main_player_cid].position
	elif show_goblin_arrow_frames > 0:
		show_goblin_arrow_frames -= 1
		current_checklist.fading = true
		_update_arrow_to(_get_goblin_pointer_pos())
		range_ring.position = goblin_map[main_player_cid].position
		TerrainShaderParams.range_rings_changed.emit()
	elif show_goblin_arrow_frames == 0:
		_destroy_arrow()
		show_goblin_arrow_frames = -1
		$ExplanationText/Body.text += "\nAnd these are your BABIES.\n"
		_mk_arrow(
				$ExplanationText.position + Vector2(5, 108),
				CameraUtil.get_label_position(Vector3(0, 1, 0))
		)
		range_ring.position = Vector3(0, 0, 0)
		range_ring.radius = 5
		TerrainShaderParams.range_rings_changed.emit()
	elif show_babies_arrow_frames > 0:
		show_babies_arrow_frames -= 1
		_update_arrow_to(CameraUtil.get_label_position(Vector3(0, 1, 0)))
	elif show_babies_arrow_frames == 0:
		_destroy_arrow()
		show_babies_arrow_frames = -1
		$ExplanationText/Body.text += (
			"\nSoon, angry FISHFOLK will arrive here to ATTACK them!\n"
		)
		_mk_arrow(
				$ExplanationText.position + Vector2(5, 152),
				CameraUtil.get_label_position(
						$MonsterSpawner/MonsterPath/Anchor.position
				)
		)
		range_ring.radius = 0.5
		range_ring.position = $MonsterSpawner/MonsterPath/Anchor.position
		TerrainShaderParams.range_rings_changed.emit()
	elif show_monster_spawn_arrow_frames > 0:
		show_monster_spawn_arrow_frames -= 1
		_update_arrow_to(
			CameraUtil.get_label_position(
				$MonsterSpawner/MonsterPath/Anchor.position
			)
		)
		range_ring.position = $MonsterSpawner/MonsterPath/Anchor.position
		TerrainShaderParams.range_rings_changed.emit()
	elif show_monster_spawn_arrow_frames == 0:
		_destroy_arrow()
		show_monster_spawn_arrow_frames = -1
		$ExplanationText/Body.text += (
			"\nAnd you can convert TREES into DEFENSES here.\n"
		)
		_mk_arrow(
				$ExplanationText.position + Vector2(5, 190),
				CameraUtil.get_label_position(
						$"palm-tree6".position,
						Vector3(0, 1, 0)
				)
		)
		range_ring.radius = 5
		range_ring.position = $"palm-tree6".position
		TerrainShaderParams.range_rings_changed.emit()
	elif show_trees_arrow_frames > 0:
		show_trees_arrow_frames -= 1
		_update_arrow_to(CameraUtil.get_label_position(
				$"palm-tree6".position,
				Vector3(0, 1, 0)
		))
	elif show_trees_arrow_frames == 0:
		_destroy_arrow()
		show_trees_arrow_frames = -1
		current_checklist = (
			$KeyboardTutuorialGameplay if mode == TutorialMode.KEYBOARD else
			$GamepadTutorialGameplay
		)
		for tree in get_tree().get_nodes_in_group(
			Constants.GROUP_NAME_TREES_AND_FELLED_TREES
		):
			tree.add_to_group(Constants.GROUP_NAME_TREES)
		current_checklist.fading = false
	else:
		check_gameplay_intro = false
		waiting_for_checkbox = MAX_CHECKBOX_WAIT_TIME


func _handle_gameplay_checklist():
	if check_tree_hugging:
		if goblin_map[main_player_cid].find_child("TreeContextMenu").visible:
			check_tree_hugging = false
			_check_checkbox("CheckTreeHugging")
	if check_menu_open:
		if goblin_map[main_player_cid].find_child("TreeContextMenu").is_open:
			check_menu_open = false
			_check_checkbox("CheckMenuOpen")
	if check_submenu:
		if (
			goblin_map[main_player_cid].find_child("TreeContextMenu").is_open
			and not (
				goblin_map[main_player_cid].find_child("TreeContextMenu")
						.current_menu == TreeContextMenu.MAIN_MENU_NAME
			)
		):
			if show_trees_arrow_frames > 0:
				show_trees_arrow_frames = 0
			check_submenu = false
			_check_checkbox("CheckSubmenu")
			$ExplanationText.fading = false
			$ExplanationText/Title.text = "Converting Trees into Towers"
			$ExplanationText/Body.text = """
				To convert trees into defensive towers you need BUILDER GEMS

			"""
			$GemPouch.show()
			$GemPouch/Cribs.hide()
			$GemPouch/MagicalGems.hide()
			$GemPouch/BuilderGems.hide()
			for _i in range(10):
				_on_drop_builder_gem(GEM_SPAWN)
			_destroy_arrow()
			_mk_arrow(
				$ExplanationText.position + Vector2(5, 108),
				CameraUtil.get_label_position(Vector3(10, 0, 2))
			)
			show_gem_arrow_frames = POINTING_AT_TIME * 10
			$GemPouch.liquidity_change.connect(_on_gem_pouch_change)
			range_ring.position = GEM_SPAWN
			range_ring.radius = 2
			TerrainShaderParams.range_rings_changed.emit()
	if check_cancel:
		if not check_submenu and not goblin_map[main_player_cid].find_child("TreeContextMenu").is_open:
			check_cancel = false
			_check_checkbox("CheckCancel")

	if check_build:
		if not (
			get_tree()
				.get_nodes_in_group(Constants.GROUP_NAME_TOWERS)
				.is_empty()
		):
			check_build = false
			_destroy_arrow()
			_check_checkbox("CheckBuild")
			_start_wave(2)
			_mk_toast("Wave 1 / 2")

			# FIXME: make this bit more cinematic
			$ExplanationText/Title.text = "A Fish Folk Attack!"
			$ExplanationText/Body.text = """Fish folk attack in waves:
				- Numbered waves
				- Endless waves

				You have LOST the game when you lose all your babies.

				When you have defeated all Fish Folk in all waves, you have WON.
			"""
			$GemPouch/Cribs.show()
			_mk_arrow(
					$ExplanationText.position + Vector2(5, 152),
					$GemPouch.position + Vector2(224, -250)
			)
			current_checklist.fading = true


func _handle_gameplay_tutorial():
	if hide_gameplay_intro_frames > 0:
		hide_gameplay_intro_frames -= 1
	elif hide_gameplay_intro_frames == 0:
		hide_gameplay_intro_frames = -1
		$ExplanationText.fading = true
		_destroy_arrow()
	elif show_gem_arrow_frames > 0:
		show_gem_arrow_frames -= 1
		_update_arrow_to(CameraUtil.get_label_position(GEM_SPAWN))
	elif show_gem_arrow_frames == 0:
		show_gem_arrow_frames = -1
		_destroy_arrow()
	elif show_collected_gem_arrow_frames > 0:
		if not check_collect_gems:
			show_collected_gem_arrow_frames -= 1
	elif show_collected_gem_arrow_frames == 0:
		show_collected_gem_arrow_frames = -1
		_destroy_arrow()
		_mk_arrow(
				$ExplanationText.position + Vector2(5, $ExplanationText.size.y - 24),
				CameraUtil.get_label_position(
						$"palm-tree6".position,
						Vector3(0, 1, 0)
				)
		)
	elif show_trees_arrow_frames_again > 0:
		show_trees_arrow_frames_again -= 1
		_update_arrow_to(CameraUtil.get_label_position(
				$"palm-tree6".position,
				Vector3(0, 1, 0)
		))
	elif show_trees_arrow_frames_again == 0:
		_destroy_arrow()
		show_trees_arrow_frames_again = -1


func _handle_upgrades_tutorial():
	if awaiting_upgrade_tutorial:
		current_checklist = $UpgradeTutorial
		current_checklist.fading = false
		$ExplanationText/Title.text = "Upgrading a tower"
		$ExplanationText/Body.text = "..."
		$ExplanationText.fading = false
		_destroy_arrow()
		awaiting_upgrade_tutorial = false

func _process(_delta):
	if not main_player_cid in goblin_map:
		return

	if _init_zoom == null:
		_init_zoom = CameraUtil.get_cam().zoom

	if _cooldown_pause > 0:
		_cooldown_pause -= 1

	if _learning_controls():
		_handle_learning_controls_frame()
	elif _learning_gameplay():
		_handle_extra_hint_timer()
		if check_gameplay_intro:
			_handle_gameplay_introduction()
		else:
			_handle_gameplay_checklist()
			_handle_gameplay_tutorial()
	elif _learning_upgrades():
		if awaiting_monster_wave_1:
			if not is_instance_valid(first_wave):
				awaiting_monster_wave_1 = false
		else:
			_handle_upgrades_tutorial()


func _add_goblin_to_scene(num : int, start_pos : Vector3 = Vector3(0, 4, 2)):
	super._add_goblin_to_scene(num, start_pos)

	if InputUtil.player_map.size() == 1:
		_hide_help_message()
		main_player_cid = num as InputUtil.ControllerID
		_init_pos = Vector2(
			goblin_map[main_player_cid].position.x,
			goblin_map[main_player_cid].position.z,
		)
		if num == InputUtil.ControllerID.KEYBOARD:
			mode = TutorialMode.KEYBOARD
			current_checklist = $KeyboardTutorial
		else:
			mode = TutorialMode.GAMEPAD
			current_checklist = $GamepadTutorial
		current_checklist.fading = false
		_mk_arrow(
				$ExplanationText.position + Vector2(5, $ExplanationText.size.y - 24),
				current_checklist.position + Vector2(
						current_checklist.size.x, current_checklist.size.y * 0.5
				)
		)
		$ExplanationText/Body.text += "\nFirst, let's learn the controls."
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
	_show_help_message("To JOIN, press either gamepad START or keyboard SPACEBAR")
	first_wave = $MonsterSpawner/MonsterWave


func _mk_arrow(from : Vector2, to : Vector2) -> void:
	var arrow : PointingArrow = ArrowScene.instantiate()
	arrow.from = from
	arrow.to = to
	add_child.call_deferred(arrow)


func _destroy_arrow() -> void:
	for arrow in get_tree().get_nodes_in_group(Constants.GROUP_NAME_ARROW_2D):
		arrow.fading = true


func _unhandled_input(event):
	super._unhandled_input(event)
	if goblin_map.size() == 0 and InputUtil.is_just_released("pause"):
		_open_confirmation_dialog()


func _open_confirmation_dialog():
	get_tree().paused = true
	$ConfirmationDialog.show()


func _on_confirmation_dialog_canceled():
	get_tree().paused = false
	$ConfirmationDialog.hide()


func _on_confirmation_dialog_confirmed():
	get_tree().call_deferred("change_scene_to_packed", MainGame)


