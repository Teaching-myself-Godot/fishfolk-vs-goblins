class_name TowerContextMenu
extends ContextMenuBase

const INITIAL_OPTION = "Upgrade"
const STAT_POS_CLOSED = Vector2i(128, 0)
const STAT_POS_OPENED = Vector2i(312, 0)


func _ready():
	_init_menu(MAIN_MENU_NAME)
	_init_menu("Upgrade")
	initial_option = INITIAL_OPTION


func _toggle_option_blink(opt, flag : bool):
	super._toggle_option_blink(opt, flag)
	for stat in $Stats.find_children(opt.name.replace("-option", "")):
		stat.material.set("shader_parameter/blink", flag)


func set_stats(tower : BaseTower):
	$"Stats/Range/Value".text = str(tower.current_range)
	$"Stats/Damage/Value".text = str(tower.current_damage)
	$"Stats/Reload Time/Value".text = str(tower.current_reload_time)


func open():
	super.open()
	$UpgradeMenu.hide()
	$Stats.position = STAT_POS_OPENED


func close():
	super.close()
	$UpgradeMenu.hide()
	$Stats.position = STAT_POS_CLOSED


func _on_gem_pouch_contents_changed(gems : int, crystals : int):
	$"MainMenu/Dismantle-option/PriceTag".update_affordable_status(gems, crystals)
	$"UpgradeMenu/Range-option/PriceTag".update_affordable_status(gems, crystals)
	$"UpgradeMenu/Reload Time-option/PriceTag".update_affordable_status(gems, crystals)
	$"UpgradeMenu/Damage-option/PriceTag".update_affordable_status(gems, crystals)
