extends Control

@export var card_scene: PackedScene = preload("res://ShopStuff/shop_item_card.tscn")
@export var pack_scene: PackedScene = preload("res://Upgrades/upgrade_pack.tscn") 

@onready var money_text = $MarginContainer/MoneyCounter/MoneyText
@onready var top_fridge = $TopFridge        # Packs here
@onready var bottom_fridge = $BottomFridge  # Attacks here
@onready var PLS_WORK = $PackOpeningScene
@onready var reroll_button = $MarginContainer/ActionMenu/Reroll
@onready var next_stage_button = $MarginContainer/ActionMenu/NextStage

var reroll_cost: int = 5

# --- UPGRADE POOL ---
var upgrade_pool = [
	{"display_name": "McWettuce","id": "lettuce", "type": "upgrade", "effect": "+20 hp", "icon": preload("res://Art/bacon.png")},
	{"display_name": "placeholder2","id": "placeholder2", "type": "upgrade", "effect": "sigma", "icon": preload("res://Art/CardPack.png")},
	{"display_name": "placeholder3","id": "placeholder3", "type": "upgrade", "effect": "yes", "icon": preload("res://Art/CardPack.png")},
	{"display_name": "placeholder4","id": "placeholder4", "type": "joker", "effect": "ohio ", "icon": preload("res://Art/CardPack.png")},
	{"display_name": "Ancient Scroll","id": "Ancient Scroll", "type": "relic", "effect": "+1 Hand size", "icon": preload("res://Art/CardPack.png")}
]

# --- REGULAR ITEM POOL --- A
var regular_item_pool = [
	{"display_name": "tin foil","id": "iron_shield", "price": 4, "type": "defense", "icon": preload("res://Art/Tinfoil(card).png")},
	{"display_name": "Frying Pan","id": "steel_sword", "price": 6, "type": "attack", "icon": preload("res://Art/CardTemplateTuff.png")},
	{"display_name": "Heal","id": "health_potion", "price": 3, "type": "utility", "icon": preload("res://Art/Heal(card).png")},
	{"display_name": "corn canon","id": "corn_canon", "price": 8, "type": "buff", "icon": preload("res://Art/CardTemplateTuff.png")},
	{"display_name": "Aura Farm","id": "we_see_the_fit", "price": 5, "type": "passive", "icon": preload("res://Art/WeSeeTheFit.png")},
	{"display_name": "Hot Sauce","id": "hot_sauce", "price": 8, "type": "buff", "icon": preload("res://Art/CardTemplateTuff.png")},
]

var pack_pool = [
	{"display_name": "Buffoon Pack", "id": "Buffoon Pack", "price": 6, "type": "pack"}
]

func _ready() -> void:
	# Safe check to make sure upgrades array exists on PlayerStats Autoload
	if not "upgrades" in PlayerStats:
		PlayerStats.set("upgrades", [])

	update_gold_ui()
	
	next_stage_button.pressed.connect(_on_next_stage_pressed)
	reroll_button.pressed.connect(_on_reroll_pressed)
	
	if PLS_WORK:
		PLS_WORK.visible = false
		if not PLS_WORK.item_chosen.is_connected(_on_pack_reward_claimed):
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
	var temp_pack_pool = pack_pool.duplicate()
	var temp_item_pool = regular_item_pool.duplicate()

	for i in range(2):
		if temp_pack_pool.is_empty(): break
		var pack_data = temp_pack_pool.pick_random()
		create_card_on_shelf(pack_data, top_fridge, true) 
		
	for i in range(5):
		if temp_item_pool.is_empty(): break
		var item_data = temp_item_pool.pick_random()
		temp_item_pool.erase(item_data)
		create_card_on_shelf(item_data, bottom_fridge, false) 

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
	var icon_rect = card.get_node_or_null("Background") 
	
	if not icon_rect:
		icon_rect = card.get_node_or_null("ItemIcon")
	
	if name_label: 
		name_label.text = item_data["display_name"]
	if price_label: 
		if item_data.has("price"):
			price_label.text = str(item_data["price"]) + " Gold"
		else:
			price_label.text = ""
		
	if icon_rect and item_data.has("icon"):
		icon_rect.texture = item_data["icon"]
		
	if buy_button:
		buy_button.pressed.connect(func(): _on_item_purchased(item_data, card))

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
			regular_item_pool.erase(item_data)
			PlayerStats.attacks.append(item_data)
			print("Successfully Bought! Global Inventory Contents: ", PlayerStats.attacks)
	else:
		print("Not enough money to buy ", item_data.get("name", "Item"))

func open_pack_screen() -> void:
	if not PLS_WORK:
		print("Error: PackOpeningScene node (PLS_WORK) is missing!")
		return
		
	top_fridge.visible = false
	bottom_fridge.visible = false
	reroll_button.disabled = true
	next_stage_button.disabled = true
	
	PLS_WORK.open_pack(upgrade_pool)

func _on_pack_reward_claimed(chosen_data: Dictionary) -> void:
	var current_upgrades = PlayerStats.get("upgrades")
	current_upgrades.append(chosen_data)
	print("Selected pack upgrade: ", chosen_data["display_name"])
	print("Global Inventory Contents: ", current_upgrades)
	
	top_fridge.visible = true
	bottom_fridge.visible = true
	next_stage_button.disabled = false
	update_gold_ui()

func _on_reroll_pressed() -> void:
	if PlayerStats.player_gold >= reroll_cost:
		PlayerStats.player_gold -= reroll_cost
		update_gold_ui()
		
		clear_shop_shelves()
		await get_tree().process_frame 
		generate_entire_shop()

func _on_next_stage_pressed() -> void:
	print("Transitioning to encounter with items: ", PlayerStats.attacks)
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")
