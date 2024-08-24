class_name TowerRumble

extends AudioStreamPlayer3D

var _done = true

func play_long(tm : float):
	_done = false
	$Timer.wait_time = tm
	$Timer.start()
	play()


func _on_timer_timeout() -> void:
	_done = true
	stop()


func _on_finished() -> void:
	if not _done:
		play()
