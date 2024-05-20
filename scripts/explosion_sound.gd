class_name ExplosionSound
extends Node3D

var radius = 2.0


func _ready():
	$ExplosionSound.pitch_scale = 1.0 + randf() * 0.2
	$ExplosionSound.play()


func _on_despawn_timer_timeout():
	queue_free()
