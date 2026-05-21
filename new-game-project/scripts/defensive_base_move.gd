extends Node


func _ready() -> void:
	Events.connect("players_turn", _fight)
	Events.connect("no_more_energy", _stop_fighting)

func _stop_fighting():
	pass
	#can_attack =  false
	


func _fight():
	pass
	#can_attack = true

func _drop() -> void:
	#print("added effect")
	#Events.emit_signal("reduce_energy_by", energy)
	#if can_attack:
		pass
		#for effect in effects: 
			#Events.emit_signal("give_side_effects", effect)
