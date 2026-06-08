extends Control

@onready var top_scroll: ScrollContainer = $TopScrollContainer
@onready var map_scroll: ScrollContainer = $MapScrollContainer

# Guard variable to prevent infinite loops
var _is_syncing: bool = false

func _ready() -> void:
	# Link the scroll positions directly 1-to-1
	top_scroll.get_h_scroll_bar().value_changed.connect(_on_top_bar_scrolled)
	map_scroll.get_h_scroll_bar().value_changed.connect(_on_map_scrolled)

func _on_top_bar_scrolled(value: float) -> void:
	if _is_syncing: return
	_is_syncing = true
	# Move the map the exact same number of pixels as the top bar
	map_scroll.scroll_horizontal = value
	_is_syncing = false

func _on_map_scrolled(value: float) -> void:
	if _is_syncing: return
	_is_syncing = true
	# Move the top bar the exact same number of pixels as the map
	top_scroll.scroll_horizontal = value
	_is_syncing = false
