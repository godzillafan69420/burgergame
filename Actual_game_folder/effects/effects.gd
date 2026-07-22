extends effects_base

var player_ingame_stats: Node2D
var before_stats: float

func _ready() -> void:
	player_ingame_stats = get_parent().get_parent().get_node("player_stats")
	if effect_name in get_parent().effect and !stackable:
		queue_free()
		return
	
	var status_effect_icon = TextureRect.new()
	status_effect_icon.name = effect_name
	status_effect_icon.texture = StatusIcon.get(effect_name)
	get_parent().get_parent().get_node("status_effect_viewer").add_child(status_effect_icon)
	get_parent().effect.append(effect_name)
	player_ingame_stats = get_parent().get_parent().find_child("player_stats")
	if type == types_of_effect[1] or effect_name == "heal":
		before_stats = player_ingame_stats.get(target_stats)
		duration += 1
		_take_effect()

	
	


func _take_effect():
	if type == types_of_effect[0] and duration  > 0:
		player_ingame_stats.get_node("HP").value -= damage 
		player_ingame_stats.get_node("Label").text = str(int(player_ingame_stats.get_node("HP").value)) + "/" +str(int(player_ingame_stats.get_node("HP").max_value))
		if player_ingame_stats.get_node("HP").value <=0:
			get_tree().change_scene_to_file("res://scenes/deathScene.tscn")
	if type == types_of_effect[1] and duration > 0:
		player_ingame_stats.set(target_stats, Effect_strength)
			
	duration -= 1
	if duration <= 0:
		player_ingame_stats.set(target_stats, before_stats)
		get_parent().effect.erase(effect_name)
		for i in get_parent().get_parent().get_node("status_effect_viewer").get_children():
			if i.name == effect_name:
				i.queue_free()
				break

		queue_free()
