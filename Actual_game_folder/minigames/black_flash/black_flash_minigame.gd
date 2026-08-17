extends Node2D

signal finished(accuracy: float)
@export var chart: Array = [
	[0.30, 0.35, 1.184],
	[0.62, 0.30, 2.009],
	[0.45, 0.55, 2.821],
	[0.70, 0.50, 3.680],
	[0.28, 0.60, 4.493],
	[0.55, 0.40, 5.329],
	[0.40, 0.28, 6.165],
	[0.65, 0.62, 6.954],
	[0.30, 0.35, 7.779],
	[0.62, 0.30, 8.615],
	[0.45, 0.55, 9.416],
	[0.70, 0.50, 10.228],
	[0.28, 0.60, 11.053],
	[0.55, 0.40, 11.889],
	[0.40, 0.28, 12.690],
	[0.65, 0.62, 13.514],
	[0.30, 0.35, 14.327],
	[0.62, 0.30, 15.163],
	[0.45, 0.55, 15.975],
	[0.70, 0.50, 16.800],
	[0.28, 0.60, 17.612],
	[0.55, 0.40, 18.425],
	[0.40, 0.28, 19.261],
	[0.65, 0.62, 20.085],
	[0.30, 0.35, 20.910],
	[0.62, 0.30, 21.722],
	[0.45, 0.55, 22.547],
	[0.70, 0.50, 23.371],
	[0.28, 0.60, 24.195],
	[0.55, 0.40, 25.020],
	[0.40, 0.28, 25.844],
	[0.65, 0.62, 26.668],
	[0.30, 0.35, 27.492],
	[0.62, 0.30, 28.305],
	[0.45, 0.55, 29.129],
	[0.70, 0.50, 29.954],
	[0.28, 0.60, 30.766],
	[0.55, 0.40, 31.591],
	[0.40, 0.28, 32.415],
	[0.65, 0.62, 33.239],
	[0.30, 0.35, 34.052],
	[0.62, 0.30, 34.888],
	[0.45, 0.55, 35.701],
	[0.70, 0.50, 36.525],
	[0.28, 0.60, 37.338],
	[0.55, 0.40, 38.174],
	[0.40, 0.28, 38.998],
	[0.65, 0.62, 39.811],
	[0.30, 0.35, 40.635],
	[0.62, 0.30, 41.459],
	[0.45, 0.55, 42.272],
	[0.70, 0.50, 43.096],
	[0.28, 0.60, 43.921],
	[0.55, 0.40, 44.745],
	[0.40, 0.28, 45.569],
	[0.65, 0.62, 46.393],
	[0.30, 0.35, 47.206],
	[0.62, 0.30, 48.030],
	[0.45, 0.55, 48.855],
	[0.70, 0.50, 49.679],
	[0.28, 0.60, 50.492],
	[0.55, 0.40, 51.316],
	[0.40, 0.28, 52.140],
	[0.65, 0.62, 52.941],
	[0.30, 0.35, 53.777],
	[0.62, 0.30, 54.602],
	[0.45, 0.55, 55.414],
	[0.70, 0.50, 56.192],
	[0.28, 0.60, 57.063],
	[0.55, 0.40, 57.899],
	[0.40, 0.28, 58.712],
	[0.65, 0.62, 59.548],
	[0.30, 0.35, 60.349],
	[0.62, 0.30, 61.185],
	[0.45, 0.55, 61.997],
	[0.70, 0.50, 62.822],
	[0.28, 0.60, 63.646],
	[0.55, 0.40, 64.470],
	[0.40, 0.28, 65.295],
	[0.65, 0.62, 66.142],
	[0.30, 0.35, 66.943],
	[0.62, 0.30, 67.756],
	[0.45, 0.55, 68.580],
	[0.70, 0.50, 69.428],
	[0.28, 0.60, 70.217],
	[0.55, 0.40, 71.041],
	[0.40, 0.28, 71.866],
	[0.65, 0.62, 72.690],
	[0.30, 0.35, 73.514],
	[0.62, 0.30, 74.327],
	[0.45, 0.55, 75.151],
	[0.70, 0.50, 75.976],
	[0.28, 0.60, 76.800],
	[0.55, 0.40, 77.613],
	[0.40, 0.28, 78.437],
	[0.65, 0.62, 79.261],
	[0.30, 0.35, 80.086],
	[0.62, 0.30, 80.910],
	[0.45, 0.55, 81.723],
	[0.70, 0.50, 82.547],
	[0.28, 0.60, 83.371],
	[0.55, 0.40, 84.196],
	[0.40, 0.28, 85.020],
	[0.65, 0.62, 85.844],
	[0.30, 0.35, 86.657],
	[0.62, 0.30, 87.481],
	[0.45, 0.55, 88.305],
	[0.70, 0.50, 89.130],
	[0.28, 0.60, 89.954],
	[0.55, 0.40, 90.767],
	[0.40, 0.28, 91.591],
	[0.65, 0.62, 92.415],
	[0.30, 0.35, 93.228],
	[0.62, 0.30, 94.064],
	[0.45, 0.55, 94.877],
	[0.70, 0.50, 95.701],
	[0.28, 0.60, 96.525],
	[0.55, 0.40, 97.350],
	[0.40, 0.28, 98.174],
	[0.65, 0.62, 98.987],
	[0.30, 0.35, 99.811],
	[0.62, 0.30, 100.635],
	[0.45, 0.55, 101.460],
	[0.70, 0.50, 102.272],
	[0.28, 0.60, 103.097],
	[0.55, 0.40, 103.921],
	[0.40, 0.28, 104.745],
	[0.65, 0.62, 105.558],
	[0.30, 0.35, 106.394],
	[0.62, 0.30, 107.207],
	[0.45, 0.55, 108.031],
	[0.70, 0.50, 108.855],
	[0.28, 0.60, 109.668],
	[0.55, 0.40, 110.492],
	[0.40, 0.28, 111.316],
	[0.65, 0.62, 112.141],
	[0.30, 0.35, 112.965],
	[0.62, 0.30, 113.778],
	[0.45, 0.55, 114.602],
	[0.70, 0.50, 115.415],
	[0.28, 0.60, 116.251],
	[0.55, 0.40, 117.075],
	[0.40, 0.28, 117.888],
	[0.65, 0.62, 118.712],
	[0.30, 0.35, 119.536],
	[0.62, 0.30, 120.361],
	[0.45, 0.55, 121.185],
	[0.70, 0.50, 122.009],
	[0.28, 0.60, 122.822],
	[0.55, 0.40, 123.646],
	[0.40, 0.28, 124.471],
	[0.65, 0.62, 125.295],
	[0.30, 0.35, 126.108],
	[0.62, 0.30, 126.932],
	[0.45, 0.55, 127.756],
	[0.70, 0.50, 128.580],
	[0.28, 0.60, 129.405],
	[0.55, 0.40, 130.218],
	[0.40, 0.28, 131.042],
	[0.65, 0.62, 131.866],
	[0.30, 0.35, 132.690],
	[0.62, 0.30, 133.515],
	[0.45, 0.55, 134.327],
	[0.70, 0.50, 135.152],
	[0.28, 0.60, 135.976],
	[0.55, 0.40, 136.800],
	[0.40, 0.28, 137.625],
	[0.65, 0.62, 138.449],
	[0.30, 0.35, 139.262],
	[0.62, 0.30, 140.086],
	[0.45, 0.55, 140.910],
	[0.70, 0.50, 141.735],
	[0.28, 0.60, 142.559],
	[0.55, 0.40, 143.372],
	[0.40, 0.28, 144.196],
	[0.65, 0.62, 145.020],
	[0.30, 0.35, 145.845],
	[0.62, 0.30, 146.669],
	[0.45, 0.55, 147.482],
	[0.70, 0.50, 148.306],
	[0.28, 0.60, 149.130],
	[0.55, 0.40, 149.954],
	[0.40, 0.28, 150.767],
	[0.65, 0.62, 151.591],
	[0.30, 0.35, 152.416],
	[0.62, 0.30, 153.240],
	[0.45, 0.55, 154.064],
	[0.70, 0.50, 154.877],
	[0.28, 0.60, 155.701],
	[0.55, 0.40, 156.526],
	[0.40, 0.28, 157.350],
]

