extends StaticBody3D

var outlines = []

func _ready():
	$AnimationPlayer.play("idle")
	outlines = find_children("*Outline")
	toggle_highlight(false)

func toggle_highlight(flag : bool):
	for outline in outlines:
		outline.visible = flag
