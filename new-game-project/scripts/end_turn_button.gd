extends Button

@onready var card_in_hand: Control

func _ready() -> void:
	card_in_hand = get_parent().get_node("cards")

func _on_button_down() -> void:

	Events.emit_signal("enemies_turn")
		
