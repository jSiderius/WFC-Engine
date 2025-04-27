extends Node

# TODO: This mess from hell should be nicely formatted in a json file

enum Dir {
	NORTH = 0,
	EAST  = 1,
	SOUTH = 2,
	WEST  = 3,
	ANY = 4,
}

## Tile Types
enum TileType{
	# TILE_ERROR = -1,

	TILE_WATER = 1,
	TILE_LAND = 2,
	TILE_SHORE = 3,
}

enum EdgeType {
	WATER,
	LAND,
	SHORE,

	# ERROR,
}

var edge_rules: Dictionary = build_edge_rules()

func build_edge_rules() -> Dictionary:

	var rules = {
		EdgeType.WATER : [EdgeType.WATER, EdgeType.SHORE],
		EdgeType.LAND : [EdgeType.LAND, EdgeType.SHORE],
		EdgeType.SHORE : [EdgeType.WATER, EdgeType.LAND, EdgeType.SHORE],
	}

	return rules

# [N, E, S, W]
const tile_edges : Dictionary = {
	# TileType.TILE_ERROR : [EdgeType.ERROR, EdgeType.ERROR, EdgeType.ERROR, EdgeType.ERROR],

	TileType.TILE_WATER : [EdgeType.WATER, EdgeType.WATER, EdgeType.WATER, EdgeType.WATER],
	TileType.TILE_LAND : [EdgeType.LAND, EdgeType.LAND, EdgeType.LAND, EdgeType.LAND],
	TileType.TILE_SHORE : [EdgeType.SHORE, EdgeType.SHORE, EdgeType.SHORE, EdgeType.SHORE],
}

const tile_weights : Dictionary = {
	TileType.TILE_WATER : 1.1,
	TileType.TILE_LAND : 1, 
	TileType.TILE_SHORE : 1,
}

const  tile_vector : Dictionary = {
	# TileType.TILE_ERROR : Vector2(22, 4),

	TileType.TILE_LAND : Vector2(0, 0),
	 TileType.TILE_WATER : Vector2(8, 11),
	 TileType.TILE_SHORE : Vector2(20, 1)
}

const  cell_to_tile_options : Dictionary = {

}

func get_opposite_direction(direction : int) -> int:
	match direction: 
		Dir.NORTH: return Dir.SOUTH
		Dir.SOUTH: return Dir.NORTH
		Dir.EAST: return Dir.WEST
		Dir.WEST: return Dir.EAST
		_: 
			print_debug("Bad value")
			return -1
