extends StaticBody3D

signal job_done
signal crafting_finished

var ingredient_slot = InventorySlot.new()
var product_slot = InventorySlot.new()

@export var factory : Node3D

var product : ItemData
var recipe : RecipeData

var crafting = false



func _ready():
	await get_tree().create_timer(1.0).timeout
	check_state()

func _physics_process(delta):
	check_state()


func clicked():
	UiManager.product_station_ui_opened(self)

func store_item(item_to_store : ItemData):
	var free_slot = get_free_slot()
	if free_slot:
		free_slot.item = item_to_store
		free_slot.amount = 1
	
	check_state()
	update_inventory_text()

func get_free_slot():
	var slots = [ingredient_slot]
	
	for s in slots:
		if not s.item:
			return s
	
	return null

func update_inventory_text():
	pass

var example_dic = {"product_id" : 1, "owner_id" : 1, "data" : ItemData, "recipe" : RecipeData}

func on_product_changed(product_dictionary : Dictionary):
	var data : ItemData = product_dictionary["data"]
	recipe_changed(product_dictionary["recipe"])
	set_icon(data.design.design_logo)
	check_state()
	print("Product changed")

func set_icon(new_icon : Texture):
	var mat : StandardMaterial3D= %IconMesh.get_active_material(0)
	mat.albedo_texture = new_icon

func recipe_changed(new_recipe):
	ingredient_slot.amount = 0
	ingredient_slot.item = null
	product_slot.amount = 0
	product_slot.item  = null
	recipe = new_recipe
	check_state()


func check_state():
	if crafting:
		print("crafting")
		return
	
	if not recipe:
		#print("RECIPE: " + str(recipe))
		return
	
	if product_slot.item:
		create_output_job()
		return
	
	var missing = get_missing_ingredients()
	
	for item in  missing:
		create_delivery_job(item)
	
	if is_ready_to_craft():
		create_craft_job()

func is_ready_to_craft():
	if recipe == null: return false
	
	var inventory_slots = [ingredient_slot]
	for requirement in recipe.inputs:
		var total_found = 0
		for slot in inventory_slots:
			if slot.item == requirement.item:
				total_found += slot.amount
		
		if total_found < requirement.amount:
			return false
	return true

func craft():
	if crafting or product_slot.item:
		return
	if is_ready_to_craft():
		crafting = true
		
		consume_ingredients()
		
		product_slot.item = recipe.outputs[0]
		product_slot.amount = 1
		
		clear_empty_slots()
		crafting_finished.emit()
		crafting = false
		
		update_inventory_text()
		check_state()

func pickup_output():
	var item = product_slot.item
	product_slot.item = null
	product_slot.amount = 0
	clear_empty_slots()
	update_inventory_text()
	check_state()
	return item

func consume_ingredients():
	for requirement in recipe.inputs:
		var remaining = requirement.amount
		for slot in [ingredient_slot]:
			if slot.item == requirement.item:
				var taken = min(slot.amount, remaining)
				slot.amount -= taken
				remaining -= taken
				if remaining <= 0:
					break


func clear_empty_slots():
	ingredient_slot.item = null
	ingredient_slot.amount = 0

func get_missing_ingredients():
	var inventory_slots = [ingredient_slot]
	
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


func create_delivery_job(item):
	for job in factory.jobs:
		if job is DeliverItemJob and job.target == self:
			if job.item == item:
				return
	var job = DeliverItemJob.new()
	job.priority = 3
	job.target = self
	job.item = item
	job.amount = 1
	factory.add_job(job)

func create_craft_job():
	for job in factory.jobs:
		if job is CraftJob and job.workstation == self:
			return
	var job = CraftJob.new()
	job.priority = 4
	job.workstation = self
	job.craft_time = recipe.base_craft_time
	factory.add_job(job)


func create_output_job():
	
	for job in factory.jobs:
		if job is HaulOutputJob and job.workstation == self:
			return
	var job = HaulOutputJob.new()
	job.priority = 5
	job.workstation = self
	job.output_item = product_slot.item
	job.is_material = product_slot.item.is_raw_material
	job.amount = product_slot.amount
	factory.add_job(job)
