class_name VolumeSlider

extends HSlider

enum AudioBusKey {
	MASTER, MUSIC, SFX
}
const AUDIO_BUSES := {
	AudioBusKey.MASTER: "Master",
	AudioBusKey.MUSIC: "Music",
	AudioBusKey.SFX: "SFX"
}

@export var audio_bus := AudioBusKey.MASTER

var _bus_idx : int

func _ready() -> void:
	_bus_idx = AudioServer.get_bus_index(AUDIO_BUSES[audio_bus])


func _on_value_changed(val: float) -> void:
	AudioServer.set_bus_volume_db(
		_bus_idx,
		linear_to_db(val)
	)
