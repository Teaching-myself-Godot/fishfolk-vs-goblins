class_name TowerContextMenu
extends ContextMenuBase

const INITIAL_OPTION = "Range"

func _ready():
	_init_menu(MAIN_MENU_NAME)
	initial_option = INITIAL_OPTION


func _on_gem_pouch_contents_changed(gems : int, crystals : int):
	$"MainMenu/Dismantle-option/PriceTag".update_affordable_status(gems, crystals)
	$"MainMenu/Range-option/PriceTag".update_affordable_status(gems, crystals)
	$"MainMenu/Rate of Fire-option/PriceTag".update_affordable_status(gems, crystals)
	$"MainMenu/Damage-option/PriceTag".update_affordable_status(gems, crystals)
