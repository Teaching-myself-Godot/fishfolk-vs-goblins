extends Sprite2D

@export var sentences : Array[String] = []

var MainGame = preload("res://goblins_vs_fishfolk.tscn")
var ToastScene = preload("res://scenes_2d/hud/toast.tscn")
var goblin_fading_in = false

func _show_next_sentence():
	var toast = ToastScene.instantiate()
	toast.message = sentences.pop_front()
	toast.scale_up()
	toast.duration = 4.5
	add_child.call_deferred(toast)
	if sentences.is_empty():
		$SentenceTimer.queue_free()


func _on_resize():
	texture.width = get_viewport().size.x
	texture.height = get_viewport().size.y
	$SubViewportContainer.size = Vector2i(
		get_viewport().size.y - 136,
		get_viewport().size.y - 136
	)
	$SubViewportContainer.position.x = (
		get_viewport().size.x / 2 - $SubViewportContainer.size.x / 2
	)
	$SubViewportContainer/SubViewport.size = $SubViewportContainer.size

func _process(_delta):
	if goblin_fading_in and $SubViewportContainer.modulate.a < 1.0:
		$SubViewportContainer.modulate.a += 0.002 


func _ready():
	get_tree().get_root().size_changed.connect(_on_resize)
	_on_resize()
	_show_next_sentence()


func _on_goblin_fade_in_delay_timeout():
	goblin_fading_in = true


func _start_main_game():
	get_tree().change_scene_to_packed(MainGame)


func _unhandled_input(_event):
	if (
		InputUtil.is_just_released("start") or 
		InputUtil.is_just_released("confirm") or 
		InputUtil.is_just_released("cancel")
	):
		_start_main_game()
