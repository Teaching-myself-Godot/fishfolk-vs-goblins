class_name TitleScreen
extends CenterContainer

signal select_stage(stage : PackedScene)
signal confirm_stage()

var JoinedPlayerScene = preload("res://scenes_2d/main_menus/joined_player.tscn")

@onready var stage_select_options = (
	$MainContainer/StageSelectMenu/VBoxContainer/StageSelectMenuOptions
			.find_children("*", "StageSelectOption", false)
)

@onready var tutorial_button = $"MainContainer/StageSelectMenu/VBoxContainer/StageSelectMenuOptions/Tutorial"
@onready var endless_stage_button = $"MainContainer/StageSelectMenu/VBoxContainer/StageSelectMenuOptions/Stage 1-2"
@onready var stage_description = $MainContainer/StageSelectMenu/VBoxContainer/StageDescriptionContainer/StageDescription
@onready var stage_description_container = $MainContainer/StageSelectMenu/VBoxContainer/StageDescriptionContainer
@onready var credits_container = $MainContainer/StageSelectMenu/Credits
@onready var close_credits_button = $MainContainer/StageSelectMenu/Credits/CenterContainer/VBoxContainer/CloseCreditsButton
@onready var player_list = $MainContainer/VBoxContainer/VBoxContainer
@onready var join_hint = $MainContainer/VBoxContainer/JoinHint/Label

var _muted := false

var _prev_cids_connected = 0

func _ready():
	tutorial_button.call_deferred("grab_focus")
	_rerender_joined_players()
	_prev_cids_connected = InputUtil.cids_registered.size()


func _process(_delta):
	if _prev_cids_connected != InputUtil.cids_registered.size():
		_prev_cids_connected = InputUtil.cids_registered.size()
		_rerender_joined_players()


func _rerender_joined_players():
	for x in player_list.get_children():
		x.queue_free()

	for cid in InputUtil.cids_registered:
		var joined_player : JoinedPlayer = JoinedPlayerScene.instantiate()
		joined_player.cid = cid
		player_list.add_child(joined_player)
		joined_player.new_player_name_submitted.connect(func(): tutorial_button.grab_focus())
	if InputUtil.ControllerID.KEYBOARD in InputUtil.cids_registered:
		join_hint.text = "- Join: press start -"
	else:
		join_hint.text = "- Join: start / space -"


func _unhandled_input(_event):
	if not visible:
		return
	if Input.is_action_just_released("leave-k"):
		InputUtil.cids_registered.erase(InputUtil.ControllerID.KEYBOARD)
	if Input.is_action_just_released("leave-0"):
		InputUtil.cids_registered.erase(InputUtil.ControllerID.GAMEPAD_1)
	if Input.is_action_just_released("leave-1"):
		InputUtil.cids_registered.erase(InputUtil.ControllerID.GAMEPAD_2)
	if Input.is_action_just_released("leave-2"):
		InputUtil.cids_registered.erase(InputUtil.ControllerID.GAMEPAD_3)
	if Input.is_action_just_released("leave-3"):
		InputUtil.cids_registered.erase(InputUtil.ControllerID.GAMEPAD_4)
	if InputUtil.cids_registered.is_empty():
		$MainContainer.hide()
		get_tree().quit()


func open_title_screen():
	show()
	_muted = true
	$UnmuteTimer.start()
	endless_stage_button.grab_focus()


func _on_select_stage(my_stage: PackedScene, description : String) -> void:
	stage_description.text = description
	select_stage.emit(my_stage)
	if not _muted:
		$OnSelectAudioStreamPlayer.play()
		await get_tree().create_timer(0.1).timeout
		$OnSelectAudioStreamPlayer.stop()


func _on_stage_confirmed() -> void:
	confirm_stage.emit()
	$OnConfirmAudioStreamPlayer.play()
	await get_tree().create_timer(0.1).timeout
	$OnConfirmAudioStreamPlayer.stop()


func _on_unmute_timer_timeout() -> void:
	_muted = false


func _on_credits_button_pressed() -> void:
	for stage_select_option : StageSelectOption in  stage_select_options:
		stage_select_option.focus_mode = FocusMode.FOCUS_NONE
	credits_container.show()
	close_credits_button.grab_focus()
	stage_description_container.hide()
	$MainContainer/VBoxContainer.hide()


func _on_close_credits_button_pressed() -> void:
	for stage_select_option : StageSelectOption in stage_select_options:
		stage_select_option.focus_mode = FocusMode.FOCUS_ALL
	credits_container.hide()
	endless_stage_button.grab_focus()
	stage_description_container.show()
	$MainContainer/VBoxContainer.show()
	
