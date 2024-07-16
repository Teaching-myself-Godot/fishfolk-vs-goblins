class_name TowerContextMenu
extends ContextMenuBase

const INITIAL_OPTION = "Upgrade"

func _ready():
	_init_menu(MAIN_MENU_NAME)
	_init_menu("Upgrade")
	initial_option = INITIAL_OPTION

func open():
	super.open()
	$UpgradeMenu.hide()


func close():
	super.close()
	$UpgradeMenu.hide()


func _on_gem_pouch_contents_changed(gems : int, crystals : int):
	$"MainMenu/Dismantle-option/PriceTag".update_affordable_status(gems, crystals)
	$"UpgradeMenu/Range-option/PriceTag".update_affordable_status(gems, crystals)
	$"UpgradeMenu/Rate of Fire-option/PriceTag".update_affordable_status(gems, crystals)
	$"UpgradeMenu/Damage-option/PriceTag".update_affordable_status(gems, crystals)
