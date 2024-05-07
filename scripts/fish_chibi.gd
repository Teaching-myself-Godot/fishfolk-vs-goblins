class_name FishChibi
extends BaseMonster


func _ready():
	super._ready()
	chest_height = 1.0
	speed = 1.2
	max_hp = 10
	hp = 10
	$AnimationPlayer.play("bounce")


