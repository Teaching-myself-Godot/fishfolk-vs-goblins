class_name MonsterPath
extends Path3D

func _ready():
	for anchor in find_children("*", "MeshInstance3D"):
		curve.add_point(anchor.position)
		anchor.hide()

