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

const LABEL_COLORS = [
	Color(0, 0.65, 0.184),
	Color(1, 0.184, 0),
	Color(0, 0.184, 1),
	Color(0.184, 0.5, 0.5),
	Color(0.5, 0.5, 0.184)
]

func _ready():
	airborne_time = 0

	$Label.text = "P" + str(player_num)
	$Label.modulate = Color(1, 1, 1, 0.5)
	var font_resource = $Label.label_settings.font
	$Label.label_settings = LabelSettings.new()
	$Label.label_settings.font = font_resource
	$Label.label_settings.font_size = 24
	$Label.label_settings.outline_size = 4
	$Label.label_settings.font_color = LABEL_COLORS[player_num]

func _unhandled_input(_event):
	if Input.is_action_just_pressed("quit") and player_num == 0:
		queue_free()
	if Input.is_action_just_pressed("quit-" + str(player_num -1)):
		queue_free()


func positionLabel():
	var cam : Camera3D = get_tree().get_first_node_in_group("cam").get_child(0)
	$Label.position = cam.unproject_position(Vector3(position.x + 0.5, position.y, position.z + 0.1))

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

	if player_num == 0 and Input.is_key_pressed(KEY_SPACE):
		return true
	if Input.is_joy_button_pressed(player_num - 1, JOY_BUTTON_A):
		return true

	return false

func _physics_process(delta):
	positionLabel()
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
