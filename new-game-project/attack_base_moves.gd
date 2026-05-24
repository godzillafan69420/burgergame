extends cards



@export var card_name: String = "aksknfk"
func _ready() -> void:
	Events.connect("players_turn", _fight)
	Events.connect("no_more_energy", _stop_fighting)
	Events.connect("in_attack_area", _in_area_of_attack)
	Events.connect("out_attack_area", _out_attack_area)
	$card_extensions/name.text = card_name

func _stop_fighting():
	can_attack =  false
	
func _in_area_of_attack():
	in_attack_area = true

func _out_attack_area():
	in_attack_area = false
	

func _fight():
	can_attack = true





func _on_mouse_entered() -> void:
	print("aosnfonaofn")
	mouse_is_incard = true

func _on_mouse_exited() -> void:
	print("jacob is a bum")
	mouse_is_incard=false
