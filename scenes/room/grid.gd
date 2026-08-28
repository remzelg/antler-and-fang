class_name Grid
extends Node

@onready var astar_grid = AStarGrid2D.new()
@onready var board_state: Dictionary = {}

func initialize(tiles: Array[Vector2i]):
	astar_grid.region = _get_rect_from_vector2i_array(tiles)
	# TODO: Set tiles within bounding rect that are empty space to solid
	astar_grid.set_diagonal_mode(AStarGrid2D.DIAGONAL_MODE_NEVER)
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.update()

# update board state. Has nothing to do with animation
# TODO: should use character ID instead of the node reference itself
func update(character, from_tile, to_tile):
	board_state.erase(from_tile)
	board_state[to_tile] = character
	astar_grid.set_point_solid(from_tile, false)
	astar_grid.set_point_solid(to_tile, true)
	astar_grid.update()

func get_distance_from(tile1, tile2):
	var path = get_tile_path_from(tile1, tile2)
	return path.size() - 1

func get_tile_path_from(tile1: Vector2i, tile2: Vector2i, get_closest_adjacent = false):
	# add extra weight to encourage facing forward and rightward
	#astar_grid.set_point_weight_scale(tile1 + Vector2i(0,-1),1.2)
	#astar_grid.set_point_weight_scale(tile1 + Vector2i(1,0),1.1)

	# AStarGrid2D.get_id_path() returns an empty path
	# whenever its start point is solid, so clear it temporarily.
	var origin_was_solid = astar_grid.is_point_solid(tile1)
	astar_grid.set_point_solid(tile1, false)
	astar_grid.update()
	
	var path
	if get_closest_adjacent:
		# assume tile you want to move towards is the last tile in path
		astar_grid.set_point_solid(tile2, false)
		astar_grid.update()
		path = astar_grid.get_id_path(tile1, tile2)
		path.remove_at(path.size()-1) # remove last tile in path
		astar_grid.set_point_solid(tile2, true)
		astar_grid.update()
	else:
		# find path to move adjacent to target
		path = astar_grid.get_id_path(tile1, tile2)

	# reset origin point to filled
	astar_grid.set_point_solid(tile1, origin_was_solid)
	astar_grid.update()

	return path

# helper function to create a rect2 around a group of vector2 points
func _get_rect_from_vector2i_array(array: Array[Vector2i]) -> Rect2i:
	if array.is_empty():
		return Rect2i()
		
	var rect = Rect2i(array[0], Vector2i.ZERO)
	for point in array:
		rect = rect.expand(point)
		
	return rect
