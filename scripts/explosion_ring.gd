class_name ExplosionRing
extends Node3D

var radius = 2.0

func _process(_delta):
	radius -= .1
	radius = 0 if radius < 0 else radius


func _ready():
	add_to_group(Constants.GROUP_NAME_EXPLOSION_RINGS)
	$DespawnTimer.start()


func _on_despawn_timer_timeout():
	queue_free()
