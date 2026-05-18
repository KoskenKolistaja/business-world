class_name ItemData
extends Resource

@export var id : String
@export var item_name : String = "item"
@export var stackable : bool = true        # Can it stack?
@export var max_stack_size : int = 64      # How high?
@export var base_value : int = 10
@export var icon : Texture
@export var visual : PackedScene
@export var is_raw_material : bool = false

var design : Design




func get_logo():
	if design:
		return design.design_logo
	else:
		return icon

func get_item_name():
	if design:
		return design.trademark_name
	else:
		return item_name
