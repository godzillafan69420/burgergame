extends Node2D


var HP: float
var speed:float

var damage_multiplier: float = 1

var player_damge_multiplier: float
var upgraded_player_damge_multiplier: float
var aoe_player_damge_multiplier: float
var single_player_damge_multiplier: float
var def:float = 1

@export var battle_logic_script: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upgraded_player_damge_multiplier = get_parent().get_parent().get_parent().get_node("player").get_node("player_stats").upgraded_damage_multiplier
	aoe_player_damge_multiplier = get_parent().get_parent().get_parent().get_node("player").get_node("player_stats").upgraded_aoe_damage_multiplier
	single_player_damge_multiplier = get_parent().get_parent().get_parent().get_node("player").get_node("player_stats").upgraded_single_damage_multiplier
	player_damge_multiplier = get_parent().get_parent().get_parent().get_node("player").get_node("player_stats").damage_multiplier
	HP = get_parent().setted_HP
	$HP.max_value = HP
	$HP.value = HP
	$Label.text = str(int($HP.value)) + "/" +str(int($HP.max_value))
	Events.connect("damaged_enemy", _take_damage)
	Events.connect("id_chosen",_damage_yourself)
	Events.connect("players_turn", _take_effect)
	
func _damage_yourself(id: int ,damage: int) -> void:
	player_damge_multiplier = get_parent().get_parent().get_parent().get_node("player").get_node("player_stats").damage_multiplier
	if id != get_parent().id:
		return
	
	$HP.value -= damage * player_damge_multiplier * def * upgraded_player_damge_multiplier * single_player_damge_multiplier
	print(damage_multiplier)
	print(player_damge_multiplier)
	print(def)
	
	$Label.text = str(int($HP.value)) + "/" +str(int($HP.max_value))
	if $HP.value <= 0:
		get_parent().queue_free()
		Events.emit_signal("check_victory_conditions")


func _take_damage(damage: int) -> void:
	
	player_damge_multiplier = get_parent().get_parent().get_parent().get_node("player").get_node("player_stats").damage_multiplier
	$HP.value -= damage * damage_multiplier * player_damge_multiplier * aoe_player_damge_multiplier * def
	$Label.text = str(int($HP.value)) + "/" +str(int($HP.max_value))
	if $HP.value <= 0:
		get_parent().queue_free()
		Events.emit_signal("check_victory_conditions")
		
func _take_effect():
	for i in $"../status".get_children():
		i._take_effect()


		
