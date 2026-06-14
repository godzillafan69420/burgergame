extends Node



@export var at_when:int = 0 #in turns if it isn't obvious
@export var dialogues: Array[DialogueEntry] = []
@onready var BattleLogic_script = $"../BattleLogic"

func _process(delta: float) -> void:
	if BattleLogic_script.current_turn == at_when:
		Events.emit_signal("dialogue", dialogues)
		queue_free()
		print("gone")
