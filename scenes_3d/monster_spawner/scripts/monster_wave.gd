class_name MonsterWave
extends Timer

signal spawn_monster(monster : BaseMonster)

@export var Monster : PackedScene
@export var wave_number : int = 1
@export var monster_count : int = 10
@export var monster_speed : float = 1.0
@export var monster_hp : int = 10
@export var gems_per_monster : int = 1
@export var crystals_per_wave : int = 1
@export var infinite_wave : bool = false

var monsters_spawned = 0

func _calculate_crystal_drop() -> bool:
	if infinite_wave:
		return randf() < 0.1

	var remaining = monster_count - monsters_spawned
	if crystals_per_wave == remaining:
		crystals_per_wave -= 1
		return true
	return false

func _on_timeout():
	if not infinite_wave and monsters_spawned >= monster_count:
		queue_free()

	var monster : BaseMonster = Monster.instantiate()
	(monster as BaseMonster).speed = monster_speed
	(monster as BaseMonster).hp = monster_hp
	(monster as BaseMonster).drop_crystal = _calculate_crystal_drop()
	(monster as BaseMonster).gems = gems_per_monster
	spawn_monster.emit(monster)

	monsters_spawned += 1
