extends Node2D
class_name enemy

var original_position:Vector2


@export var id: int = 0

@export var attacks_name:Array[String] = []
@export var def_stats: int = 1
@export var setted_HP: float = 50
var randomAttack :int
var attacks:Array[Dictionary] = []

var can_attack: bool = false

var damage_multiplier: float = 1

func _ready() -> void:
	
	original_position = global_position
	Events.connect("enemies_turn",_attacked_player)
	Events.connect("give_side_effects_to_enemies", _add_status)
	
	for i in attacks_name:
		attacks.append(EnemyAttacks.get(i))
	
func _add_status(status:String):
	var type = ListEnemyStatusEffects.get(status).instantiate()
	$status.add_child(type)
	
func _attacked_player(attack_id):
	var sentence = ""
	
	if attack_id != id:
		return
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", $"../../player".position, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.2).timeout
	randomAttack = randi_range(0,attacks.size() -1)
	
	var damage =(attacks[randomAttack].get("damage")) * damage_multiplier
	Events.emit_signal("damaged_player", damage)
	sentence = name+ " use " + attacks[randomAttack].get("name")
	#yes kallum i used ai for this if statement lmao

	var all_effects = attacks[randomAttack]["status_effects"]
	for effect in all_effects: 
		Events.emit_signal("give_side_effects", effect)
		sentence +="
		and give "+ effect
	if attacks[randomAttack]["buff"] != null:
		var all_buffs = attacks[randomAttack]["buff"]
		for effect in all_buffs: 
			Events.emit_signal("give_side_effects_to_enemies", effect)
	if get_tree() == null:
		return
	Events.emit_signal("update_display", sentence)
	var back_original = get_tree().create_tween()
	back_original.tween_property(self, "global_position", original_position, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await get_tree().create_timer(0.2).timeout
	Events.emit_signal("players_turn")



	

	
