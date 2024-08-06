extends Node3D

var _alpha = 1.0

func _on_timer_timeout() -> void:
	_alpha -= 0.01
	$"path-arrow/Cube_001".get_surface_override_material(0).albedo_color.a = _alpha
	if _alpha <= 0:
		queue_free()
