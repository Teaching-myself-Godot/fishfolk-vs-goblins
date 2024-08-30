class_name GameOverSplash
extends PanelContainer

signal close_gameover_splash();


func _unhandled_input(_event):
	if not visible:
		return

	if (
		InputUtil.is_just_released("start") or
		InputUtil.is_just_released("confirm") or
		InputUtil.is_just_released("cancel")
	):
		close_gameover_splash.emit()


func _on_button_pressed() -> void:
	close_gameover_splash.emit()
