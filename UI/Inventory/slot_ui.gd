extends Button

var data_slot : InventorySlot
var amount : int
var inventory




func display_slot(slot : InventorySlot):
	if slot.item:
		icon = slot.item.get_logo()
	else:
		icon = null
	amount = slot.amount
	%Label.text = str(amount)
	
