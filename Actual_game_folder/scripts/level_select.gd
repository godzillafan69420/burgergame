extends Control

@onready var top_scroll = $TopScrollContainer
@onready var map_scroll = $MapScrollContainer
@onready var hbox = $TopScrollContainer/HBoxContainer
@onready var godot_guy = $MapScrollContainer/Control/TextureRect

# Level Preview UI References
@onready var info_panel = $LevelInfoPanel            
@onready var enemy_preview = $LevelInfoPanel/EnemyIcon 
@onready var stage_title = $LevelInfoPanel/StageTitle 

var level_cards: Array = []
var current_level_index: int = 0
var target_scroll_x: float = 0.0

var level_preview_data: Dictionary = {
	"Tutorial": {
		"title": "Tutorial Stage",
		"icon": "res://Art/john_test.png",
		"description": "Target: Practice Dummy"
	},
	"Level_1": {
		"title": "Stage 1: The Streets",
		"icon": "res://Art/tetoPortraits.png",
		"description": "Threat: Street Goons"
	},
	"Level_2": {
		"title": "Boss: Socrates",
		"icon": "res://Art/socrates.png",
		"description": "Boss Encounter: Socrates"
	},
	"Level_3": {
		"title": "Boss: Ivan the Van",
		"icon": "res://Art/ivanthevanprotrait.png",
		"description": "Boss Encounter: Ivan the Van"
	},
	"Level_4": {
		"title": "Boss: Fake Italian Guys",
		"icon": "res://Art/furryKing.png",
		"description": "Threat: Fake Italian Crew"
	},
	"Level_5": {
		"title": "Boss: Cone L",
		"icon": "res://Art/coneL.png",
		"description": "Boss Encounter: Cone L"
	},
	"Level_6": {
		"title": "Boss: Ze Monke",
		"icon": "res://Art/zemonke.png",
		"description": "Boss Encounter: Ze Monke"
	}
}

func _player_stats_change():
	PlayerStats.player_hitpoint = 100
	PlayerStats.player_max_energy = 50
	PlayerStats.player_recovery = 10
	PlayerStats.player_aoe_damage = 1
	PlayerStats.player_single_damage = 1
	PlayerStats.player_damage = 1
	PlayerStats.player_hitpoint_recovery = 0
	for i in PlayerStats.upgrades:
		if i["id"] == "lettuce":
			PlayerStats.player_hitpoint += 25
		if i["id"] == "beef_patty":
			PlayerStats.player_damage += 0.15
		if i["id"] == "cheese":
			PlayerStats.player_recovery += 4
		if i["id"] == "bacon":
			PlayerStats.player_hitpoint_recovery += 5
		if i["id"] == "pickle":
			PlayerStats.player_damage += 0.05
			PlayerStats.player_hitpoint += 10
		if i["id"] == "chicken":
			PlayerStats.player_recovery += 2
			PlayerStats.player_max_energy += 10

func _ready():
	_player_stats_change()
	AudioManager.play("LevelSelect")
	level_cards = hbox.get_children()

	if has_node("LeftButton"): $LeftButton.pressed.connect(_on_left_button_pressed)
	if has_node("RightButton"): $RightButton.pressed.connect(_on_right_button_pressed)
	if has_node("PlayButton"): $PlayButton.pressed.connect(_on_play_button_pressed)
	
	await get_tree().process_frame

	_snap_to_level(Globals.level - 1)

	top_scroll.scroll_horizontal = target_scroll_x
	map_scroll.scroll_horizontal = target_scroll_x
	var active_card = level_cards[current_level_index]
	var card_center_global_x = active_card.global_position.x + (active_card.size.x / 2)
	godot_guy.global_position.x = card_center_global_x - (godot_guy.size.x / 2)

func _process(_delta):
	if level_cards.size() == 0: return

	top_scroll.scroll_horizontal = lerp(float(top_scroll.scroll_horizontal), target_scroll_x, 0.1)
	map_scroll.scroll_horizontal = top_scroll.scroll_horizontal

	var active_card = level_cards[current_level_index]
	var card_center_global_x = active_card.global_position.x + (active_card.size.x / 2)
	var target_guy_global_x = card_center_global_x - (godot_guy.size.x / 2)
	godot_guy.global_position.x = lerp(godot_guy.global_position.x, target_guy_global_x, 0.15)
	if info_panel:
		info_panel.global_position = active_card.global_position
	
func _snap_to_level(index: int):
	current_level_index = clamp(index, 0, level_cards.size() - 1)
	var active_card = level_cards[current_level_index]

	var screen_center_offset = top_scroll.size.x / 2
	var card_center = active_card.position.x + (active_card.size.x / 2)
	
	target_scroll_x = card_center - screen_center_offset
	
	# Call update whenever level snaps
	_update_level_preview(active_card.name)

func _update_level_preview(card_name: String):
	if level_preview_data.has(card_name):
		var data = level_preview_data[card_name]
		
		if stage_title:
			stage_title.text = data["title"]
			
		if enemy_preview and ResourceLoader.exists(data["icon"]):
			enemy_preview.texture = load(data["icon"])
			
		if info_panel:
			info_panel.visible = true

func _on_left_button_pressed():
	_snap_to_level(current_level_index - 1)

func _on_right_button_pressed():
	_snap_to_level(current_level_index + 1)

func _on_play_button_pressed():
	var current_level_node = level_cards[current_level_index]
	var dest_scene: String = ""
	
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
		TransitionManager.play_transition(dest_scene)
