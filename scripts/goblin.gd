extends CharacterBody3D

const RANGE_RINGED_THINGS_RANGE_5_GROUP_NAME = "ranged_ringed_things_range_5"

const MAX_SPEED = 8
const JUMP_VELOCITY = 9
const MAX_AIRBORNE_TIME = 150

var airborne_time = 0
var speed = 0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var player_num : int = 0
var target_position : Vector3 = Vector3.ZERO
var my_tree = null

signal build_arrow_tower(player_num : int, position : Vector3)


const LABEL_COLORS = [
	Color(0, 0.65, 0.184),
	Color(1, 0.184, 0),
	Color(0, 0.184, 1),
	Color(0.184, 0.5, 0.5),
	Color(0.5, 0.5, 0.184)
]

func _ready():
	airborne_time = 0
	$Label.text = str(player_num) + "p"
	var font_resource = $Label.label_settings.font
	$Label.label_settings = LabelSettings.new()
	$Label.label_settings.font = font_resource
	$Label.label_settings.font_size = 24
	$Label.label_settings.outline_size = 4
	$Label.label_settings.font_color = LABEL_COLORS[player_num]



func _unhandled_input(_event):
	if (Input.is_action_just_pressed("quit") and player_num == 0) or (player_num > 0 and Input.is_action_just_pressed("quit-" + str(player_num - 1))):
		leave_game()

func leave_game():
	$TreeContextMenu.close_and_hide()
	if my_tree and is_instance_valid(my_tree):
		my_tree.toggle_highlight(false)
		my_tree.remove_from_group(RANGE_RINGED_THINGS_RANGE_5_GROUP_NAME)
	queue_free()

func positionLabel():
	$Label.position = CameraUtil.get_label_position(position, Vector3(0.5, 0, 0.1))

func get_input_dir():
	if player_num == 0:
		return Input.get_vector("a", "d", "w", "s").normalized()
	return Vector2(
		Input.get_joy_axis(player_num - 1, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(player_num - 1, JOY_AXIS_LEFT_Y)
	)

func get_mouse_vector_to(pos : Vector2):
	return (get_viewport().get_mouse_position() - pos).normalized()

func should_jump() -> bool:
	if not is_on_floor() or $TreeContextMenu.is_open:
		return false

	return my_button_just_pressed("jump")

func my_button_just_pressed(button_key : String) -> bool:
	if player_num == 0 and Input.is_action_just_pressed(button_key + "-k"):
		return true
	elif player_num > 0 and Input.is_action_just_pressed(button_key + "-" + str(player_num - 1)):
		return true

	return false

func my_button_just_released(button_key : String) -> bool:
	if player_num == 0 and Input.is_action_just_released(button_key + "-k"):
		return true
	elif player_num > 0 and Input.is_action_just_released(button_key + "-" + str(player_num - 1)):
		return true

	return false

func hug_closest_tree():
	if my_tree and is_instance_valid(my_tree):
		my_tree.toggle_highlight(false)
		my_tree = null

	for tree in get_tree().get_nodes_in_group("trees"):
		var d_tree = position.distance_to(tree.position)
		if d_tree < 2.0:
			if not my_tree:
				my_tree = tree
			else:
				my_tree = tree if d_tree < position.distance_to(my_tree.position) else my_tree

	if my_tree and is_instance_valid(my_tree):
		my_tree.toggle_highlight(true)
		$TreeContextMenu.show_at(CameraUtil.get_label_position(my_tree.position, Vector3(2, 0, 0)))
	else:
		$TreeContextMenu.close_and_hide()


func _process(_delta):
	if position.y > 100:
		leave_game()
	hug_closest_tree()

	if my_button_just_pressed("confirm") and my_tree and not $TreeContextMenu.is_open:
		$TreeContextMenu.open()
	elif $TreeContextMenu.is_open:
		handle_menu_arrow_input()
		if (player_num > 0 and my_button_just_pressed("confirm") or (player_num == 0 and my_button_just_released("confirm"))) and my_tree and $TreeContextMenu.is_open:
			var choice = $TreeContextMenu.select_targeted_option()
			if choice != "":
				if my_tree and is_instance_valid(my_tree):
					build_arrow_tower.emit(player_num, my_tree.position)
					my_tree.toggle_highlight(false)
					my_tree.remove_from_group(RANGE_RINGED_THINGS_RANGE_5_GROUP_NAME)
					my_tree = null

	if my_button_just_pressed("cancel") and $TreeContextMenu.is_open:
		if $TreeContextMenu.current_menu == $TreeContextMenu.MAIN_MENU_NAME:
			$TreeContextMenu.close()
		else:
			$TreeContextMenu.close_submenu()




func handle_menu_arrow_input():
	var input_dir = get_input_dir()
	var force = Vector2.ZERO.distance_to(input_dir)
	if player_num == 0 and force == 0 and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		input_dir = get_mouse_vector_to($TreeContextMenu.position)
		force = 1

	if force > 0.5:
		$TreeContextMenu.rotate_arrow(input_dir.normalized().angle())
	else:
		$TreeContextMenu.rotate_arrow(-PI * .5)

	if is_instance_valid(my_tree):
		if $TreeContextMenu.targeted_option == "Arrow":
			my_tree.add_to_group(RANGE_RINGED_THINGS_RANGE_5_GROUP_NAME)
		else:
			my_tree.remove_from_group(RANGE_RINGED_THINGS_RANGE_5_GROUP_NAME)

func _physics_process(delta):
	positionLabel()

	if not is_on_floor():
		velocity.y -= gravity * 3 * delta

	if should_jump():
		velocity.y = JUMP_VELOCITY

	var input_dir = get_input_dir()
	if Input.is_action_pressed("shift"):
		input_dir *= .25
	var force = Vector2.ZERO.distance_to(input_dir)
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()

	if direction and not $TreeContextMenu.is_open:
		direction = direction.rotated(Vector3.UP, CameraUtil.get_cam_pivot().rotation.y)
		speed = force * MAX_SPEED
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		$Armature.rotation.y = atan2(velocity.x, velocity.z)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	if is_on_floor():
		airborne_time = 0
	else:
		if airborne_time < MAX_AIRBORNE_TIME:
			airborne_time += 1
		else:
			velocity.y = -gravity * 100
			position = Vector3(0,4,0)

	if airborne_time < 5:
		if velocity:
			$AnimationTree.set("active", true)
			$AnimationTree.set("parameters/BlendSpace1D/blend_position", force)
			$AnimationTree.set("parameters/TimeScale/scale", .1 + force * .9)
		else:
			$AnimationTree.set("active", false)
			$AnimationPlayer.play("idle")
	else:
		$AnimationTree.set("active", false)
		$AnimationPlayer.play("airborne")

	move_and_slide()
