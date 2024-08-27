extends Node

const GROUP_NAME_MONSTERS = "monsters"
const GROUP_NAME_GOBLINS = "goblins"
const GROUP_NAME_TREES = "trees"
const GROUP_NAME_TREES_AND_FELLED_TREES = "trees_and_felled_trees"
const GROUP_NAME_TOWERS = "towers"
const GROUP_NAME_CAMERA = "cam"
const GROUP_NAME_TERRAIN = "terrain"
const GROUP_NAME_MONSTERS_AIRBORNE = "airborne_monsters"
const GROUP_NAME_MONSTERS_GROUNDED = "grounded_monsters"
const GROUP_NAME_HUD_ITEM = "hud_items"
const GROUP_NAME_MONSTER_COLLISION = "monster_collision"
const GROUP_NAME_CRIBS = "cribs"
const GROUP_NAME_GOBLIN_SPAWN_POINT = "goblin_spawn_point"
const GROUP_NAME_MONSTER_WAVES = "monster_waves"
const GROUP_NAME_TOASTS = "toasts"

const MONSTER_COLLISION_LAYER = 2

const CANNON_TOWER_BASE_RANGE = 8.0
const ARROW_TOWER_BASE_RANGE = 10.0
const ANTI_AIR_TOWER_BASE_RANGE = 8.0

const CANNON_TOWER_BASE_DAMAGE = 3
const ARROW_TOWER_BASE_DAMAGE = 5
const ANTI_AIR_TOWER_BASE_DAMAGE = 1

const CANNON_TOWER_BASE_RELOAD_TIME = 5.0
const ARROW_TOWER_BASE_RELOAD_TIME = 5.0
const ANTI_AIR_TOWER_BASE_RELOAD_TIME = 5.0

enum MonsterType {
	UNKNOWN, FISH_CHIBI, FLYING_FISH, GIANT_TURTLE
}


func sum(values : Array) -> Variant:
	var tot = 0
	for amt in values:
		tot += amt
	return tot


func shares(values_per_id : Dictionary) -> Dictionary:
	var total = sum(values_per_id.values())
	var result := {}
	for share_id in values_per_id:
		result[share_id] = float(values_per_id[share_id]) / float(total)
	return result
