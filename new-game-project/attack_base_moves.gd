extends cards

func _ready() -> void:
	Events.connect("players_turn", _fight)
	Events.connect("no_more_energy", _stop_fighting)

func _stop_fighting():
	can_attack =  false
	


func _fight():
	can_attack = true

func _drop() -> void:
	Events.emit_signal("reduce_energy_by", energy)
	if can_attack:
		Events.emit_signal("damaged_enemy", damage)
