# CustomerManager.gd
class_name CustomerManager
extends Node

static var instance : CustomerManager

@export var customer_scene : PackedScene
@export var customer_container : Node3D

func _ready():
	instance = self

func _exit_tree():
	if instance == self:
		instance = null





func spawn_customer(customer_position,customer_home):
	var job = generate_buy_job(customer_home)
	var customer_instance = customer_scene.instantiate()
	if not job:
		return
	customer_container.add_child(customer_instance)
	customer_instance.global_position = customer_position
	customer_instance.home = customer_home
	customer_instance.current_job = job
	await get_tree().physics_frame
	customer_instance.generate_tasks(customer_instance.current_job)

func generate_buy_job(customer_home) -> BuyJob:
	var job = BuyJob.new()
	job.home = customer_home
	job.amount = 1
	if ProductManager.products.is_empty():
		DebugWindow.warn("No products to choose from")
		return null
	var wanted_item_dic : Dictionary = ProductManager.products.pick_random()
	var wanted_item : ItemData = wanted_item_dic["data"]
	job.item = wanted_item_dic["data"]
	if not job.item:
		DebugWindow.warn("No item found")
		return null
	var shop = find_shop_with_item(wanted_item)
	if not shop:
		DebugWindow.warn("No shop found while creating buy job")
		return null
	job.shop = shop
	return job


func find_shop_with_item(product : ItemData):
	var shops = get_tree().get_nodes_in_group("shop")
	if shops.is_empty():
		DebugWindow.warn("No shops found")
		return null
	var dics = {}
	for s in shops:
		var shop_products = s.get_sold_products()
		for item in shop_products:
			if item == product:
				return s
	return null
