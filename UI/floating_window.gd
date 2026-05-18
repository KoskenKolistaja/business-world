extends Window


@export var inventory_ui : PackedScene
@export var product_designer : PackedScene
@export var product_station_ui : PackedScene
@export var shop_shelf_ui : PackedScene

func _on_close_requested():
	queue_free()


func add_product_station_ui(station):
	var p_station_ui_instance = product_station_ui.instantiate()
	%ContentContainer.add_child(p_station_ui_instance)
	p_station_ui_instance.product_changed.connect(station.on_product_changed)

func add_shop_shelf_ui(shop_shelf):
	var shop_shelf_ui_instance = shop_shelf_ui.instantiate()
	%ContentContainer.add_child(shop_shelf_ui_instance)
	shop_shelf_ui_instance.product_changed.connect(shop_shelf.on_product_changed)

func add_product_designer():
	var product_designer_instance = product_designer.instantiate()
	%ContentContainer.add_child(product_designer_instance)
	product_designer_instance.window = self
	product_designer_instance.product_accepted.connect(
		ProductManager.add_product
	)



func initiate_inventory(inventory_data):
	
	for c in %ContentContainer.get_children():
		c.queue_free()
	
	var inventory_instance = inventory_ui.instantiate()
	%ContentContainer.add_child(inventory_instance)
	inventory_instance.initiate(inventory_data)
