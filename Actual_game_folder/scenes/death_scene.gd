extends Node2D


func _ready() -> void:
	AudioManager.play("death")


func _on_texture_button_button_down() -> void:
	get_tree().change_scene_to_file("res://battle_scene.tscn")
