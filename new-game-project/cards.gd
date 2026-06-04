extends cards


@export var card_name: String = "aksknfk"
@export_multiline var discription: String  = "aksknfk"
func _ready() -> void:
	can_attack = true
	Events.connect("no_more_energy", _stop_fighting)
	Events.connect("players_turn", _can_attack)
	$name.text = card_name
	$discription.text = discription

func _stop_fighting():
	can_attack =  false
	
func _can_attack():
	can_attack =  true
	




func _on_mouse_entered() -> void:

	mouse_is_incard = true

func _on_mouse_exited() -> void:

	mouse_is_incard=false
