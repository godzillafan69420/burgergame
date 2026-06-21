extends Node2D
class_name enemy

var original_position:Vector2


@export var id: int = 0

@export var attacks_name:Array[String] = []
@export var def_stats: int = 1
@export var setted_HP: float = 50
@export var setted_speed:float = 2
var randomAttack :int
var attacks:Array[Dictionary] = []

var can_attack: bool = false

var damage_multiplier: float = 1

func _ready() -> void:
	
	original_position = global_position
	Events.connect("enemies_turn",_attacked_player)
	
	for i in attacks_name:
		attacks.append(EnemyAttacks.get(i))
	
func _attacked_player(attack_id):
	if attack_id != id:
		return
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", $"../../player".position, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.2).timeout
	randomAttack = randi_range(0,attacks.size() -1)
	Events.emit_signal("players_turn")
	var damage =(attacks[randomAttack].get("damage")) * damage_multiplier
	Events.emit_signal("damaged_player", damage)
	
	#yes kallum i used ai for this if statement lmao
	if attacks[randomAttack].has("status_effects"):
		var all_effects = attacks[randomAttack]["status_effects"]
		for effect in all_effects: 
			Events.emit_signal("give_side_effects", effect)
	if get_tree() == null:
		return
	var back_original = get_tree().create_tween()
	back_original.tween_property(self, "global_position", original_position, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await get_tree().create_timer(0.2).timeout


	

	
