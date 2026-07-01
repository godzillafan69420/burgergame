extends Control

# Signal emitted when the player successfully chooses an upgrade
signal item_chosen(item_data: Dictionary)

@export var card_scene: PackedScene = preload("res://Upgrades/upgrade_pack.tscn")

@onready var choices_container = $VBoxContainer/ChoicesContainer
@onready var title_label = $VBoxContainer/PackTitleLabel

# Call this function to trigger the screen!
func open_pack(upgrade_pool: Array) -> void:
	# 1. Show the overlay screen
	visible = true
	
	# 2. Clear out any old choices left over from previous openings
	for child in choices_container.get_children():
		child.queue_free()
		
	# 3. Pick 3 unique rewards from the pool
	var pool_copy = upgrade_pool.duplicate()
	var choices = []
	for i in range(3):
		if pool_copy.is_empty(): 
			break
		var chosen_option = pool_copy.pick_random()
		choices.append(chosen_option)
		pool_copy.erase(chosen_option) # Prevents duplicates
		
	# 4. Instantiate the 3 chosen option cards side-by-side
	for option_data in choices:
		var card = card_scene.instantiate()
		choices_container.add_child(card)
		
		# Safely grab child text and image nodes
		var name_label = card.get_node_or_null("NameLabel")
		var price_label = card.get_node_or_null("PriceLabel")
		var effect_label = card.get_node_or_null("EffectLabel")
		var icon_rect = card.get_node_or_null("Background")
		var buy_button = card.get_node_or_null("BuyButton")
		
		# If "Background" isn't found, try fallback name "ItemIcon"
		if not icon_rect:
			icon_rect = card.get_node_or_null("ItemIcon")
		
		# Populate visual text data
		if name_label:
			name_label.text = option_data.get("display_name", "")
		if effect_label:
			effect_label.text = option_data.get("effect", "")
		if price_label:
			price_label.text = "CHOOSE!" # Replaces price text since it's a pack reward
			
		# Assign the illustration artwork texture (e.g., bacon.png)
		if icon_rect and option_data.has("icon"):
			icon_rect.texture = option_data["icon"]
			
		# Connect button click
		if buy_button:
			buy_button.pressed.connect(func(): _on_reward_selected(option_data))

func _on_reward_selected(chosen_data: Dictionary) -> void:
	# Tell the main shop system what item was chosen
	item_chosen.emit(chosen_data)
	
	# Hide the pack opening screen
	visible = false
