class_name Scores

extends PanelContainer

@export var is_end_score := false

var _damage_per_monster_type := {
	Constants.MonsterType.FISH_CHIBI: 0,
	Constants.MonsterType.FLYING_FISH: 0,
	Constants.MonsterType.GIANT_TURTLE: 0
}

var _monsters_overkilled := {
	Constants.MonsterType.FISH_CHIBI: 0,
	Constants.MonsterType.FLYING_FISH: 0,
	Constants.MonsterType.GIANT_TURTLE: 0
}

var _monsters_killed := {
	Constants.MonsterType.FISH_CHIBI: 0,
	Constants.MonsterType.FLYING_FISH: 0,
	Constants.MonsterType.GIANT_TURTLE: 0
}


var _damage_per_player := { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 }
var _gems_per_player := { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 }
var _crystals_per_player := { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 }

var _scroll_target : int = 0

@onready var scroll_container := $VBoxContainer/ScrollContainer
@onready var score_card_container := $VBoxContainer/ScrollContainer/HBoxContainer
@onready var survival_time_label = $VBoxContainer/PanelContainer/SurvivalTime

@onready var player_names := {
	1: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/Player1,
	2: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/Player2,
	3: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/Player3,
	4: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/Player4,
	5: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/Player5
}


@onready var damage_per_player_labels := {
	1: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/PlayerDamage1,
	2: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/PlayerDamage2,
	3: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/PlayerDamage3,
	4: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/PlayerDamage4,
	5: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/PlayerDamage5
}

@onready var gems_per_player_labels := {
	1: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/PlayerGems1,
	2: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/PlayerGems2,
	3: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/PlayerGems3,
	4: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/PlayerGems4,
	5: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/PlayerGems5
}

@onready var crystals_per_player_labels := {
	1: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/PlayerCrystals1,
	2: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/PlayerCrystals2,
	3: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/PlayerCrystals3,
	4: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/PlayerCrystals4,
	5: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/PlayerCrystals5
}


@onready var damage_per_monster_type_labels := {
	Constants.MonsterType.FISH_CHIBI: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerType/DamageChibiFish,
	Constants.MonsterType.FLYING_FISH: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerType/DamageFlyingFish,
	Constants.MonsterType.GIANT_TURTLE: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerType/DamageGiantTurtle
}

@onready var kills_per_monster_type_labels := {
	Constants.MonsterType.FISH_CHIBI: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerType/KilledChibiFish,
	Constants.MonsterType.FLYING_FISH: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerType/KilledFlyingFish,
	Constants.MonsterType.GIANT_TURTLE: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerType/KilledGiantTurtle
}

@onready var overkills_per_monster_type_labels := {
	Constants.MonsterType.FISH_CHIBI: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerType/OverkillChibiFish,
	Constants.MonsterType.FLYING_FISH: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerType/OverkillFlyingFish,
	Constants.MonsterType.GIANT_TURTLE: $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerType/OverkillGiantTurtle
}
var _elapsed_time = 0.0

@onready var player_rows = {
	1: find_children("Player*1"),
	2: find_children("Player*2"),
	3: find_children("Player*3"),
	4: find_children("Player*4"),
	5: find_children("Player*5")
}

@onready var total_damage_label = $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerType/DamageTotal
@onready var total_kills_label = $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerType/KilledTotal
@onready var total_overkills_label =  $VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerType/OverkillTotal


func _ready():
	for player_num in player_rows:
		for label in player_rows[player_num]:
			label.hide()


func _process(delta: float) -> void:
	if not is_end_score:
		_elapsed_time += delta

	if scroll_container.scroll_horizontal != _scroll_target:
		var next = lerp(scroll_container.scroll_horizontal, _scroll_target + _scroll_target / 10, 0.05)
		if abs(next - _scroll_target) < 2:
			next = _scroll_target
		scroll_container.scroll_horizontal = next


func _on_time_elapsed_timer_timeout() -> void:
	var seconds = _elapsed_time - (floori(_elapsed_time / 60) * 60)
	var minutes = floori(_elapsed_time / 60) % 60
	var hours = floori(_elapsed_time / (60 * 60)) % 24

	survival_time_label.text = (
		" Survival time: " +
		"%0*d:" % [2, hours] +
		"%0*d:" % [2, minutes] +
		"%0*.*f " % [4, 1, seconds]
	)


func show_player(cid : InputUtil.ControllerID):
	if cid in InputUtil.player_map():
		for label in player_rows[InputUtil.player_map()[cid]]:
			label.show()
		
		player_names[InputUtil.player_map()[cid]].text = InputUtil.get_player_name(cid)


