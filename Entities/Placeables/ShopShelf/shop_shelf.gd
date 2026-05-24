extends StaticBody3D

@export var building : Node3D

@export var inventory : InventoryData

@export var shelf_item : ItemData


var inventory_slots_amount : int = 1



func _ready():
	for i in inventory_slots_amount:
		var slot = InventorySlot.new()
		inventory.slots.append(slot)
	inventory.inventory_updated.connect(on_inventory_updated)
	check_state()


func _physics_process(delta):
	
	if inventory.slots[0].item:
		%Label3D.text = inventory.slots[0].item.get_item_name()
	else:
		%Label3D.text = "none"
	
	if Input.is_action_just_pressed("ui_up"):
		print(inventory.slots[0].item)


func has_shelf_item():
	for slot in inventory.slots:
		if slot.item == shelf_item and slot.amount > 0:
			return true
	return false


func clicked():
	UiManager.shop_shelf_ui_opened(self)


func set_icon(new_icon : Texture):
	var mat : StandardMaterial3D= %IconMesh.get_active_material(0)
	mat.albedo_texture = new_icon


func take_item(item_to_be_taken,amount : int = 1):
	if has_amount_of_item(item_to_be_taken,amount):
		inventory.erase_item(item_to_be_taken)
		set_visual_item()
		check_state()
		return item_to_be_taken
	else:
		set_visual_item()
		check_state()
		return null

func on_inventory_updated(data):
	print("INVENTORY UPDATED SIGNAL FIRED")
	print(inventory.slots)
	set_visual_item()



func has_amount_of_item(exp_item : ItemData,amount : int = 1):
	if inventory.has_amount_of_item(exp_item,amount):
		return true
	else:
		return false

func store_item(item_to_store : ItemData,amount : int = 1):
	var leftover = inventory.room_for_item(item_to_store,amount)
	if leftover < 1:
		inventory.add_item(item_to_store,amount)
		set_visual_item()
		return null
	else:
		set_visual_item()
		return item_to_store


func set_visual_item():
	var item : ItemData = inventory.slots[0].item
	if item:
		var mesh = %ShelfItemMesh
		var mat : StandardMaterial3D = mesh.get_active_material(0)
		var icon = item.get_logo()
		mat.albedo_texture = icon
		%ShelfItemMesh.show()
	else:
		var mesh = %ShelfItemMesh
		var mat : StandardMaterial3D = mesh.get_active_material(0)
		mat.albedo_texture = null
		%ShelfItemMesh.hide()
	
	if shelf_item:
		var b_mesh = %BackMesh
		var b_mat : StandardMaterial3D = b_mesh.get_active_material(0)
		b_mat.albedo_color = shelf_item.design.design_color
		var s_mesh = %ShelfMesh
		var s_mat : StandardMaterial3D = s_mesh.get_active_material(0)
		s_mat.albedo_texture = shelf_item.design.design_pattern
		s_mat.albedo_color = shelf_item.design.design_color

func on_product_changed(new_product_dictionary : Dictionary):
	var item = new_product_dictionary.data
	shelf_item = item
	set_icon(shelf_item.get_logo())
	check_state()

func check_state():
	print("CHECKING STATE")
	
	
	for s in inventory.slots:
		if s.item != shelf_item and s.amount > 0:
			print(s.item.design.trademark_name)
			create_clearing_job(s.item)
			return
	
	if not shelf_item:
		return
	
	var free_slot = get_free_slot()
	if free_slot:
		create_delivery_job(shelf_item)


func get_free_slot():
	for s in inventory.slots:
		if not s.item:
			return s
	return null


func create_delivery_job(item):
	print("Created delivery")
	for job in building.jobs:
		if job is DeliverItemJob and job.target == self:
			if job.item == item:
				return
	var job = DeliverItemJob.new()
	job.priority = 1
	job.target = self
	job.item = item
	job.amount = 1
	building.add_job(job)

func create_clearing_job(item):
	print("Created clearing")
	for job in building.jobs:
		if job is ClearingJob and job.shelf == self:
			if job.item == item:
				return
	var job = ClearingJob.new()
	job.priority = 1
	job.shelf = self
	job.item = item
	job.amount = 1
	building.add_job(job)

func update_visual():
	pass
