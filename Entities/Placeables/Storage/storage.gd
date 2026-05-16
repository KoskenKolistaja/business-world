extends StaticBody3D


@export var is_export : bool
@export var is_import : bool

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
	if inventory.has_amount_of_item(exp_item,amount):
		return true
	else:
		return false


func take_item(took_item):
	inventory.erase_item(took_item)
	return took_item

func store_item(item_to_store):
	inventory.add_item(item_to_store)

func clicked():
	UiManager.on_inventory_opened(inventory)
