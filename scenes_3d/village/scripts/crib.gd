class_name Crib
extends Node3D

var my_attacker : BaseMonster = null

func _ready():
	$AnimationPlayer.play("idle")


func _on_despawn_timer_timeout():
	queue_free()

func be_taken_by_monster():
	hide()
	$DespawnTimer.start()
