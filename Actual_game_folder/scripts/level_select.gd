extends Control

@onready var top_scroll = $TopScrollContainer
@onready var map_scroll = $MapScrollContainer
@onready var hbox = $TopScrollContainer/HBoxContainer
@onready var godot_guy = $MapScrollContainer/Control/TextureRect

var level_cards: Array = []
var current_level_index: int = 0
var target_scroll_x: float = 0.0

func _ready():
	AudioManager.play("LevelSelect")
	level_cards = hbox.get_children()

	# Connect your layout buttons
	if has_node("LeftButton"): $LeftButton.pressed.connect(_on_left_button_pressed)
	if has_node("RightButton"): $RightButton.pressed.connect(_on_right_button_pressed)
	if has_node("PlayButton"): $PlayButton.pressed.connect(_on_play_button_pressed)
	
	# Snap to whatever level the player has actually reached, instead of
	# always resetting to Tutorial. Card order is Tutorial, Level_1, Level_2...
	# which lines up with Globals.level == 1, 2, 3... so index = level - 1.
	#
	# top_scroll.size isn't valid until the engine finishes its first layout
	# pass -- reading it immediately here can give a stale/zero size, which
	# throws off the very first scroll target (this bug always existed, it
	# just never showed when we always snapped to index 0). Waiting a frame
	# fixes that.
	await get_tree().process_frame

	_snap_to_level(Globals.level - 1)

	# Jump straight to the correct scroll + character position instead of
	# visibly lerping in from the old editor-placed spot on scene load.
	top_scroll.scroll_horizontal = target_scroll_x
	map_scroll.scroll_horizontal = target_scroll_x
	var active_card = level_cards[current_level_index]
	var card_center_global_x = active_card.global_position.x + (active_card.size.x / 2)
	godot_guy.global_position.x = card_center_global_x - (godot_guy.size.x / 2)

func _process(_delta):
	if level_cards.size() == 0: return
	# 1. Smoothly slide the Top Scroll container to center the card
	top_scroll.scroll_horizontal = lerp(float(top_scroll.scroll_horizontal), target_scroll_x, 0.1)
	
	# 2. Force the Map Scroll container to mirror the exact position 1:1
	map_scroll.scroll_horizontal = top_scroll.scroll_horizontal
	# 3. Track the active level card perfectly in screen-space (global coordinates).
	# This guarantees the Godot guy stays centered underneath the country card,
	# even when you reach the 9th/10th card where the scroll containers hit a physical wall.
	var active_card = level_cards[current_level_index]
	var card_center_global_x = active_card.global_position.x + (active_card.size.x / 2)
	var target_guy_global_x = card_center_global_x - (godot_guy.size.x / 2)
	var bg_global_x = active_card.global_position.x - (active_card.size.x / 2)
	godot_guy.global_position.x = lerp(godot_guy.global_position.x, target_guy_global_x, 0.15)
	
func _snap_to_level(index: int):
	# Keep the index safely bounded inside your actual level list
	current_level_index = clamp(index, 0, level_cards.size() - 1)
	var active_card = level_cards[current_level_index]
	
	# Calculate exactly how many pixels to scroll to center this specific card
	var screen_center_offset = top_scroll.size.x / 2
	var card_center = active_card.position.x + (active_card.size.x / 2)
	
	target_scroll_x = card_center - screen_center_offset

func _on_left_button_pressed():
	_snap_to_level(current_level_index - 1)

func _on_right_button_pressed():
	_snap_to_level(current_level_index + 1)

func _on_play_button_pressed():
	var current_level_node = level_cards[current_level_index]
	var dest_scene: String = ""
	
	# Match up your node names to their destination files
	if (current_level_node.name == "Card_Cambodia" or current_level_node.name == "Tutorial") and (Globals.level ==1 or Globals.level >7):
		dest_scene = "res://scenes/battle_scene.tscn"
	elif (current_level_node.name == "Card_Philippines" or current_level_node.name == "Level_1") and (Globals.level ==2 or Globals.level >7):
		dest_scene = "res://scenes/level1.tscn"
	elif (current_level_node.name == "Card_Japan" or current_level_node.name == "Level_2") and (Globals.level ==3 or Globals.level >7):
		dest_scene = "res://scenes/socrates_boss_1.tscn"
	elif (current_level_node.name == "Card_Japan" or current_level_node.name == "Level_3") and (Globals.level ==4 or Globals.level >7):
		dest_scene = "res://scenes/ivan_the_van.tscn"
	elif (current_level_node.name == "Card_Japan" or current_level_node.name == "Level_4") and (Globals.level ==5 or Globals.level >7):
		dest_scene = "res://scenes/fake_italian_guys.tscn"
	elif (current_level_node.name == "Card_Japan" or current_level_node.name == "Level_5") and (Globals.level ==6 or Globals.level >7):
		dest_scene = "res://scenes/cone_l.tscn"
	elif (current_level_node.name == "Card_Japan" or current_level_node.name == "Level_6") and (Globals.level ==7 or Globals.level >7):
		dest_scene = "res://scenes/zemonke.tscn"
	if dest_scene != "":
		# Simply call the global manager! It takes care of everything else.
		TransitionManager.play_transition(dest_scene)
