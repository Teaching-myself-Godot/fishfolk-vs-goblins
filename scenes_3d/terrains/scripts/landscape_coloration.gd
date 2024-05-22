class_name LandscapeColoration
extends Object


var position : Vector3 = Vector3.ZERO
var radius = 2.0
var fade = 0.0
var color = Color.WHITE
var fade_progression = 0.005

func _init(rad : float, c : Color, pos : Vector3, fp : float):
	radius = rad
	color = c
	position = pos
	fade_progression = fp
