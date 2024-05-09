extends Node

var GoblinScene = preload("res://goblin.scn")
var ArrowTowerScene = preload("res://arrow_tower.scn")
var CannonTowerScene = preload("res://cannon_tower.scn")
var FishChibiScene = preload("res://fish_chibi.scn")
var ExplosionScene = preload("res://explosion.tscn")
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
	add_child.call_deferred(new_goblin)

func _on_goblin_build_cannon_tower(player_num : int, pos : Vector3):
	var new_tower : BaseTower = CannonTowerScene.instantiate()
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


func _on_cannon_tower_fire_cannon_ball(cannon_ball : CannonBall):
	cannon_ball.spawn_explosion.connect(_on_cannon_ball_spawn_explosion)
	add_child.call_deferred(cannon_ball)

func _on_cannon_ball_spawn_explosion(pos : Vector3):
	var explosion = ExplosionScene.instantiate()
	explosion.position = pos
	add_child.call_deferred(explosion)


func _spawn_monster(path : Path3D):
	var monster_target : PathFollow3D = PathFollow3D.new()
	var fish_chibi : FishChibi = FishChibiScene.instantiate()
	path.add_child(monster_target)
	fish_chibi.target = monster_target
	add_child.call_deferred(fish_chibi)


func _on_spawn_timer_timeout():
	if goblin_map.size() > 0:
		_spawn_monster($MonsterPath1)
		_spawn_monster($MonsterPath1A)
		_spawn_monster($MonsterPath1B)

