extends Control

var is_open = false

const MENU_RADIUS    = 200.0
const MAIN_MENU_NAME = "Main"
const INITIAL_OPTION = "All-Range" 
var current_menu    = MAIN_MENU_NAME
var targeted_option = INITIAL_OPTION

var menu_options = {}
var menu_labels  = {}

func _ready():
	$BackdropCircle.radius = MENU_RADIUS
	init_menu(MAIN_MENU_NAME)
	init_menu("All-Range")
	init_menu("Ground")
	init_menu("Air")
	
func init_menu(menu_key : String):
	menu_options[menu_key] = find_child(menu_key + "Menu").find_children("*-option")
	menu_labels[menu_key] = {}
	for opt in menu_options[menu_key]:
		menu_labels[menu_key][opt.name] =  opt.name.replace("-option", "")

func show_at(pos : Vector2):
	position = pos
	align()
	visible = true

func close_and_hide():
	targeted_option = INITIAL_OPTION
	current_menu = MAIN_MENU_NAME
	close()
	visible = false

func open():
	is_open = true
	$AButton.show()
	$MenuArrow.show()
	$BackdropCircle.show()
	$Label.show()
	$MainMenu.show()
	$"All-RangeMenu".hide()
	$GroundMenu.hide()
	$AirMenu.hide()

func close():
	is_open = false
	$AButton.hide()
	$MenuArrow.hide()
	$BackdropCircle.hide()
	$Label.hide()
	$MainMenu.hide()
	$"All-RangeMenu".hide()
	$GroundMenu.hide()
	$AirMenu.hide()


func select_targeted_option() -> String:
	if targeted_option in menu_options:
		var menu = find_child(targeted_option + "Menu")
		if is_instance_valid(menu):
			current_menu = targeted_option
			menu.show()
			$MainMenu.hide()
		return ""
	else:
		close_and_hide()
		return targeted_option

func close_submenu():
	var menu = find_child(current_menu + "Menu")
	if is_instance_valid(menu):
		menu.hide()
	current_menu = MAIN_MENU_NAME
	$MainMenu.show()

func d_ang(angle1, angle2):
	var diff = angle2 - angle1
	return abs(diff) if abs(diff) < 180 else abs(diff + (360 * -sign(diff)))

func rotate_arrow(angle : float):
	$MenuArrow.rotation = angle




func align():
	position.x = MENU_RADIUS if position.x < MENU_RADIUS else position.x
	position.y = MENU_RADIUS if position.y < MENU_RADIUS else position.y
	position.x = get_viewport().size.x - MENU_RADIUS if position.x + MENU_RADIUS > get_viewport().size.x else position.x
	position.y = get_viewport().size.y - MENU_RADIUS if position.y + MENU_RADIUS > get_viewport().size.y else position.y
	var pointing_at = null
	var min_delta = 361.0
	for opt in menu_options[current_menu]:
		var delta = d_ang(rad_to_deg($MenuArrow.rotation), rad_to_deg(Vector2.ZERO.angle_to_point(opt.position)))
		opt.material.set("shader_parameter/blink", false)
		if delta < min_delta:
			min_delta = delta
			pointing_at = opt
	
	if pointing_at and is_instance_valid(pointing_at):
		pointing_at.material.set("shader_parameter/blink", true)
		$Label.text = menu_labels[current_menu][pointing_at.name]
		targeted_option = menu_labels[current_menu][pointing_at.name]

func _process(_delta):
	align()
