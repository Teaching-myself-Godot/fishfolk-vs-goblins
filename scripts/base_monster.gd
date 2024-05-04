class_name BaseMonster
extends CharacterBody3D

var chest_height = 0.75
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * 3 * delta

	if Input.is_action_pressed("z-debug-butt"):
		if Input.is_action_pressed("shift"):
			velocity.x = -2
			velocity.z = -2
		else:
			velocity.x = 2
			velocity.z = 2
	else:
		velocity = Vector3.ZERO

	move_and_slide()

func _ready():
	add_to_group(Constants.GROUP_NAME_MONSTERS)
