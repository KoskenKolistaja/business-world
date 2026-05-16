extends Node

var index = 1

var products = []


var example_dic = {"product_id" : 1, "owner_id" : 1, "data" : ProductData.new(), "recipe" : RecipeData}



func add_product(new_product : ProductData , new_recipe : RecipeData):
	var new_dic = {
		"product_id" : index,
		"owner_id" : 1,
		"data" : new_product,
		"recipe" : new_recipe,
	}
	index += 1
	print(new_dic)
	products.append(new_dic)

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
