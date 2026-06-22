extends Node2D


var HP: float
var speed:float

var damage_multiplier: float = 1

@export var battle_logic_script: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HP = get_parent().setted_HP
	$HP.max_value = HP
	$HP.value = HP
	Events.connect("damaged_enemy", _take_damage)
	Events.connect("id_chosen",_damage_yourself)
	
func _damage_yourself(id: int ,damage: int) -> void:
	if id != get_parent().id:
		return
	$HP.value -= damage * damage_multiplier
	if $HP.value <= 0:
		get_parent().queue_free()
		Events.emit_signal("check_victory_conditions")


func _take_damage(damage: int) -> void:
	$HP.value -= damage * damage_multiplier
	if $HP.value <= 0:
		get_parent().queue_free()
		Events.emit_signal("check_victory_conditions")
		
	



		
