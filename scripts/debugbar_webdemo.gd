extends Label

func _process(_delta):
	text = "(currently running at " + str(Engine.get_frames_per_second()) + " fps)"
