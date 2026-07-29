extends CanvasLayer

@onready var cut_in: Control = $CutIn
@onready var background: TextureRect = $CutIn/Background
@onready var flash: ColorRect = $CutIn/Flash
@onready var black_fade: ColorRect = _get_or_create_black_fade()

# Where the shard art starts/ends off-screen. -1300/1300 matched your
# original art offset -- tweak if it doesn't fully clear your resolution.
@export var offscreen_offset: float = 1300.0

# BlackFade needs adding to the .tscn by hand (drag a ColorRect under CutIn,
# full-rect anchors, color black, alpha 0). Until you do, this builds one at
# runtime so the transition still works either way.
func _get_or_create_black_fade() -> ColorRect:
	var existing = get_node_or_null("CutIn/BlackFade")
	if existing:
		return existing

	var rect := ColorRect.new()
	rect.name = "BlackFade"
	rect.color = Color(0, 0, 0, 0)
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$CutIn.add_child(rect)
	return rect

func _ready() -> void:
	# Keep transition hidden when game launches
	cut_in.visible = false
	flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	black_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	flash.modulate.a = 0.0
	black_fade.modulate.a = 0.0

func play_transition(target_scene_path: String) -> void:
	cut_in.visible = true

	# 1. SLAM IN -- fast hit with a tiny overshoot pop. Ends fully covering
	#    the screen.
	await _slam_in()

	# 2. Crossfade the shard art to solid black -- this is what actually
	#    hides the scene swap, so it reads as a clean beat instead of a hitch.
	await _fade_to_black()

	# 3. Swap scenes while the screen is solid black.
	get_tree().change_scene_to_file(target_scene_path)
	await get_tree().process_frame  # give the new scene a frame to enter the tree

	# 4. Fade smoothly from black into the new scene.
	await _fade_from_black()

	cut_in.visible = false

func _slam_in() -> void:
	background.position = Vector2(-offscreen_offset, 0)
	background.scale = Vector2(1.5, 1.5)
	background.rotation_degrees = 0.0
	cut_in.modulate = Color(1, 1, 1, 1)
	flash.modulate.a = 0.0
	black_fade.modulate.a = 0.0

	# The slam: one quick, decisive hit -- no lingering easing.
	var tw := create_tween()
	tw.set_parallel(true)
	tw.tween_property(background, "position", Vector2(15, 0), 0.08)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tw.tween_property(background, "scale", Vector2(0.97, 0.97), 0.08)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tw.tween_callback(_impact_flash).set_delay(0.06)
	await tw.finished

	# Tiny snap-back to rest -- this is the "pop," kept short so it doesn't drag.
	var settle := create_tween()
	settle.set_parallel(true)
	settle.tween_property(background, "position", Vector2.ZERO, 0.045)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	settle.tween_property(background, "scale", Vector2.ONE, 0.045)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await settle.finished

func _fade_to_black() -> void:
	var tw := create_tween()
	tw.tween_property(black_fade, "modulate:a", 1.0, 0.09)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tw.finished
	# Small hold on solid black so the swap below never peeks through.
	await get_tree().create_timer(0.04).timeout

func _fade_from_black() -> void:
	var tw := create_tween()
	tw.tween_property(black_fade, "modulate:a", 0.0, 0.22)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tw.finished

func _impact_flash() -> void:
	flash.modulate.a = 1.0
	var tw := create_tween()
	tw.tween_property(flash, "modulate:a", 0.0, 0.12).set_trans(Tween.TRANS_SINE)
