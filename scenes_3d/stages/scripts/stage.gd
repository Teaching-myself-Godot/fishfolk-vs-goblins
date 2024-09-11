class_name Stage
extends Node

signal open_pause_menu()
signal gameover()
signal stage_won()
signal gameover_with_scores(score_card : Scores)

const MAX_MONSTERS = 80
const FRAME_CNT_MAX = 3
var frame_cnt = 0
var assigned_frame = 0

var GoblinScene = preload("res://scenes_3d/player/goblin.scn")
var ArrowTowerScene = preload("res://scenes_3d/towers/arrow_tower.scn")
var CannonTowerScene = preload("res://scenes_3d/towers/cannon_tower.scn")
var AntiAirTowerScene = preload("res://scenes_3d/towers/anti_air_tower.scn")
var GullTowerScene = preload("res://scenes_3d/towers/gull_tower.tscn")
var FishChibiScene = preload("res://scenes_3d/monsters/fish_chibi.scn")
var FlyingFishScene = preload("res://scenes_3d/monsters/flying_fish.scn")
var GiantTurtleScene = preload("res://scenes_3d/monsters/giant_turtle.scn")
var ExplosionScene = preload("res://scenes_3d/effects/explosion.tscn")
var ExplosionSoundScene = preload("res://scenes_3d/effects/explosion_sound.tscn")
var MagicalCrystalScene = preload("res://scenes_3d/drop_items/magical_crystal.tscn")
var BuilderGemScene = preload("res://scenes_3d/drop_items/builder_gem.tscn")
var DustParticlesScene = preload("res://scenes_3d/effects/dust_particles.tscn")
var TurtleFlipperDustParticlesScene = preload("res://scenes_3d/effects/turtle_flipper_dust_particles.tscn")
var ToastScene = preload("res://scenes_2d/hud/toast.tscn")

var gem_pouch : GemPouch
var goblin_map = {}
var _stage_started = false
var _started_in_debug_mode = false
var _score_card : Scores = null
var wave_emitters_present = []
var monster_waves = []

func _debug_start():
	if OS.is_debug_build() and not _stage_started:
		_started_in_debug_mode = true
		for hud_item in get_tree().get_nodes_in_group(Constants.GROUP_NAME_HUD_ITEM):
			hud_item.show()
		_start_wave(1)


func _unhandled_input(_event):
	if Input.is_action_just_released("start-k") and not _is_in_game(0):
		_add_goblin_to_scene(0)
	if Input.is_action_just_released("start-0") and not _is_in_game(1):
		_add_goblin_to_scene(1)
	if Input.is_action_just_released("start-1") and not _is_in_game(2):
		_add_goblin_to_scene(2)
	if Input.is_action_just_released("start-2") and not _is_in_game(3):
		_add_goblin_to_scene(3)
	if Input.is_action_just_released("start-3") and not _is_in_game(4):
		_add_goblin_to_scene(4)
	if Input.is_key_pressed(KEY_F5):
		_debug_start()
	if Input.is_key_pressed(KEY_ESCAPE) and _started_in_debug_mode:
		get_tree().quit()

func _is_in_game(num : int):
	if num in goblin_map:
		if goblin_map[num] and is_instance_valid(goblin_map[num]):
			return true
		else:
			goblin_map.erase(num)
	return false


func _add_goblin_to_scene(num : int, start_pos : Vector3 = Vector3.ZERO):
	CameraUtil.get_cam().current = true

	var new_goblin : Goblin = GoblinScene.instantiate()
	goblin_map[num] = new_goblin
	new_goblin.player_num = num
	if start_pos:
		new_goblin.position = start_pos
	elif find_child("GoblinSpawnPoint"):
		new_goblin.position = find_child("GoblinSpawnPoint").position
	else:
		new_goblin.position = Vector3(0, 4, 0)

	var goblin_already_in_stage = get_tree().get_first_node_in_group(Constants.GROUP_NAME_GOBLINS)
	if is_instance_valid(goblin_already_in_stage):
		new_goblin.position.x = goblin_already_in_stage.position.x + (-2 + randf() * 4)
		new_goblin.position.z = goblin_already_in_stage.position.z + (-2 + randf() * 4)
		new_goblin.position.y = goblin_already_in_stage.position.y + 4

	new_goblin.build_arrow_tower.connect(_on_goblin_build_arrow_tower)
	new_goblin.build_cannon_tower.connect(_on_goblin_build_cannon_tower)
	new_goblin.build_anti_air_tower.connect(_on_goblin_build_anti_air_tower)
	new_goblin.request_pause_menu.connect(_on_goblin_request_pause_menu)
	gem_pouch.liquidity_change.connect(new_goblin._on_gem_pouch_contents_changed)
	new_goblin._on_gem_pouch_contents_changed(gem_pouch.builder_gems, gem_pouch.magical_crystals)
	new_goblin.find_child("TreeContextMenu").spend_gems.connect(gem_pouch.spend_gems)
	new_goblin.find_child("TowerContextMenu").spend_gems.connect(gem_pouch.spend_gems)
	add_child.call_deferred(new_goblin)

	if is_instance_valid(_score_card):
		_score_card.show_player(num)


