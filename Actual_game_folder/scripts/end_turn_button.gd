extends Button

var enemy_id_turn: int
@onready var card_in_hand: Control
var battle_logic_script: Node
var enemy_list: Node2D
var total_enemies: int

func _ready() -> void:
	battle_logic_script = $"../../BattleLogic"
	card_in_hand = get_parent().get_node("cards")
	enemy_list = $"../../enemies"
	total_enemies = enemy_list.get_child_count() -1
	enemy_id_turn = total_enemies

func _on_button_down() -> void:
	var children = enemy_list.get_children()
	
	for index in range(children.size()):
		children[index].id = index
	total_enemies = enemy_list.get_child_count() -1
	enemy_id_turn +=1
	if enemy_id_turn > total_enemies:
		enemy_id_turn = 0
		
	
	Events.emit_signal("enemies_turn", enemy_id_turn)

	
