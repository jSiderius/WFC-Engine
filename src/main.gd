extends Control

# export variables
@export var debug : bool = true
@export var square_size : float = 15.0

# global variables
# var grid_loader : Resource = preload("res://code/Grid/grid.gd")
var tile_manager : TileManager

func _ready() -> void:

	# Seed randomness
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	# Adjust screen size
	var screen_size : Vector2 = get_viewport_rect().size
	var w_h : Vector2i = find_width_and_height(screen_size, square_size)
	screen_size = update_screen_size(w_h.x, w_h.y, square_size) 

	# Begin algorithms 
	if debug: await redraw_and_pause(0, 0.0, false)

	# Fill the initial grid
	tile_manager = TileManager.new(w_h.x, w_h.y, square_size)
	add_child(tile_manager)

	test_outsidespace_wfc()

func test_outsidespace_wfc():
	tile_manager.wave_function_collapse_pq()
	
func find_width_and_height(screen_size : Vector2, square_size : float) -> Vector2i: 
	''' Takes the screen size and square size and determines the integer size of the screen in terms of squares '''

	var width : int =  ceil(screen_size.x / square_size)
	var height : int = ceil(screen_size.y / square_size)

	return Vector2i(width, height)


func update_screen_size(width : int, height : int, square_size : float) -> Vector2: 
	''' Takes the current screensize and the square size and updates the size of the screen to land exactly on a square, returns the resulting size '''

	var screen_size : Vector2 = Vector2(width*square_size, height*square_size)
	DisplayServer.window_set_size(screen_size)

	return screen_size

var last_exit_time : float = 0.0 
# Takes the algorithm number (int) and the amount of time to stall (float)
# Prints the amount of time the algorithm took, and stall for visual analysis 
func redraw_and_pause(alg : int, stall : float = 1.0, screenshot = true, debug = true) -> void:
	'''
		Purpose: 
			Redraw the screen and generate debugging information such as the time since the last call and creating a screenshot of the new state of the program
			TODO: Improve the modularity of algorithms

		Arguments: 
			alg: 
				The current algorithm number
			stall: 
				The amount of time to pause the entire program
			screenshot: 
				Boolean indicating if a screenshot should be taken
			debug:
				Boolean indicating if the function should print out

		Return: void
	'''

	if debug: print("Algorithm ", alg, " complete in ", (Time.get_ticks_msec() / 1000.0) - last_exit_time, " seconds")
	queue_redraw()
	await get_tree().create_timer(stall).timeout
	if screenshot: take_screenshot()
	print("\t exit redraw_and_pause()")
	last_exit_time = Time.get_ticks_msec() / 1000.0

''' Permanent data for take_screenshot() ''' 
var start_time : String = Time.get_datetime_string_from_system()
var path = "/Users/joshsiderius/Desktop/GodotSS/%s" % [start_time]
var first_screenshot = true 

func take_screenshot():
	''' Takes a screenshot of the game window and saves to file ''' 

	if first_screenshot: 
		first_screenshot = false
		DirAccess.make_dir_recursive_absolute(path)
		
	# Get the root viewport
	var root_viewport = get_viewport()
	# Capture the viewport as an image
	var screenshot = root_viewport.get_texture().get_image()
	
	# Save the screenshot to a file
	var file_path = "/Users/joshsiderius/Desktop/GodotSS/%s/%d.png" % [start_time, Time.get_ticks_usec()]
	var _error = screenshot.save_png(file_path)
	
func _draw() -> void:
	if tile_manager: tile_manager.queue_redraw()
