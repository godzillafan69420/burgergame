extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var cut_in_ui = $CutIn

func play_transition(target_scene_path: String):
	
	cut_in_ui.mouse_filter = Control.MOUSE_FILTER_STOP
	
	cut_in_ui.visible = true
	cut_in_ui.modulate.a = 1.0
	
	# 3. Play the visual cut-in animation
	animation_player.play("Transition")
	

	await get_tree().create_timer(0.4).timeout
	
	get_tree().change_scene_to_file(target_scene_path)
	
	await animation_player.animation_finished
	
	cut_in_ui.visible = false
	cut_in_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
