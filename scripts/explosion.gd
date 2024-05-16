class_name Explosion
extends Node3D

var duration = 0.5
var size = 10.0

func _on_despawn_timer_timeout():
	queue_free()

func _process(_delta):
	$GPUParticles3D.get_material_override().albedo_color.a -= 0.03
	$GPUParticles3D2.get_material_override().albedo_color.a -= 0.03
	$GPUParticles3D2.get_draw_pass_mesh(0).size.x += size  * 0.1
	$GPUParticles3D2.visible = true

func _ready():
	$DespawnTimer.wait_time = duration
	$GPUParticles3D.get_draw_pass_mesh(0).size = Vector2(size, size)
	$DespawnTimer.start()
