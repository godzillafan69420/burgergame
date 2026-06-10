extends Control

@onready var top_scroll = $TopScrollContainer
@onready var map_scroll = $MapScrollContainer
@onready var hbox = $TopScrollContainer/HBoxContainer
@onready var godot_guy = $MapScrollContainer/Control/TextureRect

var level_cards: Array = []
var current_level_index: int = 0

# Variables to handle smooth button snapping without fighting mouse drags
var target_scroll_x: float = 0.0
var is_snapping: bool = false

func _ready():
	level_cards = hbox.get_children()
	
	# Keep both windows moving 1:1 when dragging with the mouse
	top_scroll.get_h_scroll_bar().value_changed.connect(_on_top_scroll_changed)
	
	# Connect your buttons (Make sure these names match your Scene Tree exactly!)
	if has_node("LeftButton"): $LeftButton.pressed.connect(_on_left_button_pressed)
	if has_node("RightButton"): $RightButton.pressed.connect(_on_right_button_pressed)
	if has_node("PlayButton"): $PlayButton.pressed.connect(_on_play_button_pressed)

func _on_top_scroll_changed(value: float):
	# Instantly mirror the scroll movement to the map container
	map_scroll.scroll_horizontal = value
	
	# If the player is manually dragging the screen, find out which card is closest to the middle
	if not is_snapping:
		_determine_closest_level()

func _process(delta):
	if level_cards.size() == 0: return

	# 1. Smoothly slide the screen ONLY if an arrow button was clicked
	if is_snapping:
		top_scroll.scroll_horizontal = lerp(float(top_scroll.scroll_horizontal), target_scroll_x, 0.1)
		# Turn off snapping once we arrive closely at the target
		if abs(top_scroll.scroll_horizontal - target_scroll_x) < 1.0:
			top_scroll.scroll_horizontal = target_scroll_x
			is_snapping = false

	# 2. FOOLPROOF CHARACTER TRACKING:
	# Look at where the active card physically sits on your monitor right now
	var active_card = level_cards[current_level_index]
	var card_center_global_x = active_card.global_position.x + (active_card.size.x / 2)
	
	# Position the Godot guy perfectly underneath that screen coordinate
	var target_guy_global_x = card_center_global_x - (godot_guy.size.x / 2)
	godot_guy.global_position.x = lerp(godot_guy.global_position.x, target_guy_global_x, 0.15)

func _determine_closest_level():
	# Finds which card is closest to the exact horizontal center of the screen
	var screen_center_x = top_scroll.global_position.x + (top_scroll.size.x / 2)
	var closest_index = 0
	var closest_distance = INF
	
	for i in range(level_cards.size()):
		var card = level_cards[i]
		var card_center_x = card.global_position.x + (card.size.x / 2)
		var dist = abs(card_center_x - screen_center_x)
		if dist < closest_distance:
			closest_distance = dist
			closest_index = i
			
	current_level_index = closest_index

func _snap_to_level(index: int):
	current_level_index = clamp(index, 0, level_cards.size() - 1)
	var active_card = level_cards[current_level_index]
	
	# Calculate exactly how many pixels to scroll to center this specific card
	var screen_center_offset = top_scroll.size.x / 2
	var card_center = active_card.position.x + (active_card.size.x / 2)
	
	target_scroll_x = card_center - screen_center_offset
	is_snapping = true

func _on_left_button_pressed():
	_snap_to_level(current_level_index - 1)

func _on_right_button_pressed():
	_snap_to_level(current_level_index + 1)

func _on_play_button_pressed():
	var current_level_node = level_cards[current_level_index]
	
	# The master registry! This dynamically handles whichever stage is active
	print("Play button clicked! Entering Stage: ", current_level_node.name)
	
	# Example level management layout:
	if current_level_node.name == "Card_Cambodia":
		get_tree().change_scene_to_file("res://levels/cambodia.tscn")
	elif current_level_node.name == "Card_Philippines":
		get_tree().change_scene_to_file("res://levels/philippines.tscn")
