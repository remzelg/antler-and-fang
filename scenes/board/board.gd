class_name Board extends Node2D

# This class has 2 main purposes
# Display map
# Store location data for all characters on map
#  and make calculations against said data

@onready var map: Map = $Map
@onready var grid: Grid = $Grid

@onready var board_state: Dictionary = {}

var temp_filled: Array[Vector2i] # to be cleared on cleanup
var temp_board_state: Dictionary[Vector2i, String] # to overwrite board state on cleanup

func _ready():
	var grid_corners: Array[Vector2i] = [Vector2i(8,4), Vector2i(8,-3), Vector2i(12,-3), Vector2i(12,4)]
	var rect = _get_rect_from_vector2i_array(grid_corners)
	initialize(rect)

func initialize(rect: Rect2i):
	grid.initialize(rect)
	# setup board state dictionary with null for every tile
	var start = rect.position
	var end = rect.position + rect.size
	for x in range(start.x, end.x + 1):
		for y in range(start.y, end.y + 1):
			var point_id = Vector2i(x, y)
			
			# note we could also populate character locations here if we wanted
			board_state[point_id] = null

# tile to world coords
func map_to_local(tile):
	return map.map_to_local(tile)

func place(character_id, tile):
	board_state[tile] = character_id
	grid.fill(tile)

# fill the target tile, queue up state changes for after loop completion
func moving(character_id, tile_path):
	temp_board_state[tile_path[0]] = ""
	temp_board_state[tile_path[-1]] = character_id
	temp_filled.push_front(tile_path[0])
	grid.fill(tile_path[-1]) # actually mark destination tile solid

func cleanup():
	for tile in temp_filled:
		grid.clear(tile)
	board_state.merge(temp_board_state, true)
	
	# remove empty string values from dictionary
	for key in board_state.keys().duplicate():
		if board_state[key] == "":
			board_state.erase(key)
	
	# clear for next loop run
	temp_filled = []
	temp_board_state = {}

func get_location_of(character_id):
	var found_key
	for key in board_state:
		if board_state[key] == character_id:
			found_key = key
			break # Stop loop early
	return found_key

func get_path_from(from_tile, to_tile, to_closest_adjacent = false):
	var path: Array[Vector2i] = grid.get_tile_path_from(from_tile, to_tile, to_closest_adjacent)
	return path

func null_or_adjacent_enemy_tiles(current_tile: Vector2i) -> Array[Vector2i]:
	var directions = [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1,  0),                  Vector2i(1,  0),
		Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1),
	]
	
	var adjacent_enemies: Array[Vector2i] = []
	var current_character_id = board_state[current_tile]
	
	for dir in directions:
		var adj_tile = current_tile + dir
		if board_state.has(adj_tile) and board_state[adj_tile] != null:
			var character_id = board_state[adj_tile]
			if !character_id.begins_with(current_character_id[0]):
				adjacent_enemies.push_back(adj_tile)
	
	if adjacent_enemies != []:
		return adjacent_enemies
	
	return []

# TODO: Implmement ability to ignore filled tiles to find nearest enemy
func null_or_nearest_enemy_tile(current_tile, ignore_filled_tiles=false) -> Vector2i:
	var closest_tile = null
	var min_path_length: int = 99
	var ally_prefix = board_state[current_tile][0]
	
	for tile_pos in board_state:
		var character_id = board_state[tile_pos]
		
		if !character_id:
			continue
		# Skip characters on your own team
		if character_id.begins_with(ally_prefix):
			continue
		
		# Get the path array of Vector2i points from your AStar grid
		var path: Array[Vector2i] = get_path_from(current_tile, tile_pos, true)
		
		# If the path is empty, the enemy is completely trapped/unreachable
		if path.is_empty():
			continue
			
		# The length of the array corresponds to the actual walking distance
		var path_length = path.size()
		if path_length < min_path_length:
			min_path_length = path_length
			closest_tile = tile_pos
		
	return closest_tile

#region Utils
func _tile_path_to_coords(tiles):
	var coords = []
	for tile in tiles:
		coords.push_back(map.map_to_local(tile))
	
	return coords

# helper function to create a rect2 around a group of vector2 points
func _get_rect_from_vector2i_array(array: Array[Vector2i]) -> Rect2i:
	if array.is_empty():
		return Rect2i()
		
	var rect = Rect2i(array[0], Vector2i.ZERO)
	for point in array:
		rect = rect.expand(point)
		
	return rect
#endregion
