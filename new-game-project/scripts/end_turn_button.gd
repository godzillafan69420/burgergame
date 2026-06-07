extends Button

var enemy_id_turn: int = 0
@onready var card_in_hand: Control
var battle_logic_script: Node
var enemy_list: Node2D
var total_enemies: int

func _ready() -> void:
	battle_logic_script = $"../../BattleLogic"
	card_in_hand = get_parent().get_node("cards")
	enemy_list = $"../../enemies"
	total_enemies = enemy_list.get_child_count()


func _on_button_down() -> void:
	total_enemies = enemy_list.get_child_count()
	if enemy_id_turn < total_enemies:
		enemy_id_turn +=1
	else:
		enemy_id_turn = 1
	Events.emit_signal("enemies_turn", enemy_id_turn)

	
