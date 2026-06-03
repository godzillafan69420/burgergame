extends Control

# Signal emitted when the player successfully chooses an upgrade
signal item_chosen(item_data: Dictionary)

@export var card_scene: PackedScene = preload("res://ShopStuff/shop_item_card.tscn")

@onready var choices_container = $VBoxContainer/ChoicesContainer
@onready var title_label = $VBoxContainer/PackTitleLabel

# Call this function to trigger the screen!
func open_pack(upgrade_pool: Array) -> void:
	# Show the overlay screen
	visible = true
	
	# Clear out any old choices left over
	for child in choices_container.get_children():
		child.queue_free()
		
	# Pick 3 unique rewards from the pool
	var pool_copy = upgrade_pool.duplicate()
	var choices = []
	for i in range(3):
		if pool_copy.is_empty(): break
		var chosen_option = pool_copy.pick_random()
		choices.append(chosen_option)
		pool_copy.erase(chosen_option) # Prevents duplicates
		
	# Instantiate the 3 option cards side-by-side inside choices_container
	for option_data in choices:
		var card = card_scene.instantiate()
		choices_container.add_child(card)
		
		# Safely access internal nodes using your fallback system
		var name_label = card.get_node_or_null("NameLabel")
		var price_label = card.get_node_or_null("PriceLabel")
		var buy_button = card.get_node_or_null("BuyButton")
		
		if name_label:
			name_label.text = option_data["name"]
		if price_label:
			price_label.text = "CHOOSE!" # Replaces price text since it's a pack reward
			
		if buy_button:
			buy_button.pressed.connect(func(): _on_reward_selected(option_data))

func _on_reward_selected(chosen_data: Dictionary) -> void:
	# Tell the main shop system what item was chosen
	item_chosen.emit(chosen_data)
	
	# Hide the pack opening screen
	visible = false
