extends Area3D

func _ready():
	$MeshInstance3D.hide()

func _on_area_entered(area):
	if area.is_in_group(Constants.GROUP_NAME_MONSTERS):
		print("TODO: make monster attack nearest target")
		area.queue_free()
