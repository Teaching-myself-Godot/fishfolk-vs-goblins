class_name TowerContextMenu
extends ContextMenuBase

const INITIAL_OPTION = "Range Upgrade"

func _ready():
	_init_menu(MAIN_MENU_NAME)
	initial_option = INITIAL_OPTION


func _on_gem_pouch_contents_changed(gems : int, crystals : int):
	$"MainMenu/Dismantle-option/PriceTag".update_affordable_status(gems, crystals)
	$"MainMenu/Range Upgrade-option/PriceTag".update_affordable_status(gems, crystals)
