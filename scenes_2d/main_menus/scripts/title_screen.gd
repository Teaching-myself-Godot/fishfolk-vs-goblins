class_name TitleScreen
extends PanelContainer

signal select_stage(stage : PackedScene)
signal confirm_stage()
@onready var stage_select_options = (
	$"StageSelectMenu/VBoxContainer/StageSelectMenuOptions"
			.find_children("*", "StageSelectOption", false)
)

@onready var tutorial_button = $"StageSelectMenu/VBoxContainer/StageSelectMenuOptions/Tutorial"
@onready var endless_stage_button = $"StageSelectMenu/VBoxContainer/StageSelectMenuOptions/Stage 1-2"
@onready var stage_description = $StageSelectMenu/VBoxContainer/StageDescriptionContainer/StageDescription
@onready var stage_description_container = $StageSelectMenu/VBoxContainer/StageDescriptionContainer
@onready var credits_container = $StageSelectMenu/Credits
@onready var close_credits_button = $StageSelectMenu/Credits/CenterContainer/VBoxContainer/CloseCreditsButton

var _muted := false


func _ready():
	tutorial_button.call_deferred("grab_focus")


func _unhandled_input(_event):
	if not visible:
		return
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()


func open_title_screen():
	InputUtil.player_map = {}
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


func _on_close_credits_button_pressed() -> void:
	for stage_select_option : StageSelectOption in stage_select_options:
		stage_select_option.focus_mode = FocusMode.FOCUS_ALL
	credits_container.hide()
	endless_stage_button.grab_focus()
	stage_description_container.show()
