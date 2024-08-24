extends PanelContainer

signal close_credits()

func _on_close_credits_button_pressed() -> void:
	close_credits.emit()
