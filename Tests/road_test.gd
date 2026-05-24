extends Node3D


@export var car_storage_a : Node3D
@export var car_storage_b : Node3D
@export var car_storage_c : Node3D

@export var car_scene : PackedScene








func _ready():
	await get_tree().create_timer(1.0).timeout
	print(TrafficManager.get_lane_path(%Straight3.get_lane(),%Straight4.get_lane()))
	
	spawn_truck()

func spawn_truck():
	var start = car_storage_a.get_start_lane()
	
	var end
	
	if 0.5 < randf_range(0,1):
		end = car_storage_b.get_end_lane()
	else:
		end = car_storage_c.get_end_lane()
	
	
	var path = TrafficManager.get_lane_path(start,end)
	
	var truck_instance = car_scene.instantiate()
	truck_instance.is_truck = true
	truck_instance.directions = path
	truck_instance.lane = start
	add_child(truck_instance)
	


func _on_timer_timeout():
	spawn_truck()
