extends Control

# Adjustable grid settings
var grid_spacing_size : Vector2 = Vector2(16, 16)
var grid_spacing_offset : Vector2 = Vector2(0, 0)
var grid_spacing_gap : Vector2 = Vector2(0, 0)

var grid_color = Color(0.8, 0.8, 0.8)
var background_color = Color(0.2, 0.2, 0.2)

@onready var sprite = $Sprite

func _ready():
	# Update the grid whenever you want to change spacing
	queue_redraw()

func _draw():
	# Draw custom background color
	# draw_rect(Rect2(Vector2(0, 0), size), background_color)
	var i : int = 0
	var offset : float = 0.0
	for x in range(sprite.position.x + grid_spacing_offset.x - grid_spacing_size.x, size.x, grid_spacing_size.x):
		i+=1
		offset += 0.0 if i % 2 == 0 else grid_spacing_gap.x
		draw_line(Vector2(x + offset, 0), Vector2(x + offset, size.y), grid_color, -2)
	i = 0
	offset = 0
	for x in range(sprite.position.x + grid_spacing_offset.x, 0, -grid_spacing_size.x):
		offset += 0.0 if i % 2 == 0 else grid_spacing_gap.x
		draw_line(Vector2(x - offset, 0), Vector2(x - offset, size.y), grid_color)
		i+=1
	i = 0
	offset = 0
	for y in range(sprite.position.y + grid_spacing_offset.y - grid_spacing_size.y, size.y, grid_spacing_size.y):
		i+=1
		offset += 0.0 if i % 2 == 0 else grid_spacing_gap.y
		draw_line(Vector2(0, y + offset), Vector2(size.x, y + offset), grid_color)
	i = 0
	offset = 0
	for y in range(sprite.position.y + grid_spacing_offset.y, 0, -grid_spacing_size.y):
		offset += 0.0 if i % 2 == 0 else grid_spacing_gap.y
		draw_line(Vector2(0, y-offset), Vector2(size.x, y-offset), grid_color)
		i+=1

# Example function to change grid spacing dynamically
func set_grid_spacing(horizontal: int, vertical: int):
	grid_spacing_size.x = horizontal
	grid_spacing_size.y = vertical
	queue_redraw()
