class_name Explosion
extends Node3D


func _on_despawn_timer_timeout():
	queue_free()

func _ready():
	$DespawnTimer.start()
