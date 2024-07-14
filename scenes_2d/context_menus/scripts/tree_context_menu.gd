class_name TreeContextMenu
extends ContextMenuBase

const INITIAL_OPTION = "All-Range" 

func _ready():
	_init_menu(MAIN_MENU_NAME)
	_init_menu("All-Range")
	_init_menu("Ground")
	_init_menu("Air")
	initial_option = INITIAL_OPTION


func open():
	super.open()
	$"All-RangeMenu".hide()
	$GroundMenu.hide()
	$AirMenu.hide()


func close():
	super.close()
	$"All-RangeMenu".hide()
	$GroundMenu.hide()
	$AirMenu.hide()


func _on_gem_pouch_contents_changed(gems : int, crystals : int):
	$"All-RangeMenu/Arrow-option/PriceTag".update_affordable_status(gems, crystals)
	$"GroundMenu/Cannon-option/PriceTag".update_affordable_status(gems, crystals)
	$"AirMenu/Anti-Air-option/PriceTag".update_affordable_status(gems, crystals)
