class_name JoinedPlayer
extends PanelContainer

var cid = InputUtil.ControllerID.GAMEPAD_1

@onready var player_label = $VBoxContainer/HBoxContainer/PlayerLabel
@onready var gamepad_icon = $VBoxContainer/HBoxContainer/GamepadIcon
@onready var keyboard_icon = $VBoxContainer/HBoxContainer/KeyboardIcon
@onready var hint_label = $VBoxContainer/HintLabel

func _ready() -> void:
	var _pmap = InputUtil.player_map()
	if cid in _pmap:
		var player_num = _pmap[cid]
		var font_resource = player_label.label_settings.font
		player_label.label_settings = LabelSettings.new()
		player_label.label_settings.font = font_resource
		player_label.label_settings.font_size = 32
		player_label.label_settings.outline_size = 6
		player_label.label_settings.font_color = Constants.LABEL_COLORS[player_num - 1]
		player_label.text = " Player " + str(player_num)
	if cid == InputUtil.ControllerID.KEYBOARD:
		keyboard_icon.show()
		gamepad_icon.hide()
		hint_label.text = "- Press escape to leave -"
	else:
		gamepad_icon.show()
		keyboard_icon.hide()
		hint_label.text = "- Press select to leave -"
