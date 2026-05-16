class_name ProductData
extends ItemData

# The underlying general item (e.g., General Laptop)
@export var base_item: ItemData

# Trademark & Skin Data
@export var trademark_name: String
@export var design_logo: Texture
@export var design_pattern: Texture
@export var design_color: Color

# Business Metrics
@export var aimed_profit: int
@export var marketing_strength: int
