class_name HPBar
extends Node2D

var max_hp  : int = 10
var hp      : int = 5
var dmg_sum : int = 0

func _draw():
	var al = $Control/DamageLabel.modulate.a * 2.0
	al = 1.0 if al > 1.0 else al
	draw_rect(Rect2(0, 1, 1, 10), Color(255, 255, 255, 0.6))

	draw_rect(Rect2(1, 0, max_hp * 3, 1), Color(255, 255, 255, 0.6))

	draw_rect(Rect2(1, 1, hp * 3, 10), Color(255, 0, 0, 0.6))
	draw_rect(Rect2(1 + hp * 3, 1, dmg_sum * 3, 10),  Color(al, al, 0.0, 0.6))
	draw_rect(Rect2(1 + (hp + dmg_sum) * 3, 1, (max_hp - dmg_sum - hp) * 3 , 10), Color(0, 0, 0, 0.4))

	draw_rect(Rect2(1, 12, max_hp * 3, 1), Color(255, 255, 255, 0.6))
	draw_rect(Rect2(max_hp * 3 + 1, 1, 1, 10), Color(255, 255, 255, 0.6))

func draw_damage(dmg : int):
	dmg_sum += dmg
	if dmg == 0:
		$Control/DamageLabel.text = "Overkill!"
		$Control/DamageLabel.modulate = Color(0.0, 0.0, 0.0, 1.0)
	else:
		$Control/DamageLabel.text = str(dmg_sum)
		$Control/DamageLabel.modulate.r = 1.0
		$Control/DamageLabel.modulate.g = 1.0
		$Control/DamageLabel.modulate.b = 0.0

	$Control/DamageLabel.modulate.a = 1.0

func _ready():
	$Control/DamageLabel.modulate.a = 0.0
	$Control/DamageLabel.scale = Vector2.ONE
	$Control/DamageLabel.position = Vector2.ZERO

func _process(_delta):
	if $Control/DamageLabel.modulate.a > 0.0:
		$Control/DamageLabel.modulate.a -= .01 if $Control/DamageLabel.modulate.a > 0.0 else 0.0
		$Control/DamageLabel.scale *= 1.01
		$Control/DamageLabel.position += Vector2(-8 +  randf() * 4, -randf() * 8)
	else:
		$Control/DamageLabel.scale = Vector2.ONE
		$Control/DamageLabel.position = Vector2.ZERO
		dmg_sum = 0
	queue_redraw()
