extends StaticBody3D

@export var shop : Node3D

signal register_checked(customer)

var waiting_customers = []

# Take the customer as an argument and add them to the line
func request_buy_item(customer):
	waiting_customers.append(customer)
	
	var job = SellJob.new()
	job.register = self
	shop.add_job(job)
	job.priority = 2
	
	DebugWindow.print("Customer joined the line. Queue size: %d" % waiting_customers.size())

# Called when the seller actually processes the front of the line
func check_register():
	if waiting_customers.size() > 0:
		var current_customer = waiting_customers[0]
		waiting_customers.remove_at(0)
		# Emit the specific customer who just got served
		register_checked.emit(current_customer)

func get_seller_rotation_target():
	#return self.global_position + Vector3.BACK
	return (%BuyerPosition.global_position - %SellerPosition.global_position).normalized()

func get_buyer_rotation_target():
	#return self.global_position + Vector3.FORWARD
	return (%SellerPosition.global_position - %BuyerPosition.global_position).normalized()

func get_seller_position():
	return %SellerPosition.global_position

func get_buyer_position():
	return %BuyerPosition.global_position
