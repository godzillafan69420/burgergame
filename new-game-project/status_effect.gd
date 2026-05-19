extends Node

var effects =[]
const EFFECTS_FOLDER = "res://effects/"
func _ready() -> void:
	Events.connect("players_turn", _take_side_effects)
	Events.connect("give_side_effects", _new_side_effects)
	
	
func _take_side_effects():
	for i in get_children():
		i._take_effect()
	
func _new_side_effects(effects):
	var effect =ListOfStatusEffects.POISON_SCENE.instantiate()
	add_child(effect)
