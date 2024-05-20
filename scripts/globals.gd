extends Node

signal range_rings_changed()


var range_rings = []
var landscape_colorations = []


func add_range_ring(rr : RangeRing):
	range_rings.push_front(rr)
	if range_rings.size() > 60:
		range_rings.pop_back()
	range_rings_changed.emit()


func drop_range_ring(rr : RangeRing):
	range_rings.erase(rr)
	range_rings_changed.emit()


func add_landscape_coloration(lc : LandscapeColoration):
	landscape_colorations.push_back(lc)
	if landscape_colorations.size() > 60:
		landscape_colorations.pop_front()


func drop_landscape_coloration(lc : LandscapeColoration):
	landscape_colorations.erase(lc)

