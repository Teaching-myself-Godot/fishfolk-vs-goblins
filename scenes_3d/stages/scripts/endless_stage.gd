class_name EndlessStage
extends Stage

@onready var chibi_waves := [
	$MonsterSpawner/MonsterWave,
	$MonsterSpawner2/MonsterWave,
	$MonsterSpawner3/MonsterWave,
]

func _pause_chibi_waves():
	for wave : MonsterWave in chibi_waves:
		wave.stop()
	await get_tree().create_timer(6).timeout
	for wave : MonsterWave in chibi_waves:
		wave.start()
