extends ColorRect

var patterns : Array[Texture] = [
	preload("res://Assets/Patterns/Tiles/tile_0000.png"),
	preload("res://Assets/Patterns/Tiles/tile_0001.png"),
	preload("res://Assets/Patterns/Tiles/tile_0002.png"),
	preload("res://Assets/Patterns/Tiles/tile_0003.png"),
	preload("res://Assets/Patterns/Tiles/tile_0004.png"),
	preload("res://Assets/Patterns/Tiles/tile_0005.png"),
	preload("res://Assets/Patterns/Tiles/tile_0006.png"),
	preload("res://Assets/Patterns/Tiles/tile_0007.png"),
	preload("res://Assets/Patterns/Tiles/tile_0008.png"),
	preload("res://Assets/Patterns/Tiles/tile_0009.png"),
	preload("res://Assets/Patterns/Tiles/tile_0010.png"),
	preload("res://Assets/Patterns/Tiles/tile_0011.png"),
	preload("res://Assets/Patterns/Tiles/tile_0012.png"),
	preload("res://Assets/Patterns/Tiles/tile_0013.png"),
	preload("res://Assets/Patterns/Tiles/tile_0014.png"),
	preload("res://Assets/Patterns/Tiles/tile_0015.png"),
	preload("res://Assets/Patterns/Tiles/tile_0016.png"),
	preload("res://Assets/Patterns/Tiles/tile_0017.png"),
	preload("res://Assets/Patterns/Tiles/tile_0018.png"),
	preload("res://Assets/Patterns/Tiles/tile_0019.png"),
	preload("res://Assets/Patterns/Tiles/tile_0020.png"),
	preload("res://Assets/Patterns/Tiles/tile_0021.png"),
	preload("res://Assets/Patterns/Tiles/tile_0022.png"),
	preload("res://Assets/Patterns/Tiles/tile_0023.png"),
	preload("res://Assets/Patterns/Tiles/tile_0024.png"),
	preload("res://Assets/Patterns/Tiles/tile_0025.png"),
	preload("res://Assets/Patterns/Tiles/tile_0026.png"),
	preload("res://Assets/Patterns/Tiles/tile_0027.png"),
	preload("res://Assets/Patterns/Tiles/tile_0028.png"),
	preload("res://Assets/Patterns/Tiles/tile_0029.png"),
	preload("res://Assets/Patterns/Tiles/tile_0030.png"),
	preload("res://Assets/Patterns/Tiles/tile_0031.png"),
	preload("res://Assets/Patterns/Tiles/tile_0032.png"),
	preload("res://Assets/Patterns/Tiles/tile_0033.png"),
	preload("res://Assets/Patterns/Tiles/tile_0034.png"),
	preload("res://Assets/Patterns/Tiles/tile_0035.png"),
	preload("res://Assets/Patterns/Tiles/tile_0036.png"),
	preload("res://Assets/Patterns/Tiles/tile_0037.png"),
	preload("res://Assets/Patterns/Tiles/tile_0038.png"),
	preload("res://Assets/Patterns/Tiles/tile_0039.png"),
	preload("res://Assets/Patterns/Tiles/tile_0040.png"),
	preload("res://Assets/Patterns/Tiles/tile_0041.png"),
	preload("res://Assets/Patterns/Tiles/tile_0042.png"),
	preload("res://Assets/Patterns/Tiles/tile_0043.png"),
	preload("res://Assets/Patterns/Tiles/tile_0044.png"),
	preload("res://Assets/Patterns/Tiles/tile_0045.png"),
	preload("res://Assets/Patterns/Tiles/tile_0046.png"),
	preload("res://Assets/Patterns/Tiles/tile_0047.png"),
	preload("res://Assets/Patterns/Tiles/tile_0048.png"),
	preload("res://Assets/Patterns/Tiles/tile_0049.png"),
	preload("res://Assets/Patterns/Tiles/tile_0050.png"),
	preload("res://Assets/Patterns/Tiles/tile_0051.png"),
	preload("res://Assets/Patterns/Tiles/tile_0052.png"),
	preload("res://Assets/Patterns/Tiles/tile_0053.png"),
	preload("res://Assets/Patterns/Tiles/tile_0054.png"),
	preload("res://Assets/Patterns/Tiles/tile_0055.png"),
	preload("res://Assets/Patterns/Tiles/tile_0056.png"),
	preload("res://Assets/Patterns/Tiles/tile_0057.png"),
	preload("res://Assets/Patterns/Tiles/tile_0058.png"),
	preload("res://Assets/Patterns/Tiles/tile_0059.png"),
	preload("res://Assets/Patterns/Tiles/tile_0060.png"),
	preload("res://Assets/Patterns/Tiles/tile_0061.png"),
	preload("res://Assets/Patterns/Tiles/tile_0062.png"),
	preload("res://Assets/Patterns/Tiles/tile_0063.png")
]

