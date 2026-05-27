extends Panel

class_name cards

var card_id: int = 0


var can_attack = false

var selected_card: bool = false
var mouse_is_incard: bool = false

var in_attack_area: bool = false

var card_number: int =0
const POSITION_OF_CARDS:Array = [
	Vector2(100,500),
	Vector2(250,500),
	Vector2(400,500),
	Vector2(550,500),
	Vector2(700,500)]

@export var damage: float = 2
@export var energy: float = 10

@export var effects: Array[String]
func _ready() -> void:
	var new_id = 0
	for i in range(get_parent().get_child_count()):
		if get_parent().get_children()[i-1].card_id != card_id:
			card_id = new_id
		else:
			new_id +=1
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and !selected_card and mouse_is_incard:
		selected_card = true
	if event.is_action_released("click") and selected_card and mouse_is_incard:
		if in_attack_area and can_attack:
			
			_drop()
			
		else:
			selected_card = false

func _drop() -> void:
	Events.emit_signal("reduce_energy_by", energy)
	if !can_attack:
		return
	Events.emit_signal("damaged_enemy", damage)
	for effect in effects: 
		Events.emit_signal("give_side_effects", effect)
	queue_free()



func _process(delta: float) -> void:
	if get_parent().get_child_count() < 5:
		var new_id = 0
		for i in range(get_parent().get_child_count()):
			if get_parent().get_children()[i-1].card_id != card_id:
				card_id = new_id
			else:
				new_id +=1
	if position.x > 235 and position.x < 1000 and position.y > 44 and position.y < 400:
		print("in area")
		in_attack_area = true
	else:
		in_attack_area = false
	if !selected_card:

		position = POSITION_OF_CARDS[card_id]
	else:
		position = get_global_mouse_position() + Vector2(-100,-100)
	
	
