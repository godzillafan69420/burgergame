extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var cut_in_ui = $CutIn

func play_transition(target_scene_path: String):
	# 1. Prevent overlapping inputs while transitioning
	# (Stops players from spamming buttons mid-slash)
	cut_in_ui.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# 2. Reset visibility/opacity properties before playing
	cut_in_ui.visible = true
	cut_in_ui.modulate.a = 1.0
	
	# 3. Play the visual cut-in animation
	animation_player.play("persona_slash")
	
	# 4. Wait for the exact moment the character slashes and covers the screen.
	# If your animation is 1.0s long, waiting 0.4s ensures the scene change 
	# happens seamlessly right behind the character graphic!
	await get_tree().create_timer(0.4).timeout
	
	# 5. Change the background scene safely
	get_tree().change_scene_to_file(target_scene_path)
	
	# 6. Wait for the remaining fade-out animation tracks to completely finish
	await animation_player.animation_finished
	
	# 7. Clean up and hide the layer until next time
	cut_in_ui.visible = false
	cut_in_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
