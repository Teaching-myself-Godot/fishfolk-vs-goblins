class_name PathPreview
extends PathFollow3D

signal show_arrow(position : Vector3, next_position : Vector3)

var _prev_pos : Vector3 = Vector3.INF

func _on_timer_timeout() -> void:
	progress += 3
	if _prev_pos != Vector3.INF:
		show_arrow.emit(_prev_pos, position)
	_prev_pos = position
	if progress_ratio >= 1:
		queue_free()
