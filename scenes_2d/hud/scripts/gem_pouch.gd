class_name GemPouch
extends Node2D

signal liquidity_change(gems : int, crystals : int)


@export var builder_gems     : int = 0
@export var magical_crystals : int = 0

var cribs : int = 0
var builder_gems_showing : int = 0
var magical_crystals_showing : int = 0
var builder_gem_count_label : Label
var magical_crystal_count_label : Label
var crib_count_label : Label


func _ready():
	builder_gems_showing = builder_gems
	magical_crystals_showing = magical_crystals
	builder_gem_count_label = $BuilderGems/Label
	magical_crystal_count_label = $MagicalGems/Label
	crib_count_label = $Cribs/Label
	_update_labels()
	liquidity_change.emit(builder_gems, magical_crystals)
	get_tree().get_root().size_changed.connect(_on_resize)
	_on_resize()


func _update_labels():
	builder_gem_count_label.text = str(builder_gems_showing)
	magical_crystal_count_label.text = str(magical_crystals_showing)
	crib_count_label.text = str(cribs)


func collect_builder_gem():
	builder_gems += 10
	liquidity_change.emit(builder_gems, magical_crystals)


func collect_magical_crystal():
	magical_crystals += 1
	liquidity_change.emit(builder_gems, magical_crystals)


func lose_baby():
	cribs -= 1 if cribs > 0 else 0
	_update_labels()


func spend_gems(gems : int, crystals : int):
	builder_gems -= gems
	magical_crystals -= crystals
	builder_gems = 0 if builder_gems < 0 else builder_gems
	magical_crystals = 0 if magical_crystals < 0 else magical_crystals
	liquidity_change.emit(builder_gems, magical_crystals)


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


func _on_resize():
	if position.y != get_viewport().size.y:
		position.y = get_viewport().size.y
