extends Panel

class_name cards

var selected_card: bool = false
var mouse_is_incard: bool = false

var card_number: int =0
const POSITION_OF_CARDS:Array = [
	Vector2(180,500),
	Vector2(240,500),
	Vector2(300,500),
	Vector2(360,500),
	Vector2(420,500)]

@export var damage: float = 2
@export var energy: float = 10

@export var effects: Array[String]


	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click") and !selected_card and mouse_is_incard:
		selected_card = true
	if Input.is_action_just_pressed("click") and selected_card and mouse_is_incard:
		selected_card = false
	if selected_card:
		position = get_global_mouse_position() + Vector2(-100,-100)
	
