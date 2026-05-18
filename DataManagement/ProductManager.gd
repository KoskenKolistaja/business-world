extends Node

var index = 0

var products = []


var example_dic = {"product_id" : 1, "owner_id" : 1, "data" : ItemData, "recipe" : RecipeData}



func add_product(new_product : ItemData , new_recipe : RecipeData):
	var id = get_free_id()
	var new_dic = {
		"product_id" : id,
		"owner_id" : 1,
		"data" : new_product,
		"recipe" : new_recipe,
	}
	products.append(new_dic)


func get_free_id():
	index += 1
	return index



func delete_product(id_to_be_deleted : int):
	
	for i in products:
		if products[i]["product_id"] == id_to_be_deleted:
			products.remove_at(i)


func get_products_by_owner(owner_id : int):
	var returned = []
	for p in products:
		if p["owner_id"] == owner_id:
			returned.append(p)
	return returned


func get_product_by_id(id : int):
	for p in products:
		if p["product_id"] == id:
			return p
