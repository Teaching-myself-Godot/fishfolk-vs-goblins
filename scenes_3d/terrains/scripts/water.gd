extends MeshInstance3D

var wv = 0.0

func _process(delta):
	wv += delta
	if wv > 4 * PI:
		wv = wv - 4 * PI
	position.y = cos(wv)
