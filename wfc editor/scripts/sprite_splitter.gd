extends Panel

var dragging : bool = false
var resizing = false
var resize_margin = 10
var min_size = Vector2(100, 100)
var resize_start_mouse = Vector2.ZERO
var resize_start_size = Vector2.ZERO

@onready var scroll = $VBoxContainer/MainContentScroll
@onready var main_content = $VBoxContainer/MainContentScroll/MainContent

func _ready():
	scroll.get_v_scroll_bar().size = Vector2(0, 0)
	scroll.get_v_scroll_bar().custom_minimum_size.x = 0
	
	get_tree().create_timer(.01).timeout.connect(
		func () -> void:
			scroll.scroll_horizontal = (main_content.size.x - scroll.size.x) / 2.0
			scroll.scroll_vertical = (main_content.size.y - scroll.size.y) / 2.0
	)

	base_size = main_content.size


func _process(_delta):
	if resizing: 
		var new_size =  get_global_mouse_position() - position
		new_size.x = max(new_size.x, min_size.x)
		new_size.y = max(new_size.y, min_size.y)
		size = new_size

func _gui_input(event : InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if _is_in_resize_zone(event.position):
				resizing = true
			else:
				dragging = true
		else:
			dragging = false
			resizing = false

	if dragging and event is InputEventMouseMotion:
		global_position += event.relative
		# TODO: Not working?
		if _is_in_resize_zone(event.position):
			Input.set_default_cursor_shape(Input.CURSOR_DRAG)
		else:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)

			
func _is_in_resize_zone(mouse_pos):
	return (
		mouse_pos.x >= size.x - resize_margin
		and mouse_pos.y >= size.y - resize_margin
	)


func _on_zoom_out_button_pressed() -> void:
	zoom_factor = min(zoom_factor + 0.1, zoom_max)
	update_zoom()
	queue_redraw()

func _on_zoom_in_button_pressed() -> void:
	zoom_factor = max(zoom_factor - 0.1, zoom_min)
	update_zoom()

var base_size : Vector2
var zoom_factor : float = 1.0
var zoom_min : float = 0.5
var zoom_max : float = 3.0
func update_zoom():
	# Apply scale to the content node
	# TODO: Scaling
	main_content.scale = Vector2(zoom_factor, zoom_factor)

	scroll.scroll_horizontal = (main_content.size.x - scroll.size.x) / 2.0
	scroll.scroll_vertical = (main_content.size.y - scroll.size.y) / 2.0

func _on_offset_x_value_changed(value: float) -> void:
	main_content.grid_spacing_offset.x = value
	main_content.queue_redraw()
func _on_offset_y_value_changed(value: float) -> void:
	main_content.grid_spacing_offset.y = value
	main_content.queue_redraw()
func _on_size_x_value_changed(value: float) -> void:
	main_content.grid_spacing_size.x = value
	main_content.queue_redraw()

func _on_size_y_value_changed(value: float) -> void:
	main_content.grid_spacing_size.y = value
	main_content.queue_redraw()

func _on_gap_x_value_changed(value: float) -> void:
	main_content.grid_spacing_gap.x = value
	main_content.queue_redraw()

func _on_gap_y_value_changed(value: float) -> void:
	main_content.grid_spacing_gap.y = value
	main_content.queue_redraw()


func _on_close_button_pressed() -> void:
	print("end")
	get_parent().queue_free()
