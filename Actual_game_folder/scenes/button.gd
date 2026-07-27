extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play("MainMenu")
	AudioManager.changeVolume()



func _on_button_pressed() -> void:
	TransitionManager.play_transition("res://scenes/battle_scene.tscn")
