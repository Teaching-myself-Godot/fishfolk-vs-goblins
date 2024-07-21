extends Node2D

const ARROW_POINT_WIDTH = 50

@export var from : Vector2
@export var to : Vector2
@export var color : Color
@export var outline_color : Color

func _process(_delta):
	var size = from.distance_to(to)
	if size < ARROW_POINT_WIDTH + 10:
		size = ARROW_POINT_WIDTH + 10
	
	
	$PointFill.offset.x = size - ARROW_POINT_WIDTH
	$Outline.points[1].x = size - ARROW_POINT_WIDTH + 2
	$Outline.points[2].x = size - ARROW_POINT_WIDTH
	$Outline.points[3].x = size + 3
	$Outline.points[4].x = size - ARROW_POINT_WIDTH
	$Outline.points[5].x = size - ARROW_POINT_WIDTH + 2
	$LineFill.scale.x = size - ARROW_POINT_WIDTH + 2

	position = from
	rotation = from.angle_to_point(to)
	$PointFill.modulate = color
	$LineFill.modulate = color
	$Outline.default_color = outline_color
	queue_redraw()
