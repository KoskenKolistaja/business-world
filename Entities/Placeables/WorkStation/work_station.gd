extends StaticBody3D

signal crafting_finished



@export var factory : Node3D

@export var recipe : RecipeData

@export var is_laptop : bool

@onready var slot_1 = InventorySlot.new()
@onready var slot_2 = InventorySlot.new()
@onready var slot_3 = InventorySlot.new()

@onready var craft_slot = InventorySlot.new()

var crafting = false

func _ready():
	#if is_laptop:
		#slot_1.item = preload("res://Entities/Items/screen.tres")
		#slot_2.item = preload("res://Entities/Items/processor.tres")
		#slot_3.item = preload("res://Entities/Items/battery.tres")
		#slot_1.amount = 1
		#slot_2.amount = 1
		#slot_3.amount = 1
	
	
	await get_tree().create_timer(0.5).timeout
	
	update_inventory_text()
	
	if recipe:
		var icon = recipe.outputs[0].get_logo()
		set_icon(icon)

func get_recipe():
	return recipe

func get_inventory():
	return [slot_1,slot_2,slot_3]

func store_item(item_to_store : ItemData):
	var free_slot = get_free_slot()
	if free_slot:
		free_slot.item = item_to_store
		free_slot.amount = 1
	
	update_inventory_text()



func get_free_slot():
	var slots = [slot_1,slot_2,slot_3]
	
	for s in slots:
		if not s.item:
			return s
	
	return null


func set_icon(new_icon : Texture):
	var mat : StandardMaterial3D= %IconMesh.get_active_material(0)
	mat.albedo_texture = new_icon

func update_inventory_text():
	%InventoryLabel.text = str(get_inventory_item_names())
	if craft_slot.item:
		%CraftSlotLabel.text = str(craft_slot.item.item_name)
	else:
		%CraftSlotLabel.text = "<none>"

func pickup_output():
	var item = craft_slot.item
	craft_slot.item = null
	craft_slot.amount = 0
	clear_empty_slots()
	update_inventory_text()
	return item

func get_inventory_item_names():
	var slots = [slot_1,slot_2,slot_3]
	var names = []
	for s in slots:
		if s.item:
			var entry = s.item.item_name + " " + str(s.amount)
			names.append(entry)
		else:
			names.append("<empty>")
	return names

func clear_empty_slots():
	var slots = [slot_1,slot_2,slot_3,craft_slot]
	for s in slots:
		if s.amount < 1:
			s.item = null


func is_ready_to_craft():
	if recipe == null: return false
	
	var inventory_slots = get_inventory()
	for requirement in recipe.inputs:
		var total_found = 0
		for slot in inventory_slots:
			if slot.item == requirement.item:
				total_found += slot.amount
		
		if total_found < requirement.amount:
			return false
	return true

func craft():
	if crafting or craft_slot.item:
		return
	if is_ready_to_craft():
		crafting = true
		
		consume_ingredients()
		
		craft_slot.item = recipe.outputs[0]
		craft_slot.amount = 1
		
		clear_empty_slots()
		update_inventory_text()
		crafting_finished.emit()
		crafting = false

func consume_ingredients():
	for requirement in recipe.inputs:
		var remaining = requirement.amount
		for slot in get_inventory():
			if slot.item == requirement.item:
				var taken = min(slot.amount, remaining)
				slot.amount -= taken
				remaining -= taken
				if remaining <= 0:
					break


func get_missing_ingredients():
	var inventory_slots = get_inventory()
	
	var missing_items = []
	
	for requirement in recipe.inputs:
		
		var required_item = requirement.item
		var required_amount = requirement.amount
		
		var total_found = 0
		
		for slot in inventory_slots:
		
			if slot.item == required_item:
				total_found += slot.amount
		
		if total_found < required_amount:
			missing_items.append(requirement.item)
	
	return missing_items

func has_crafted_item():
	if craft_slot.item:
		return true
	return false


func check_state():
	if crafting:
		return
	
	if craft_slot.item:
		create_output_job()
		return
	
	var missing = get_missing_ingredients()
	
	for item in  missing:
		create_delivery_job(item)
	
	if is_ready_to_craft():
		create_craft_job()



func create_delivery_job(item):
	for job in factory.jobs:
		if job is DeliverItemJob and job.target == self:
			if job.item == item:
				return

	var job = DeliverItemJob.new()
	job.target = self
	job.item = item
	job.amount = 1
	factory.add_job(job)

func create_craft_job():
	for job in factory.jobs:
		if job is CraftJob and job.workstation == self:
			#print("Returned at craft because of a duplicate")
			return
	var job = CraftJob.new()
	job.priority = 2
	job.workstation = self
	job.craft_time = recipe.base_craft_time
	factory.add_job(job)
	#print("Created a craft job")

func create_output_job():
	
	for job in factory.jobs:
		if job is HaulOutputJob and job.workstation == self:
			#print("Returned at output because of a duplicate")
			return
	var job = HaulOutputJob.new()
	job.priority = 2
	job.workstation = self
	job.output_item = craft_slot.item
	job.is_material = craft_slot.item.is_raw_material
	job.amount = craft_slot.amount
	factory.add_job(job)

func _on_job_timer_timeout():
	check_state()
