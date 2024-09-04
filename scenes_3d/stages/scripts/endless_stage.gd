class_name EndlessStage
extends Stage

@onready var chibi_waves := [
	$MonsterSpawner/MonsterWave,
	$MonsterSpawner2/MonsterWave,
	$MonsterSpawner3/MonsterWave,
]

@onready var flying_fish_wave = $MonsterSpawner4/MonsterWave2
@onready var turtle_wave = $MonsterSpawner5/MonsterWave

func _pause_chibi_waves():
	for wave : MonsterWave in chibi_waves:
		wave.stop()
	await get_tree().create_timer(6).timeout
	for wave : MonsterWave in chibi_waves:
		wave.start()


func _on_goblin_build_cannon_tower(player_num : int, pos : Vector3):
	var new_tower : CannonTower = super._on_goblin_build_cannon_tower(player_num, pos)
	new_tower.current_damage = 1


func _on_speed_increase_timer_timeout() -> void:
	if flying_fish_wave.monster_speed >= 5:
		_mk_toast("The flying fish cannot go any faster!", 15.0, true)

		$SpeedIncreaseTimer.stop()
		return
	_mk_toast("The flying fish just got faster!", 5.0, true)
	flying_fish_wave.monster_speed += .25


func _on_drops_increase_timer_timeout() -> void:
	_mk_toast("More crystals will be dropped!", 15.0, true)
	for wave : MonsterWave in chibi_waves:
		wave.crystal_drop_percentage += 1 if wave.crystal_drop_percentage < 100 else 0
	flying_fish_wave.crystal_drop_percentage += 20 if flying_fish_wave.crystal_drop_percentage < 100 else 0