var logos = [
	preload("res://Assets/Logos/abstract-005.png"),
	preload("res://Assets/Logos/abstract-104.png"),
	preload("res://Assets/Logos/air-force.png"),
	preload("res://Assets/Logos/clover.png"),
	preload("res://Assets/Logos/cracked-helm.png"),
	preload("res://Assets/Logos/gluttony.png"),
	preload("res://Assets/Logos/hedgehog.png"),
	preload("res://Assets/Logos/oat.png"),
	preload("res://Assets/Logos/ophanim.png"),
	preload("res://Assets/Logos/peace-dove.png"),
	preload("res://Assets/Logos/skull-crossed-bones.png"),
	preload("res://Assets/Logos/thwomp.png"),
	preload("res://Assets/Logos/artificial-hive.png"),
	preload("res://Assets/Logos/automatic-sas.png"),
	preload("res://Assets/Logos/chameleon-glyph.png"),
	preload("res://Assets/Logos/chili-pepper.png"),
	preload("res://Assets/Logos/drop.png"),
	preload("res://Assets/Logos/eagle-emblem.png"),
	preload("res://Assets/Logos/reactor.png"),
	preload("res://Assets/Logos/relationship-bounds.png"),
	preload("res://Assets/Logos/steelwing-emblem.png"),
	preload("res://Assets/Logos/totem-head.png")
]

var items = [
	preload("res://Entities/Items/laptop.tres"),
	preload("res://Entities/Items/ketchup.tres"),
]


signal product_accepted(new_product_data : ItemData)

var window

var pattern_index = 0
var logo_index = 0
var item_index = 0

var selected_pattern = preload("res://Assets/Patterns/Tiles/tile_0000.png")
var selected_logo = preload("res://Assets/Logos/artificial-hive.png")
var selected_item = preload("res://Entities/Items/laptop.tres")



func _ready():
	update_price_label()
	
	if not window:
		window = get_parent().get_parent()
		self.product_accepted.connect(ProductManager.add_product)


@export var id : String
@export var item_name : String = "item"
@export var stackable : bool = true        # Can it stack?
@export var max_stack_size : int = 64      # How high?
@export var base_value : int = 10
@export var icon : Texture
@export var visual : PackedScene
@export var is_raw_material : bool = false

func assemble_product_data():
	var item = selected_item.duplicate()
	var new_design = Design.new()
	
	item.is_raw_material = false
	
	new_design.trademark_name = %NameEdit.text
	new_design.design_logo = selected_logo
	new_design.design_pattern = selected_pattern
	new_design.design_color = %ColorPicker.color
	
	var profit = int(%Price.value)
	new_design.aimed_profit = profit
	new_design.marketing_strength = 1
	
	
	item.design = new_design
	
	return item


func _on_color_picker_button_color_changed(color):
	%PatternTexture.modulate = color


func previous_pattern():
	pattern_index -= 1
	if pattern_index < 0:
		pattern_index = patterns.size() - 1
	selected_pattern = patterns[pattern_index]
	%PatternTexture.texture = selected_pattern



func next_pattern():
	pattern_index += 1
	if pattern_index > patterns.size() - 1:
		pattern_index = 0
	selected_pattern = patterns[pattern_index]
	%PatternTexture.texture = selected_pattern


func previous_logo():
	logo_index -= 1
	if logo_index < 0:
		logo_index = logos.size() - 1
	selected_logo = logos[logo_index]
	%LogoTexture.texture = selected_logo



func next_logo():
	logo_index += 1
	if logo_index > logos.size() - 1:
		logo_index = 0
	selected_logo = logos[logo_index]
	%LogoTexture.texture = selected_logo


func previous_item():
	item_index -= 1
	if item_index < 0:
		item_index = items.size() - 1
	selected_item = items[item_index]
	%ItemTexture.texture = selected_item.icon
	update_price_label()


func next_item():
	item_index += 1
	if item_index > items.size() - 1:
		item_index = 0
	selected_item = items[item_index]
	%ItemTexture.texture = selected_item.icon
	update_price_label()


func _on_previous_button_pressed():
	previous_pattern()

func _on_next_button_pressed():
	next_pattern()

func _on_previous_logo_button_pressed():
	previous_logo()

func _on_next_logo_button_pressed():
	next_logo()

func _on_previous_item_button_pressed():
	previous_item()

func _on_next_item_button_pressed():
	next_item()

func _on_add_product_button_pressed():
	var new_product = assemble_product_data()
	var recipe = assemble_recipe(new_product)
	product_accepted.emit(new_product,recipe)
	window.queue_free()


func assemble_recipe(product : ItemData):
	var new_recipe = RecipeData.new()
	var new_recipe_entry = RecipeEntry.new()
	
	new_recipe_entry.item = selected_item
	new_recipe_entry.amount = 1
	new_recipe.inputs.append(new_recipe_entry)
	new_recipe.outputs.append(product)
	return new_recipe

var product_recipes = {
	preload("res://Entities/Items/laptop.tres") : preload("res://Entities/Recipes/laptop_recipe.tres"),
	preload("res://Entities/Items/ketchup.tres") : preload("res://Entities/Recipes/ketchup_recipe.tres")
}



func update_price_label():
	var profit = int(%Price.value)
	var price = selected_item.base_value + profit
	%PriceLabel.text = "Price: " + "\n" + str(selected_item.base_value) + "$ + " + str(profit) + "$" + "\n" +"= " + str(price) + "$"


func _on_price_value_changed(value):
	update_price_label()
