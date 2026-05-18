extends Button

var can_attack = false

func _ready() -> void:
	Events.connect("waiting_recharge", _begin_speed_regen)



func _begin_speed_regen():
	can_attack = true

func _on_button_down() -> void:
	Events.emit_signal("damaged_enemy", 20)

func _process(delta: float) -> void:
	
