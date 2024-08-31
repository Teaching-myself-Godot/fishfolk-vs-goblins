class_name GoblinsVsFishfolk
extends Node

var current_stage_scene : PackedScene
var current_stage : Stage

@onready var final_score_card = $GameOverWithScoreCardSplash/CenterContainer/VBoxContainer/Scores

func _ready():
	get_tree().paused = true
	if InputUtil.cids_registered.is_empty():
		InputUtil.cids_registered.append(0)

func _toggle_fullscreen():
	_play_confirm_sound()
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
	current_stage.gameover_with_scores.connect(_on_gameover_with_scores)
	current_stage.stage_won.connect(_on_stage_won)
	$StageHolder.add_child(current_stage)


func _pause_game():
	get_tree().paused = true
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.hide()
	$PauseMenu.open_menu()


func _on_gameover():
	get_tree().paused = true
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.hide()
	$TuneNo1Player.stop()
	$GameOverSplash.show()

func _on_gameover_with_scores(scores : Scores):
	get_tree().paused = true
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.hide()
		
	$TuneNo1Player.stop()
	$GameOverWithScoreCardSplash.show()
	final_score_card.copy_from(scores)
	for cid in InputUtil.player_map.keys():
		final_score_card.show_player(cid)
	final_score_card.show()

func _on_stage_won():
	get_tree().paused = true
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.hide()
	$TuneNo1Player.stop()
	$StageWonSplash.show()


func _get_goblin_spawn_point() -> Vector3:
	var pos = Vector3(0, 4, 0)
	var spawn = get_tree().get_first_node_in_group(
		Constants.GROUP_NAME_GOBLIN_SPAWN_POINT
	)
	if is_instance_valid(spawn):
		pos = spawn.position
		spawn.queue_free()
	return pos


func _start_stage():
	get_tree().paused = false
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.show()

	var start_pos = _get_goblin_spawn_point()
	if InputUtil.cids_registered.is_empty():
		InputUtil.cids_registered.append(InputUtil.ControllerID.KEYBOARD)
	for cid in InputUtil.cids_registered:
		current_stage._add_goblin_to_scene(cid, start_pos)
		start_pos.x += 2
	$TuneNo1Player.play()
	current_stage._start_wave(1)


func _on_title_screen_confirm_stage():
	$TitleScreen.hide()
	_start_stage()


func _on_pause_menu_restart_stage():
	_play_confirm_sound()
	_select_stage(current_stage_scene)
	$PauseMenu.close_menu()
	_start_stage()


func _on_pause_menu_open_stage_select():
	_play_confirm_sound()
	get_tree().paused = true
	$PauseMenu.close_menu()
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.hide()
	$TitleScreen.open_title_screen()


func _on_game_over_splash_close_gameover_splash():
	$GameOverSplash.hide()
	$GameOverWithScoreCardSplash.hide()
	$StageWonSplash.hide()
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.hide()
	$TitleScreen.open_title_screen()


func _on_quit_pressed():
	_play_confirm_sound()
	get_tree().quit()


func _on_continue_pressed():
	get_tree().paused = false
	$PauseMenu.close_menu()
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.show()
	_play_confirm_sound()

func _on_tune_no_1_player_finished():
	if not get_tree().paused:
		$TuneNo1Player.play()


func _play_confirm_sound():
	$OnSelectAudioStreamPlayer.play()
	await get_tree().create_timer(0.1).timeout
	$OnSelectAudioStreamPlayer.stop()