@export var circle_radius: float = 48.0
@export var approach_time: float = 1.0 # seconds from ring appearing to landing
@export var approach_start_scale: float = 2.4
@export var perfect_window: float = 0.08 # seconds
@export var good_window: float = 0.18 # seconds
@export var end_padding: float = 1.0
@export var music_player_path: NodePath = ^"MusicPlayer"

# Shown in the on-screen threshold readout. Should match whatever
# black_flash_card.gd uses for its own bonus-damage cutoff (currently 0.9).
@export var critical_accuracy_threshold: float = 0.9

# Turn on ONLY for standalone testing (Run Current Scene). Leave off for
# real play -- black_flash_card.gd calls start() itself.
@export var autostart_for_testing: bool = false

const PERFECT_SCORE = 300
const GOOD_SCORE = 150
const NOTE_COLORS = [
	Color(0.28, 0.75, 1.0), Color(1.0, 0.55, 0.75), Color(0.55, 1.0, 0.55),
	Color(1.0, 0.85, 0.35), Color(0.75, 0.55, 1.0),
]

class OsuNote extends Node2D:
	var hit_time: float
	var judged: bool = false
	var radius: float = 48.0
	var approach_start_scale: float = 2.4
	var progress: float = 0.0 # 0 = just appeared, 1 = exactly on hit_time
	var note_color: Color = Color.WHITE

	func _draw() -> void:
		draw_circle(Vector2.ZERO, radius, note_color)
		draw_arc(Vector2.ZERO, radius, 0.0, TAU, 40, Color(1, 1, 1, 0.9), 3.0)
		if progress < 1.2:
			var approach_radius = lerp(radius * approach_start_scale, radius, clamp(progress, 0.0, 1.0))
			draw_arc(Vector2.ZERO, approach_radius, 0.0, TAU, 48, Color(1, 1, 1, 0.85), 3.0)

	func set_progress(p: float) -> void:
		progress = p
		queue_redraw()

