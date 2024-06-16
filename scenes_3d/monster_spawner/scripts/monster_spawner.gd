class_name MonsterSpawner
extends Node3D

var path : MonsterPath
var waves : Array[MonsterWave] = []

signal spawn_monster(path : Path3D, monster : BaseMonster)

func _ready():
	var _paths = find_children("*", "MonsterPath")
	if _paths.size() == 0:
		printerr("MonsterSpawner is missing a path!")
		return

	path = _paths[0]
	for wave : MonsterWave in find_children("*", "MonsterWave"):
		wave.spawn_monster.connect(_on_wave_spawn_monster)
		waves.append(wave)


func _on_wave_spawn_monster(monster : BaseMonster):
	if is_instance_valid(path):
		spawn_monster.emit(path, monster)


func start_wave(wave_number : int):
	for wave in waves:
		if is_instance_valid(wave) and wave.wave_number == wave_number:
			wave.start()
			wave.show()
