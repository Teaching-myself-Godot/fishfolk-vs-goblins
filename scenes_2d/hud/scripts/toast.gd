class_name Toast
extends Control

@export var message : String = "message"
@export var duration : float = 3.0

var fading = false


func _ready():
	$Label.text = message
	$DurationTimer.wait_time = duration
	$DurationTimer.start()
	modulate.a = 0.0

func _process(_delta):
	if fading:
		modulate.a -= 0.05
		if modulate.a <= 0.0:
			queue_free()
	elif modulate.a < 1.0:
		modulate.a += 0.1

func _on_duration_timer_timeout():
	fading = true

func scale_up():
	$overlay.scale.x += .15
