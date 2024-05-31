class_name Goblin
extends CharacterBody3D

signal build_arrow_tower(player_num : int, position : Vector3)
signal build_cannon_tower(player_num : int, position : Vector3)
signal build_anti_air_tower(player_num : int, position : Vector3)


const HUG_RANGE = 3.0
const MAX_SPEED = 8
const JUMP_VELOCITY = 9
const MAX_AIRBORNE_TIME = 150
const LABEL_COLORS = [
	Color(0, 0.65, 0.184),
	Color(1, 0.184, 0),
	Color(0, 0.184, 1),
	Color(0.184, 0.5, 0.5),
	Color(0.5, 0.5, 0.184)
]

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var chest_height = 1.2
var airborne_time = 0
var speed = 0
var player_num : int = 0
var target_position : Vector3 = Vector3.ZERO
var my_tree : MyTree = null
var my_tower : BaseTower = null
var my_riding_turtle : GiantTurtle = null

func _initialize_label():
	$Label.text = str(player_num) + "p"
	var font_resource = $Label.label_settings.font
	$Label.label_settings = LabelSettings.new()
	$Label.label_settings.font = font_resource
	$Label.label_settings.font_size = 24
	$Label.label_settings.outline_size = 4
	$Label.label_settings.font_color = LABEL_COLORS[player_num]


func _leave_game():
	_unhighlight_my_huggables()
	$TreeContextMenu.close_and_hide()
	queue_free()


func _reposition_label():
	$Label.position = CameraUtil.get_label_position(position, Vector3(0.5, 0, 0.1))


func _get_input_vector() -> Vector2:
	if player_num == 0:
		return Input.get_vector("a", "d", "w", "s").normalized()
	return Vector2(
		Input.get_joy_axis(player_num - 1, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(player_num - 1, JOY_AXIS_LEFT_Y)
	)


func _get_mouse_vector_to(pos : Vector2) -> Vector2:
	return (get_viewport().get_mouse_position() - pos).normalized()


# per user button just pressed detection 
func _my_button_just_pressed(button_key : String) -> bool:
	if player_num == 0 and Input.is_action_just_pressed(button_key + "-k"):
		return true
	elif player_num > 0 and Input.is_action_just_pressed(button_key + "-" + str(player_num - 1)):
		return true

	return false


# per user button release detection 
func _my_button_just_released(button_key : String) -> bool:
	if player_num == 0 and Input.is_action_just_released(button_key + "-k"):
		return true
	elif player_num > 0 and Input.is_action_just_released(button_key + "-" + str(player_num - 1)):
		return true

	return false


func _should_jump() -> bool:
	# can only start jump if on floor and no context menu is open
	if not is_on_floor() or $TreeContextMenu.is_open:
		return false

	return _my_button_just_pressed("jump")


func _pressed_valid_confirm_for_a_context_menu() -> bool:
	var joy_confirmed = player_num > 0 and _my_button_just_pressed("confirm")
	var mouse_confirmed = player_num == 0 and _my_button_just_released("confirm")	
	return joy_confirmed or mouse_confirmed


func _pressed_confirm_in_tree_context_menu() -> bool:
	return _pressed_valid_confirm_for_a_context_menu() and my_tree and $TreeContextMenu.is_open

func _handle_context_menu_confirm():
	# if a valid final choice is made (select_targeted_option returns non-empy string)
	# then apply the choice (like: build a tower from the TreeContextMenu)
	if _pressed_confirm_in_tree_context_menu():
		var choice = $TreeContextMenu.select_targeted_option()
		if choice != "" and my_tree and is_instance_valid(my_tree):
			if choice == "Arrow":
				build_arrow_tower.emit(player_num, my_tree.position)
			elif choice == "Cannon":
				build_cannon_tower.emit(player_num, my_tree.position)
			elif choice == "Anti-Air":
				build_anti_air_tower.emit(player_num, my_tree.position)
			my_tree.toggle_highlight(false)
			my_tree = null
			if player_num > 0:
				Input.start_joy_vibration(player_num - 1, .5, .25, 1.5)


func _handle_context_menu_arrow_input():
	var input_dir = _get_input_vector()
	var force = Vector2.ZERO.distance_to(input_dir)
	
	# handle mouse cursor input for arrow
	if player_num == 0 and force == 0 and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		input_dir = _get_mouse_vector_to($TreeContextMenu.position)
		force = 1

	# rotate the arrow to the pointed at angle
	if force > 0.5:
		$TreeContextMenu.rotate_arrow(input_dir.normalized().angle())
	else:
		$TreeContextMenu.rotate_arrow(-PI * .5)

	# highlight the range of any currently targeted tower in the context menu
	if is_instance_valid(my_tree):
		var opt = $TreeContextMenu.targeted_option
		if  opt == "Arrow":
			my_tree.set_range_ring(Constants.ARROW_TOWER_BASE_RANGE)
		elif opt == "Anti-Air":
			my_tree.set_range_ring(Constants.ANTI_AIR_TOWER_BASE_RANGE)
		elif opt == "Cannon":
			my_tree.set_range_ring(Constants.CANNON_TOWER_BASE_RANGE)
		else:
			my_tree.drop_range_ring()
			my_tree.drop_range_ring()

func _handle_context_menus():
	# open the context menu if requested and valid,
	# else handle any open context menu
	if _my_button_just_pressed("confirm") and my_tree and not $TreeContextMenu.is_open:
		$TreeContextMenu.open()
	elif $TreeContextMenu.is_open:
		_handle_context_menu_arrow_input()
		_handle_context_menu_confirm()

	# close the context menu, or submenu if requested and valid
	if _my_button_just_pressed("cancel") and $TreeContextMenu.is_open:
		if $TreeContextMenu.current_menu == $TreeContextMenu.MAIN_MENU_NAME:
			$TreeContextMenu.close()
		else:
			$TreeContextMenu.close_submenu()

func _get_closest_huggable(group_name : String) -> Node3D:
	var closest_huggable = null

	for candidate in get_tree().get_nodes_in_group(group_name):
		var d_candidate = position.distance_to(candidate.position)
		if d_candidate < HUG_RANGE:
			if not closest_huggable or d_candidate < position.distance_to(closest_huggable.position):
				closest_huggable = candidate

	return closest_huggable

func _unhighlight_my_huggables():
	# unhighlight my tree
	if my_tree and is_instance_valid(my_tree):
		my_tree.toggle_highlight(false)
		my_tree = null

	# unhighlight my tower
	if my_tower and is_instance_valid(my_tower):
		my_tower.toggle_highlight(false)
		my_tower = null


func _hug_closest_tree_or_tower():
	# unhighlight things I can '_hug_' (get an interactive context menu with)
	_unhighlight_my_huggables()

	# set my tree to the closest tree on the map, if within hugging range
	my_tree = _get_closest_huggable(Constants.GROUP_NAME_TREES)
	# set my tower to the closest tower on the map, if within hugging range
	my_tower = _get_closest_huggable(Constants.GROUP_NAME_TOWERS)

	# get the closest one of those 2
	if my_tower and my_tree:
		if position.distance_to(my_tower.position) < position.distance_to(my_tree.position):
			my_tree = null
		else:
			my_tower = null

	# highlight the closest tree for me if I have one
	if my_tree and is_instance_valid(my_tree):
		my_tree.toggle_highlight(true)
		$TreeContextMenu.show_at(CameraUtil.get_label_position(my_tree.position, Vector3(2, 0, 0)))
	else:
		$TreeContextMenu.close_and_hide()

	if my_tower and is_instance_valid(my_tower):
		my_tower.toggle_highlight(true)
	else:
		pass


func _handle_jumping():
	if _should_jump():
		velocity.y = JUMP_VELOCITY


func _handle_running(force : float, direction : Vector3):
	# we can only run when we're not interacting with a menu
	if direction and not $TreeContextMenu.is_open:
		direction = direction.rotated(Vector3.UP, CameraUtil.get_cam_pivot().rotation.y)
		speed = force * MAX_SPEED
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		$Armature.rotation.y = atan2(velocity.x, velocity.z)
	else:

		if is_instance_valid(my_riding_turtle):
			if position.distance_to(my_riding_turtle.position) > 0.5:
				direction = position.direction_to(my_riding_turtle.position).normalized()
				velocity.x = direction.x * MAX_SPEED
				velocity.z = direction.z * MAX_SPEED
			else:
				position.x = my_riding_turtle.position.x
				position.z = my_riding_turtle.position.z
				velocity.x = 0
				velocity.z = 0
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)

