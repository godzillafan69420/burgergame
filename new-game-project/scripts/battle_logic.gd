extends Node


var enemy_id_turn: int = 0
var total_enemies:int = 1
const MAX_CARDS = 5

var num_of_enemies: int = 0
var current_state
enum States{players_turn, enemies_turn, dialogue} 

var cards_can_spawn = ["blocking", "punch"]

var num_of_cards

var card_list: Control

var enemy_list: Node2D


func _ready() -> void:
	enemy_list = $"../enemies"
	card_list = $"../UI/cards"
	print(total_enemies)
	card_list.child_order_changed.connect(_update_card_ids)
	
	num_of_cards = card_list.get_child_count()
	for i in $"../enemies".get_children():
		num_of_enemies += 1

	current_state = States.players_turn
	Events.connect("players_turn", _players_turn)
	Events.connect("enemies_turn", _enemies_turn)
	Events.connect("dialogue", _dialogue)
	Events.connect("check_victory_conditions", _check_victory)
	
	Events.emit_signal("players_turn")
func _dialogue():
	current_state = States.dialogue


func _players_turn():
	num_of_cards = card_list.get_child_count()
	current_state = States.players_turn
	
	if num_of_cards < MAX_CARDS:
		for i in range(MAX_CARDS - num_of_cards):
			var card_choice = randi_range(0, cards_can_spawn.size() - 1)
			var new_card = ListOfCards.get(cards_can_spawn[card_choice]).instantiate()
			card_list.add_child(new_card)
		
		# Update all IDs sequentially now that the hand is full
		_update_card_ids()

# Cleaned-up sequential ID assignment function
func _update_card_ids() -> void:
	var children = card_list.get_children()
	num_of_cards = children.size()
	for index in range(children.size()):
		children[index].card_id = index
func _enemies_turn():
	
	print(total_enemies)
	current_state = States.enemies_turn
	num_of_cards = card_list.get_child_count()

func _check_victory():
	print("changingScene")
	print(enemy_list.get_child_count()-1)
	if enemy_list.get_child_count() -1 == 0:
		get_tree().change_scene_to_file("res://ShopStuff/shop_scene.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
