class_name BasicDrop
extends Area3D

var touched_by_goblin : Goblin = null
var velocity = Vector3.ZERO
var is_on_floor = false;

func _process(_delta):
	if touched_by_goblin and $GemMesh.scale.y < 0.75:
		$GemMesh.scale.x += 0.01
		$GemMesh.scale.y += 0.01
		$GemMesh.scale.z += 0.01
		$GemMesh.get_surface_override_material(0).emission_energy_multiplier += 0.025
		$GemMesh.get_surface_override_material(0).albedo_color.a -= 0.025
		if is_instance_valid(touched_by_goblin):
			var target_pos = Vector3(
				touched_by_goblin.position.x,
				touched_by_goblin.position.y + touched_by_goblin.chest_height,
				touched_by_goblin.position.z,
			)
			position = lerp(position, touched_by_goblin.position, 0.25)
	else:
		if touched_by_goblin:
			queue_free()
		elif not is_on_floor:
			rotation.y = lerp_angle(rotation.y, rotation.y + 0.1, 0.5)

func _physics_process(delta):
	if is_on_floor:
		velocity = Vector3.ZERO
	else:
		velocity.y = lerp(velocity.y, -gravity, 0.1)

	position += velocity * delta

func _on_body_entered(body):
	if body.is_in_group(Constants.GROUP_NAME_TERRAIN):
		is_on_floor = true
	
	if not touched_by_goblin and is_instance_valid(body) and body.is_in_group(Constants.GROUP_NAME_GOBLINS):
		touched_by_goblin = body
		$GemMesh.get_surface_override_material(0).emission_enabled = true
		$GemMesh.get_surface_override_material(0).transparency = 1
		$GemMesh/Outline.hide()
		$AudioStreamPlayer3D.play()
