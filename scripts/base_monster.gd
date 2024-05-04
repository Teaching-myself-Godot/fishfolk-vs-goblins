class_name BaseMonster
extends CharacterBody3D

var chest_height = 0.75


func _physics_process(_delta):
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
