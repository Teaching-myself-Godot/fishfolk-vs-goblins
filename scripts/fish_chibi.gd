class_name FishChibi
extends BaseMonster


func _ready():
	super._ready()
	chest_height = 1.0
	speed = 1.2
	$HPBar.max_hp = 10
	$HPBar.hp = 10
	$AnimationPlayer.play("bounce")
	add_to_group(Constants.GROUP_NAME_MONSTERS_GROUNDED)
