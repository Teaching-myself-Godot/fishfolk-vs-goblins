class_name GoblinsVsFishfolk
extends Node

var Stage1_1 : PackedScene = preload("res://scenes_3d/stages/stage-1-1.tscn")
var Stage1_2 : PackedScene = preload("res://scenes_3d/stages/stage-1-2.tscn")
var Stage1_3 : PackedScene = preload("res://scenes_3d/stages/stage-1-3.tscn")

var stages = [
	Stage1_1, Stage1_2, Stage1_3
]
var current_stage_idx : int = 0
var current_stage_scene : PackedScene
var current_stage : Stage


func _ready():
	get_tree().paused = true
	_select_stage(0)

func _select_stage(idx):
	current_stage_idx = idx if idx < stages.size() else 0
	current_stage_idx = current_stage_idx if current_stage_idx > -1 else stages.size() - 1
	if is_instance_valid(current_stage):
		$StageHolder.remove_child(current_stage)
		current_stage.queue_free()

	current_stage_scene = stages[current_stage_idx]
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


func _continue_game():
	CameraUtil.get_cam().current = true
	get_tree().paused = false
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.show()

	for cid in InputUtil.player_map:
		current_stage._add_goblin_to_scene(cid)
		break # FIXME: prevent goblins from spawning at same spot

func _on_title_screen_close_title_screen():
	$TitleScreen.hide()
	_continue_game()


func _on_pause_menu_restart_stage():
	_select_stage(current_stage_scene)


func _on_title_screen_select_next_stage():
	if $TitleScreen.visible:
		_select_stage(current_stage_idx + 1)


func _on_title_screen_select_previous_stage():
	if $TitleScreen.visible:
		_select_stage(current_stage_idx - 1)


func _on_pause_menu_open_stage_select():
	get_tree().paused = true
	$PauseMenu.hide()
	_select_stage(0)
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.hide()
	$TitleScreen.show()


func _on_game_over_splash_close_gameover_splash():
	$GameOverSplash.hide()
	_select_stage(0)
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.hide()
	$TitleScreen.show()