var _pending: Array = [] # chart entries not yet spawned
var _notes: Array = [] # OsuNote currently on screen
var _notes_container: Node2D

var _score: int = 0
var _max_score: int = 0
var _started: bool = false
var _elapsed: float = 0.0

var _score_label: Label
var _threshold_label: Label
var _hint_label: Label

func _ready() -> void:
	_notes_container = Node2D.new()
	add_child(_notes_container)
	_build_hud()
	set_process(false)
	if autostart_for_testing:
		start()

func _build_hud() -> void:
	_score_label = Label.new()
	_score_label.add_theme_font_size_override("font_size", 28)
	_score_label.add_theme_color_override("font_color", Color.WHITE)
	_score_label.add_theme_color_override("font_outline_color", Color.BLACK)
	_score_label.add_theme_constant_override("outline_size", 5)
	_score_label.position = Vector2(24, 20)
	add_child(_score_label)

	_threshold_label = Label.new()
	_threshold_label.add_theme_font_size_override("font_size", 18)
	_threshold_label.add_theme_color_override("font_color", Color(1, 0.9, 0.6))
	_threshold_label.add_theme_color_override("font_outline_color", Color.BLACK)
	_threshold_label.add_theme_constant_override("outline_size", 4)
	_threshold_label.position = Vector2(24, 58)
	add_child(_threshold_label)

	_hint_label = Label.new()
	_hint_label.text = "Click the circles right as the ring closes in!"
	_hint_label.add_theme_font_size_override("font_size", 16)
	_hint_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.75))
	_hint_label.add_theme_color_override("font_outline_color", Color.BLACK)
	_hint_label.add_theme_constant_override("outline_size", 4)
	add_child(_hint_label)

	_update_hud()

