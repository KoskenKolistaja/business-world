extends StaticBody3D


@export var is_export : bool
@export var is_import : bool
@export var infinite : bool

@export var inventory : InventoryData

var inventory_slots_amount : int = 16


func _ready():
	for i in inventory_slots_amount:
		var slot = InventorySlot.new()
		inventory.slots.append(slot)
	
	var e_parts = preload("res://Entities/Items/electronic_parts.tres")
	
	if is_import:
		inventory.add_item(e_parts,512)


func has_amount_of_item(exp_item : ItemData,amount : int = 1):
	if infinite:
		return true
	if inventory.has_amount_of_item(exp_item,amount):
		return true
	else:
		return false


func take_item(item_to_be_taken,amount : int = 1):
	if has_amount_of_item(item_to_be_taken,amount):
		inventory.erase_item(item_to_be_taken)
		return item_to_be_taken
	else:
		return null


func store_item(item_to_store):
	inventory.add_item(item_to_store)

func clicked():
	UiManager.on_inventory_opened(inventory)
