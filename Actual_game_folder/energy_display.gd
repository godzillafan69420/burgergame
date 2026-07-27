extends Label

var total_energy: float
var total_regeneration: float

func _ready() -> void:
	total_energy = PlayerStats.player_energy
	$"../energyBar".max_value = 50
	$"../energyBar".value = total_energy
	total_regeneration = PlayerStats.player_recovery
	text = str(total_energy)
	Events.connect("reduce_energy_by", _reduced_energy)
	Events.connect("players_turn", _regenerate_energy)
	
func _regenerate_energy():
	total_energy += total_regeneration + get_parent().get_parent().get_node("player").get_node("player_stats").stamina_regeneration
	$"../energyBar".value = total_energy
	if total_energy >= 50:
		total_energy = 50
	
	text = str(total_energy)
func _reduced_energy(cost: float):
	if cost<= total_energy:
		total_energy -= cost
	$"../energyBar".value = total_energy

	Events.emit_signal("total_energy", total_energy)
	text = str(total_energy)
	
