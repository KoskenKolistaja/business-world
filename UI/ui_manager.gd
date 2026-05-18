extends CanvasLayer


@export var floating_window_scene : PackedScene



func shop_shelf_ui_opened(shop_shelf):
	for c in %EditWindows.get_children():
		c.queue_free()
	var window_instance = floating_window_scene.instantiate()
	window_instance.size = Vector2i(400,500)
	window_instance.title = "Shop Shelf"
	%EditWindows.add_child(window_instance)
	window_instance.position = get_viewport().get_mouse_position()
	window_instance.add_shop_shelf_ui(shop_shelf)


func product_station_ui_opened(station):
	for c in %EditWindows.get_children():
		c.queue_free()
	
	var window_instance = floating_window_scene.instantiate()
	window_instance.size = Vector2i(400,500)
	window_instance.title = "Product Station"
	%EditWindows.add_child(window_instance)
	window_instance.position = get_viewport().get_mouse_position()
	window_instance.add_product_station_ui(station)



func on_product_designer_opened():
	for c in %EditWindows.get_children():
		c.queue_free()
	
	var window_instance = floating_window_scene.instantiate()
	window_instance.size = Vector2i(400,800)
	window_instance.title = "Product Designer"
	%EditWindows.add_child(window_instance)
	window_instance.position = get_viewport().get_mouse_position()
	window_instance.add_product_designer()




func on_inventory_opened(data : InventoryData):
	for c in %InventoryWindows.get_children():
		c.queue_free()
	
	var window_instance = floating_window_scene.instantiate()
	window_instance.size = Vector2i(400,300)
	window_instance.title = "Inventory"
	%InventoryWindows.add_child(window_instance)
	window_instance.position = get_viewport().get_mouse_position()
	window_instance.initiate_inventory(data)


func _on_button_pressed():
	on_product_designer_opened()
