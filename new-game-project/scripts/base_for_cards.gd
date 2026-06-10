extends TextureRect

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

@export var AOE: bool

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and !selected_card and mouse_is_incard:
		selected_card = true
	if event.is_action_released("click") and selected_card and mouse_is_incard:
		if in_attack_area and can_attack and (get_area_under_mouse() or get_area_under_mouse() == 0):
			_drop()
			Events.emit_signal("update_id")
		elif in_attack_area and can_attack and AOE:
			_drop()
			Events.emit_signal("update_id")
		elif get_area_under_mouse() == null and !AOE:
			selected_card = false
		else:
			selected_card = false
			

func _drop() -> void:
	
	
	if !can_attack:
		return
	Events.emit_signal("reduce_energy_by", energy)
	if AOE:
		Events.emit_signal("damaged_enemy", damage)
	else:
		Events.emit_signal("id_chosen",get_area_under_mouse(), damage)
	for effect in effects: 
		Events.emit_signal("give_side_effects", effect)
	

	queue_free()



func _process(delta: float) -> void:
	if position.x > 235 and position.x < 2000 and position.y > 44 and position.y < 400:
		in_attack_area = true
	else:
		in_attack_area = false
	if !selected_card:

		position = POSITION_OF_CARDS[card_id]
	else:
		position = get_global_mouse_position() + Vector2(-100,-100)
	
func get_area_under_mouse():
	var space_state = get_world_2d().direct_space_state
	var mouse_pos = get_global_mouse_position()
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = true   # Must be true to look for Area2Ds
	query.collide_with_bodies = false # Ignore normal physics bodies
	
	var results = space_state.intersect_point(query)
	if results.size() > 0:
		var area = results[0]["collider"] as Area2D 
		return area.get_parent().id# Returns the underlying Area2D
	return null
