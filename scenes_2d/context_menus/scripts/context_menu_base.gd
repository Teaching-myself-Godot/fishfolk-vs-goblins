class_name ContextMenuBase
extends Control

signal spend_gems(gems : int, crystals : int)

const MENU_RADIUS    = 320.0
const MAIN_MENU_NAME = "Main"

var initial_option = ""

var current_menu = MAIN_MENU_NAME
var targeted_option = ""
var is_open : bool = false
var menu_options = {}
var menu_labels  = {}


func _init_menu(menu_key : String):
	menu_options[menu_key] = find_child(menu_key + "Menu").find_children("*-option")
	menu_labels[menu_key] = {}
	for opt in menu_options[menu_key]:
		menu_labels[menu_key][opt.name] =  opt.name.replace("-option", "")


func _d_ang(angle1, angle2):
	var diff = angle2 - angle1
	return abs(diff) if abs(diff) < 180 else abs(diff + (360 * -sign(diff)))


func _toggle_option_blink(opt, flag : bool):
	opt.material.set("shader_parameter/blink", flag)


func _get_targeted_option():
	var option_pointed_at = null
	var min_delta = 361.0

	for opt in menu_options[current_menu]:
		_toggle_option_blink(opt, false)
		var delta = _d_ang(
				rad_to_deg($MenuArrow.rotation),
				rad_to_deg(Vector2.ZERO.angle_to_point(opt.position))
		)
		if delta < min_delta:
			min_delta = delta
			option_pointed_at = opt
	return option_pointed_at


func _handle_arrow_rotation():
	var option_pointed_at = _get_targeted_option()
	if option_pointed_at and is_instance_valid(option_pointed_at):
		_toggle_option_blink(option_pointed_at, true)
		$Label.text = menu_labels[current_menu][option_pointed_at.name]
		targeted_option = menu_labels[current_menu][option_pointed_at.name]


func _align():
	position.x = MENU_RADIUS if position.x < MENU_RADIUS else position.x
	position.y = MENU_RADIUS if position.y < MENU_RADIUS else position.y
	position.x = (
			get_viewport().size.x - MENU_RADIUS if position.x + MENU_RADIUS > get_viewport().size.x
			else position.x
	)
	position.y = (
			get_viewport().size.y - MENU_RADIUS if position.y + MENU_RADIUS > get_viewport().size.y
			else position.y
	)


func _process(_delta):
	_align()
	_handle_arrow_rotation()


func show_at(pos : Vector2):
	position = pos
	visible = true
	_align()
	_handle_arrow_rotation()


func close_and_hide():
	for opt in menu_options[current_menu]:
		_toggle_option_blink(opt, false)
	current_menu = MAIN_MENU_NAME
	targeted_option = initial_option
	close()
	visible = false


func open():
	is_open = true
	$AButton.show()
	$MenuArrow.show()
	$BackdropCircle.show()
	$Label.show()
	$MainMenu.show()



func close():
	is_open = false
	$AButton.hide()
	$MenuArrow.hide()
	$BackdropCircle.hide()
	$Label.hide()
	$MainMenu.hide()


func select_targeted_option() -> String:
	if targeted_option in menu_options:
		var menu = find_child(targeted_option + "Menu")
		if is_instance_valid(menu):
			current_menu = targeted_option
			menu.show()
			$MainMenu.hide()
			_play_confirm_sound()
		return ""
	else:
		var choice = targeted_option
		var price_tag : PriceTag = (
			find_child(current_menu + "Menu")
					.find_child(choice + "-option")
					.find_child("PriceTag")
		)
		if price_tag.can_afford:
			close_and_hide()
			spend_gems.emit(
					price_tag.builder_gem_price,
					price_tag.magical_crystal_price
			)
			_play_confirm_sound()
			return choice
		else:
			return ""

func close_submenu():
	for opt in menu_options[current_menu]:
		_toggle_option_blink(opt, false)
	var menu = find_child(current_menu + "Menu")
	if is_instance_valid(menu):
		menu.hide()
	current_menu = MAIN_MENU_NAME
	$MainMenu.show()


func rotate_arrow(angle : float):
	$MenuArrow.rotation = angle


func _on_gem_pouch_contents_changed(_gems : int, _crystals : int):
	printerr("_on_gem_pouch_contents_changed must be overridden")


func _play_confirm_sound():
	$OnConfirmAudioStreamPlayer.play()
	await get_tree().create_timer(0.1).timeout
	$OnConfirmAudioStreamPlayer.stop()
