extends Control

@export var card_scene: PackedScene = preload("res://ShopStuff/shop_item_card.tscn")

@onready var money_text = $MarginContainer/MoneyCounter/MoneyText
@onready var card_container = $BottomFridge
@onready var PLS_WORK = $PackOpeningScene
@onready var reroll_button = $MarginContainer/ActionMenu/Reroll
@onready var next_stage_button = $MarginContainer/ActionMenu/NextStage

var reroll_cost: int = 5

var upgrade_pool = [
	{"name": "Abstract Joker", "type": "joker", "effect": "+3 Multiplier"},
	{"name": "Golden Relic", "type": "relic", "effect": "+2 Gold per round"},
	{"name": "Ice Shard", "type": "upgrade", "effect": "+5 Freeze damage"},
	{"name": "Fiery Heart", "type": "joker", "effect": "1.5x Multiplier"},
	{"name": "Ancient Scroll", "type": "relic", "effect": "+1 Hand size"}
]

# Items (Added the Buffoon Pack here so it can spawn on shelves!)
var item_pool = [
	{"name": "Iron Shield", "price": 4, "type": "defense"},
	{"name": "Steel Sword", "price": 6, "type": "attack"},
	{"name": "Health Potion", "price": 3, "type": "utility"},
	{"name": "Lucky Dice", "price": 8, "type": "buff"},
	{"name": "Spiked Boots", "price": 5, "type": "passive"},
	{"name": "Buffoon Pack", "price": 6, "type": "pack"}
]

func _ready() -> void:
	update_gold_ui()
	
	next_stage_button.pressed.connect(_on_next_stage_pressed)
	reroll_button.pressed.connect(_on_reroll_pressed)
	
	# Hide the pack opening overlay when the shop first opens
	if PLS_WORK:
		PLS_WORK.visible = false
	
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
		update_gold_ui()
		
		# 2. Destroy the card node instance cleanly from the shelf display
		card_node.queue_free()
		
		# 3. Check if they bought a regular item or a Pack
		if item_data.get("type") == "pack":
			print("Pack purchased! Opening reward selection...")
			open_pack_screen()
		else:
			# Append item payload dictionary directly to your global attack array
			PlayerStats.attacks.append(item_data)
			print("Successfully Bought! Global Inventory Contents: ", PlayerStats.attacks)
	else:
		print("Not enough money to buy ", item_data["name"])

# PACK OPENING REWARD SCREEN LOGIC
func open_pack_screen() -> void:
	if not PLS_WORK:
		print("Error: PackOpeningScene node (PLS_WORK) is missing!")
		return
		
	# Show the full-screen overlay and freeze standard shop menu buttons
	PLS_WORK.visible = true
	reroll_button.disabled = true
	next_stage_button.disabled = true
	
	# Find where to put the cards inside your pack scene. 
	# If you have an HBoxContainer named "ChoicesContainer" inside it, it will use that.
	# Otherwise, it falls back to adding them directly to PLS_WORK.
	var target_container = PLS_WORK.get_node_or_null("ChoicesContainer")
	if not target_container:
		target_container = PLS_WORK
		
	# Clear out any old choices from previous packs
	for child in target_container.get_children():
		if child is Control: # Protects background visual nodes if any
			child.queue_free()
			
	# Pick 3 unique random choices from the upgrade pool
	var pool_copy = upgrade_pool.duplicate()
	var choices = []
	for i in range(3):
		if pool_copy.is_empty(): break
		var chosen_option = pool_copy.pick_random()
		choices.append(chosen_option)
		pool_copy.erase(chosen_option) # Prevents duplicates within the same pack
		
	# Spawn the 3 reward cards
	for option_data in choices:
		var card = card_scene.instantiate()
		target_container.add_child(card)
		
		var name_label = card.get_node_or_null("NameLabel")
		var price_label = card.get_node_or_null("PriceLabel")
		var buy_button = card.get_node_or_null("BuyButton")
		
		if name_label:
			name_label.text = option_data["name"]
		if price_label:
			price_label.text = "CHOOSE!" # Replaces the price text since it's free now
			
		if buy_button:
			buy_button.pressed.connect(func(): _on_pack_reward_selected(option_data, target_container))

# HANDLING REWARD SELECTION
func _on_pack_reward_selected(chosen_data: Dictionary, target_container: Node) -> void:
	# 1. Save the selected item directly to inventory
	PlayerStats.attacks.append(chosen_data)
	print("Selected pack upgrade: ", chosen_data["name"])
	print("Global Inventory Contents: ", PlayerStats.attacks)
	
	# 2. Clear out the generated cards inside the pack overlay
	for child in target_container.get_children():
		if child is Control:
			child.queue_free()
			
	# 3. Hide the pack selection screen overlay
	PLS_WORK.visible = false
	
	# 4. Return shop buttons to normal
	next_stage_button.disabled = false
	update_gold_ui() # Recalculates if player can still afford rerolls

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
