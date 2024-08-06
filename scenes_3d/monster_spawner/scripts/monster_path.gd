class_name MonsterPath
extends Path3D

var PathArrowScene = preload("res://scenes_3d/monster_spawner/path_arrow.tscn")
var PathPreviewScene = preload("res://scenes_3d/monster_spawner/path_preview.tscn")

func _ready():
	for anchor in find_children("*", "", false):
		curve.add_point(anchor.global_position + Vector3.UP)
		anchor.hide()


func display():
	var previewer : PathPreview = PathPreviewScene.instantiate()
	add_child(previewer)
	previewer.show_arrow.connect(_show_arrow)

func _show_arrow(pos : Vector3, next_pos : Vector3):
	var arrow : Node3D = PathArrowScene.instantiate()
	arrow.position = pos
	arrow.look_at_from_position(pos, next_pos)
	add_child.call_deferred(arrow)
