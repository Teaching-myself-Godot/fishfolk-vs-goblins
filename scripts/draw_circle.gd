extends Node2D

@export var radius = 25
@export var color  = Color(0, 0, 0, 0.125)


func _draw():
	draw_circle(Vector2(0,0), radius - 1, color)
	draw_circle(Vector2(0,0), radius, Color(color.r, color.g, color.b, color.a * .5))
