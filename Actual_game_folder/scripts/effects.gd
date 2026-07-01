extends effects_base

var player_ingame_stats: Node2D

func _ready() -> void:
	get_parent().effect.append(effect_name)
	player_ingame_stats = get_parent().get_parent().find_child("player_stats")
	if type == types_of_effect[1]:
		duration += 1
	_take_effect()
	
	


func _take_effect():
	if type == types_of_effect[0] and duration  >= 0:
		Events.emit_signal("damaged_player", damage)
	
	if type == types_of_effect[1] and duration > 0:
		player_ingame_stats.set(target_stats, Effect_strength)
			
	duration -= 1
	if duration <= 0:
		if target_stats =="damage_multiplier":
			player_ingame_stats.set(target_stats, 1)
		if target_stats =="def_stats":
			player_ingame_stats.set(target_stats, 0)
		get_parent().effect.erase(effect_name)
		print(get_parent().effect)
		queue_free()
