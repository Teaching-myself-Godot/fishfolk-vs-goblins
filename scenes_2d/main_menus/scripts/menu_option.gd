class_name MenuOption
extends Button

var muted := true

func _on_focus_entered():
	$BButton.show()
	modulate = Color(1, 1, 1, 1)
	if not muted:
		$OnSelectAudioStreamPlayer.play()
		await get_tree().create_timer(0.1).timeout
		$OnSelectAudioStreamPlayer.stop()


func _on_focus_exited():
	$BButton.hide()
	modulate = Color(1, 1, 1, 0.4)
