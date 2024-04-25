extends CharacterBody3D

var airborne_time = 0
var speed = 0
const MAX_SPEED = 8
const JUMP_VELOCITY = 9
const MAX_AIRBORNE_TIME = 150

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var player_num : int = 0

var target_position : Vector3 = Vector3.ZERO

func _ready():
	airborne_time = 0

func _unhandled_input(_event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()


func get_input_dir():
	if player_num == 0:
		return Input.get_vector("a", "d", "w", "s").normalized()
	return Vector2(
		Input.get_joy_axis(player_num - 1, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(player_num - 1, JOY_AXIS_LEFT_Y)
	)

func should_jump() -> bool:
	if not is_on_floor():
		return false
	if not Input.is_action_just_pressed("jump"):
		return false
	if player_num == 0 and Input.is_key_pressed(KEY_SPACE):
		return true
	if Input.is_joy_button_pressed(player_num - 1, JOY_BUTTON_A):
		return true

	return false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * 3 * delta

	if should_jump():
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

	if is_on_floor():
		airborne_time = 0
	else:
		if airborne_time < MAX_AIRBORNE_TIME:
			airborne_time += 1
		else:
			position = Vector3(0,0,0)

	if airborne_time < 10:
		$AnimationTree.set("active", true)
		$AnimationTree.set("parameters/BlendSpace1D/blend_position", force)
	else:
		$AnimationTree.set("active", false)
		$AnimationPlayer.play("airborne")

	move_and_slide()
