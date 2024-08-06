class_name PriceTag
extends Control

@export var builder_gem_price : int = 100
@export var magical_crystal_price : int = 0

var last_known_gems : int = 0
var last_known_crystals : int = 0
var can_afford = false

func _ready():
	_update_labels()


func _update_labels():
	if builder_gem_price < 0 or magical_crystal_price < 0:
		$BuilderGemPrice.text = "Max"
		$MagicalCrystalPrice.text = "Max"
	else:
		$BuilderGemPrice.text = str(builder_gem_price)
		$MagicalCrystalPrice.text = str(magical_crystal_price)


func update_price(gems : int, crystals : int):
	builder_gem_price = gems
	magical_crystal_price = crystals
	_update_labels()
	update_affordable_status(last_known_gems, last_known_crystals)


func update_affordable_status(gems : int, crystals : int):
	last_known_gems = gems
	last_known_crystals = crystals
	can_afford = true
	if gems < builder_gem_price or builder_gem_price < 0:
		$BuilderGemPrice.label_settings.font_color = Color.RED
		$BuilderGemPrice.label_settings.outline_color = Color.RED
		can_afford = false
	else:
		$BuilderGemPrice.label_settings.font_color = Color(0.031, 0.937, 0)
		$BuilderGemPrice.label_settings.outline_color = Color(0, 0.855, 0.247)

	if crystals < magical_crystal_price or magical_crystal_price < 0:
		$MagicalCrystalPrice.label_settings.font_color = Color.RED
		$MagicalCrystalPrice.label_settings.outline_color = Color.RED
		can_afford = false
	else:
		$MagicalCrystalPrice.label_settings.font_color = Color(0.42, 0, 0.647)
		$MagicalCrystalPrice.label_settings.outline_color = Color(1, 0.557, 1)
