class_name GoblinsVsFishfolk
extends Node

var current_stage_scene : PackedScene
var current_stage : Stage


func _ready():
	get_tree().paused = true


func _toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _select_stage(stage_scene : PackedScene):
	if is_instance_valid(current_stage):
		$StageHolder.remove_child(current_stage)
		current_stage.queue_free()

	current_stage_scene = stage_scene
	current_stage = current_stage_scene.instantiate()
	current_stage.open_pause_menu.connect(_pause_game)
	current_stage.gameover.connect(_on_gameover)
	$StageHolder.add_child(current_stage)


func _pause_game():
	get_tree().paused = true
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.hide()
	$PauseMenu.open_menu()


func _on_gameover():
	get_tree().paused = true
	$GameOverSplash.show()


func _get_goblin_spawn_point() -> Vector3:
	var pos = Vector3(0, 4, 0)
	var spawn = get_tree().get_first_node_in_group(
		Constants.GROUP_NAME_GOBLIN_SPAWN_POINT
	)
	return spawn.position if is_instance_valid(spawn) else pos


func _start_stage():
	CameraUtil.get_cam().current = true
	get_tree().paused = false
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.show()

	var start_pos = _get_goblin_spawn_point()
	for cid in InputUtil.cids_registered:
		current_stage._add_goblin_to_scene(cid, start_pos)
		start_pos.x += 2


func _on_title_screen_confirm_stage():
	$TitleScreen.hide()
	_start_stage()


func _on_pause_menu_restart_stage():
	_select_stage(current_stage_scene)
	$PauseMenu.hide()
	_start_stage()


func _on_pause_menu_open_stage_select():
	get_tree().paused = true
	$PauseMenu.hide()
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.hide()
	$TitleScreen.open_title_screen()


func _on_game_over_splash_close_gameover_splash():
	$GameOverSplash.hide()
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.hide()
	$TitleScreen.open_title_screen()


func _on_quit_pressed():
	get_tree().quit()


func _on_continue_pressed():
	get_tree().paused = false
	$PauseMenu.hide()
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.show()
