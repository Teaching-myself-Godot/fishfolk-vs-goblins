extends Control

var is_open = false

const MENU_RADIUS = 200.0

var type_options = []
var type_labels = {}

func _ready():
	$BackdropCircle.radius = MENU_RADIUS
	type_options = $TypeMenu.find_children("*-option")
	for type_option in type_options:
		type_labels[type_option.name] = type_option.name.replace("-option", "")

func show_at(pos : Vector2):
	position = pos
	align()
	visible = true

func close_and_hide():
	close()
	visible = false

func open():
	is_open = true
	$AButton.show()
	$MenuArrow.show()
	$BackdropCircle.show()
	$Label.show()
	$TypeMenu.show()

func d_ang(angle1, angle2):
	var diff = angle2 - angle1
	return abs(diff) if abs(diff) < 180 else abs(diff + (360 * -sign(diff)))

func rotate_arrow(angle : float):
	$MenuArrow.rotation = angle


func close():
	is_open = false
	$AButton.hide()
	$MenuArrow.hide()
	$BackdropCircle.hide()
	$Label.hide()
	$TypeMenu.hide()

func align():
	position.x = MENU_RADIUS if position.x < MENU_RADIUS else position.x
	position.y = MENU_RADIUS if position.y < MENU_RADIUS else position.y
	position.x = get_viewport().size.x - MENU_RADIUS if position.x + MENU_RADIUS > get_viewport().size.x else position.x
	position.y = get_viewport().size.y - MENU_RADIUS if position.y + MENU_RADIUS > get_viewport().size.y else position.y
	var pointing_at = type_options[1]
	var min_delta = 361.0
	for opt in type_options:
		var delta = d_ang(rad_to_deg($MenuArrow.rotation), rad_to_deg(Vector2.ZERO.angle_to_point(opt.position)))
		opt.material.set("shader_parameter/blink", false)
		if delta < min_delta:
			min_delta = delta
			pointing_at = opt

	pointing_at.material.set("shader_parameter/blink", true)
	$Label.text = type_labels[pointing_at.name]

func _process(_delta):
	align()