func _update_hud() -> void:
	_score_label.text = "Score: %d" % _score
	var live_accuracy := 0.0
	if _max_score > 0:
		live_accuracy = float(_score) / float(_max_score)
	var pct := int(round(live_accuracy * 100.0))
	var crit_pct := int(round(critical_accuracy_threshold * 100.0))
	_threshold_label.text = "Accuracy: %d%%  (need %d%% for CRITICAL damage)" % [pct, crit_pct]

func start() -> void:
	if _started:
		return
	_started = true

	var vp := get_viewport().get_visible_rect().size
	_hint_label.position = Vector2(vp.x * 0.5 - 220, vp.y - 50)

	_pending = chart.duplicate(true)
	_pending.sort_custom(func(a, b): return a[2] < b[2])
	_notes.clear()
	_score = 0
	_max_score = chart.size() * PERFECT_SCORE
	_elapsed = 0.0
	_update_hud()

	var music_player = get_node_or_null(music_player_path)
	if music_player:
		music_player.play()

	set_process(true)

func _process(delta: float) -> void:
	_elapsed += delta

	while _pending.size() > 0 and _pending[0][2] - approach_time <= _elapsed:
		var entry = _pending.pop_front()
		_spawn_note(entry[0], entry[1], entry[2])

	for note in _notes.duplicate():
		if note.judged:
			continue
		var t_left = note.hit_time - _elapsed
		var progress = 1.0 - (t_left / approach_time)
		note.set_progress(progress)
		if t_left < -good_window:
			_judge(note, "MISS", 0)

	if Input.is_action_just_pressed("click"):
		_try_click(get_global_mouse_position())

	if _pending.is_empty() and _notes.is_empty():
		_finish()

func _spawn_note(x_frac: float, y_frac: float, hit_time: float) -> void:
	var vp := get_viewport().get_visible_rect().size
	var note := OsuNote.new()
	note.hit_time = hit_time
	note.radius = circle_radius
	note.approach_start_scale = approach_start_scale
	note.note_color = NOTE_COLORS[_notes.size() % NOTE_COLORS.size()]
	note.position = Vector2(x_frac * vp.x, y_frac * vp.y)
	_notes_container.add_child(note)
	_notes.append(note)

func _try_click(mouse_pos: Vector2) -> void:
	var best_note = null
	var best_diff := INF
	for note in _notes:
		if note.judged:
			continue
		if note.global_position.distance_to(mouse_pos) > note.radius:
			continue
		var diff = absf(note.hit_time - _elapsed)
		if diff < best_diff:
			best_diff = diff
			best_note = note

	if best_note == null or best_diff > good_window:
		return

	if best_diff <= perfect_window:
		_judge(best_note, "PERFECT", PERFECT_SCORE)
	else:
		_judge(best_note, "GOOD", GOOD_SCORE)

func _judge(note: OsuNote, label_text: String, points: int) -> void:
	note.judged = true
	_score += points
	_update_hud()
	_show_popup(label_text, note.position, points > 0)
	_burst_and_free(note, points > 0)
	_notes.erase(note)

func _burst_and_free(note: OsuNote, was_hit: bool) -> void:
	var tw := create_tween()
	if was_hit:
		tw.tween_property(note, "scale", Vector2(1.4, 1.4), 0.15)\
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tw.parallel().tween_property(note, "modulate:a", 0.0, 0.18)
	else:
		tw.tween_property(note, "modulate:a", 0.0, 0.12)
	tw.tween_callback(note.queue_free)

func _show_popup(text: String, pos: Vector2, was_hit: bool) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 22)
	label.add_theme_color_override("font_color", Color.WHITE if was_hit else Color(1, 0.4, 0.4))
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 5)
	label.position = pos + Vector2(-30, -circle_radius - 30)
	add_child(label)

	var tw := create_tween()
	tw.tween_property(label, "position:y", label.position.y - 30, 0.4)
	tw.parallel().tween_property(label, "modulate:a", 0.0, 0.4)
	tw.tween_callback(label.queue_free)

func _finish() -> void:
	set_process(false)
	_started = false
	var accuracy := 0.0
	if _max_score > 0:
		accuracy = float(_score) / float(_max_score)
	finished.emit(clamp(accuracy, 0.0, 1.0))
