extends ColorRect


signal product_changed




func _ready():
	initiate_products()


func initiate_products():
	var id = multiplayer.get_unique_id()
	var owned_products : Array = ProductManager.get_products_by_owner(id)
	
	if owned_products.size() < 1:
		%WarningLabel.show()
	
	print(owned_products)
	
	for p in owned_products:
		var data = p["data"]
		%OptionButton.add_icon_item(data.design.design_logo,data.design.trademark_name,p["product_id"])


func _on_assign_button_pressed():
	assign()
	get_parent().get_parent().queue_free()

func assign():
	var current_id = %OptionButton.get_selected_id()
	if current_id < 0:
		return
	var product_dictionary = ProductManager.get_product_by_id(current_id)
	print(product_dictionary)
	product_changed.emit(product_dictionary)
