extends Node2D

var HP: float
var speed:float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HP = PlayerStats.player_hitpoint
	$HP.max_value = HP
	$HP.value = HP
	Events.connect("damaged_player", _take_damage)

func _take_damage(damage: int) -> void:
	$HP.value -= damage
	
