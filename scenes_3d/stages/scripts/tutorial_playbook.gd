extends Node

var _indicators : Array = []
var _range_ring : RangeRing = RangeRing.new(Vector3.ZERO, 2)


func _ready() -> void:
	_indicators = find_children("*", "Indicator")


func show_next_indicator_3d(target : Node3D, height_3d : float = 0.0, ring_radius : float = 0.0):
	var next_indicator : Indicator = _indicators.pop_front()
	if is_instance_valid(target):
		next_indicator.target = target
	next_indicator.fading = false
	next_indicator.height_3d = height_3d
