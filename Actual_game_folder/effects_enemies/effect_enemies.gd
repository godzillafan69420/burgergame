extends Node

var types_of_effect = ["lethal", "buff"]

@export var effect_name:String
@export var type = "lethal"
@export var damage: float
@export var target_stats: String = ""
@export var duration: int = 5
@export var Effect_strength: float = 1.2
@export var stackable: bool = false


var enemy_status_node :Node2D
var before_status: float

func _ready() -> void:
	if effect_name in get_parent().effect and !stackable:
		queue_free()
		return
	var status_effect_icon = TextureRect.new()
	status_effect_icon.name = effect_name
	status_effect_icon.texture = StatusIcon.get(effect_name)
	get_parent().get_parent().get_node("status_effect_viewer").add_child(status_effect_icon)
	get_parent().effect.append(effect_name)
	enemy_status_node = get_parent().get_parent().get_node("enemy_stats")
	if type == types_of_effect[1]:
		before_status= enemy_status_node.get(target_stats)
		print(before_status)
	_take_effect()
	


func _take_effect():
	if type == types_of_effect[0] and duration  > 0:
		enemy_status_node.get_node("HP").value -= damage 
		enemy_status_node.get_node("Label").text = str(int(enemy_status_node.get_node("HP").value)) + "/" +str(int(enemy_status_node.get_node("HP").max_value))
		if enemy_status_node.get_node("HP").value <= 0:
			get_parent().get_parent().queue_free()
			Events.emit_signal("check_victory_conditions")
	if type == types_of_effect[1] and duration > 0:
		enemy_status_node.set(target_stats, Effect_strength)
	duration -= 1
	if duration <= 0:
		enemy_status_node.set(target_stats, before_status)
		get_parent().effect.erase(effect_name)
		for i in get_parent().get_parent().get_node("status_effect_viewer").get_children():
			if i.name == effect_name:
				i.queue_free()
				break
		queue_free()
