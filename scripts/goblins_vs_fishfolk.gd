class_name GoblinsVsFishfolk
extends Node

var Stage1_1 : PackedScene = preload("res://scenes_3d/stages/stage-1-1.tscn")
var Stage1_2 : PackedScene = preload("res://scenes_3d/stages/stage-1-2.tscn")

var current_stage_scene : PackedScene
var current_stage : Stage
var toggle_stage_test : bool = false

func _ready():
	get_tree().paused = true
	_select_stage(Stage1_1)

func _select_stage(stage : PackedScene):
	if is_instance_valid(current_stage):
		$StageHolder.remove_child(current_stage)
		current_stage.queue_free()

	current_stage_scene = stage
	current_stage = stage.instantiate()
	current_stage.open_pause_menu.connect(_pause_game)
	$StageHolder.add_child(current_stage)


func _pause_game():
	get_tree().paused = true
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.hide()
	$PauseMenu.open_menu()


func _continue_game():
	get_tree().paused = false
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.show()


func _on_title_screen_close_title_screen():
	$TitleScreen.hide()
	_continue_game()


func _on_pause_menu_restart_stage():
	_select_stage(current_stage_scene)


func _on_title_screen_toggle_stage_select_test():
	printerr("FIXME: drop stage select tester")
	if $TitleScreen.visible:
		if toggle_stage_test:
			_select_stage(Stage1_1)
		else:
			_select_stage(Stage1_2)
		toggle_stage_test = !toggle_stage_test


func _on_pause_menu_open_stage_select():
	get_tree().paused = true
	$PauseMenu.hide()
	_select_stage(Stage1_1)
	toggle_stage_test = false
	for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
		hud_item.hide()

	$TitleScreen.show()
