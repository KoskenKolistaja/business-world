extends Node3D

var speed = 0.2


func _physics_process(delta):
	if Input.is_action_pressed("up"):
		var vector = get_viewport().get_camera_3d().basis.z
		vector.y = 0
		vector = vector.normalized()
		global_position += -vector * speed
	if Input.is_action_pressed("left"):
		global_position += -get_viewport().get_camera_3d().basis.x * speed
	if Input.is_action_pressed("right"):
		global_position += get_viewport().get_camera_3d().basis.x * speed
	if Input.is_action_pressed("down"):
		var vector = get_viewport().get_camera_3d().basis.z
		vector.y = 0
		vector = vector.normalized()
		global_position += vector * speed
	
	if Input.is_action_just_pressed("wheel_up"):
		global_position += -get_viewport().get_camera_3d().basis.z
	if Input.is_action_just_pressed("wheel_down"):
		global_position += get_viewport().get_camera_3d().basis.z

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
