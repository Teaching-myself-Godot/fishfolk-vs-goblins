extends StaticBody3D

var outlines = []
var goblin_hugged = null

func _ready():
	$AnimationPlayer.play("idle")
	outlines = find_children("*Outline")
	toggle_outline(false)

func toggle_outline(flag : bool):
	for outline in outlines:
		outline.visible = flag

func hug_goblin(goblin):
	if goblin_hugged:
		if position.distance_to(goblin.position) < position.distance_to(goblin_hugged.position):
			goblin_hugged = goblin
	else:
		goblin_hugged = goblin

func _process(_delta):
	if goblin_hugged:
		if is_instance_valid(goblin_hugged):
			if position.distance_to(goblin_hugged.position) > 2:
				goblin_hugged = null
				toggle_outline(false)
			else:
				toggle_outline(true)
		else:
			goblin_hugged = null
			toggle_outline(false)