func _on_goblin_request_pause_menu():
	open_pause_menu.emit()


func _on_goblin_build_anti_air_tower(player_num : int, pos : Vector3):
	var new_tower : GullTower = GullTowerScene.instantiate()
	new_tower.built_by_player(player_num)
	new_tower.position = Vector3(pos.x, pos.y - 4, pos.z)
	new_tower.rise_target_position = Vector3(pos.x, pos.y - 0.5, pos.z)
	#new_tower.fire_anti_air_missile.connect(_on_missile_tower_fire_missile)
	new_tower.drop_builder_gem.connect(_on_drop_builder_gem)
	add_child.call_deferred(new_tower)


func _on_goblin_build_cannon_tower(player_num : int, pos : Vector3):
	var new_tower : CannonTower = CannonTowerScene.instantiate()
	new_tower.built_by_player(player_num)
	new_tower.position = Vector3(pos.x, pos.y - 4, pos.z)
	new_tower.rise_target_position = Vector3(pos.x, pos.y - 0.5, pos.z)
	new_tower.fire_cannon_ball.connect(_on_cannon_tower_fire_cannon_ball)
	new_tower.drop_builder_gem.connect(_on_drop_builder_gem)
	add_child.call_deferred(new_tower)
	return new_tower


func _on_goblin_build_arrow_tower(player_num : int, pos : Vector3):
	var new_tower : ArrowTower = ArrowTowerScene.instantiate()
	new_tower.built_by_player(player_num)
	new_tower.position = Vector3(pos.x, pos.y - 4, pos.z)
	new_tower.rise_target_position = Vector3(pos.x, pos.y - 0.5, pos.z)
	new_tower.load_arrow.connect(_on_arrow_tower_load_arrow)
	new_tower.drop_builder_gem.connect(_on_drop_builder_gem)
	add_child.call_deferred(new_tower)


func _on_arrow_tower_load_arrow(arrow : Arrow):
	add_child.call_deferred(arrow)


func _on_missile_tower_fire_missile(missile : AntiAirMissile):
	missile.spawn_explosion.connect(_on_missile_spawn_explosion)
	add_child.call_deferred(missile)


func _on_cannon_tower_fire_cannon_ball(cannon_ball : CannonBall):
	cannon_ball.spawn_explosion.connect(_on_cannon_ball_spawn_explosion)
	add_child.call_deferred(cannon_ball)


func _on_missile_spawn_explosion(pos : Vector3):
	var explosion = ExplosionScene.instantiate()
	explosion.duration = 0.25
	explosion.size = 3.0
	explosion.position = pos
	add_child.call_deferred(explosion)


func _on_cannon_ball_spawn_explosion(pos : Vector3):
	var explosion = ExplosionScene.instantiate()
	explosion.position = pos
	add_child.call_deferred(explosion)

	for i in range(3):
		TerrainShaderParams.add_landscape_coloration(
			LandscapeColoration.new(
				randf() * 2.0,
				Color(0.169, 0.106, 0),
				pos + Vector3(-2.0 + randf() * 4, 0.0,  -2.0 + randf() * 4.0),
				0.005
			)
		)

	var main_explosion_ring = ExplosionSoundScene.instantiate()
	main_explosion_ring.position = pos
	TerrainShaderParams.add_landscape_coloration(
		LandscapeColoration.new(2.0, Color(0.169, 0.106, 0), pos, 0.005)
	)
	add_child.call_deferred(main_explosion_ring)


func _on_spawn_turtle_flipper_dust_particles(pos : Vector3):
	var particles = TurtleFlipperDustParticlesScene.instantiate()
	particles.position = Vector3(pos.x, pos.y + 0.5, pos.z)
	add_child.call_deferred(particles)


func _on_spawn_dust_particle(pos : Vector3):
	var particles = DustParticlesScene.instantiate()
	particles.position = Vector3(pos.x, pos.y + 0.5, pos.z)
	add_child.call_deferred(particles)
	TerrainShaderParams.add_landscape_coloration(
		LandscapeColoration.new(0.5, Color(0.169, 0.106, 0), pos, 0.005)
	)


func _on_monster_reached_crib(crib : Crib):
	if is_instance_valid(crib):
		_on_spawn_dust_particle(crib.position)
		crib.be_taken_by_monster()
		gem_pouch.lose_baby()


func _on_drop_builder_gem(pos : Vector3):
	var new_gem : BuilderGem  = BuilderGemScene.instantiate()
	new_gem.position = Vector3(pos.x, pos.y + 1.0, pos.z)
	new_gem.velocity.y = 20
	new_gem.velocity.x = -3 + randf() * 6
	new_gem.velocity.z = -3 + randf() * 6
	new_gem.collect_builder_gem.connect(_on_collect_builder_gem)
	add_child.call_deferred(new_gem)


