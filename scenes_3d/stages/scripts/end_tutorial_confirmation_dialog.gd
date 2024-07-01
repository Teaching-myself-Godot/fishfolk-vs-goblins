extends ConfirmationDialog

func _unhandled_input(_event):
	if InputUtil.is_just_released("cancel"):
		canceled.emit()
