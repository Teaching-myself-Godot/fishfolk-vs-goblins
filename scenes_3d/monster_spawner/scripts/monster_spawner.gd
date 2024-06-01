extends Node3D

func _ready():
	var path = find_children("*", "Path3D")
	if path.size() == 0:
		printerr("MonsterSpawner is missing a path!")
		return

