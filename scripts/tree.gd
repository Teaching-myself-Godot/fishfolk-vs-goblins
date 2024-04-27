extends StaticBody3D

var outlines = []
var goblin_hugged = null

func _ready():
	$AnimationPlayer.play("idle")
	outlines = find_children("*Outline")
	toggle_menu(false)

func toggle_menu(flag : bool):
	for outline in outlines:
		outline.visible = flag
	$Menu.visible = flag
	$Menu.position = CameraUtil.get_label_position(position, Vector3(2, 0, 0))

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
				toggle_menu(false)
			else:
				toggle_menu(true)
		else:
			goblin_hugged = null
			toggle_menu(false)
