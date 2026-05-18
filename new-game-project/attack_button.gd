extends Button

var can_attack = false

func _ready() -> void:
	Events.connect("players_turn", _fight)



func _fight():
	can_attack = true

func _on_button_down() -> void:
	if can_attack:
		Events.emit_signal("damaged_enemy", 20)
		can_attack = false
		Events.emit_signal("waiting_recharge")


		
