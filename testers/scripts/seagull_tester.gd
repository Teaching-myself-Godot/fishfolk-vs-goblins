extends Node3D


func _unhandled_input(_e: InputEvent) -> void:
	if Input.is_key_pressed(KEY_1):
		$gull.target = $goblin
	if Input.is_key_pressed(KEY_2):
		$gull.flying = true
	if Input.is_key_pressed(KEY_3):
		$gull.target = $Roost
	if Input.is_key_pressed(KEY_4):
		$gull.target = $"flying-fish"
	if Input.is_key_pressed(KEY_5):
		if $gull.flying:
			$gull/gull/AnimationPlayer.play("cry")
		else:
			$gull/gull/AnimationPlayer.play("idle_cry")
