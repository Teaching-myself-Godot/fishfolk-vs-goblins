class_name GoblinsVsFishfolk
extends Node


func _ready():
	get_tree().paused = true


func _on_title_screen_close_title_screen():
	$TitleScreen.hide()
