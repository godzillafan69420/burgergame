extends TextureRect

class_name status_effect_icon

var text = ""
func _process(delta: float) -> void:
	if get_global_rect().has_point(get_global_mouse_position()):
		Events.emit_signal("show_status_text", text)
	else:
		Events.emit_signal("hide_status_text")
		
