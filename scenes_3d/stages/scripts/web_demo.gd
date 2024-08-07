class_name WebDemo
extends Node

func _ready() -> void:
	for tree : MyTree in get_tree().get_nodes_in_group(Constants.GROUP_NAME_TREES_AND_FELLED_TREES):
		tree.stop_animation()
	find_child("MonsterSpawner3").queue_free()
