class_name Grid extends Node

@onready var astar_grid = AStarGrid2D.new()

func initialize(rect: Rect2i):
	# setup astar grid 2D
	astar_grid.region = rect
	# TODO: Set tiles within bounding rect that are empty space to solid
	astar_grid.set_diagonal_mode(AStarGrid2D.DIAGONAL_MODE_NEVER)
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.update()

# update board state. Has nothing to do with animation
func fill(tile):
	astar_grid.set_point_solid(tile, true)

func clear(tile):
	astar_grid.set_point_solid(tile, false)

func get_distance_from(tile1, tile2):
	var path = get_tile_path_from(tile1, tile2)
	return path.size() - 1

func get_tile_path_from(tile1: Vector2i, tile2: Vector2i, to_closest_adjacent = false):
	# add extra weight to encourage facing forward and rightward
	#astar_grid.set_point_weight_scale(tile1 + Vector2i(0,-1),1.2)
	#astar_grid.set_point_weight_scale(tile1 + Vector2i(1,0),1.1)

	# AStarGrid2D.get_id_path() returns an empty path
	# whenever its start point or end point are solid, so clear them temporarily
	# when calculating paths for characters.
	var origin_was_filled = astar_grid.is_point_solid(tile1)
	
	if origin_was_filled:
		astar_grid.set_point_solid(tile1, false)
	
	var path
	if to_closest_adjacent:
		var was_filled = astar_grid.is_point_solid(tile2)
		if was_filled:
			astar_grid.set_point_solid(tile2, false)
		path = astar_grid.get_id_path(tile1, tile2)
		path.remove_at(path.size()-1) # remove last tile in path
		# reset to previous state
		if was_filled:
			astar_grid.set_point_solid(tile2, true)
	else:
		# find path to move adjacent to target
		path = astar_grid.get_id_path(tile1, tile2)
	
	if origin_was_filled:
		astar_grid.set_point_solid(tile1, true)
	
	return path
