extends Node


const FRAME_CNT_MAX = 3
var frame_cnt = 0
var assigned_frame = 0

var GoblinScene = preload("res://goblin.scn")
var ArrowTowerScene = preload("res://arrow_tower.scn")
var CannonTowerScene = preload("res://cannon_tower.scn")
var AntiAirTowerScene = preload("res://anti_air_tower.scn")
var FishChibiScene = preload("res://fish_chibi.scn")
var FlyingFishScene = preload("res://flying_fish.scn")
var ExplosionScene = preload("res://explosion.tscn")
var ExplosionRingScene = preload("res://explosion_ring.tscn")
var MagicalCrystalScene = preload("res://magical_crystal.tscn")
var BuilderGemScene = preload("res://builder_gem.tscn")
var DustParticlesScene = preload("res://dust_particles.tscn")

var goblin_map = {}

func _no_goblins() -> bool:
	return get_tree().get_nodes_in_group(Constants.GROUP_NAME_GOBLINS).is_empty()


func _unhandled_input(_event):
	if Input.is_action_just_pressed("quit") and _no_goblins():
		get_tree().quit()

	for k in range(0, 3):
		if Input.is_action_pressed("quit-" + str(k)) and Input.is_action_pressed("start-" + str(k)):
			get_tree().quit()

	if Input.is_action_just_released("f11"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
	if Input.is_action_just_released("start-k"):
		add_goblin_to_scene(0)
	if Input.is_action_just_released("start-0"):
		add_goblin_to_scene(1)
	if Input.is_action_just_released("start-1"):
		add_goblin_to_scene(2)
	if Input.is_action_just_released("start-2"):
		add_goblin_to_scene(3)
	if Input.is_action_just_released("start-3"):
		add_goblin_to_scene(4)


func add_goblin_to_scene(num : int):
	if goblin_map.size() == 0:
		_spawn_monster($MonsterPath1B, FlyingFishScene.instantiate(), false)

	if num in goblin_map:
		if goblin_map[num] and is_instance_valid(goblin_map[num]):
			return
		else: 
			goblin_map.erase(num)
		
	var new_goblin : Goblin = GoblinScene.instantiate()
	goblin_map[num] = new_goblin
	new_goblin.player_num = num
	new_goblin.position = Vector3(0, 4, 0)

	var goblin = get_tree().get_first_node_in_group(Constants.GROUP_NAME_GOBLINS)
	if goblin and is_instance_valid(goblin):
		new_goblin.position.x = goblin.position.x + (-2 + randf() * 4)
		new_goblin.position.z = goblin.position.z + (-2 + randf() * 4)
		new_goblin.position.y = goblin.position.y + 4
	new_goblin.build_arrow_tower.connect(_on_goblin_build_arrow_tower)
	new_goblin.build_cannon_tower.connect(_on_goblin_build_cannon_tower)
	new_goblin.build_anti_air_tower.connect(_on_goblin_build_anti_air_tower)
	add_child.call_deferred(new_goblin)

func _on_goblin_build_anti_air_tower(player_num : int, pos : Vector3):
	var new_tower : AntiAirTower = AntiAirTowerScene.instantiate()
	new_tower.built_by_player = player_num
	new_tower.position = Vector3(pos.x, pos.y - 4, pos.z)
	new_tower.rise_target_position = Vector3(pos.x, pos.y - .5, pos.z)
	new_tower.fire_anti_air_missile.connect(_on_missile_tower_fire_missile)
	add_child.call_deferred(new_tower)

func _on_goblin_build_cannon_tower(player_num : int, pos : Vector3):
	var new_tower : CannonTower = CannonTowerScene.instantiate()
	new_tower.built_by_player = player_num
	new_tower.position = Vector3(pos.x, pos.y - 4, pos.z)
	new_tower.rise_target_position = Vector3(pos.x, pos.y - .5, pos.z)
	new_tower.fire_cannon_ball.connect(_on_cannon_tower_fire_cannon_ball)
	add_child.call_deferred(new_tower)

func _on_goblin_build_arrow_tower(player_num : int, pos : Vector3):
	var new_tower : ArrowTower = ArrowTowerScene.instantiate()
	new_tower.built_by_player = player_num
	new_tower.position = Vector3(pos.x, pos.y - 4, pos.z)
	new_tower.rise_target_position = Vector3(pos.x, pos.y - .5, pos.z)
	new_tower.load_arrow.connect(_on_arrow_tower_load_arrow)
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
		var explosion_ring = ExplosionRingScene.instantiate()
		explosion_ring.position = pos + Vector3(-2.0 + randf() * 4, 0.0,  -2.0 + randf() * 4.0)
		explosion_ring.radius = randf() * 2.0
		add_child.call_deferred(explosion_ring)

	var main_explosion_ring = ExplosionRingScene.instantiate()
	main_explosion_ring.position = pos
	main_explosion_ring.radius = 2.0
	add_child.call_deferred(main_explosion_ring)


func _spawn_monster(path : Path3D, monster : BaseMonster, limit_frames = true):
	var monster_target : PathFollow3D = PathFollow3D.new()
	path.add_child(monster_target)
	monster.target = monster_target
	monster.drop_magical_crystal.connect(_on_drop_magical_crystal)
	monster.drop_builder_gem.connect(_on_drop_builder_gem)
	monster.spawn_dust_particles.connect(_on_spawn_dust_particle)
	monster.my_frame_cycle = assigned_frame
	monster.limit_frames = limit_frames
	assigned_frame = assigned_frame + 1 if assigned_frame < FRAME_CNT_MAX else 0
	add_child.call_deferred(monster)


func _get_monster_count() -> int:
	return get_tree().get_nodes_in_group(Constants.GROUP_NAME_MONSTERS).size()


func _on_spawn_dust_particle(pos : Vector3):
	var particles = DustParticlesScene.instantiate()
	var explosion_ring = ExplosionRingScene.instantiate()
	particles.position = Vector3(pos.x, pos.y + 0.5, pos.z)
	add_child.call_deferred(particles)
	explosion_ring.position = pos 
	explosion_ring.radius = .5
	add_child.call_deferred(explosion_ring)

func _on_drop_builder_gem(pos : Vector3):
	var new_gem = BuilderGemScene.instantiate()
	new_gem.position = Vector3(pos.x, pos.y + 1.0, pos.z)
	new_gem.velocity.y = 20
	new_gem.velocity.x = -3 + randf() * 3
	new_gem.velocity.z = -3 + randf() * 3
	add_child.call_deferred(new_gem)


func _on_drop_magical_crystal(pos : Vector3):
	var new_crystal = MagicalCrystalScene.instantiate()
	new_crystal.position = Vector3(pos.x, pos.y + 1.0, pos.z)
	new_crystal.velocity.y = 20
	new_crystal.velocity.x = -3 + randf() * 3
	new_crystal.velocity.z = -3 + randf() * 3
	add_child.call_deferred(new_crystal)


func _on_spawn_timer_timeout():
	if goblin_map.size() > 0 and _get_monster_count() < 120:
		_spawn_monster($MonsterPath1A,  FishChibiScene.instantiate())
		_spawn_monster($MonsterPath1,  FishChibiScene.instantiate())


func _on_spawn_timer_2_timeout():
	if goblin_map.size() > 0 and _get_monster_count() < 120:
		_spawn_monster($MonsterPath1, FishChibiScene.instantiate())
		_spawn_monster($MonsterPath1A, FishChibiScene.instantiate())


func _on_spawn_timer_3_timeout():
	if goblin_map.size() > 0 and _get_monster_count() < 125:
		_spawn_monster($MonsterPath1B, FlyingFishScene.instantiate(), false)


func _physics_process(delta):
	frame_cnt = frame_cnt + 1 if frame_cnt < FRAME_CNT_MAX else 0
	for monster : BaseMonster in get_tree().get_nodes_in_group(Constants.GROUP_NAME_MONSTERS):
		monster.handle_update(delta, frame_cnt)
