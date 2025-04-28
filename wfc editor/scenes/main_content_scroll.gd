extends Control

# Adjustable grid settings
var grid_spacing_x = 50
var grid_spacing_y = 50
var grid_color = Color(0.8, 0.8, 0.8)  # Light grey grid lines
var background_color = Color(0.2, 0.2, 0.2)  # Dark background

func _ready():
	# Update the grid whenever you want to change spacing
	queue_redraw()

func _draw():
	# Draw custom background color
	# draw_rect(Rect2(Vector2(0, 0), rect_size), background_color)

	# Draw grid lines
	for x in range(0, size.x, grid_spacing_x):
		draw_line(Vector2(x, 0), Vector2(x, size.y), grid_color)
	for y in range(0, size.y, grid_spacing_y):
		draw_line(Vector2(0, y), Vector2(size.x, y), grid_color)

# Example function to change grid spacing dynamically
func set_grid_spacing(horizontal: int, vertical: int):
	grid_spacing_x = horizontal
	grid_spacing_y = vertical
	queue_redraw()
