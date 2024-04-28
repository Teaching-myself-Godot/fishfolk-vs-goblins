extends Control

var is_open = false

const MENU_RADIUS = 200.0

func _ready():
	$BackdropCircle.radius = MENU_RADIUS

func show_at(pos : Vector2):
	position = pos
	align()
	visible = true

func close_and_hide():
	close()
	visible = false

func open():
	is_open = true
	$"BButton/HighlightCircle".hide()
	$AButton.show()
	$MenuArrow.show()
	$BackdropCircle.show()

func rotate_arrow(angle : float):
	$MenuArrow.rotation = angle

func close():
	is_open = false
	$"BButton/HighlightCircle".show()
	$AButton.hide()
	$MenuArrow.hide()
	$BackdropCircle.hide()

func align():
	position.x = MENU_RADIUS if position.x < MENU_RADIUS else position.x
	position.y = MENU_RADIUS if position.y < MENU_RADIUS else position.y
	position.x = get_viewport().size.x - MENU_RADIUS if position.x + MENU_RADIUS > get_viewport().size.x else position.x
	position.y = get_viewport().size.y - MENU_RADIUS if position.y + MENU_RADIUS > get_viewport().size.y else position.y

func _process(delta):
	align()
