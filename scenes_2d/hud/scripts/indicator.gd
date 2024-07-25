class_name Indicator

extends Control

@export var target : Node3D
@export var height_3d : float = 0.0
@export var fading : bool = true
@export var target_2d : Vector2 = Vector2.ZERO
@export var radius_3d : float = 0.0

func _ready():
	modulate.a = 0.0
	$PointingArrow.to = target_2d


func _process(_delta: float) -> void:
	var global_from = position + Vector2(
		size.x * 0.5,
		size.y - 3
	)

	var global_to = (
		CameraUtil.keep_in_viewport(
				CameraUtil.get_label_position(target.position, Vector3.UP * height_3d)
		) if is_instance_valid(target) else (
				CameraUtil.keep_in_viewport(target_2d)
		)
	)
	$Circle.position = global_from - position
	$PointingArrow.to = global_to - position
	$PointingArrow.from = global_from - position

	if fading:
		if modulate.a > 0.0:
			modulate.a -= 0.05
		else:
			hide()
	else:
		show()
		if modulate.a < 1.0:
			modulate.a += 0.05



