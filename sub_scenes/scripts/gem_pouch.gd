class_name GemPouch

extends Node2D

@export var builder_gems     : int = 300
@export var magical_crystals : int = 0

var builder_gems_showing : int = builder_gems
var magical_crystals_showing : int = magical_crystals
var builder_gem_count_label : Label
var magical_crystal_count_label : Label



func _ready():
	builder_gem_count_label = $BuilderGems/Label
	magical_crystal_count_label = $MagicalGems/Label
	_update_labels()

func _update_labels():
	builder_gem_count_label.text = str(builder_gems_showing)
	magical_crystal_count_label.text = str(magical_crystals_showing)


func collect_builder_gem():
	builder_gems += 10


func collect_magical_crystal():
	magical_crystals += 1


func _process(_delta):
	var should_update = false
	if builder_gems > builder_gems_showing:
		builder_gems_showing += 1
		should_update = true
	elif builder_gems < builder_gems_showing:
		builder_gems_showing -= 1
		should_update = true

	if magical_crystals > magical_crystals_showing:
		magical_crystals_showing += 1
		should_update = true
	elif magical_crystals < magical_crystals_showing:
		magical_crystals_showing -= 1
		should_update = true

	if should_update == true:
		_update_labels()
	
	if position.y != get_viewport().size.y:
		position.y = get_viewport().size.y

