extends CharacterBody3D

var speed = 0
const MAX_SPEED = 8
const JUMP_VELOCITY = 9

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var player_num : int = 0

var target_position : Vector3 = Vector3.ZERO

func _ready():
	$AnimationPlayer.play("idle")

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("ui_accept"):
		$AnimationPlayer.play("cheer")

func get_input_dir():
	if player_num == 0:
		return Input.get_vector("a", "d", "w", "s").normalized()
	if player_num == 1:
		return Vector2(
			Input.get_joy_axis(0, JOY_AXIS_LEFT_X), 
			Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
		)
	if player_num == 2:
		return Vector2(
			Input.get_joy_axis(1, JOY_AXIS_LEFT_X), 
			Input.get_joy_axis(1, JOY_AXIS_LEFT_Y)
		)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * 3 * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = get_input_dir()
	if Input.is_action_pressed("shift"):
		input_dir *= .25
	var force = Vector2.ZERO.distance_to(input_dir)
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()

	if direction:
		speed = force * MAX_SPEED
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		$Armature.rotation.y = 0.5 * PI + atan2(velocity.x, velocity.z)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	var jump_force = 0 if is_on_floor() else velocity.y
	if velocity.y < 1 and not is_on_floor():
		jump_force = 1

	$AnimationTree.set("parameters/BlendSpace2D/blend_position", Vector2(force, jump_force))

	move_and_slide()

func _on_static_body_3d_input_event(camera, event, pos, normal, shape_idx):
	var mouse_click = event as InputEventMouseButton
	if mouse_click and mouse_click.button_index == 1 and mouse_click.pressed:
		target_position = pos
