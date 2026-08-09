class_name Map
extends TileMapLayer

# in charge of all things graph related
# in charge of drawing background
# Knows the location of every pixel on the screen
# Knows how to fetch the location of a specific ID/Character
# Knows how to path between two spaces
# Does NOT know anything about the game logic

var board_state: Dictionary = {}

func _ready():
	var tiles = get_used_cells()
	for tile in tiles:
		# TODO: check tile for player or enemy then update board state
		board_state[tile] = "blank"
	print("tiles present:")
	print(tiles)

#region Drawer
func highlight_tile(tile, color = Color.YELLOW):
	var coords = get_global_coords_from_tile(tile)
	$Drawer.highlighted_tiles[coords] = Color.YELLOW
	$Drawer.queue_redraw()

func fill_tile(tile, color = Color.YELLOW):
	var coords = get_global_coords_from_tile(tile)
	$Drawer.colored_tiles[coords] = Color.YELLOW
	$Drawer.queue_redraw()

func clear_all_tiles():
	$Drawer.highlighted_tiles = {}
	$Drawer.colored_tiles = {}
	$Drawer.queue_redraw()
#endregion

#region Grid
# This is for keeping track of board state
var astar_grid

# update board state. Has nothing to do with animation
func move(character, origin_tile, destination_tile):
	board_state.erase(origin_tile)
	board_state[destination_tile] = character
	astar_grid.set_point_solid(origin_tile, false)
	astar_grid.set_point_solid(destination_tile, true)

# Initialize astar grid for pathfinding
func _initialize_astar_grid():
	astar_grid = AStarGrid2D.new()
	astar_grid.region = get_used_cells()
	astar_grid.set_diagonal_mode(AStarGrid2D.DIAGONAL_MODE_NEVER)
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	reset_grid()
	
	return astar_grid

# TODO: Do we need this? Maybe move to parent
func get_player_tiles():
	var player_tiles = []

	for tile in board_state:
		var node = board_state[tile]
		if node.name == 'Ranger' || node.name == 'Warrior':
			player_tiles.append(tile)
	
	return player_tiles

func reset_grid():
	astar_grid.clear()
	astar_grid.update()

func get_distance_from(tile1, tile2):
	var path = get_tile_path_from(tile1, tile2)
	return path.size() - 1

# this is a bit too specific. Maybe change name
func is_a_tile(tile):
	return get_cell_source_id(tile) != -1

# try not to use outside of this script
func get_tile_from_global_coords(global_coords):
	return local_to_map(global_coords)

# try not to use outside of this scripts
func get_global_coords_from_tile(tile: Vector2i):
	return map_to_local(tile)

func get_tile_path_from(tile1: Vector2i, tile2: Vector2i, get_closest_adjacent = false):
	if get_cell_source_id(tile2) == -1:
		return []

	# add extra weight to encourage facing forward and rightward
	#astar_grid.set_point_weight_scale(tile1 + Vector2i(0,-1),1.2)
	#astar_grid.set_point_weight_scale(tile1 + Vector2i(1,0),1.1)

	# tile1 is where the pathing unit currently stands, so it's always marked
	# solid by reset_grid(). AStarGrid2D.get_id_path() returns an empty path
	# whenever its start point is solid, so clear it temporarily.
	var origin_was_solid = astar_grid.is_point_solid(tile1)
	astar_grid.set_point_solid(tile1, false)

	var path
	if get_closest_adjacent:
		# assume tile you want to move towards is the last tile in path
		astar_grid.set_point_solid(tile2, false)
		path = astar_grid.get_id_path(tile1, tile2)
		path.remove_at(path.size()-1)
	else:
		# find path to move adjacent to target
		path = astar_grid.get_id_path(tile1, tile2)

	# reset origin point to filled
	astar_grid.set_point_solid(tile1, origin_was_solid)

	return path
#endregion
