extends Area3D

var touched_by_goblin : Goblin = null

func _process(_delta):
	if touched_by_goblin and $Icosphere.scale.y < 3.0:
		$Icosphere.scale.x -= 0.02
		$Icosphere.scale.y += 0.15
		$Icosphere.scale.z -= 0.02
		$Icosphere.get_surface_override_material(0).emission_energy_multiplier += 0.1
		$Icosphere.get_surface_override_material(0).albedo_color.a -= 0.025
		if is_instance_valid(touched_by_goblin):
			var target_pos = Vector3(
				touched_by_goblin.position.x,
				touched_by_goblin.position.y + $Icosphere.scale.y + touched_by_goblin.chest_height,
				touched_by_goblin.position.z,
			)
			position = lerp(position, target_pos, 0.25)
	else:
		if touched_by_goblin:
			queue_free()
		else:
			rotation.y = lerp_angle(rotation.y, rotation.y + 0.1, 0.5)


func _on_body_entered(body):
	if not touched_by_goblin and is_instance_valid(body) and body.is_in_group(Constants.GROUP_NAME_GOBLINS):
		touched_by_goblin = body
		$Icosphere.get_surface_override_material(0).emission_enabled = true
		$Icosphere.get_surface_override_material(0).transparency = 1
		$Icosphere/Outline.hide()
		$AudioStreamPlayer3D.play()
