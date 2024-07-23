class_name TutorialStage

extends Stage

var MainGame = preload("res://goblins_vs_fishfolk.tscn")
var ArrowScene = preload("res://scenes_2d/hud/pointing_arrow.tscn")
enum TutorialMode { KEYBOARD, GAMEPAD }

var range_ring : RangeRing = RangeRing.new(Vector3.ZERO, 2)

#var message_suite = {
	#TutorialMode.KEYBOARD: [
		#"To RUN, use arrow-buttons or 'w', 'a', 's', 'd'",
		#"To JUMP, press SPACEBAR",
		#"To ZOOM, click and drag MOUSEWHEEL up and down",
		#"To LOOK AROUND, click and drag MOUSEWHEEL left and right",
		#"To BUILD, LEFT-click MOUSE or press SHIFT next to a tree",
		#"To PICK a type, LEFT-click MOUSE or press SHIFT",
		#"To CANCEL, RIGHT-click MOUSE or press ESC",
		#"Now build an ARROW-TOWER with your new BUILDER GEMS",
		#"Fish Folk will soon come to try and take your baby"
	#],
	#TutorialMode.GAMEPAD: [
		#"To RUN, use L-stick",
		#"To JUMP, press A (Nintendo B)",
		#"To ZOOM, move R-stick up and down",
		#"TO LOOK AROUND, move R-stick left and right",
		#"To BUILD, press B (Nintendo A) next to a tree",
		#"To PICK a type, press B (Nintendo A), point with L-stick",
		#"To CANCEL, press A (Nintendo B)",
		#"Now build an ARROW-TOWER with your new BUILDER GEMS",
		#"Fish Folk will soon come to try and take your baby"
	#]
#}

const ONE_SECOND = 60
const POINTING_AT_TIME = ONE_SECOND * 3
const MAX_CHECKBOX_WAIT_TIME = ONE_SECOND * 5

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
var hide_gameplay_intro_frames = ONE_SECOND * 2

# Gameplay checklist
var show_gameplay_explainer_delay = ONE_SECOND
var check_tree_hugging = true
var check_menu_open = true
var check_submenu = true
var check_cancel = true
var check_build = true
var check_upgrade = true
#var check_done = true

var current_checklist : Control = null
var waiting_for_checkbox = MAX_CHECKBOX_WAIT_TIME

var _init_pos = Vector2.ZERO
var _init_zoom = null
var _init_rot = 0.0
var _cooldown_pause = 20


func _learning_controls() -> bool:
	return check_jumping or check_running or check_zooming or check_looking


func _learning_gameplay() -> bool:
	return check_menu_open or check_submenu or check_cancel or check_build or check_upgrade


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


func _check_checkbox(name : String):
	if is_instance_valid(current_checklist):
		waiting_for_checkbox = MAX_CHECKBOX_WAIT_TIME
		_hide_help_message()
		current_checklist.find_child(name).set_checked(true)


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
		if abs(CameraUtil.get_cam().zoom - _init_zoom) > 5.0:
			check_zooming = false
			_check_checkbox("CheckZooming")
	if check_looking:
		if abs(_init_rot - CameraUtil.get_cam_pivot().rotation.y) > 0.2:
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
		if (
				show_goblin_arrow_frames < POINTING_AT_TIME - ONE_SECOND and
				current_checklist.modulate.a > 0
		):
			current_checklist.modulate.a -= 0.025
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
						Vector3(0, 3, 0)
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
		$ExplanationText/Body.text += "Let's prepare!"
		current_checklist = (
			$KeyboardTutuorialGameplay if mode == TutorialMode.KEYBOARD else
			$GamepadTutorialGameplay
		)
		for tree in get_tree().get_nodes_in_group(
			Constants.GROUP_NAME_TREES_AND_FELLED_TREES
		):
			tree.add_to_group(Constants.GROUP_NAME_TREES)
		current_checklist.show()
	else:
		check_gameplay_intro = false


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
			if hide_gameplay_intro_frames > 0:
				hide_gameplay_intro_frames -= 1
			elif hide_gameplay_intro_frames == 0:
				hide_gameplay_intro_frames = -1
				$ExplanationText.fading = true
			elif show_gameplay_explainer_delay > 0:
				show_gameplay_explainer_delay -= 1
			elif show_gameplay_explainer_delay == 0:
				show_gameplay_explainer_delay = -1
				waiting_for_checkbox = MAX_CHECKBOX_WAIT_TIME

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
				check_submenu = false
				_check_checkbox("CheckSubmenu")
				$ExplanationText2.fading = false
				$GemPouch.show()
				$GemPouch/Cribs.hide()
				$GemPouch/MagicalGems.hide()
	#elif (
			#check_menu_open and
			#goblin_map[main_player_cid].find_child("TreeContextMenu").is_open
	#):
		#check_menu_open = false
		#_mk_toast(message_suite[mode][5], 10.0, true)
	#elif check_submenu:
		#if (
			#goblin_map[main_player_cid].find_child("TreeContextMenu").is_open and
			#not (
				#goblin_map[main_player_cid].find_child("TreeContextMenu")
						#.current_menu == TreeContextMenu.MAIN_MENU_NAME
			#)
		#):
			#check_submenu = false
			#_mk_toast(message_suite[mode][6], 10.0, true)
	#elif check_cancel:
		#if (
			#goblin_map[main_player_cid].find_child("TreeContextMenu").is_open and
			#(
				#goblin_map[main_player_cid].find_child("TreeContextMenu")
						#.current_menu == TreeContextMenu.MAIN_MENU_NAME
			#)
		#):
			#check_cancel = false
			#gem_pouch.show()
			#for _x in range(10):
				#gem_pouch.collect_builder_gem()
			#_mk_toast(message_suite[mode][7], 10.0, true)
	#elif check_build:
		#if not (
			#get_tree()
				#.get_nodes_in_group(Constants.GROUP_NAME_TOWERS)
				#.is_empty()
		#):
			#check_build = false
			#_mk_toast(message_suite[mode][8], 10.0, true)
			#_start_wave(2)
	#elif check_done:
		#if find_children("*", "MonsterWave").size() == 0:
			#check_done = false
			#_mk_toast("Thank you for playing the tutorial!", 3, true)
			#$EndTutorialDelay.start()


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
		current_checklist.show()
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


