extends Node2D

var passives = [1,2,3,4,54,56]
var img = preload("res://icon.svg")
const gap_size: float = 25
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in passives:
		var toppings = Sprite2D.new()
		toppings.position =i* Vector2.UP * gap_size
		toppings.texture = img
		$toppings_group.add_child(toppings)
