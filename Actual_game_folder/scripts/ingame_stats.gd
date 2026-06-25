extends Node2D



var HP: float



var def_stats: float = 0
const MAX_DEF: float = 20

var damage_multiplier: float = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	HP = PlayerStats.player_hitpoint
	$HP.max_value = HP
	$HP.value = HP
	$Label.text = str(int($HP.value)) + "/" +str(int($HP.max_value))
	Events.connect("damaged_player", _take_damage)
	


func _take_damage(damage: float) -> void:
	$HP.value -= damage * ((MAX_DEF - def_stats)/MAX_DEF)
	$Label.text = str(int($HP.value)) + "/" +str(int($HP.max_value))
	if $HP.value<=0:
		get_tree().change_scene_to_file("res://scenes/deathScene.tscn")
	


		
		
