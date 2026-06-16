extends Control

var count: int = 0

var current_dialogue: Array

var doing_dialogue: bool = false
func _ready() -> void:
	Events.connect("dialogue", _set_up)
	

func _set_up(dialgoue:Array):
	current_dialogue = dialgoue
	doing_dialogue = true
	_say_stuff()
	
func _process(delta: float) -> void:
	if !doing_dialogue:
		return
	
	if Input.is_action_just_pressed("click"):
		count += 1
		if count > current_dialogue.size()-1:
			visible = false
			count = 0
			Events.emit_signal("players_turn")
			doing_dialogue = false
		else:
			_say_stuff()
		
	
func _say_stuff():
	if count > current_dialogue.size()-1:
		return
	visible = true
	$Name.text = current_dialogue[count].character_name
	$Panel/paragraph.text = current_dialogue[count].paragraphs
	$protraits.texture = current_dialogue[count].portrait

		
	
			
			
			
			

	
			
		
	
	
