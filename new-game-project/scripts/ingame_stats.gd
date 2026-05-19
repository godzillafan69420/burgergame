extends Node2D



var HP: float
var speed:float

var def_stats: float = 0
const MAX_DEF: float = 20

@export var battle_logic_script: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	HP = PlayerStats.player_hitpoint
	$HP.max_value = HP
	$HP.value = HP
	Events.connect("damaged_player", _take_damage)
	


func _take_damage(damage: float) -> void:
	$HP.value -= damage * ((MAX_DEF - def_stats)/MAX_DEF)
	
	

	

	
func _process(delta: float) -> void:
	if battle_logic_script.current_state == battle_logic_script.States.waiting:
		$SPD.value += PlayerStats.player_speed * delta
	if $SPD.value == 100:
		Events.emit_signal("players_turn")
		$SPD.value = 0

		
		
