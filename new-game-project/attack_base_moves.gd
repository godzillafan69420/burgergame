extends cards


var can_attack = false
@export var card_name: String = "aksknfk"
func _ready() -> void:
	Events.connect("players_turn", _fight)
	Events.connect("no_more_energy", _stop_fighting)
	$card_extensions/name.text = card_name

func _stop_fighting():
	can_attack =  false
	

	

func _fight():
	can_attack = true

func _drop() -> void:
	Events.emit_signal("reduce_energy_by", energy)
	if can_attack:
		Events.emit_signal("damaged_enemy", damage)


func _on_area_2d_mouse_entered() -> void:
	print("aosnfonaofn")
	mouse_is_incard = true


func _on_area_2d_mouse_exited() -> void:
	print("kallum is a bum")
	mouse_is_incard=false