func _handle_falling(delta : float):
	if is_on_floor():
		# safely on the ground, we do not need to keep track of how long we've
		# been falling
		airborne_time = 0
	else:
		velocity.y -= gravity * 3 * delta
		if airborne_time < MAX_AIRBORNE_TIME:
			# we're just keeping track of how long we're falling
			airborne_time += 1
		else:
			# we fell for a hundred frames and need to be rescued
			# apply a reasonable fall speed
			velocity.y = -gravity * 100
			# position us 4 metres in the air at the map origin
			position = Vector3(0, 4, 0)


func _handle_animation(force : float):
	if airborne_time < 5:
		if velocity and not is_instance_valid(my_riding_turtle):
			$AnimationTree.set("active", true)
			$AnimationTree.set("parameters/BlendSpace1D/blend_position", force)
			$AnimationTree.set("parameters/TimeScale/scale", .1 + force * .9)
		else:
			$AnimationTree.set("active", false)
			$AnimationPlayer.play("idle")
	else:
		$AnimationTree.set("active", false)
		$AnimationPlayer.play("airborne")


func _ready():
	add_to_group(Constants.GROUP_NAME_GOBLINS)
	airborne_time = 0
	_initialize_label()


func _process(_delta):
	_hug_closest_tree_or_tower()
	_handle_context_menus()

	if _my_button_just_released("quit"):
		_leave_game()

func _physics_process(delta):
	var input_dir = _get_input_vector()
	var force = Vector2.ZERO.distance_to(input_dir)
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()

	_handle_falling(delta)
	_handle_jumping()
	_handle_running(force, direction)
	_handle_animation(force)

	move_and_slide()

	_reposition_label()


func _on_gem_pouch_contents_changed(gems : int, crystals : int):
	$TreeContextMenu._on_gem_pouch_contents_changed(gems, crystals)
