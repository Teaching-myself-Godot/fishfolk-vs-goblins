class_name TitleScreen
extends PanelContainer

signal select_stage(stage : PackedScene)
signal confirm_stage()
@onready var stage_select_options = (
	$"StageSelectMenu/VBoxContainer/StageSelectMenuOptions"
			.find_children("*", "StageSelectOption", false)
)

var _muted := false


func _ready():
	$"StageSelectMenu/VBoxContainer/StageSelectMenuOptions/Tutorial".call_deferred("grab_focus")


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
	$"StageSelectMenu/VBoxContainer/StageSelectMenuOptions/Stage 1-2".grab_focus()


func _on_select_stage(my_stage: PackedScene) -> void:
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
	$StageSelectMenu/Credits.show()
	$StageSelectMenu/Credits/CenterContainer/VBoxContainer/CloseCreditsButton.grab_focus()


func _on_close_credits_button_pressed() -> void:
	for stage_select_option : StageSelectOption in stage_select_options:
		stage_select_option.focus_mode = FocusMode.FOCUS_ALL
	$StageSelectMenu/Credits.hide()
	$"StageSelectMenu/VBoxContainer/StageSelectMenuOptions/Stage 1-2".grab_focus()
