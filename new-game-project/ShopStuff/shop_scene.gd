extends Control

@export var card_scene: PackedScene = preload("res://ShopStuff/shop_item_card.tscn")
# NEW: Preload your separate upgrade pack visual style scene here
@export var pack_scene: PackedScene = preload("res://Upgrades/upgrade_pack.tscn") 

@onready var money_text = $MarginContainer/MoneyCounter/MoneyText
@onready var top_fridge = $TopFridge        # Packs here
@onready var bottom_fridge = $BottomFridge  # attacks here
@onready var PLS_WORK = $PackOpeningScene
@onready var reroll_button = $MarginContainer/ActionMenu/Reroll
@onready var next_stage_button = $MarginContainer/ActionMenu/NextStage

var reroll_cost: int = 5
#upgradses tuff
var upgrade_pool = [
	{"name": "placeholder", "type": "upgrade", "effect": "deez"},
	{"name": "placeholder2", "type": "upgrade", "effect": "sigma"},
	{"name": "placeholder3", "type": "upgrade", "effect": "yes"},
	{"name": "placeholder4", "type": "joker", "effect": "ohio "},
	{"name": "Ancient Scroll", "type": "relic", "effect": "+1 Hand size"}
]

# 2 different item pools so they dont mix 
var regular_item_pool = [
	{"name": "Iron Shield", "price": 4, "type": "defense"},
	{"name": "Steel Sword", "price": 6, "type": "attack"},
	{"name": "Health Potion", "price": 3, "type": "utility"},
	{"name": "Lucky Dice", "price": 8, "type": "buff"},
	{"name": "Spiked Boots", "price": 5, "type": "passive"}
]

var pack_pool = [
	{"name": "Buffoon Pack", "price": 6, "type": "pack"}
]

func _ready() -> void:
	update_gold_ui()
	
	next_stage_button.pressed.connect(_on_next_stage_pressed)
	reroll_button.pressed.connect(_on_reroll_pressed)
	
	if PLS_WORK:
		PLS_WORK.visible = false
		PLS_WORK.item_chosen.connect(_on_pack_reward_claimed)
	
	clear_shop_shelves()
	generate_entire_shop()

func update_gold_ui() -> void:
	money_text.text = "$" + str(PlayerStats.player_gold)
	
	if PlayerStats.player_gold < reroll_cost:
		reroll_button.disabled = true
		reroll_button.text = "Reroll (HaHa Pooron!)"
	else:
		reroll_button.disabled = false
		reroll_button.text = "Reroll $" + str(reroll_cost)

func clear_shop_shelves() -> void:
	for child in top_fridge.get_children():
		child.queue_free()
	for child in bottom_fridge.get_children():
		child.queue_free()

func generate_entire_shop() -> void:
	# 1. Spawn 2 random packs on the Top Fridge (Tells the generator to use the pack scene layout)
	for i in range(2):
		if pack_pool.is_empty(): break
		var pack_data = pack_pool.pick_random()
		create_card_on_shelf(pack_data, top_fridge, true) #true for the other layout
		
	# 2. Spawn 5 random regular items on the Bottom Fridge
	for i in range(5):
		if regular_item_pool.is_empty(): break
		var item_data = regular_item_pool.pick_random()
		create_card_on_shelf(item_data, bottom_fridge, false) #flase is normal layout unc

# Helper function that cleanly handles text setups and chooses the correct layout style
func create_card_on_shelf(item_data: Dictionary, target_fridge: Node, is_pack: bool) -> void:
	var card
	if is_pack and pack_scene:
		card = pack_scene.instantiate()
	else:
		card = card_scene.instantiate()
		
	target_fridge.add_child(card)
	
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
		
	top_fridge.visible = false
	bottom_fridge.visible = false
	reroll_button.disabled = true
	next_stage_button.disabled = true
	
	PLS_WORK.open_pack(upgrade_pool)

# HANDLING REWARD SELECTION (Via signal)
func _on_pack_reward_claimed(chosen_data: Dictionary) -> void:
	PlayerStats.attacks.append(chosen_data)
	print("Selected pack upgrade: ", chosen_data["name"])
	print("Global Inventory Contents: ", PlayerStats.attacks)
	
	top_fridge.visible = true
	bottom_fridge.visible = true
	next_stage_button.disabled = false
	update_gold_ui()

# REROLL BUTTON
func _on_reroll_pressed() -> void:
	if PlayerStats.player_gold >= reroll_cost:
		PlayerStats.player_gold -= reroll_cost
		update_gold_ui()
		
		clear_shop_shelves()
		await get_tree().process_frame 
		generate_entire_shop()

# NEXT STAGE BUTTON
func _on_next_stage_pressed() -> void:
	print("Transitioning to encounter with items: ", PlayerStats.attacks)
	get_tree().change_scene_to_file("res://battle_scene.tscn")
