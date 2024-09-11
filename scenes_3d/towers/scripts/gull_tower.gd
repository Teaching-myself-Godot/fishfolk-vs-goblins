class_name GullTower
extends BaseTower

var GullScene := preload("res://scenes_3d/projectiles/gull.tscn")
@onready var roosts := find_children("Roost*")


func _ready() -> void:
	super()
	for roost in roosts:
		var gull : Gull = GullScene.instantiate()
		gull.roost = roost
		gull.target = roost
		gull.position = Vector3(randf_range(-20, 20), 50, randf_range(-20, 20))
		add_child.call_deferred(gull)
