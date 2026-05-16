extends Control

@export var slot_scene : PackedScene
var current_inventory_data : InventoryData

# 1. CALL THIS ONCE when the window opens
func initiate(inventory_data : InventoryData):
	# Prevent double-connections
	if current_inventory_data and current_inventory_data.inventory_updated.is_connected(_on_inventory_updated):
		current_inventory_data.inventory_updated.disconnect(_on_inventory_updated)
	
	current_inventory_data = inventory_data
	current_inventory_data.inventory_updated.connect(_on_inventory_updated)
	
	# Draw the initial state
	_refresh_ui()

# 2. CALL THIS whenever the data changes
func _on_inventory_updated(_data = null): # Added optional param to match signal
	_refresh_ui()

# 3. THE DRAWING LOGIC
func _refresh_ui():
	# IMPORTANT: Clear existing UI slots first!
	for child in %GridContainer.get_children():
		child.queue_free()
	
	# Now build the new ones
	for s in current_inventory_data.slots:
		var slot_instance = slot_scene.instantiate()
		%GridContainer.add_child(slot_instance)
		
		# Pass data to the slot (Let the slot handle its own icon/label)
		if slot_instance.has_method("display_slot"):
			slot_instance.display_slot(s)
		else:
			# Fallback if your Slot UI is simple
			if s.item:
				slot_instance.icon = s.item.get_logo()
				slot_instance.amount = s.amount
