extends Control

@export var target : Node3D
@export var height_3d : float = 0.0
@export var fading : bool = true

func _ready():
	modulate.a = 0.0
	$PointingArrow.to = Vector2(size.x * 0.5, position.y + size.y + 100)


func _process(_delta: float) -> void:
	$PointingArrow.from = Vector2(
		size.x * 0.5,
		size.y - 2
	)

	if is_instance_valid(target):
		$PointingArrow.to = CameraUtil.keep_in_viewport(
			CameraUtil.get_label_position(target.position, Vector3.UP * height_3d)
		) - position #+ Vector2(size.x * 0.5, 0)
	if fading:
		if modulate.a > 0.0:
			modulate.a -= 0.05
		else:
			hide()
	else:
		show()
		if modulate.a < 1.0:
			modulate.a += 0.05



