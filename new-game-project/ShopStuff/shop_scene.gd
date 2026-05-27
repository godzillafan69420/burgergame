extends Control

@export var card_scene: PackedScene = preload("res://ShopStuff/shop_item_card.tscn")

@onready var money_text = $MarginContainer/MoneyCounter/MoneyText
@onready var card_container = $BottomFridge
@onready var reroll_button = $MarginContainer/ActionMenu/Reroll

var reroll_cost: int = 5

# Items
var item_pool = [
	{"name": "Iron Shield", "price": 4, "type": "defense"},
	{"name": "Steel Sword", "price": 6, "type": "attack"},
	{"name": "Health Potion", "price": 3, "type": "utility"},
	{"name": "Lucky Dice", "price": 8, "type": "buff"},
	{"name": "Spiked Boots", "price": 5, "type": "passive"}
]

func _ready() -> void:
	update_gold_ui()
	
	$MarginContainer/ActionMenu/NextStage.pressed.connect(_on_next_stage_pressed)
	$MarginContainer/ActionMenu/Reroll.pressed.connect(_on_reroll_pressed)
	
	clear_shop_shelf()
	generate_shop_cards(3)

func update_gold_ui() -> void:
	# Accesses global Player wallet
	money_text.text = "$" + str(PlayerStats.player_gold)
	
	if PlayerStats.player_gold < reroll_cost:
		reroll_button.disabled = true
		reroll_button.text = "Reroll (Poor!)"
	else:
		reroll_button.disabled = false
		reroll_button.text = "Reroll $" + str(reroll_cost)

func clear_shop_shelf() -> void:
	for child in card_container.get_children():
		child.queue_free()

func generate_shop_cards(amount: int) -> void:
	for i in range(amount):
		var card = card_scene.instantiate()
		card_container.add_child(card)
		
		var item_data = item_pool.pick_random()
		
		var name_label = card.get_node_or_null("NameLabel")
		var price_label = card.get_node_or_null("PriceLabel")
		var buy_button = card.get_node_or_null("BuyButton")
		
		if name_label: 
			name_label.text = item_data["name"]
		if price_label: 
			price_label.text = str(item_data["price"]) + " Gold"
			
		# DYNAMIC ITEM BUY SIGNAL:
		if buy_button:
			buy_button.pressed.connect(func(): _on_item_purchased(item_data, card))

# BUY LOGIC
func _on_item_purchased(item_data: Dictionary, card_node: Node) -> void:
	var cost = item_data["price"]
	
	if PlayerStats.player_gold >= cost:
		# 1. Deduct currency
		PlayerStats.player_gold -= cost
		
		# 2. Append item payload dictionary directly to your global attack array
		PlayerStats.attacks.append(item_data)
		print("Successfully Bought! Global Inventory Contents: ", PlayerStats.attacks)
		
		# 3. Destroy card node instance cleanly from the shelf display
		card_node.queue_free()
		
		# 4. Refresh display text balances
		update_gold_ui()
	else:
		print("Not enough money to buy ", item_data["name"])

# REROLL BUTTON
func _on_reroll_pressed() -> void:
	if PlayerStats.player_gold >= reroll_cost:
		PlayerStats.player_gold -= reroll_cost
		update_gold_ui()
		
		clear_shop_shelf()
		await get_tree().process_frame 
		generate_shop_cards(3)

# NEXT STAGE BUTTON
func _on_next_stage_pressed() -> void:
	print("Transitioning to encounter with items: ", PlayerStats.attacks)
	get_tree().change_scene_to_file("res://battle_scene.tscn")
