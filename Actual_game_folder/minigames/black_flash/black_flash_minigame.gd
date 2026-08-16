extends Node2D
## black_flash_minigame.gd (v2 -- rebuilt from scratch)
##
## Fully self-contained FNF-style rhythm minigame. No "Signals" autoload,
## no separate FallingKey/KeyListener/ScorePressText scenes -- everything
## (lane layout, falling notes, hit judging, scoring, popups) lives in this
## one script. Only external dependency is the arrows.webp spritesheet.
##
## Layout is computed from the ACTUAL viewport size at start() time, not
## hardcoded pixel positions -- so there's nothing to manually re-position
## to match a threshold buried in another file.
##
## Judging is time-based (how close your press is to the note's scheduled
## hit time), not pixel-distance-based -- this is the standard approach and
## sidesteps an entire category of "note position doesn't match hitbox"
## bugs, since speed/position are always mathematically consistent.
##
## Interface (unchanged from before, so black_flash_card.gd needs no edits):
##   signal finished(accuracy: float)
##   func start() -> void

signal finished(accuracy: float)

# Each entry: [lane_index (0-3), time_in_seconds_the_note_should_be_hit].
# Keep this SHORT -- a few seconds, not a full song.
@export var chart: Array = [
	[0, 0.6], [1, 1.0], [2, 1.4], [3, 1.8],
	[0, 2.4], [1, 2.4], [2, 2.8], [3, 2.8],
	[0, 3.5], [1, 3.9], [2, 4.3], [3, 4.7],
]

@export var arrows_texture: Texture2D
@export var note_speed: float = 700.0 # pixels/second, delta-scaled
@export var perfect_window: float = 0.07 # seconds
@export var good_window: float = 0.14 # seconds
@export var end_padding: float = 1.0
@export var music_player_path: NodePath = ^"MusicPlayer"

# Turn on ONLY for standalone testing (Run Current Scene). Leave off for
# real play -- black_flash_card.gd calls start() itself.
@export var autostart_for_testing: bool = false

const LANE_COUNT = 4
const LANE_KEYS = ["button_Q", "button_W", "button_O", "button_P"]
const LANE_FRAMES = [0, 1, 2, 3] # left, down, up, right in arrows.webp row 0
const SPAWN_Y = -80.0
const PERFECT_SCORE = 300
const GOOD_SCORE = 150

class NoteData:
	var sprite: Sprite2D
	var lane: int
	var hit_time: float
	var judged: bool = false

var _lane_x: Array = []
var _hit_y: float = 0.0
var _pending: Array = [] # chart entries not yet spawned
var _notes: Array = [] # NoteData currently on screen
var _lane_targets: Array = []
var _notes_container: Node2D

var _score: int = 0
var _max_score: int = 0
var _started: bool = false
var _elapsed: float = 0.0

func _ready() -> void:
	if not arrows_texture:
		arrows_texture = load("res://minigames/black_flash/art/arrows.webp")
	_notes_container = Node2D.new()
	add_child(_notes_container)
	set_process(false)
	if autostart_for_testing:
		start()

func start() -> void:
	if _started:
		return
	_started = true

	_compute_layout()
	_spawn_lane_targets()

	_pending = chart.duplicate(true)
	_pending.sort_custom(func(a, b): return a[1] < b[1])
	_notes.clear()
	_score = 0
	_max_score = chart.size() * PERFECT_SCORE
	_elapsed = 0.0

	var music_player = get_node_or_null(music_player_path)
	if music_player:
		music_player.play()

	set_process(true)

func _compute_layout() -> void:
	var vp := get_viewport().get_visible_rect().size
	_hit_y = vp.y * 0.78
	var spacing := 110.0
	var start_x := vp.x * 0.5 - spacing * 1.5
	_lane_x.clear()
	for i in range(LANE_COUNT):
		_lane_x.append(start_x + i * spacing)

func _make_arrow_sprite(lane: int) -> Sprite2D:
	var s := Sprite2D.new()
	s.texture = arrows_texture
	s.hframes = 4
	s.vframes = 3
	s.frame = LANE_FRAMES[lane]
	return s

func _spawn_lane_targets() -> void:
	for t in _lane_targets:
		if is_instance_valid(t):
			t.queue_free()
	_lane_targets.clear()
	for lane in range(LANE_COUNT):
		var s = _make_arrow_sprite(lane)
		s.modulate = Color(1, 1, 1, 0.45)
		s.position = Vector2(_lane_x[lane], _hit_y)
		add_child(s)
		_lane_targets.append(s)

func _travel_time() -> float:
	return (_hit_y - SPAWN_Y) / note_speed

func _process(delta: float) -> void:
	_elapsed += delta
	var travel = _travel_time()

	# Spawn any notes whose flight should have begun by now, so they arrive
	# at the hit line exactly on their scheduled hit_time.
	while _pending.size() > 0 and _pending[0][1] - travel <= _elapsed:
		var entry = _pending.pop_front()
		_spawn_note(entry[0], entry[1])

	# Move notes + auto-miss anything that's fallen well past the hit line.
	for note in _notes.duplicate():
		if note.judged:
			continue
		var t_left = note.hit_time - _elapsed
		var frac = clamp(1.0 - (t_left / travel), 0.0, 1.3)
		note.sprite.position.y = lerp(SPAWN_Y, _hit_y, frac)
		if t_left < -good_window:
			_judge(note, "MISS", 0)

	for lane in range(LANE_COUNT):
		if Input.is_action_just_pressed(LANE_KEYS[lane]):
			_try_hit(lane)

	if _pending.is_empty() and _notes.is_empty():
		_finish()

func _spawn_note(lane: int, hit_time: float) -> void:
	var s = _make_arrow_sprite(lane)
	s.position = Vector2(_lane_x[lane], SPAWN_Y)
	_notes_container.add_child(s)
	var note := NoteData.new()
	note.sprite = s
	note.lane = lane
	note.hit_time = hit_time
	_notes.append(note)

func _try_hit(lane: int) -> void:
	var best_note = null
	var best_diff := INF
	for note in _notes:
		if note.judged or note.lane != lane:
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

func _judge(note: NoteData, label: String, points: int) -> void:
	note.judged = true
	_score += points
	if is_instance_valid(note.sprite):
		note.sprite.queue_free()
	_notes.erase(note)
	_show_popup(label, _lane_x[note.lane])

func _show_popup(text: String, x: float) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 22)
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 6)
	label.position = Vector2(x - 30, _hit_y - 60)
	add_child(label)

	var tw := create_tween()
	tw.tween_property(label, "position:y", label.position.y - 30, 0.4)
	tw.parallel().tween_property(label, "modulate:a", 0.0, 0.4)
	tw.tween_callback(label.queue_free)

func _finish() -> void:
	set_process(false)
	_started = false
	for t in _lane_targets:
		if is_instance_valid(t):
			t.queue_free()
	_lane_targets.clear()

	var accuracy := 0.0
	if _max_score > 0:
		accuracy = float(_score) / float(_max_score)
	finished.emit(clamp(accuracy, 0.0, 1.0))
