extends Node3D


@export var door : Node3D


func get_door_position():
	return door.global_position


func _on_timer_timeout():
	request_spawn_customer()
	%Timer.wait_time = randf_range(5,40)


func request_spawn_customer():
	CustomerManager.instance.spawn_customer(get_door_position(),self)
