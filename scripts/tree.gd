extends StaticBody3D

var outlines = []
var felled = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var fall_velocity = 0
func _ready():
	$AnimationPlayer.play("idle")
	outlines = find_children("*Outline")
	toggle_highlight(false)

func toggle_highlight(flag : bool):
	for outline in outlines:
		outline.visible = flag

func _physics_process(delta):
	if felled:
		fall_velocity += gravity * delta
		rotation_degrees.x += fall_velocity
		if rotation_degrees.x > 95:
			queue_free()
	
