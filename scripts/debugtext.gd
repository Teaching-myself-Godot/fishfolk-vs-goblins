extends Label


func _process(_delta):
	text = str(DisplayServer.window_get_size())
