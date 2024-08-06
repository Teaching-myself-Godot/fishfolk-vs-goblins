class_name Indicator

extends Control

signal done()

enum ArrowPosition {
	BOTTOM, TOP, LEFT, RIGHT
}

@export var target : Node3D
@export var arrow_position : ArrowPosition = ArrowPosition.BOTTOM
@export var height_3d : float = 0.0
@export var fading : bool = true
@export var target_2d : Node2D
@export var radius_3d : float = 0.0
@export var align_2d : Vector2 = Vector2.ZERO

var _range_ring : RangeRing = null
var _already_finished = false


func _ready():
	modulate.a = 0.0
	$PointingArrow.to = Vector2(0, 0)


func _get_arrow_from_pos() -> Vector2:
	match arrow_position:
		ArrowPosition.RIGHT:
			return Vector2(size.x - 2, size.y * 0.5)
		ArrowPosition.LEFT:
			return Vector2(2, size.y * 0.5)
		ArrowPosition.TOP:
			return Vector2(size.x * 0.5, 3)
		ArrowPosition.BOTTOM:
			return Vector2(size.x * 0.5, size.y - 3)
		_:
			return Vector2(size.x * 0.5, size.y - 3)

func _get_global_to():
	if is_instance_valid(target):
		if CameraUtil.is_behind_camera(target.position):
			var vp = get_viewport().get_visible_rect().size
			return Vector2(vp.x * 0.5, vp.y)
		else:
			return CameraUtil.keep_in_viewport(
				CameraUtil.get_label_position(target.position, Vector3.UP * height_3d)
			)
	elif is_instance_valid(target_2d):
		return CameraUtil.keep_in_viewport(target_2d.position + align_2d)
	else:
		return Vector2(0, 0)

func _process(_delta: float) -> void:
	var global_from = position + _get_arrow_from_pos()
	var global_to = _get_global_to()
	$Circle.position = global_from - position
	$PointingArrow.to = global_to - position
	$PointingArrow.from = global_from - position
	if _range_ring and is_instance_valid(target):
		_range_ring.position = target.position
		TerrainShaderParams.range_rings_changed.emit()

	if fading:
		if modulate.a > 0.0:
			modulate.a -= 0.05
		else:
			hide()
	else:
		show()
		if modulate.a < 1.0:
			modulate.a += 0.05


func start(duration : float = -1):
	fading = false
	$FadeoutTimeoutTimer.start(duration)
	if radius_3d > 0 and _range_ring == null and is_instance_valid(target):
		_range_ring = RangeRing.new(target.position, radius_3d)
		TerrainShaderParams.add_range_ring(_range_ring)


func finish():
	if not _already_finished:
		_already_finished = true
		fading = true
		TerrainShaderParams.drop_range_ring(_range_ring)
		done.emit()


func _on_fadeout_timeout_timer_timeout() -> void:
	finish()


func _unhandled_input(_event: InputEvent) -> void:
	if not fading and Input.is_action_just_released("open_debug"):
		$FadeoutTimeoutTimer.stop()
		_on_fadeout_timeout_timer_timeout()
