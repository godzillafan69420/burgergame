extends Node2D

var HP: float
var speed:float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HP = get_parent().setted_HP
	$HP.max_value = HP
	
