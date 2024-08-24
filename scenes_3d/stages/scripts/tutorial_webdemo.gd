extends Tutorial


var _started = false

func _on_spawn_turtle_flipper_dust_particles(_pos : Vector3):
	pass

func _on_spawn_dust_particle(_pos : Vector3):
	pass


func _unhandled_input(_event: InputEvent) -> void:
	if not _started and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_started = true
		_add_goblin_to_scene(0)
		get_tree().get_first_node_in_group("web_splash_screen").hide()
		$TuneNo1Player.play()


func _on_play_with_gamepad_button_pressed() -> void:
	if not _started:
		_started = true
		_add_goblin_to_scene(1)
		get_tree().get_first_node_in_group("web_splash_screen").hide()
		$TuneNo1Player.play()


func _on_tune_no_1_player_finished() -> void:
	if _started:
		$TuneNo1Player.play()
