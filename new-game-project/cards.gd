extends cards



@export var card_name: String = "aksknfk"
@export_multiline var discription: String  = "aksknfk"
func _ready() -> void:
	Events.connect("players_turn", _fight)
	Events.connect("no_more_energy", _stop_fighting)

	$name.text = card_name
	$discription.text = discription

func _stop_fighting():
	can_attack =  false
	

	

func _fight():
	can_attack = true




func _on_mouse_entered() -> void:
	print("aosnfonaofn")
	mouse_is_incard = true

func _on_mouse_exited() -> void:
	print("jacob is a bum")
	mouse_is_incard=false
