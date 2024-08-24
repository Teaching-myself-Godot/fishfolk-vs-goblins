class_name WebDemo
extends Node

func _ready() -> void:
	for tree : MyTree in get_tree().get_nodes_in_group(Constants.GROUP_NAME_TREES_AND_FELLED_TREES):
		tree.stop_animation()
	find_child("MonsterSpawner3").queue_free()


func _on_tutorial_gameover() -> void:
	get_tree().paused = true
	$PanelContainer.hide()
	$GameOverSplash.show()


func _on_tutorial_stage_won() -> void:
	get_tree().paused = true
	$PanelContainer.hide()
	$GameOverSplash.show()


func _on_close_credits_button_pressed() -> void:
	$CenterContainer/Credits.hide()


func _on_credits_pressed() -> void:
	$CenterContainer/Credits.show()
	$CenterContainer/Credits/CenterContainer/VBoxContainer/CloseCreditsButton.grab_focus()
