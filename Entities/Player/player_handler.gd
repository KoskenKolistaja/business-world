extends Node3D




func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var hit = get_mouse_raycast()
		if hit:
			if hit.collider.has_method("clicked"):
				hit.collider.clicked()



func get_mouse_raycast(max_distance: float = 1000.0) -> Dictionary:
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return {}

	var mouse_pos := get_viewport().get_mouse_position()

	var ray_origin := camera.project_ray_origin(mouse_pos)
	var ray_direction := camera.project_ray_normal(mouse_pos)

	var ray_end := ray_origin + ray_direction * max_distance

	var space_state := get_world_3d().direct_space_state

	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collide_with_areas = true

	var result := space_state.intersect_ray(query)

	return result
