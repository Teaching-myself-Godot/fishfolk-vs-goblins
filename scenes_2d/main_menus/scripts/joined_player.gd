class_name JoinedPlayer
extends PanelContainer

signal new_player_name_submitted()
var cid = InputUtil.ControllerID.GAMEPAD_1

@onready var player_name = $VBoxContainer/HBoxContainer/LineEdit
@onready var gamepad_icon = $VBoxContainer/HBoxContainer/GamepadIcon
@onready var keyboard_icon = $VBoxContainer/HBoxContainer/KeyboardIcon
@onready var hint_label = $VBoxContainer/HintLabel

func _ready() -> void:
	var _pmap = InputUtil.player_map()
	if cid in _pmap:
		var player_num = _pmap[cid]
		player_name['theme_override_colors/font_color'] = Constants.LABEL_COLORS[player_num - 1]
		player_name.text = InputUtil.get_player_name(cid)
		player_name.placeholder_text = InputUtil.get_player_name(cid)
	if cid == InputUtil.ControllerID.KEYBOARD:
		keyboard_icon.show()
		gamepad_icon.hide()
		hint_label.text = "- Press escape to leave -"
	else:
		gamepad_icon.show()
		keyboard_icon.hide()
		hint_label.text = "- Press select to leave -"


func _on_line_edit_text_changed(new_text: String) -> void:
	InputUtil.set_player_name(cid, new_text)


func _on_line_edit_text_submitted(new_text: String) -> void:
	InputUtil.set_player_name(cid, new_text)
	new_player_name_submitted.emit()
