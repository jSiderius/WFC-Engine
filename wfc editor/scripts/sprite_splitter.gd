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
			scroll.set_deferred("scroll_vertical", scroll.get_v_scroll_bar().max_value / 2.0 - 165)
			scroll.set_deferred("scroll_horizontal", scroll.get_h_scroll_bar().max_value / 2.0 - 400)
	)


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
	main_content.scale += Vector2(1.0, 1.0)
	queue_redraw()

func _on_zoom_in_button_pressed() -> void:
	main_content.scale -= Vector2(0.5, 0.5)
	queue_redraw()
