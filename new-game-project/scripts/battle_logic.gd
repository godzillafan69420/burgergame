extends Node

var num_of_enemies: int = 0
var current_state
enum States{players_turn, enemies_turn, waiting} 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in $"../enemies".get_children():
		num_of_enemies += 1

	current_state = States.waiting
	Events.connect("players_turn",_players_turn)
	Events.connect("enemies_turn",_enemies_turn)
	Events.connect("waiting_recharge", _recharging)
func _recharging():
	current_state = States.waiting


func _players_turn():
	current_state = States.players_turn

func _enemies_turn():
	current_state = States.enemies_turn

# Called every frame. 'delta' is the elapsed time since the previous frame.
