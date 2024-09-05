class_name HPIncreaseTimer
extends Timer

@export var increase_by := [
	1,
	1,
	1,
	3,
	8
]
var ToastScene = preload("res://scenes_2d/hud/toast.tscn")


func _on_timeout():
	for toasted in get_tree().get_nodes_in_group(Constants.GROUP_NAME_TOASTS):
		toasted.queue_free()

	var i = 0
	for wave : MonsterWave in get_tree().get_nodes_in_group(Constants.GROUP_NAME_MONSTER_WAVES):
		wave.monster_hp += increase_by[i]
		i += 1

	var toast = ToastScene.instantiate()
	toast.message = "The fishfolk just got tougher!"
	toast.duration = 5
	toast.scale_up()
	get_parent().add_child.call_deferred(toast)
