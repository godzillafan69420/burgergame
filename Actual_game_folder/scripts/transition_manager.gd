extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cut_in: Control = $CutIn

func _ready() -> void:
	# Keep transition hidden when game launches
	cut_in.visible = false

func play_transition(target_scene_path: String) -> void:
	# 1. Show the transition canvas
	cut_in.visible = true
	
	# 2. Play the animation
	animation_player.play("Transition")
	
	# 3. Wait for the slash/cut-in animation to finish completely
	await animation_player.animation_finished
	
	# 4. Change the active scene
	get_tree().change_scene_to_file(target_scene_path)
	
	# 5. Hide the transition UI so mouse clicks pass through freely
	cut_in.visible = false
