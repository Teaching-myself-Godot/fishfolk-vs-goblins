class_name HPBar
extends Node2D

var max_hp : int = 10
var hp     : int = 5

func _draw():
	#ct(rect: Rect2, color: Color, filled: bool = true, width: float = -1.0)
	#draw_rect(Rect2(0,1, max_hp * 3 + 2, 1), Color(255, 255, 255, 0.3))
	#draw_rect(Rect2(1,0, max_hp * 3, 12), Color(255, 255, 255, 0.3))

	draw_rect(Rect2(0, 1, 1, 10), Color(255, 255, 255, 0.6))

	draw_rect(Rect2(1, 0, max_hp * 3, 1), Color(255, 255, 255, 0.6))

	draw_rect(Rect2(1, 1, hp * 3, 10), Color(255, 0, 0, 0.6))
	draw_rect(Rect2(1 + hp * 3, 1, max_hp * 3 - hp * 3, 10), Color(0, 0, 0, 0.4))

	draw_rect(Rect2(1, 12, max_hp * 3, 1), Color(255, 255, 255, 0.6))
	draw_rect(Rect2(max_hp * 3 + 1, 1, 1, 10), Color(255, 255, 255, 0.6))
