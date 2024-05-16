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
		$BuilderGemPrice.position = Vector2(20, 20)
		$BuilderGemSubViewport.position = Vector2(128, 24)
