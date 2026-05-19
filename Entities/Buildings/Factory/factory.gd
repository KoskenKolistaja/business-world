extends Node3D


@export var export_storage : Node3D
@export var import_storage : Node3D

var jobs = []






func _physics_process(delta):
	if Engine.get_frames_drawn() % 100 == 0:
		var job_names = []
		for j in jobs:
			# This gets the script name like "DeliverIngredientJob"
			var type_name = j.get_script().get_global_name()
			var status = " [RESERVED]" if j.reserved else " [FREE]"
			job_names.append(type_name + status)


func add_job(job):
	if is_job_acceptable(job):
		jobs.append(job)



func is_job_acceptable(job):
	if job.get_script().get_global_name() == "DeliverItemJob":
		assert(import_storage, "IMPORT STORAGE NOT FOUND IN FACTORY")
		if import_storage.has_amount_of_item(job.item,job.amount):
			return true
		else:
			return false
	
	return true


func return_job(job):
	if is_job_acceptable(job):
		jobs.append(job)
	else:
		job_cancelled(job)


func get_available_job():
	# Sort the jobs array: highest priority first
	# (Change '>' to '<' if 1 is your highest priority)
	jobs.sort_custom(func(a, b): return a.priority > b.priority)
	
	for job in jobs:
		if not job.reserved:
			job.reserved = true
			if is_job_acceptable(job):
				return job
			else:
				# CRUCIAL: If the job wasn't acceptable, unreserve it 
				# so other NPCs can try to take it later!
				job.reserved = false
				
	return null

func job_done(done_job):
	jobs.erase(done_job)

func job_cancelled(cancelled_job):
	jobs.erase(cancelled_job)

func get_export_storage():
	return export_storage

func get_import_storage():
	return import_storage
