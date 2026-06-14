extends Label

var total_energy: float
var total_regeneration: float

func _ready() -> void:
	total_energy = PlayerStats.player_energy
	total_regeneration = PlayerStats.player_recovery
	text = str(total_energy)
	Events.connect("reduce_energy_by", _reduced_energy)
	Events.connect("players_turn", _regenerate_energy)
	
func _regenerate_energy():
	total_energy += total_regeneration
	text = str(total_energy)
func _reduced_energy(cost: float):
	if cost<= total_energy:
		total_energy -= cost
	else:
		Events.emit_signal("no_more_energy")
	text = str(total_energy)
