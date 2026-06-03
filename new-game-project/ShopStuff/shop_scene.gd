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

# Items
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
	
	# Connect the pack opening scene's choice signal back to this shop script
	if PLS_WORK:
		PLS_WORK.visible = false
		PLS_WORK.item_chosen.connect(_on_pack_reward_claimed)
	
	clear_shop_shelf()
	generate_shop_cards(3)

func update_gold_ui() -> void:
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
			
		if buy_button:
			buy_button.pressed.connect(func(): _on_item_purchased(item_data, card))

# BUY LOGIC
func _on_item_purchased(item_data: Dictionary, card_node: Node) -> void:
	var cost = item_data["price"]
	
	if PlayerStats.player_gold >= cost:
		PlayerStats.player_gold -= cost
		update_gold_ui()
		
		card_node.queue_free()
		
		if item_data.get("type") == "pack":
			print("Pack purchased! Opening reward selection...")
			open_pack_screen()
		else:
			PlayerStats.attacks.append(item_data)
			print("Successfully Bought! Global Inventory Contents: ", PlayerStats.attacks)
	else:
		print("Not enough money to buy ", item_data["name"])

# PACK OPENING SETUP
func open_pack_screen() -> void:
	if not PLS_WORK:
		print("Error: PackOpeningScene node (PLS_WORK) is missing!")
		return
		
	# 1. Hide the normal shop shelves so things don't look messy
	card_container.visible = false
	reroll_button.disabled = true
	next_stage_button.disabled = true
	
	# 2. Tell the pack scene script to execute its custom generation layout
	PLS_WORK.open_pack(upgrade_pool)

# HANDLING REWARD SELECTION (Triggered via signal from PLS_WORK)
func _on_pack_reward_claimed(chosen_data: Dictionary) -> void:
	# 1. Add item payload directly to global attack array
	PlayerStats.attacks.append(chosen_data)
	print("Selected pack upgrade: ", chosen_data["name"])
	print("Global Inventory Contents: ", PlayerStats.attacks)
	
	# 2. Return layout visibility to normal shop state
	card_container.visible = true
	next_stage_button.disabled = false
	update_gold_ui()

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
