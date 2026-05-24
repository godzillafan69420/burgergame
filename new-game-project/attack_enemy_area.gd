extends Area2D

@export var single: bool = false



func _on_mouse_entered() -> void:
	Events.emit_signal("in_attack_area")


func _on_mouse_exited() -> void:
	Events.emit_signal("out_attack_area")
