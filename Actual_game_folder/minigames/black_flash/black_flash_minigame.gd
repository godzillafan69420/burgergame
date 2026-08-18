extends Node2D
## black_flash_minigame.gd (v3 -- osu! style, mouse-driven)
##
## Circles appear on screen with a shrinking "approach ring." Click inside
## the circle right as the ring collapses onto it. Judged Perfect/Good/Miss
## by timing accuracy, same scoring shape as before.
##
## Fully self-contained: everything is drawn procedurally (no sprite sheet
## needed), no external autoload. Uses the same "click" input action your
## cards already use, so it matches your game's existing mouse controls.
##
## Interface (unchanged, so black_flash_card.gd needs no edits):
##   signal finished(accuracy: float)
##   func start() -> void

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

@export_group("Pacing")
# Scales every note's timing. 0.5 = notes arrive twice as fast (whole thing
# takes half as long). 2.0 = everything comes in at half speed. 1.0 = as
# authored/generated.
@export var chart_time_scale: float = 1.0
# Hard cutoff in seconds -- any note scheduled after this is simply dropped,
# so a long chart (e.g. a full song) can be capped to a short burst without
# re-authoring it. 0 = no cutoff, play the whole chart.
@export var max_duration: float = 15.0

@export_group("Song Sync")
# If > 0, the chart is auto-generated to match this song's tempo instead of
# using the hardcoded `chart` array above -- lets you drop in any song
# without hand-authoring timestamps, as long as you know its BPM (look it
# up -- I can't listen to the audio and detect it myself).
@export var song_bpm: float = 0.0
@export var beats_per_note: int = 2 # 1 = a note every beat (busy), 2 = every other beat, etc.
@export var first_beat_offset: float = 0.5 # seconds of intro silence before the first beat
@export var song_length_override: float = 0.0 # 0 = use the AudioStream's own reported length

@export_group("Difficulty")
# Divides approach_time by this value -- purely a reaction-window knob.
# 1.0 = approach_time as authored above. 2.0 = ring closes twice as fast
# (half the reaction time), which is what actually makes the minigame
# harder. Notes still land exactly on their scheduled time / the song's
# real beat -- this does NOT touch chart_time_scale, song timing, or
# audio pitch/speed at all.
@export var reaction_speed: float = 1.0

var _effective_approach_time: float = 1.0

@export_group("Note Density")
# Multiplies how many notes actually spawn by inserting extra notes evenly
# into the gaps between the existing chart's timestamps. 1 = unchanged.
# 2 = an extra note squeezed into the middle of every gap (roughly double).
# 3 = two extra notes per gap, etc. The original notes stay locked to their
# original times / the song's real beat -- only the in-between notes are new.
@export var note_density: int = 2

