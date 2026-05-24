extends Panel

class_name cards

var card_id: int = 0

var not_in_position: bool = false

var can_attack = false

var selected_card: bool = false
var mouse_is_incard: bool = false

var in_attack_area: bool = false

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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and !selected_card and mouse_is_incard:
		selected_card = true
		not_in_position = true
	if event.is_action_released("click") and selected_card and mouse_is_incard:
		if !in_attack_area:
			selected_card = false
		
			
		

func _drop() -> void:
	Events.emit_signal("reduce_energy_by", energy)
	if can_attack:
		Events.emit_signal("damaged_enemy", damage)

func _process(delta: float) -> void:
	if in_attack_area and selected_card:
			_drop()
			queue_free()
			
	if !selected_card:

		position = POSITION_OF_CARDS[card_id]
		not_in_position = false
	else:
		position = get_global_mouse_position() + Vector2(-100,-100)
	
	
