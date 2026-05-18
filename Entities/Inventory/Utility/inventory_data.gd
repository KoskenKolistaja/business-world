# InventoryData.gd
class_name InventoryData
extends Resource

signal inventory_updated(inventory_data: InventoryData)

@export var slots: Array[InventorySlot]






func add_item(item_data: ItemData, amount: int = 1) -> int:
	# 1. Try to stack with existing items
	for slot in slots:
		if slot.item == item_data and slot.amount < item_data.max_stack_size:
			var can_add = item_data.max_stack_size - slot.amount
			var to_add = min(amount, can_add)
			slot.amount += to_add
			amount -= to_add
			
			if amount <= 0:
				inventory_updated.emit(self)
				return 0
	# 2. Try to find an empty slot for leftovers
	for slot in slots:
		if not slot.item:
			slot.item = item_data
			slot.amount = min(amount, item_data.max_stack_size)
			amount -= slot.amount
			
			if amount <= 0:
				inventory_updated.emit(self)
				return 0
				
	inventory_updated.emit(self)
	return amount # Returns remaining items if inventory is full


func room_for_item(item_data: ItemData, amount: int = 1) -> int:
	var remaining_amount = amount
	# 1. Simulate stacking with existing items
	for slot in slots:
		if slot.item == item_data and slot.amount < item_data.max_stack_size:
			var can_add = item_data.max_stack_size - slot.amount
			var to_add = min(remaining_amount, can_add)
			remaining_amount -= to_add
			
			if remaining_amount <= 0:
				return 0
	# 2. Simulate placing leftovers into empty slots
	for slot in slots:
		if not slot.item:
			var to_add = min(remaining_amount, item_data.max_stack_size)
			remaining_amount -= to_add
			
			if remaining_amount <= 0:
				return 0
				
	return remaining_amount # Returns what couldn't fit without changing inventory state




## Erases a specific amount of an item, potentially from multiple slots
func erase_item(item_data: ItemData, amount_to_erase: int = 1) -> bool:
	
	if slots[0].item:
		print("INVENTORY SLOT 0 ITEM: " + str(slots[0].item))
	
	print("PARAMETER NAME: " + str(item_data))
	
	# 1. Verification Phase: Do we have enough before we start deleting?
	if not has_amount_of_item(item_data, amount_to_erase):
		print("Transaction Failed: Not enough ", item_data.design.trademark_name)
		return false
	
	# 2. Execution Phase: Start subtracting
	var remaining_to_erase = amount_to_erase
	
	for slot in slots:
		if slot.item == item_data:
			var amount_in_slot = slot.amount
			
			# Determine how much to take from this specific slot
			var take = min(remaining_to_erase, amount_in_slot)
			
			slot.amount -= take
			remaining_to_erase -= take
			
			# If the slot is now empty, clear the item data
			if slot.amount <= 0:
				slot.item = null
				slot.amount = 0 # Safety reset
			
			# If we've satisfied the whole request, stop looping
			if remaining_to_erase <= 0:
				break
				
	# 3. Finalization: Tell the UI to update
	inventory_updated.emit(self)
	return true


## Checks the total quantity of a specific item across all slots
func get_total_amount_of_item(item_data: ItemData) -> int:
	var total = 0
	for slot in slots:
		if slot.item == item_data:
			total += slot.amount
	return total

## Returns true if the inventory contains at least the specified amount
func has_amount_of_item(item_data: ItemData, amount: int = 1) -> bool:
	return get_total_amount_of_item(item_data) >= amount
