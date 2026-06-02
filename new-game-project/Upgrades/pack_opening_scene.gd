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
		
	# Instantiate the 3 option cards
	for option_data in choices:
		var card = card_scene.instantiate()
		choices_container.add_child(card)
		
		# Set up the card text using Kevin's method
		if card.has_method("setup_item"):
			card.setup_item(option_data["name"], 0) # 0 Gold / Free selection
			
		# Connect the card's click directly to selecting this reward
		if card.has_signal("clicked"):
			card.clicked.connect(func(): _on_reward_selected(option_data))

func _on_reward_selected(chosen_data: Dictionary) -> void:
	# Tell the main shop system what item was chosen
	item_chosen.emit(chosen_data)
	
	# Hide the pack opening screen
	visible = false
