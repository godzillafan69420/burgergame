extends Node2D
class_name enemy


@export var attacks = [EnemyAttacks.punch]
@export var def_stats: int = 1
@export var setted_HP: float = 50
@export var setted_speed:float = 2

func _ready() -> void:
	Events.connect("enemies_turn",_attacked_player)
	
func _attacked_player():
	Events.emit_signal("waiting_recharge")
	for i in attacks.size():
		Events.emit_signal("damaged_player",attacks[i].get("damage"))
	
