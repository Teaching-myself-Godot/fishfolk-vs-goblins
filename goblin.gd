extends CharacterBody3D


const SPEED = 2.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var armature = $metarig

@export var player_num : int = 0

func _ready():
	$AnimationPlayer.play("idle")

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("ui_accept"):
		$AnimationPlayer.play("cheer")

func get_input_dir():
	if player_num == 0:
		return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if player_num == 1:
		return Input.get_vector("a", "d", "w", "s")
	if player_num == 2:
		return Input.get_vector("d", "a", "s", "w")
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = get_input_dir()
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		armature.rotation.y = atan2(velocity.x, velocity.z)
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()
