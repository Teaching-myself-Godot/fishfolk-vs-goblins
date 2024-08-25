class_name Scores

extends PanelContainer

var _damage_per_monster_type := {
	Constants.MonsterType.FISH_CHIBI: 0,
	Constants.MonsterType.FLYING_FISH: 0,
	Constants.MonsterType.GIANT_TURTLE: 0
}
var _damage_per_player := {
	1: 0, 2: 0, 3: 0, 4: 0, 5: 0
}

var _total_damage = 0

@onready var survival_time_label = $VBoxContainer/PanelContainer/SurvivalTime

@onready var damage_per_player_labels := {
	1: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/PlayerDamage1,
	2: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/PlayerDamage2,
	3: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/PlayerDamage3,
	4: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/PlayerDamage4,
	5: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/PlayerDamage5
}

@onready var damage_per_monster_type_labels := {
	Constants.MonsterType.FISH_CHIBI: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerType/DamageChibiFish,
	Constants.MonsterType.FLYING_FISH: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerType/DamageFlyingFish,
	Constants.MonsterType.GIANT_TURTLE: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerType/DamageGiantTurtle
}

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


func count_damage(player_cid : int, type : Constants.MonsterType, dmg : int) -> void:
	print(InputUtil.player_map)
	if player_cid in InputUtil.player_map:
		var player_num = InputUtil.player_map[player_cid]
		_damage_per_player[player_num] += dmg
		damage_per_player_labels[player_num].text = str(_damage_per_player[player_num])
	_damage_per_monster_type[type] += dmg
	damage_per_monster_type_labels[type].text = str(_damage_per_monster_type[type])
	_total_damage += dmg
	$VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/DamageTotal.text = str(_total_damage)
	$VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerType/DamageTotal.text = str(_total_damage)
