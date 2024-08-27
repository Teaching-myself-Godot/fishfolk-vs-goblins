class_name Scores

extends PanelContainer

var _damage_per_monster_type := {
	Constants.MonsterType.FISH_CHIBI: 0,
	Constants.MonsterType.FLYING_FISH: 0,
	Constants.MonsterType.GIANT_TURTLE: 0
}
var _damage_per_player := { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 }
var _gems_per_player := { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 }
var _crystals_per_player := { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 }


var _total_damage = 0
var _scroll_target : int = 0

@onready var scroll_container := $VBoxContainer/ScrollContainer
@onready var score_card_container := $VBoxContainer/ScrollContainer/HBoxContainer
@onready var survival_time_label = $VBoxContainer/PanelContainer/SurvivalTime

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

var _elapsed_time = 0.0

func _process(delta: float) -> void:
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

func count_damage(damage_per_player : Dictionary, type : Constants.MonsterType, dmg : int) -> void:
	var shares = Constants.shares(damage_per_player)

	for player_cid in damage_per_player:
		if player_cid in InputUtil.player_map:
			var player_num = InputUtil.player_map[player_cid]
			_damage_per_player[player_num] += dmg * shares[player_cid]

	var total_shares = Constants.shares(_damage_per_player)
	for player_num in _damage_per_player:
		damage_per_player_labels[player_num].text = "%.2f" % (total_shares[player_num] * 100) + '%'

	_damage_per_monster_type[type] += dmg
	damage_per_monster_type_labels[type].text = str(_damage_per_monster_type[type])
	_total_damage += dmg
	$VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/DamageTotal.text = str(_total_damage)
	$VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerType/DamageTotal.text = str(_total_damage)


func count_magical_crystal_collect(player_cid : InputUtil.ControllerID):
	if player_cid in InputUtil.player_map:
		var player_num = InputUtil.player_map[player_cid]
		_crystals_per_player[player_num] += 1
	var total_shares = Constants.shares(_crystals_per_player)
	for player_num in _crystals_per_player:
		crystals_per_player_labels[player_num].text = "%.2f" % (total_shares[player_num] * 100) + '%'
	$VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/CrystalsTotal.text = (
			str(Constants.sum(_crystals_per_player.values()))
	)


func count_builder_gem_collect(player_cid : InputUtil.ControllerID):
	if player_cid in InputUtil.player_map:
		var player_num = InputUtil.player_map[player_cid]
		_gems_per_player[player_num] += 10
	var total_shares = Constants.shares(_gems_per_player)
	for player_num in _gems_per_player:
		gems_per_player_labels[player_num].text = "%.2f" % (total_shares[player_num] * 100) + '%'
	$VBoxContainer/ScrollContainer/HBoxContainer/DamageAndKillsPerPlayer/GemsTotal.text = (
			str(Constants.sum(_gems_per_player.values()))
	)

func _on_sliding_panel_timer_timeout() -> void:
	_scroll_target += scroll_container.size.x
	if _scroll_target >= score_card_container.size.x:
		_scroll_target = 0
