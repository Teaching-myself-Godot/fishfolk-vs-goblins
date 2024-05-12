class_name FlyingFish
extends BaseMonster


func _ready():
	super._ready()
	chest_height = 0.0
	$HPBar.max_hp = 30
	$HPBar.hp = 30
	add_to_group(Constants.GROUP_NAME_MONSTERS_AIRBORNE)
