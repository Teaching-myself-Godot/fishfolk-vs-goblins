extends Node3D


func _ready():
	$GPUParticles3D.emitting = true;


func _on_despawn_timer_timeout():
	queue_free()
