extends Node3D

@export var grid_manager : Node3D


func _physics_process(delta):
	assert(grid_manager,"Grid manager not found in item_placer")
	
	var hit = get_mouse_raycast()
	if hit:
		var grid_pos = grid_manager.world_pos_to_grid_pos(hit["position"])
		var world_pos = grid_manager.grid_pos_to_world_pos(grid_pos)
		%CursorItem.global_position = world_pos




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
