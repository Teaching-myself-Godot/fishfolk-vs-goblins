extends Node


func get_cam_pivot() -> CameraPivot:
	return get_tree().get_first_node_in_group(Constants.GROUP_NAME_CAMERA)


func get_cam() -> MyCamera:
	return get_cam_pivot().get_child(0)


func is_behind_camera(pos : Vector3) -> bool:
	return get_cam().is_position_behind(pos)


func get_label_position(pos_in : Vector3, trans : Vector3 = Vector3.ZERO):
	var pos = (
		pos_in + trans.rotated(Vector3.UP, CameraUtil.get_cam_pivot().rotation.y) if trans else
		pos_in
	)

	return get_cam().unproject_position(pos)

func keep_in_viewport(pos : Vector2) -> Vector2:
	var bounded_to = pos
	var bounds = get_viewport().get_visible_rect()
	if bounds.has_point(bounded_to):
		return pos
	else:
		bounded_to.x = (
				0 if bounded_to.x < 0 else
				bounds.size.x if bounded_to.x > bounds.size.x else
				bounded_to.x
		)
		bounded_to.y = (
				0 if bounded_to.y < 0 else
				bounds.size.y if bounded_to.y > bounds.size.y else
				bounded_to.y
		)
		return bounded_to
