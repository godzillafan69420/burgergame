extends effects_base

var player_ingame_stats: Node2D

func _ready() -> void:
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

		player_ingame_stats.set(target_stats, PlayerStats.player_defalt_def)
		queue_free()
