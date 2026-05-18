extends Node

var num_of_enemies: int = 0
var current_state
enum States{players_turn, enemies_turn, waiting} 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in $"../enemies".get_children():
		num_of_enemies += 1
	print(num_of_enemies)
	current_state = States.waiting

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state == States.waiting:
		
