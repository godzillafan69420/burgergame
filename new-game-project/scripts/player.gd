extends Node2D




var passives = [1,2,3,4,54,56,"ninja","yes sir","cool","1000","t3"]
var img = preload("res://Art/burgerpatty.png")
const gap_size: float = 25
const offset: float = 30
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	passives = PlayerStats.upgrades
	for i in passives:
		var toppings = Sprite2D.new()
		toppings.position.y = i  * -gap_size - offset
		toppings.texture = img
		$toppings_group.add_child(toppings)




	
