class_name ExplosionRing
extends Node3D

var radius = 2.0
var fade = 0.0


func _process(_delta):
	fade += 0.005 if fade < 0.9 else 0.0


func _ready():
	add_to_group(Constants.GROUP_NAME_EXPLOSION_RINGS)


func _on_despawn_timer_timeout():
	queue_free()
