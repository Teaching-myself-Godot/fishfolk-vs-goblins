class_name PauseMenu
extends Sprite2D


signal close_pause_menu()


func _unhandled_input(_event):
	if not visible:
		return

	if InputUtil.is_just_released("cancel"):
		close_pause_menu.emit()


func _on_resize():
	position = get_viewport().size / 2


func _ready():
	get_tree().get_root().size_changed.connect(_on_resize)
	_on_resize()
	$Continue.grab_focus()
	$AudioStreamPlayer.play()


func open_menu():
	show()
	$Continue.grab_focus()
	$AudioStreamPlayer.play(0.0)


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
