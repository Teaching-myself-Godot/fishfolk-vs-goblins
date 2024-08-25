class_name Scores

extends PanelContainer

@onready var survival_time_label = $VBoxContainer/PanelContainer/SurvivalTime

var _elapsed_time = 0.0

func _process(delta: float) -> void:
	_elapsed_time += delta


func _on_time_elapsed_timer_timeout() -> void:
	var seconds = _elapsed_time - (floori(_elapsed_time / 60) * 60)
	var minutes = floori(_elapsed_time / 60) % 60
	var hours = floori(_elapsed_time / (60 * 60)) % 24
	#print("%.*f" % [2, milis])

	survival_time_label.text = (
		" Survival time: " +
		"%0*d:" % [2, hours] +
		"%0*d:" % [2, minutes] +
		"%0*.*f " % [4, 1, seconds]
	)

