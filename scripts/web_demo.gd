class_name WebDemo
extends GoblinsVsFishfolk

var my_stage_scene : PackedScene = preload("res://scenes_3d/stages/tutorial.tscn")


func _ready():
	super._ready()
	_select_stage(my_stage_scene)


func _on_title_screen_start() -> void:
	InputUtil.cids_registered.append(InputUtil.ControllerID.KEYBOARD)
	super._on_title_screen_confirm_stage()
