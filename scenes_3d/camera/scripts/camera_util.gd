extends Node


func get_cam_pivot() -> CameraPivot:
	return get_tree().get_first_node_in_group(Constants.GROUP_NAME_CAMERA)


func get_cam() -> MyCamera:
	return get_cam_pivot().get_child(0)


func get_label_position(pos : Vector3, trans : Vector3 = Vector3(0, 0, 0)):
	return get_cam().unproject_position(
			pos + trans.rotated(Vector3.UP, CameraUtil.get_cam_pivot().rotation.y)
	)
