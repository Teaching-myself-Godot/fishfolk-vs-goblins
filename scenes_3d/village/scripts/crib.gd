class_name Crib
extends Node3D

var my_attacker : BaseMonster = null

func _ready():
	$AnimationPlayer.play("idle")
