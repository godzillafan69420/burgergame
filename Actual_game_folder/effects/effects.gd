extends effects_base

var player_ingame_stats: Node2D

func _ready() -> void:
	if effect_name in get_parent().effect and !stackable:
		queue_free()
		return
		
	var status_effect_icon = TextureRect.new()
	status_effect_icon.name = effect_name
	status_effect_icon.texture = StatusIcon.get(effect_name)
	get_parent().get_parent().get_node("status_effect_viewer").add_child(status_effect_icon)
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
		for i in get_parent().get_parent().get_node("status_effect_viewer").get_children():
			if i.name == effect_name:
				i.queue_free()
				break
		
		queue_free()
