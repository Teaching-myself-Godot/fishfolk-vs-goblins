extends Node3D


func _unhandled_input(_e: InputEvent) -> void:
	if Input.is_key_pressed(KEY_1):
		$gull.target = $goblin
	if Input.is_key_pressed(KEY_2) and is_instance_valid($gull.target):
		$gull.flying = true
	if Input.is_key_pressed(KEY_3):
		$gull.target = $Roost
	if Input.is_key_pressed(KEY_4):
		$gull.target = $"flying-fish"
	if Input.is_key_pressed(KEY_5):
		$gull.cry()


var wv = 0.0

func _process(delta):
	wv += delta
	if wv > 4 * PI:
		wv = wv - 4 * PI
	$Roost.position.y = 5 + cos(wv) * 4

