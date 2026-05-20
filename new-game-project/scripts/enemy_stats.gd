extends Node2D


var HP: float
var speed:float
@export var battle_logic_script: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HP = get_parent().setted_HP
	$HP.max_value = HP
	$HP.value = HP
	Events.connect("damaged_enemy", _take_damage)

	
	
func _take_damage(damage: int) -> void:
	$HP.value -= damage



		
