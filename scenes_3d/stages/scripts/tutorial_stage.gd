class_name TutorialStage

extends Stage

var MainGame = preload("res://goblins_vs_fishfolk.tscn")

enum TutorialMode { KEYBOARD, GAMEPAD }

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

var mode : TutorialMode
var main_player_cid : InputUtil.ControllerID

var check_running = true
var check_jumping = true
var check_zooming = true
var check_looking = true
var check_menu_open = true
var check_submenu = true
var check_cancel = true
var check_build = true
var check_done = true

var _init_pos = Vector2.ZERO
var _init_zoom = null
var _init_rot = 0.0

var cooldown_pause = 20

func _process(_delta):
	if not main_player_cid in goblin_map:
		return

	if _init_zoom == null:
		_init_zoom = CameraUtil.get_cam().zoom
	if cooldown_pause > 0:
		cooldown_pause -= 1

	$KeyboardTutorial/CheckRunning.set_checked(not check_running)
	$KeyboardTutorial/CheckJumping.set_checked(not check_jumping)
	$KeyboardTutorial/CheckZooming.set_checked(not check_zooming)
	$KeyboardTutorial/CheckLooking.set_checked(not check_looking)
	$GamepadTutorial/CheckRunning.set_checked(not check_running)
	$GamepadTutorial/CheckJumping.set_checked(not check_jumping)
	$GamepadTutorial/CheckZooming.set_checked(not check_zooming)
	$GamepadTutorial/CheckLooking.set_checked(not check_looking)


	if check_running:
		var pos = Vector2(
			goblin_map[main_player_cid].position.x,
			goblin_map[main_player_cid].position.z,
		)
		if pos.distance_to(_init_pos) > 3.0:
			check_running = false
			#_mk_toast(message_suite[mode][1], 10.0, true)

	if check_jumping and cooldown_pause == 0:
		if InputUtil.is_just_released("jump"):
			check_jumping = false
			#_mk_toast(message_suite[mode][2], 10.0, true)

	if check_zooming:
		if abs(CameraUtil.get_cam().zoom - _init_zoom) > 5.0:
			check_zooming = false
			_init_rot = CameraUtil.get_cam_pivot().rotation.y
			#_mk_toast(message_suite[mode][3], 10.0, true)

	if check_looking:
		if abs(_init_rot - CameraUtil.get_cam_pivot().rotation.y) > 0.1:
			check_looking = false
			#_mk_toast(message_suite[mode][4], 10.0, true)


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


func _add_goblin_to_scene(num : int, start_pos : Vector3 = Vector3(0, 4, 0)):
	super._add_goblin_to_scene(num, start_pos)
	for toasted : Toast in get_tree().get_nodes_in_group(Constants.GROUP_NAME_TOASTS):
		toasted.fading = true

	if InputUtil.player_map.size() == 1:
		main_player_cid = num as InputUtil.ControllerID
		_init_pos = Vector2(
			goblin_map[main_player_cid].position.x,
			goblin_map[main_player_cid].position.z,
		)
		if num == InputUtil.ControllerID.KEYBOARD:
			mode = TutorialMode.KEYBOARD
			$KeyboardTutorial.show()
		else:
			mode = TutorialMode.GAMEPAD
			$GamepadTutorial.show()
		#_mk_toast(message_suite[mode][0], 10.0, true)


func _ready():
	super._ready()
	_mk_toast(
			"To JOIN, press either gamepad START or keyboard SPACEBAR",
			100,
			true
	).set_anchors_preset(Control.PRESET_CENTER)


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


