extends Node2D




var passives = []
var lettuce = preload("res://Art/lectuce.png")
var beef_patty = preload("res://Art/burgerpatty.png")
const gap_size: float = 25
const offset: float = 30
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	passives = PlayerStats.upgrades
	for i in range(passives.size()):
		var toppings = Sprite2D.new()
		toppings.position.y = i  * -gap_size - offset
		toppings.texture = get(passives[i]["id"])
		$toppings_group.add_child(toppings)




	
