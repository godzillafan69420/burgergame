extends Control

@onready var top_scroll: ScrollContainer = $TopScrollContainer
@onready var map_scroll: ScrollContainer = $MapScrollContainer

# A guard variable to prevent infinite loops (Top moves Map -> Map moves Top -> etc.)
var _is_syncing: bool = false

func _ready() -> void:
	# Access the built-in scrollbars and listen to their value changes
	top_scroll.get_h_scroll_bar().value_changed.connect(_on_top_bar_scrolled)
	map_scroll.get_h_scroll_bar().value_changed.connect(_on_map_scrolled)

func _on_top_bar_scrolled(value: float) -> void:
	if _is_syncing: return
	_is_syncing = true
	
	# Calculate how far the top bar is scrolled as a percentage (0.0 to 1.0)
	var max_top_scroll = top_scroll.get_h_scroll_bar().max_value - top_scroll.size.x
	if max_top_scroll > 0:
		var scroll_percentage = value / max_top_scroll
		
		# Apply that same percentage to the map container
		var max_map_scroll = map_scroll.get_h_scroll_bar().max_value - map_scroll.size.x
		map_scroll.scroll_horizontal = scroll_percentage * max_map_scroll
		
	_is_syncing = false

func _on_map_scrolled(value: float) -> void:
	if _is_syncing: return
	_is_syncing = true
	
	# Calculate how far the map is scrolled as a percentage (0.0 to 1.0)
	var max_map_scroll = map_scroll.get_h_scroll_bar().max_value - map_scroll.size.x
	if max_map_scroll > 0:
		var scroll_percentage = value / max_map_scroll
		
		# Apply that same percentage to the top bar container
		var max_top_scroll = top_scroll.get_h_scroll_bar().max_value - top_scroll.size.x
		top_scroll.scroll_horizontal = scroll_percentage * max_top_scroll
		
	_is_syncing = false
