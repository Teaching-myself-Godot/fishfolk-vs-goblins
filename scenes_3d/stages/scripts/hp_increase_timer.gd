class_name HPIncreaseTimer
extends Timer

@export var increase_by : int = 5
var ToastScene = preload("res://scenes_2d/hud/toast.tscn")


func _on_timeout():
	for toasted in get_tree().get_nodes_in_group(Constants.GROUP_NAME_TOASTS):
		toasted.queue_free()

	for wave : MonsterWave in get_tree().get_nodes_in_group(Constants.GROUP_NAME_MONSTER_WAVES):
		wave.monster_hp += increase_by

	var toast = ToastScene.instantiate()
	toast.message = "The monsters just got tougher!"
	toast.duration = 3
	toast.scale_up()
	get_parent().add_child.call_deferred(toast)
