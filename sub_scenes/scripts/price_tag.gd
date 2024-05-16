class_name PriceTag
extends Control

@export var builder_gem_price : int = 100
@export var magical_crystal_price : int = 0

func _ready():
	$BuilderGemPrice.text = str(builder_gem_price)
	if magical_crystal_price > 0:
		$MagicalCrystalPrice.text = str(magical_crystal_price)
	else:
		$MagicalCrystalPrice.hide()
		$MagicalCrystalSubViewport.hide()


func update_label_colors(gems : int, crystals : int):
	if gems < builder_gem_price:
		$BuilderGemPrice.label_settings.font_color = Color.RED
		$BuilderGemPrice.label_settings.outline_color = Color.RED
	else:
		$BuilderGemPrice.label_settings.font_color = Color(0.031, 0.937, 0)
		$BuilderGemPrice.label_settings.outline_color = Color(0, 0.855, 0.247)
		
	if crystals < magical_crystal_price:
		$MagicalCrystalPrice.label_settings.font_color = Color.RED
		$MagicalCrystalPrice.label_settings.outline_color = Color.RED
	else:
		$MagicalCrystalPrice.label_settings.font_color = Color(0.42, 0, 0.647)
		$MagicalCrystalPrice.label_settings.outline_color = Color(1, 0.557, 1)

