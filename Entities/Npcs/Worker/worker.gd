#Worker.gd
extends Node3D

@export var building : Node3D
@export var work_station : Node3D

var speed = 3.0 # Increased for delta
var held_item = null
var tasks : Array = []
var current_job = null
var is_processing = false # Guard to prevent await overlap

@export var rotation_speed = 10.0 # Adjust this to make turns faster/slower


@onready var state_machine = %AnimationTree.get("parameters/playback")




func _ready():
	%JobTimer.wait_time = randf_range(0.1,0.2)
	await get_tree().create_timer(randf_range(0,1)).timeout
	%JobTimer.start()
	%LeftHand.start()
	%RightHand.start()

func _physics_process(delta):
	
	if held_item:
		%Label3D2.text = held_item.get_item_name()
	else:
		%Label3D2.text = "none"
	
	
	if held_item:
		%LeftHand.influence = move_toward(%LeftHand.influence,1.0,0.1)
		%RightHand.influence = move_toward(%RightHand.influence,1.0,0.1)
	else:
		%LeftHand.influence = move_toward(%LeftHand.influence,0.0,0.1)
		%RightHand.influence = move_toward(%RightHand.influence,0.0,0.1)
	
	
	if current_job:
		var type_name = current_job.get_script().get_global_name()
		%Label3D.text = str(type_name)
	else:
		%Label3D.text = "no current job"
	
	# Only run logic if we have tasks
	if tasks.is_empty():
		if current_job != null:
			# Only notify the factory ONCE when the job actually finishes
			building.job_done(current_job)
			current_job = null
		return 

	if is_processing:
		return
	
	process_task(tasks[0], delta)

func process_task(task, delta):
	match task.type:
		"move":
			move_to(task.target.global_position, delta)
			state_machine.travel("run")
			
		"pickup":
			pickup_item(task)
			state_machine.travel("work")
			
		"pickup_output": # Added missing case
			held_item = task.target.pickup_output() 
			update_hand_item()
			tasks.remove_at(0)
			state_machine.travel("work")
		"deliver":
			deliver_item(task.target)
			state_machine.travel("work")
		"craft":
			handle_craft_task(task)
			state_machine.travel("work")
		"store_output":
			store_output(task.target)
			state_machine.travel("work")
		"wander":
			move_to(tasks[0]["position"],delta)
			state_machine.travel("run")
	
	if tasks.is_empty():
		state_machine.travel("idle")

func move_to(target_position, delta):
	var vector = target_position - self.global_position
	var direction = vector.normalized()
	direction.y = 0
	if direction.length() > 0.1:
		# 1. Create a "target" basis (where we want to face)
		var target_basis = Basis.looking_at(direction)
		
		# 2. Smoothly rotate our current basis toward that target basis
		basis = basis.slerp(target_basis, rotation_speed * delta)
	global_position += direction * speed * delta
	
	if vector.length() < 1.0:
		tasks.remove_at(0)

# Helper function to handle the await safely
func handle_craft_task(task):
	is_processing = true
	await get_tree().create_timer(task.duration).timeout
	if current_job:
		current_job.workstation.craft()
	tasks.remove_at(0)
	is_processing = false

func pickup_item(exp_task):
	var target = tasks[0].target
	var item_to_get = exp_task["item"]
	held_item = target.take_item(item_to_get) #Take item returns null if inventory doesn't have it
	update_hand_item()
	tasks.remove_at(0) # Task complete, move to next
	if held_item == null:
		return_job()


func deliver_item(exp_target):
	if exp_target.has_method("store_item"):
		held_item = exp_target.store_item(held_item)
	else:
		held_item = null 
	
	update_hand_item()
	tasks.remove_at(0)

func store_output(exp_target):
	if exp_target.has_method("store_item"):
		exp_target.store_item(held_item)
	held_item = null
	update_hand_item()
	tasks.remove_at(0)


func update_hand_item():
	# Accessing the material unique name %HandItemMesh
	var mesh = %HandItemMesh
	var mat : StandardMaterial3D = mesh.get_active_material(0)
	if mat and held_item:
		mat.albedo_texture = held_item.get_logo()
		%AnimationPlayer.play("raise_hands")
		%HandItemMesh.show()
	elif mat:
		%AnimationPlayer.play_backwards("raise_hands")
		mat.albedo_texture = null
		%HandItemMesh.hide()

func generate_tasks(job):
	tasks.clear()
	if job == null: return
	
	if job is DeliverItemJob:
		var import_storage = building.get_import_storage()
		tasks.append({"type": "move", "target": import_storage})
		tasks.append({"type": "pickup", "target": import_storage, "item": job.item})
		tasks.append({"type": "move", "target": job.target})
		tasks.append({"type": "deliver", "target": job.target})
		
	elif job is CraftJob:
		tasks.append({"type": "move", "target": job.workstation})
		tasks.append({"type": "craft", "duration": job.craft_time})
		
	elif job is HaulOutputJob:
		var export_storage = building.get_export_storage()
		var import_storage = building.get_import_storage()
		tasks.append({"type": "move", "target": job.workstation})
		tasks.append({"type": "pickup_output", "target": job.workstation})
		if not job.is_material:
			tasks.append({"type": "move", "target": export_storage})
			tasks.append({"type": "store_output", "target": export_storage})
		else:
			tasks.append({"type": "move", "target": import_storage})
			tasks.append({"type": "store_output", "target": import_storage})
	elif job is ClearingJob:
		var import_storage = building.get_import_storage()
		tasks.append({"type": "move", "target": job.shelf})
		tasks.append({"type": "pickup", "target": job.shelf, "item": job.item})
		tasks.append({"type": "move", "target": import_storage})
		tasks.append({"type": "deliver", "target": import_storage})
	else:
		var wander_position = self.global_position + Vector3(randf_range(-3,3),0,randf_range(-3,3))
		tasks.append({"type": "wander","position": wander_position})

# Item amount target

func _on_job_timer_timeout():
	if current_job == null and tasks.is_empty():
		var new_job = building.get_available_job()
		if new_job:
			current_job = new_job
			generate_tasks(new_job)
		elif 0.1 > randf_range(0,1):
			generate_tasks("none")

func return_job():
	current_job.reserved = false
	building.return_job(current_job)
	current_job = null
	tasks.clear()
