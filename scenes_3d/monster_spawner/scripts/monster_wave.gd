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
@export var crystal_chance := 0.1
@export var gem_chance := 0.25

@onready var label := $Control/HBoxContainer/Label
@onready var thumbnail_texture := $Control/HBoxContainer/TextureRect

var monsters_spawned = 0
var my_monsters : Array = []

func _calculate_crystal_drop() -> bool:
	if infinite_wave:
		return randf() < crystal_chance

	var remaining = monster_count - monsters_spawned
	if crystals_per_wave == remaining:
		crystals_per_wave -= 1
		return true
	return false


func _calculate_gem_drop():
	if infinite_wave:
		var gems = 0
		for _i in range(0, gems_per_monster):
			gems += 1 if randf() < gem_chance else 0
		return gems
	
	return gems_per_monster


func _on_poll_wave_cleared_timer_timeout():
	if not infinite_wave and monsters_spawned > 0 and monsters_spawned >= monster_count:
		var monsters_left = monsters_spawned
		for m in my_monsters:
			if not is_instance_valid(m):
				monsters_left -= 1
		if monsters_left == 0:
			queue_free()


func _on_timeout():
	if not infinite_wave and monsters_spawned >= monster_count:
		return

	var monster : BaseMonster = Monster.instantiate()
	(monster as BaseMonster).speed = monster_speed
	(monster as BaseMonster).hp = monster_hp
	(monster as BaseMonster).drop_crystal = _calculate_crystal_drop()
	(monster as BaseMonster).gems = _calculate_gem_drop()
	spawn_monster.emit(monster)
	if not infinite_wave:
		my_monsters.append(monster)
	monsters_spawned += 1
	_update_label()


func _update_label(text : String = ""):
	if infinite_wave:
		label.text = "∞ "
	else:
		label.text = str(monsters_spawned) + " / " + str(monster_count)


func _ready():
	var monster : BaseMonster = Monster.instantiate()
	thumbnail_texture.texture = monster.thumbnail
	_update_label()
	monster.queue_free()


func show():
	$Control.show()
