class_name Explosion
extends Node3D


func _on_despawn_timer_timeout():
	queue_free()

func _process(_delta):
	$GPUParticles3D.get_material_override().albedo_color.a -= 0.03
	$GPUParticles3D2.get_material_override().albedo_color.a -= 0.03
	$GPUParticles3D2.get_draw_pass_mesh(0).size.x += 1
	
func _ready():
	$DespawnTimer.start()
