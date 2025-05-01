extends Control

# Adjustable grid settings
var grid_spacing_size : Vector2 = Vector2(16, 16)
var grid_spacing_offset : Vector2 = Vector2(0, 0)
var grid_spacing_gap : Vector2 = Vector2(0, 0)

var grid_color = Color(0.8, 0.8, 0.8)
var background_color = Color(0.2, 0.2, 0.2)

@onready var sprite = $Sprite

func _ready():
	queue_redraw()

func _draw():
	# Draw custom background color
	var i : int = 0
	var _position : float = sprite.position.x + grid_spacing_offset.x
	for x in range(_position, size.x, 1):
		if _position > size.x: break

		if i % 2 == 0:
			var rect : Rect2 = Rect2(Vector2(_position, 0), Vector2(grid_spacing_size.x, size.y))
			draw_rect(rect, grid_color, false)
			_position += grid_spacing_size.x
		else:
			var rect : Rect2 = Rect2(Vector2(_position, 0), Vector2(grid_spacing_gap.x, size.y))
			draw_rect(rect, Color(grid_color, 0.3), true)
			_position += grid_spacing_gap.x
		i+=1
		
	i = 0
	_position = sprite.position.x + grid_spacing_offset.x
	for x in range(_position, 0, -1):
		if _position < 0: break

		if i % 2 == 1:
			var rect : Rect2 = Rect2(Vector2(_position, 0), Vector2(-grid_spacing_size.x, size.y))
			draw_rect(rect, grid_color, false)
			_position -= grid_spacing_size.x
		else:
			var rect : Rect2 = Rect2(Vector2(_position, 0), Vector2(-grid_spacing_gap.x, size.y))
			draw_rect(rect, Color(grid_color, 0.3), true)
			_position -= grid_spacing_gap.x
		i+=1

	i = 0
	_position = sprite.position.y + grid_spacing_offset.y
	for y in range(_position, size.y, 1):
		if _position > size.y: break

		if i % 2 == 0:
			var rect : Rect2 = Rect2(Vector2(0, _position), Vector2(size.x, grid_spacing_size.y))
			draw_rect(rect, grid_color, false)
			_position += grid_spacing_size.y
		else:
			var rect : Rect2 = Rect2(Vector2(0, _position), Vector2(size.x, grid_spacing_gap.y))
			draw_rect(rect, Color(grid_color, 0.3), true)
			_position += grid_spacing_gap.y
		i+=1
		
	i = 0
	_position = sprite.position.y + grid_spacing_offset.y
	for y in range(_position, 0, -1):
		if _position < 0: break

		if i % 2 == 1:
			var rect : Rect2 = Rect2(Vector2(0, _position), Vector2(size.x, -grid_spacing_size.y))
			draw_rect(rect, grid_color, false)
			_position -= grid_spacing_size.y
		else:
			var rect : Rect2 = Rect2(Vector2(0, _position), Vector2(size.x, -grid_spacing_gap.y))
			draw_rect(rect, Color(grid_color, 0.3), true)
			_position -= grid_spacing_gap.y
		i+=1

# Example function to change grid spacing dynamically
func set_grid_spacing(horizontal: int, vertical: int):
	grid_spacing_size.x = horizontal
	grid_spacing_size.y = vertical
	queue_redraw()
