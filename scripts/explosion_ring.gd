class_name ExplosionRing
extends Node3D

var radius = 2.0
var my_landscape_coloration : LandscapeColoration = null


func _on_coloration_fade_timer_timeout():
	if my_landscape_coloration:
		my_landscape_coloration.fade += 0.015 if my_landscape_coloration.fade < 0.9 else 0.0
		Globals.landscape_colorations_changed.emit()


func _ready():
	my_landscape_coloration = LandscapeColoration.new(radius, Color(0.169, 0.106, 0), position)
	Globals.add_landscape_coloration(my_landscape_coloration)
	$ExplosionSound.pitch_scale = 1.0 + randf() * 0.2
	$ExplosionSound.play()


func _on_despawn_timer_timeout():
	Globals.drop_landscape_coloration(my_landscape_coloration)
	queue_free()