func _on_drop_magical_crystal(pos : Vector3) -> MagicalCrystal:
	var new_crystal : MagicalCrystal = MagicalCrystalScene.instantiate()
	new_crystal.position = Vector3(pos.x, pos.y + 1.0, pos.z)
	new_crystal.velocity.y = 20
	new_crystal.velocity.x = -3 + randf() * 3
	new_crystal.velocity.z = -3 + randf() * 3
	new_crystal.collect_magical_crystal.connect(_on_collect_magical_crystal)
	add_child.call_deferred(new_crystal)
	return new_crystal


func _on_collect_builder_gem(cid : InputUtil.ControllerID):
	gem_pouch.collect_builder_gem()
	if is_instance_valid(_score_card):
		_score_card.count_builder_gem_collect(cid)


func _on_collect_magical_crystal(cid : InputUtil.ControllerID):
	gem_pouch.collect_magical_crystal()
	if is_instance_valid(_score_card):
		_score_card.count_magical_crystal_collect(cid)


func _count_monsters():
	return get_tree().get_nodes_in_group(Constants.GROUP_NAME_MONSTERS).size()


func _on_monster_damaged(damage_per_player : Dictionary, type : Constants.MonsterType, dmg : int):
	if is_instance_valid(_score_card):
		_score_card.count_damage(damage_per_player, type, dmg)


func _on_monster_killed(type : Constants.MonsterType):
	if is_instance_valid(_score_card):
		_score_card.count_kill(type)


func _on_monster_overkilled(type : Constants.MonsterType):
	if is_instance_valid(_score_card):
		_score_card.count_overkill(type)


func _spawn_monster(path : Path3D, monster : BaseMonster):
	if _count_monsters() > MAX_MONSTERS:
		return

	var monster_target : PathFollow3D = PathFollow3D.new()
	path.add_child(monster_target)
	if monster.has_signal("spawn_turtle_flipper_dust_particles"):
		monster.spawn_turtle_flipper_dust_particles.connect(_on_spawn_turtle_flipper_dust_particles)

	monster.target = monster_target
	monster.drop_magical_crystal.connect(_on_drop_magical_crystal)
	monster.drop_builder_gem.connect(_on_drop_builder_gem)
	monster.spawn_dust_particles.connect(_on_spawn_dust_particle)
	monster.kill_your_darling.connect(_on_monster_reached_crib)
	monster.damaged.connect(_on_monster_damaged)
	monster.killed.connect(_on_monster_killed)
	monster.overkilled.connect(_on_monster_overkilled)
	monster.my_frame_cycle = assigned_frame
	assigned_frame = assigned_frame + 1 if assigned_frame < FRAME_CNT_MAX else 0
	add_child.call_deferred(monster)


func _physics_process(delta):
	frame_cnt = frame_cnt + 1 if frame_cnt < FRAME_CNT_MAX else 0
	for monster : BaseMonster in get_tree().get_nodes_in_group(Constants.GROUP_NAME_MONSTERS):
		monster.handle_update(delta, frame_cnt)

	if get_tree().get_nodes_in_group(Constants.GROUP_NAME_CRIBS).is_empty():
		if is_instance_valid(_score_card):
			gameover_with_scores.emit(_score_card)
		else:
			gameover.emit()

	for wave_emitter : MonsterWaveEmitter in wave_emitters_present:
		if wave_emitter.last_wave_cleared():
			stage_won.emit()

	if wave_emitters_present.is_empty() and monster_waves.filter(func(w): return is_instance_valid(w)).is_empty():
		stage_won.emit()



func _mk_toast(message : String = "toast message", duration : float = 3.0, big : bool = false) -> Toast:
	for toasted in get_tree().get_nodes_in_group(Constants.GROUP_NAME_TOASTS):
		toasted.queue_free()

	var toast = ToastScene.instantiate()
	toast.message = message
	toast.duration = duration
	if big:
		toast.scale_up()

	add_child.call_deferred(toast)
	return toast


func _start_wave(wave_num):
	_stage_started = true
	for spawner : MonsterSpawner in find_children("*", "MonsterSpawner"):
		spawner.start_wave(wave_num)

	for wave_emitter in wave_emitters_present:
		wave_emitter.current_wave = wave_num
		_mk_toast("Wave " + str(wave_num) + " / " + str(wave_emitter.number_of_waves))


func _ready():
	TerrainShaderParams.clear()
	wave_emitters_present = find_children("*", "MonsterWaveEmitter")
	monster_waves = find_children("*", "MonsterWave")
	var scores = find_children("*", "Scores")
	_score_card = scores[0] if not scores.is_empty() else null
	gem_pouch = $GemPouch
	gem_pouch.cribs = get_tree().get_nodes_in_group(Constants.GROUP_NAME_CRIBS).size()
	gem_pouch._update_labels()
	for spawner : MonsterSpawner in find_children("*", "MonsterSpawner"):
		spawner.spawn_monster.connect(_spawn_monster)
