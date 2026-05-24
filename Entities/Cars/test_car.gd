class_name Car
extends Node3D

@export var road : Node3D
var lane : Lane

var progress : float = 0.0

var speed : float = 5.0

var directions

var is_truck : bool = false

func _ready():
	if not lane:
		lane = road.get_lane()
	speed = randf_range(4,6)
	
	if not is_truck:
		var meshes = %Meshes.get_children()
		var random = meshes.pick_random()
		random.show()
	else:
		%delivery.show()


func _physics_process(delta):
	progress += speed * delta
	
	# Handle moving to the next lane
	if progress >= lane.length:
		
		progress -= lane.length
		if not directions:
			lane = lane.get_next_lane(self)
		else:
			directions.remove_at(0)
			if directions.is_empty():
				queue_free()
			else:
				lane = directions[0]
	
	# 1. Set the current global position
	var pos = lane.sample_position(progress)
	global_position = pos
	
	# 2. Look ahead smoothly (even previewing the next lane!)
	var look_ahead_distance = 1.0
	var look_progress = progress + look_ahead_distance
	var look_lane = lane
	
	#if look_progress >= look_lane.length:
		#look_progress -= look_lane.length
		#look_lane = look_lane.get_next_lane()
		#
	var future_pos = look_lane.sample_position(look_progress)
	
	# 3. Tell look_at where to aim in world space
	if global_position.distance_squared_to(future_pos) > 0.001:
		look_at(future_pos)
	
	if lane.id:
		%Label3D.text = str(progress)
