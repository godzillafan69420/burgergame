extends Control

# Preload your shop item scene (the UI card/button template)
const SHOP_ITEM_SCENE = preload("res://ShopStuff/shop_item_card.tscn") # Adjust to your actual path

# 1. Define your items, prices, and their spawn weights (higher weight = more common)
var item_pool = {
	"health_potion": {"name": "Health Potion", "price": 50, "weight": 50},
	"attack_buff": {"name": "Sharp Grindstone", "price": 100, "weight": 30},
	"rare_sword": {"name": "Legendary Blade", "price": 500, "weight": 5},
	"shield": {"name": "Iron Shield", "price": 150, "weight": 25}
}

# Reference to where you want to put the items
# (Change this to an HBoxContainer or your Marker2D nodes)
@onready var shop_container = $BottomFridge

func _ready():
	randomize() # Essential in older versions, good practice to ensure true randomness
	generate_shop_inventory(3) # Generate 3 random items

func generate_shop_inventory(number_of_items: int):
	# Clear out any old items first
	for child in shop_container.get_children():
		child.queue_free()
		
	for i in range(number_of_items):
		var chosen_item_key = get_random_item_by_weight()
		var item_data = item_pool[chosen_item_key]
		
		# Instantiate the visual UI card
		var item_instance = SHOP_ITEM_SCENE.instantiate()
		
		# Add it to the scene tree (Container automatically positions it)
		shop_container.add_child(item_instance)
		
		# Pass the random data to the item card script so it updates its labels/textures
		if item_instance.has_method("setup_item"):
			item_instance.setup_item(item_data.name, item_data.price)

# 2. Weighted Random Selection Algorithm
func get_random_item_by_weight() -> String:
	var total_weight = 0
	for item in item_pool.values():
		total_weight += item.weight
		
	# Pick a random number between 0 and the sum of all weights
	var roll = randf_range(0, total_weight)
	var current_weight_sum = 0
	
	# Find which item "owns" the rolled number
	for item_key in item_pool:
		current_weight_sum += item_pool[item_key].weight
		if roll <= current_weight_sum:
			return item_key
			
	return item_pool.keys()[0] # Fallback just in case
