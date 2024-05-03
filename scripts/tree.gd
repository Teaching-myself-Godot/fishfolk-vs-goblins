class_name MyTree
extends StaticBody3D

var outlines = []
var felled = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var fall_velocity = 0

func _ready():
	$AnimationPlayer.play("idle")
	outlines = find_children("*Outline")
	toggle_highlight(false)

func _physics_process(delta):
	if felled:
		fall_velocity += gravity * delta
		rotation_degrees.x += fall_velocity
		if rotation_degrees.x > 95:
			queue_free()

func toggle_highlight(flag : bool):
	for outline in outlines:
		outline.visible = flag

func is_within_radius(pos : Vector3, radius : float) -> bool:
	return Vector2(pos.x, pos.z).distance_to(Vector2(position.x, position.z)) < radius

func fell():
	felled = true
	rotation_degrees.y = randi() * 360
