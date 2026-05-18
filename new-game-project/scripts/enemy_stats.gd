extends Node2D


var HP: float
var speed:float
@export var battle_logic_script: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HP = get_parent().setted_HP
	$HP.max_value = HP
	$HP.value = HP
	Events.connect("damaged_enemy", _take_damage)

	
	
func _take_damage(damage: int) -> void:
	$HP.value -= damage



func _process(delta: float) -> void:
	if battle_logic_script.current_state == battle_logic_script.States.waiting:
		$SPD.value += get_parent().setted_speed * delta
	if $SPD.value == 100:
		Events.emit_signal("enemies_turn")
		$SPD.value = 0

		
