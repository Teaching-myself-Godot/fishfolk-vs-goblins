class_name ExplosionRing
extends Node3D

var radius = 2.0


func _ready():
	var lc = LandscapeColoration.new(radius, Color(0.169, 0.106, 0), position, 0.005)
	Globals.add_landscape_coloration(lc)
	$ExplosionSound.pitch_scale = 1.0 + randf() * 0.2
	$ExplosionSound.play()


func _on_despawn_timer_timeout():
	queue_free()
