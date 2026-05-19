extends Node2D
class_name enemy


@export var attacks_name:Array[String] = []
@export var def_stats: int = 1
@export var setted_HP: float = 50
@export var setted_speed:float = 2
var randomAttack :int
var attacks:Array[Dictionary] = []

var can_attack: bool = false

func _ready() -> void:
	Events.connect("enemies_turn",_attacked_player)
	for i in attacks_name:
		attacks.append(EnemyAttacks.get(i))
	
func _attacked_player():
	
	if !can_attack:
		return
	randomAttack = randi_range(0,attacks.size()-1)
	Events.emit_signal("waiting_recharge")
	
	Events.emit_signal("damaged_player", attacks[randomAttack].get("damage"))
	
	#yes kallum i used ai for this if statement lmao
	if attacks[randomAttack].has("status_effects"):
		var all_effects = attacks[randomAttack]["status_effects"]
		for effect in all_effects: 
			Events.emit_signal("give_side_effects", effect)
			
			
