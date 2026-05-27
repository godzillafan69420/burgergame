extends Node


const MAX_CARDS = 5

var num_of_enemies: int = 0
var current_state
enum States{players_turn, enemies_turn, dialogue} 

var cards_can_spawn = ["blocking", "punch"]

var num_of_cards

var card_list: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_list = $"../UI/cards"
	num_of_cards = card_list.get_child_count()
	for i in $"../enemies".get_children():
		num_of_enemies += 1

	current_state = States.players_turn
	Events.connect("players_turn",_players_turn)
	Events.connect("enemies_turn",_enemies_turn)
	Events.connect("dialogue", _dialogue)
	Events.emit_signal("players_turn")
func _dialogue():
	current_state = States.dialogue


func _players_turn():
	num_of_cards = card_list.get_child_count()
	current_state = States.players_turn
	if num_of_cards < MAX_CARDS:
		for i in range(MAX_CARDS-num_of_cards):
			var card_choice = randi_range(0,cards_can_spawn.size()-1)
			var new_card = ListOfCards.get(cards_can_spawn[card_choice]).instantiate()
			card_list.add_child(new_card)
			num_of_cards = card_list.get_child_count()
			
	

func _enemies_turn():
	current_state = States.enemies_turn
	num_of_cards = card_list.get_child_count()

# Called every frame. 'delta' is the elapsed time since the previous frame.
