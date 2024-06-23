extends Node3D

func _ready():
	$AnimationPlayer.play("idle")
	$AnimationPlayer.speed_scale = 0.5
