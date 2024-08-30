extends MeshInstance3D

@export var amplitude := 1.0
@export var attack := 1.0
var wv = 0.0

func _process(delta):
	wv += delta * attack
	if wv > 4 * PI:
		wv = wv - 4 * PI
	position.y = cos(wv) * amplitude
