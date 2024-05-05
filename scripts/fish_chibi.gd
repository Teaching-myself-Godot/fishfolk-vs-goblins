class_name FishChibi
extends BaseMonster


func _ready():
	super._ready()
	chest_height = 1
	$AnimationPlayer.play("bounce")