func rank_players():
	var dmg_shares = Constants.shares(_damage_per_player)
	var gem_shares = Constants.shares(_gems_per_player)
	var cry_shares = Constants.shares(_crystals_per_player)
	var tot_shares = {}
	for player_num in _damage_per_player:
		tot_shares[player_num] = (
			dmg_shares[player_num] * 3 +
				gem_shares[player_num] +
				cry_shares[player_num]
		)
	var srted = tot_shares.keys()
	srted.sort_custom(func (a, b): return tot_shares[a] > tot_shares[b])
	for j in range(srted.size()):
		var player_num = srted[j]
		var child_pos = (j + 1) * player_rows[player_num].size()
		for i in range(player_rows[player_num].size()):
			$VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer.move_child(
				player_rows[player_num][i], child_pos + i
			)
			if i == player_rows[player_num].size() - 1:
				if tot_shares[player_num]:
					player_rows[player_num][i].text = "%.1f" % (tot_shares[player_num] * 2.0)
				else:
					player_rows[player_num][i].text = "0.0"


func _update_player_labels(stat : Dictionary, label_dict : Dictionary):
	var total_shares = Constants.shares(stat)
	for player_num in stat:
		label_dict[player_num].text = "%d" % (total_shares[player_num] * 100) + '%'


func count_damage(damage_per_player : Dictionary, type : Constants.MonsterType, dmg : int) -> void:
	var shares = Constants.shares(damage_per_player)

	for player_cid in damage_per_player:
		if player_cid in InputUtil.player_map():
			var player_num = InputUtil.player_map()[player_cid]
			_damage_per_player[player_num] += dmg * shares[player_cid]

	_update_player_labels(_damage_per_player, damage_per_player_labels)

	_damage_per_monster_type[type] += dmg
	damage_per_monster_type_labels[type].text = str(_damage_per_monster_type[type])
	total_damage_label.text = str(Constants.sum(_damage_per_monster_type.values()))
	rank_players()


func count_magical_crystal_collect(player_cid : InputUtil.ControllerID):
	if player_cid in InputUtil.player_map():
		var player_num = InputUtil.player_map()[player_cid]
		_crystals_per_player[player_num] += 1
	_update_player_labels(_crystals_per_player, crystals_per_player_labels)
	rank_players()


func count_builder_gem_collect(player_cid : InputUtil.ControllerID):
	if player_cid in InputUtil.player_map():
		var player_num = InputUtil.player_map()[player_cid]
		_gems_per_player[player_num] += 10
	_update_player_labels(_gems_per_player, gems_per_player_labels)
	rank_players()


func count_overkill(type : Constants.MonsterType):
	_monsters_overkilled[type] += 1
	overkills_per_monster_type_labels[type].text = str(_monsters_overkilled[type])
	total_overkills_label.text = str(Constants.sum(_monsters_overkilled.values()))


func count_kill(type : Constants.MonsterType):
	_monsters_killed[type] += 1
	kills_per_monster_type_labels[type].text = str(_monsters_killed[type])
	total_kills_label.text = str(Constants.sum(_monsters_killed.values()))


func _on_sliding_panel_timer_timeout() -> void:
	_scroll_target += scroll_container.size.x
	if _scroll_target >= score_card_container.size.x:
		_scroll_target = 0


func copy_from(other : Scores):
	_elapsed_time = other._elapsed_time
	_crystals_per_player = other._crystals_per_player.duplicate(true)
	_gems_per_player = other._gems_per_player.duplicate(true)
	_damage_per_monster_type = other._damage_per_monster_type.duplicate(true)
	_monsters_killed = other._monsters_killed.duplicate(true)	
	_monsters_overkilled = other._monsters_overkilled.duplicate(true)
	_damage_per_player = other._damage_per_player.duplicate(true)
	for type in _monsters_killed.keys():
		kills_per_monster_type_labels[type].text = str(_monsters_killed[type])
		overkills_per_monster_type_labels[type].text = str(_monsters_overkilled[type])
		damage_per_monster_type_labels[type].text = str(_damage_per_monster_type[type])
	total_damage_label.text = str(Constants.sum(_damage_per_monster_type.values()))
	total_overkills_label.text = str(Constants.sum(_monsters_overkilled.values()))
	total_kills_label.text = str(Constants.sum(_monsters_killed.values()))

	_update_player_labels(_crystals_per_player, crystals_per_player_labels)
	_update_player_labels(_gems_per_player, gems_per_player_labels)
	_update_player_labels(_damage_per_player, damage_per_player_labels)
	_on_time_elapsed_timer_timeout()
	rank_players()
