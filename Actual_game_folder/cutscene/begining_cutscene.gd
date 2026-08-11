extends Node2D

@export_multiline var pannel_1 ="" 
@export_multiline var pannel_2 ="" 
@export_multiline var pannel_3 ="" 

@export_multiline var pannel_4 ="" 
@export_multiline var pannel_5 ="" 

const image1 = preload("res://Art/cutscene/once a time.png")
const image2 = preload("res://Art/cutscene/what the hell.png")
const image3 = preload("res://Art/cutscene/lore 3.png")
const image4 = preload("res://Art/cutscene/lore 4.png")
const image5 = preload("res://Art/cutscene/lore5.png")

func _ready() -> void:
	$TextureRect.texture = image1
	$Panel/Label.text = pannel_1
	
	var dialogue_tween = create_tween()
	dialogue_tween.tween_property($Panel/Label, "visible_characters",pannel_1.length(), 30)
	dialogue_tween.play()

func _change_stuff(dialogue, image):
	pass
