extends Node

var types_of_effect = ["lethal", "buff"]

@export var type = "lethal"
@export var damage: float
@export var target_stats: String = ""
@export var duration: int = 5
@export var Effect_strength: float = 1.2

var enemy_status_node :Node2D
var before_status: float

func _ready() -> void:
	enemy_status_node = get_parent().get_parent().get_node("enemy_stats")
	if type == types_of_effect[1]:
		before_status= enemy_status_node.get(target_stats)
		print(before_status)
	_take_effect()
	


func _take_effect():
	if type == types_of_effect[0] and duration  > 0:
		enemy_status_node.get_node("HP").value -= damage 
		enemy_status_node.get_node("Label").text = str(int(enemy_status_node.get_node("HP").value)) + "/" +str(int(enemy_status_node.get_node("HP").max_value))
	if type == types_of_effect[1] and duration > 0:
		enemy_status_node.set(target_stats, Effect_strength)
	duration -= 1
	if duration <= 0:
		enemy_status_node.set(target_stats, before_status)
		queue_free()
