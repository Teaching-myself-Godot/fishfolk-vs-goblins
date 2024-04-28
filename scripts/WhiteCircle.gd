extends Node2D

@export var radius = 25

func _draw():
	draw_circle(Vector2(0,0), radius - 1, Color(1, 1, 1, 0.5))
	draw_circle(Vector2(0,0), radius, Color(1, 1, 1, 0.125))
