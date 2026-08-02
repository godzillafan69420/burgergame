extends Control

# Signal emitted when the player successfully chooses an upgrade
signal item_chosen(item_data: Dictionary)

@export var card_scene: PackedScene = preload("res://Upgrades/upgrade_pack.tscn")

@onready var choices_container = $VBoxContainer/ChoicesContainer
@onready var title_label = $VBoxContainer/PackTitleLabel
@onready var pack_opener = $PackOpener  # instance of res://ShopStuff/pack_opener.tscn

# How long the pack sits on screen (post-intro, pre-pop) so the player
# actually registers it before it explodes. Tune to taste.
@export var anticipation_delay: float = 0.5

# Call this function to trigger the screen!
func open_pack(upgrade_pool: Array) -> void:
	# 1. Show the overlay screen
	visible = true

	# 2. Hide the reward UI until the pack has visually popped open.
	#    (We build the cards now so there's no hitch later, just keep them invisible.)
	title_label.modulate.a = 0.0
	choices_container.modulate.a = 0.0

	# 3. Clear out any old choices left over from previous openings
	for child in choices_container.get_children():
		child.queue_free()

	# 4. Pick 3 unique rewards from the pool
	var pool_copy = upgrade_pool.duplicate()
	var choices = []
	for i in range(3):
		if pool_copy.is_empty():
			break
		var chosen_option = pool_copy.pick_random()
		choices.append(chosen_option)
		pool_copy.erase(chosen_option) # Prevents duplicates

	# 5. Instantiate the 3 chosen option cards side-by-side (still invisible)
	for option_data in choices:
		var card = card_scene.instantiate()
		choices_container.add_child(card)
		_populate_card(card, option_data)

	# 6. Play the Balatro-style pop: pack appears, anticipation beat, then bursts open
	pack_opener.reset() # clears _is_open + resets position/alpha from any previous opening
	pack_opener.show()
	pack_opener.play_intro()
	await get_tree().create_timer(anticipation_delay).timeout
	pack_opener.open_pack()
	await pack_opener.pack_opened

	# 7. Reveal the reward cards now that the pack has finished popping
	var reveal_tween = create_tween()
	reveal_tween.tween_property(title_label, "modulate:a", 1.0, 0.25)
	reveal_tween.parallel().tween_property(choices_container, "modulate:a", 1.0, 0.25)

func _populate_card(card: Control, option_data: Dictionary) -> void:
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

	# Hover tooltip -- Balatro-style popup, same component the shop cards use.
	card.mouse_entered.connect(func():
		HoverTooltip.show_at(card, option_data.get("display_name", ""), option_data.get("effect", ""))
	)
	card.mouse_exited.connect(func(): HoverTooltip.hide_tooltip(card))

func _on_reward_selected(chosen_data: Dictionary) -> void:
	HoverTooltip.hide_tooltip()

	# Tell the main shop system what item was chosen
	item_chosen.emit(chosen_data)

	# Hide the pack opening screen
	visible = false
