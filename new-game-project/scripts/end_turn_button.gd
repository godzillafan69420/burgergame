extends Button

@onready var card_in_hand: Control
var battle_logic_script: Node

func _ready() -> void:
	battle_logic_script = $"../../BattleLogic"
	card_in_hand = get_parent().get_node("cards")

func _on_button_down() -> void:

	Events.emit_signal("enemies_turn", battle_logic_script.enemy_id_turn )
		
