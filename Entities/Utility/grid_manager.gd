extends Node3D

@export var building_size : Vector2i = Vector2i(6,6)




func world_pos_to_grid_pos(world_pos : Vector3):
	world_pos -= self.global_position
	var grid_pos : Vector2i
	grid_pos.x = roundi(world_pos.x)
	grid_pos.y = roundi(world_pos.z)
	
	grid_pos.x = clampi(grid_pos.x,0,building_size.x - 1)
	grid_pos.y = clampi(grid_pos.y,0,building_size.y - 1)
	
	return grid_pos

func grid_pos_to_world_pos(grid_pos : Vector2i):
	var returned = self.global_position
	returned.x += grid_pos.x
	returned.z += grid_pos.y
	return returned
