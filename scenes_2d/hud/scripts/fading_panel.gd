class_name FadingPanel

extends Panel

@export var fading = false

func _ready():
	modulate.a = 0.0


func _process(_delta):
	if not fading and not visible:
		show()
	if fading and modulate.a > 0.0:
		modulate.a -= 0.025
	elif modulate.a < 1.0:
		modulate.a += 0.025
