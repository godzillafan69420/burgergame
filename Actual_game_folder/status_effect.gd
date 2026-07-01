extends Node



var effect = []
func _ready() -> void:
	Events.connect("players_turn", _take_side_effects)
	Events.connect("give_side_effects", _new_side_effects)
	
	
func _take_side_effects():
	for i in get_children():
		i._take_effect()
	
func _new_side_effects(effects:String):
	
	
	var status_effect_icon = TextureRect.new()
	$"../status_effect_viewer".add_child(status_effect_icon)
	var new_effect =ListOfStatusEffects.get(effects).instantiate()
	new_effect.player_ingame_stats = get_parent().get_parent().find_child("player_stats")
	add_child(new_effect)