@export_group("Hold Notes")
# Chance (0-1) that any given spawned note becomes a hold note instead of a
# tap. Hold notes require you to press and hold inside the circle, then
# drag the mouse forward (up) or back (down) -- shown by an arrow on the
# note -- and keep holding until the ring finishes closing.
@export var hold_note_chance: float = 0.3
@export var hold_duration: float = 0.35 # seconds you must hold the drag for
@export var hold_drag_distance: float = 50.0 # px of drag required to count

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

	# Hold-note state. hold_dir: 1 = forward/up drag, -1 = back/down drag.
	var is_hold: bool = false
	var hold_dir: int = 1
	var holding: bool = false
	var hold_press_elapsed: float = 0.0
	var drag_start_pos: Vector2 = Vector2.ZERO
	var drag_ok: bool = false
	var slider_length: float = 90.0 # visual length of the hold's body/tail
	var hold_progress: float = 0.0 # 0 = just grabbed, 1 = ready to release

	func _draw() -> void:
		if is_hold:
			_draw_slider_body()
		else:
			draw_circle(Vector2.ZERO, radius, note_color)
			draw_arc(Vector2.ZERO, radius, 0.0, TAU, 40, Color(1, 1, 1, 0.9), 3.0)
		if progress < 1.2:
			var approach_radius = lerp(radius * approach_start_scale, radius, clamp(progress, 0.0, 1.0))
			var ring_color := Color(1, 1, 1, 0.85)
			if holding:
				ring_color = Color(1, 0.85, 0.3, 0.95) if drag_ok else Color(1, 0.4, 0.4, 0.9)
			draw_arc(Vector2.ZERO, approach_radius, 0.0, TAU, 48, ring_color, 3.0)

	func _draw_slider_body() -> void:
		# osu-style slider: an elongated body from the head (click here,
		# same radius as a normal tap circle) out to a smaller tail (drag
		# target), so hold notes read as a visibly different shape/size
		# from taps at a glance, not just a same-size circle with an arrow.
		var dir_y := -1.0 if hold_dir == 1 else 1.0
		var tail := Vector2(0, dir_y * slider_length)

		draw_line(Vector2.ZERO, tail, note_color.darkened(0.1), radius * 1.1, true)
		draw_circle(tail, radius * 0.7, note_color.lightened(0.15))
		draw_arc(tail, radius * 0.7, 0.0, TAU, 28, Color(1, 1, 1, 0.85), 2.5)

		draw_circle(Vector2.ZERO, radius, note_color)
		draw_arc(Vector2.ZERO, radius, 0.0, TAU, 40, Color(1, 1, 1, 0.9), 3.0)
		_draw_hold_arrow()

		if holding:
			# Ball slides from head to tail as the hold progresses, so the
			# player can see exactly when it's about to finish and release.
			var ball_pos: Vector2 = tail * hold_progress
			var ball_color := Color(1, 0.85, 0.3) if drag_ok else Color(1, 0.4, 0.4)
			# dim the portion of the track already covered
			draw_line(Vector2.ZERO, ball_pos, Color(1, 1, 1, 0.5), radius * 0.5, true)
			draw_circle(ball_pos, radius * 0.55, ball_color)
			draw_arc(ball_pos, radius * 0.55, 0.0, TAU, 24, Color.WHITE, 2.5)

	func _draw_hold_arrow() -> void:
		var s := radius * 0.55
		var points: PackedVector2Array
		if hold_dir == 1:
			points = PackedVector2Array([
				Vector2(-s * 0.5, s * 0.3), Vector2(0, -s * 0.5), Vector2(s * 0.5, s * 0.3),
			])
		else:
			points = PackedVector2Array([
				Vector2(-s * 0.5, -s * 0.3), Vector2(0, s * 0.5), Vector2(s * 0.5, -s * 0.3),
			])
		draw_polyline(points, Color.WHITE, 4.0, true)

	func set_progress(p: float) -> void:
		progress = p
		queue_redraw()

	func set_hold_progress(p: float) -> void:
		hold_progress = clamp(p, 0.0, 1.0)
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
	_hint_label.text = "Click circles as the ring closes! Hold + drag ▲/▼ for arrow notes."
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

	var music_player = get_node_or_null(music_player_path)

	var active_chart: Array = chart
	if song_bpm > 0.0 and music_player and music_player.stream:
		active_chart = _generate_chart_from_bpm(music_player.stream)

	# Inject extra notes into the gaps between the real chart notes (density),
	# and roll hold-note type/direction, before scaling/cutting the timeline.
	active_chart = _apply_note_density(active_chart)

	# Apply chart_time_scale (compress/stretch every note's timing) and
	# max_duration (drop anything past the cutoff) to get the actual
	# playable set of notes for this run.
	var scale: float = chart_time_scale if chart_time_scale > 0.0 else 1.0
	_pending = []
	for entry in active_chart:
		var scaled_time: float = entry[2] * scale
		if max_duration <= 0.0 or scaled_time <= max_duration:
			_pending.append([entry[0], entry[1], scaled_time, entry[3], entry[4]])

	_pending.sort_custom(func(a, b): return a[2] < b[2])
	_notes.clear()
	_score = 0
	_max_score = _pending.size() * PERFECT_SCORE
	_elapsed = 0.0

	# reaction_speed only affects how long the approach ring takes to close --
	# completely independent of chart/song timing above.
	var rspeed: float = reaction_speed if reaction_speed > 0.0 else 1.0
	_effective_approach_time = approach_time / rspeed

	_update_hud()

	if music_player:
		# Keep the music in sync with the compressed/stretched timeline.
		# Side effect: this also shifts pitch up/down, since Godot doesn't
		# have a built-in pitch-independent time-stretch. Fine for a quick
		# attack minigame, but worth knowing.
		music_player.pitch_scale = 1.0 / scale
		music_player.play()

	set_process(true)

func _generate_chart_from_bpm(stream: AudioStream) -> Array:
	var beat_duration := 60.0 / song_bpm
	var note_interval := beat_duration * float(beats_per_note)
	var length := song_length_override if song_length_override > 0.0 else stream.get_length()

	# Cycle through a handful of on-screen spots for a bit of visual variety
	# instead of every note landing in the same place.
	var positions := [
		Vector2(0.30, 0.35), Vector2(0.62, 0.30), Vector2(0.45, 0.55),
		Vector2(0.70, 0.50), Vector2(0.28, 0.60), Vector2(0.55, 0.40),
		Vector2(0.40, 0.28), Vector2(0.65, 0.62),
	]

	var generated: Array = []
	var t := first_beat_offset + note_interval
	var i := 0
	while t < length - end_padding:
		var p: Vector2 = positions[i % positions.size()]
		generated.append([p.x, p.y, t])
		t += note_interval
		i += 1
	return generated

