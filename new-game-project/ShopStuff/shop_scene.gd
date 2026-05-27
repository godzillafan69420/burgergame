extends Control

# Preload your card scene so we can spawn it programmatically
@export var card_scene: PackedScene = preload("res://ShopStuff/shop_item_card.tscn")

# Node References based on your scene tree
@onready var money_text = $MarginContainer/MoneyCounter/MoneyText
@onready var card_container = $BottomFridge
@onready var reroll_button = $MarginContainer/ActionMenu/Reroll

# Economy Variables
var player_gold: int = 25  # Starting cash for testing
var reroll_cost: int = 5

# A mock data item pool to dynamically generate distinct items
var item_pool = [
	{"name": "Manji kick", "price": 4},
	{"name": "Lapse blue", "price": 6},
	{"name": "Nue", "price": 3},
	{"name": "Lucky Dice", "price": 8},
	{"name": "Resolute slash", "price": 5}
]

func _ready() -> void:
	# 1. Update the UI to display initial gold count
	update_gold_ui()
	
	# 2. Wire up button signals directly in code
	$MarginContainer/ActionMenu/NextStage.pressed.connect(_on_next_stage_pressed)
	$MarginContainer/ActionMenu/Reroll.pressed.connect(_on_reroll_pressed)
	
	# 3. Wipe out whatever placeholder cards are in the editor and generate random ones
	clear_shop_shelf()
	generate_shop_cards(3) # Spawns 3 random cards

#updates text to see if you are a pooron (poor moron)
func update_gold_ui() -> void:
	money_text.text = "$" + str(player_gold)
	
	if player_gold < reroll_cost:
		reroll_button.disabled = true
		reroll_button.text = "Reroll (hahaha Poor)"
	else:
		reroll_button.disabled = false
		reroll_button.text = "Reroll $" + str(reroll_cost)

# Deletes all existing cards
func clear_shop_shelf() -> void:
	for child in card_container.get_children():
		child.queue_free()

# Makes new stuff
func generate_shop_cards(amount: int) -> void:
	for i in range(amount):
		var card = card_scene.instantiate()
		card_container.add_child(card)
		
		# Pick a random dictionary out of our item pool
		var item_data = item_pool.pick_random()
		
		# Apply the name and price directly to your card labels
		var name_label = card.get_node_or_null("NameLabel")
		var price_label = card.get_node_or_null("PriceLabel")
		
		if name_label: 
			name_label.text = item_data["name"]
		if price_label: 
			price_label.text = str(item_data["price"]) + " Gold"

# REROLL BUTTON LOGIC
func _on_reroll_pressed() -> void:
	if player_gold >= reroll_cost:
		player_gold -= reroll_cost
		update_gold_ui()
		
		clear_shop_shelf()
		# Wait exactly one frame layout cycle so Godot finishes deleting old nodes safely
		await get_tree().process_frame 
		generate_shop_cards(3)

# NEXT STAGE BUTTON LOGIC
func _on_next_stage_pressed() -> void:
	print("Advancing to next stage...")
	# Change this to the level select probably
	get_tree().change_scene_to_file("res://battle_scene.tscn")
