extends Control

class_name TileManager

var font : Font = preload("res://font/Money Plans.otf")

var tile_splicer : TileSplicer
var tile_grid : Array[Array]
var constraining_grid : Array[Array]
var height : int
var width : int
var complete : bool = false
var square_size : float
var pq : PriorityQueue

enum ConstrainingIDs {
	DEFAULT = -1
}

func _init(_height : int, _width : int, _square_size : float, _constraining_grid : Array[Array] = []) -> void:
	
	height = _height
	width = _width
	square_size = _square_size
	constraining_grid = _constraining_grid
	tile_splicer = TileSplicer.new(Image.load_from_file("res://tileset.png"), 16, 16, Vector2(square_size, square_size))
	
	if constraining_grid == []: init_default_constraining_grid()
	
	generate_tile_grid()
	constrain_tile_grid()
	init_priority_queue()

func generate_tile_grid() -> void:
	'''
		Purpose:
			Setup a tile grid according to the data in the Grid argument

		Arguments:
			id_grid:
				Grid containing data for the tiles

		Return: void
	'''

	# Iterate the grid and create a tile for each cell
	for y in range(height): 
		tile_grid.append([])
		for x in range(width):
			tile_grid[y].append(Tile.new(constraining_grid[y][x]))

func constrain_tile_grid() -> void:
	for y in range(height): for x in range(width): 
		var tile : Tile = tile_grid[y][x]
		var tile_possibilities = tile.get_possibilities()
		
		# Initialize NESW Neighbors
		if y > 0:
			tile.add_neighbor(wfcConfig.Dir.NORTH, tile_grid[y-1][x])
			tile_grid[y-1][x].constrain(tile_possibilities, wfcConfig.Dir.NORTH)
			tile.constrain(tile_grid[y-1][x].possibilities, wfcConfig.Dir.SOUTH)
		if y < height-1:
			tile.add_neighbor(wfcConfig.Dir.SOUTH, tile_grid[y+1][x])
			tile_grid[y+1][x].constrain(tile_possibilities, wfcConfig.Dir.SOUTH)
			tile.constrain(tile_grid[y+1][x].possibilities, wfcConfig.Dir.NORTH)
		if x > 0:
			tile.add_neighbor(wfcConfig.Dir.WEST, tile_grid[y][x-1])
			tile_grid[y][x-1].constrain(tile_possibilities, wfcConfig.Dir.WEST)
			tile.constrain(tile_grid[y][x-1].possibilities, wfcConfig.Dir.EAST)
		if x < width - 1:
			tile.add_neighbor(wfcConfig.Dir.EAST, tile_grid[y][x+1])
			tile_grid[y][x+1].constrain(tile_possibilities, wfcConfig.Dir.EAST)
			tile.constrain(tile_grid[y][x+1].possibilities, wfcConfig.Dir.WEST)

func init_priority_queue() -> void:
	pq = PriorityQueue.new()

	for y in range(height): for x in range(width):
		pq.insert(tile_grid[y][x], float(get_entropy(y, x)))

func init_default_constraining_grid() -> void: 
	constraining_grid = []

	for y in range(height): 
		constraining_grid.append([])
		for x in range(width):
			constraining_grid[y].append(ConstrainingIDs.DEFAULT)


func get_entropy(y : int, x : int) -> int:
	''' Returns the entropy of the tile at (y, x)'''

	return tile_grid[y][x].get_entropy()

func get_type(y : int, x : int) -> int:
	''' Return the tile type of the tile at position y, x '''

	if len(tile_grid[y][x].get_possibilities()) == 0:
		print_debug("Tile type requested for tile with no possibilities")
		push_warning("Tile type requested for tile with no possibilities")
		return wfcConfig.TILE_ERROR

	return tile_grid[y][x].get_possibilities()[0]

func get_lowest_entropy_tile_pq():
	return pq.pop_min()

func wave_function_collapse_pq(spectate : bool = true) -> void:
	''' Execute the wave function collapse algorithm '''

	# Run iterations of the algorithm until complete
	var is_complete : bool = false
	while not is_complete: 
		is_complete = wave_function_collapse_iteration_pq()
		if spectate: queue_redraw()
	
	for y in range(height): for x in range(width):
		# if get_type(y, x) == wfcConfig.TileType.TILE_ERROR: tile_grid[y][x].removal_failure()
		pass

	queue_redraw()
	
	complete = true
	
func wave_function_collapse_iteration_pq() -> bool:
	'''
		Purpose: 
			Completes a single iteration of the wave function collapse algorithm
		Return:
			bool: indicates if the algorithm is complete
	'''

	# Return if all cells are collapsed
	if pq.is_empty(): return true

	# Select the lowest entropy tile
	var  tile_to_collapse : Tile = get_lowest_entropy_tile_pq()
	tile_to_collapse.collapse()

	# Constrain all tiles effected by the collapse
	var stack : Array = [tile_to_collapse]
	while(len(stack) > 0):
		var tile : Tile = stack.pop_back()
		
		# Iterate the tiles neighbors
		for direction in tile.get_directions():

			# Setup the neighbor
			var neighbor : Tile = tile.get_neighbor(direction)
			if neighbor.get_entropy() == 0: continue
			
			# Constrain the neighbor according to the tile, if it reduces add it to the stack and update the pq
			if neighbor.constrain(tile.get_possibilities(), direction): 
				pq.insert_or_update(neighbor, len(neighbor.possibilities))
				stack.append(neighbor)
	
	return false

func _draw() -> void:

	for y in height: for x in width:
		
		var t : Tile = tile_grid[y][x]
		
		if t.entropy == 0 or t.entropy == 1:
			var callback : Dictionary = tile_splicer.get_drawing_data(wfcConfig.tile_vector[t.get_tile_type()], Vector2i(y, x))
			draw_texture_rect_region( tile_splicer.tileset_texture, callback["rect"], callback["src_rect"] )
			
			if t.overlay:
				callback = tile_splicer.get_drawing_data(wfcConfig.overlay_vector[t.overlay], Vector2i(y, x))
				draw_texture_rect_region( tile_splicer.tileset_texture, callback["rect"], callback["src_rect"] )
			continue
		
		var rect : Rect2 = Rect2(Vector2(x*square_size, y*square_size), Vector2(square_size, square_size)) #Takes pos = (y,x) and coverts to godot's coords (x, y)
		draw_rect(rect, Color(0, 0, 0, 1.0))

		# Calculate text size and position for centering
		var text = str(t.entropy)
		var text_pos = (Vector2(x * square_size + square_size / 2.0, y * square_size + square_size / 2.0))
		
		# Draw the text
		draw_string(font, text_pos, text)
