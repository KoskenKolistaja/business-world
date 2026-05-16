class_name InventorySlot
extends Resource

@export var item : ItemData
@export var amount : int
var reserved_amount : int




func get_available_amount():
	return amount - reserved_amount