func _apply_note_density(base_chart: Array) -> Array:
	# Normalize every entry to [x, y, time, type, dir] regardless of whether
	# it came from the hardcoded chart (3 elements) or already has a type.
	var normalized: Array = []
	for e in base_chart:
		var etype: String = e[3] if e.size() > 3 else "tap"
		var edir: int = e[4] if e.size() > 4 else 1
		normalized.append([e[0], e[1], e[2], etype, edir])
	normalized.sort_custom(func(a, b): return a[2] < b[2])

	if note_density <= 1 or normalized.size() < 2:
		return normalized

	var extra_per_gap: int = note_density - 1
	var result: Array = []
	for i in range(normalized.size()):
		result.append(normalized[i])
		if i >= normalized.size() - 1:
			continue
		var t0: float = normalized[i][2]
		var t1: float = normalized[i + 1][2]
		var gap: float = t1 - t0
		for k in range(1, extra_per_gap + 1):
			var frac: float = float(k) / float(extra_per_gap + 1)
			var t: float = t0 + gap * frac
			# Interpolate position between the two real notes, then nudge it
			# off the straight line a bit so it isn't perfectly on the path.
			var px: float = clamp(lerp(normalized[i][0], normalized[i + 1][0], frac) + randf_range(-0.08, 0.08), 0.12, 0.88)
			var py: float = clamp(lerp(normalized[i][1], normalized[i + 1][1], frac) + randf_range(-0.08, 0.08), 0.12, 0.88)
			var etype := "tap"
			var edir := 1
			if randf() < hold_note_chance:
				etype = "hold"
				edir = 1 if randf() < 0.5 else -1
			result.append([px, py, t, etype, edir])
	return result

func _process(delta: float) -> void:
	_elapsed += delta

	while _pending.size() > 0 and _pending[0][2] - _effective_approach_time <= _elapsed:
		var entry = _pending.pop_front()
		_spawn_note(entry[0], entry[1], entry[2], entry[3], entry[4])

	var mouse_pos := get_global_mouse_position()
	var button_held := Input.is_action_pressed("click")

	for note in _notes.duplicate():
		if note.judged:
			continue

		if note.is_hold and note.holding:
			# Actively being held: track the drag, and resolve automatically
			# once hold_duration has elapsed -- no precise release timing
			# needed, just "keep holding and dragging until it's done."
			if button_held:
				_update_hold_drag(note, mouse_pos)
				note.set_progress(1.0)
				var hold_frac: float = 1.0
				if hold_duration > 0.0:
					hold_frac = (_elapsed - note.hold_press_elapsed) / hold_duration
				note.set_hold_progress(hold_frac)
				if _elapsed - note.hold_press_elapsed >= hold_duration:
					if note.drag_ok:
						var diff = absf(note.hit_time - note.hold_press_elapsed)
						if diff <= perfect_window:
							_judge(note, "PERFECT", PERFECT_SCORE)
						else:
							_judge(note, "GOOD", GOOD_SCORE)
					else:
						_judge(note, "MISS", 0)
			else:
				# let go too early -- dropped the hold
				_judge(note, "MISS", 0)
			continue

		var t_left = note.hit_time - _elapsed
		var progress = 1.0 - (t_left / _effective_approach_time)
		note.set_progress(progress)
		if t_left < -good_window:
			_judge(note, "MISS", 0)

	if Input.is_action_just_pressed("click"):
		_try_press(mouse_pos)

	if _pending.is_empty() and _notes.is_empty():
		_finish()

func _spawn_note(x_frac: float, y_frac: float, hit_time: float, note_type: String = "tap", note_dir: int = 1) -> void:
	var vp := get_viewport().get_visible_rect().size
	var note := OsuNote.new()
	note.hit_time = hit_time
	note.radius = circle_radius
	note.approach_start_scale = approach_start_scale
	note.note_color = NOTE_COLORS[_notes.size() % NOTE_COLORS.size()]
	note.is_hold = (note_type == "hold")
	note.hold_dir = note_dir
	if note.is_hold:
		note.slider_length = clamp(hold_drag_distance * 1.5, 70.0, 240.0)
	note.position = Vector2(x_frac * vp.x, y_frac * vp.y)
	_notes_container.add_child(note)
	_notes.append(note)

func _update_hold_drag(note: OsuNote, mouse_pos: Vector2) -> void:
	if note.drag_ok:
		return
	var delta: Vector2 = mouse_pos - note.drag_start_pos
	if note.hold_dir == 1 and delta.y <= -hold_drag_distance:
		note.drag_ok = true
	elif note.hold_dir == -1 and delta.y >= hold_drag_distance:
		note.drag_ok = true

func _try_press(mouse_pos: Vector2) -> void:
	var best_note = null
	var best_diff := INF
	for note in _notes:
		if note.judged or note.holding:
			continue
		if note.global_position.distance_to(mouse_pos) > note.radius:
			continue
		var diff = absf(note.hit_time - _elapsed)
		# Taps need a precise click near hit_time (skill = timing). Hold
		# notes need to be grabbed and dragged for a stretch of real time,
		# so they get a much wider window to press down in -- anywhere from
		# the moment they appear up to the same miss cutoff taps use. The
		# actual timing/skill for a hold comes from keeping it held+dragged,
		# not from the instant you first press it.
		var window: float = good_window
		if note.is_hold:
			window = _effective_approach_time + good_window
		if diff > window:
			continue
		if diff < best_diff:
			best_diff = diff
			best_note = note

	if best_note == null:
		return

	if best_note.is_hold:
		best_note.holding = true
		best_note.hold_press_elapsed = _elapsed
		best_note.drag_start_pos = mouse_pos
		best_note.drag_ok = false
		best_note.set_hold_progress(0.0)
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
