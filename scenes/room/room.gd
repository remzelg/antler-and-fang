class_name Room extends Node2D

# This class has 2 main purposes
# Display map and animations on said map
# Store location data for all characters on map
#  and make calculations against said data

@onready var map: Map = $Map
@onready var grid: Grid = $Grid
@onready var display: Display = $Display

@onready var board_state: Dictionary = {}

var temp_filled: Array[Vector2i] # to be cleared on cleanup
var temp_board_state: Dictionary # to overwrite board state on cleanup

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

func place(character_id, tile):
	var character = _find_character(character_id)
	var coord = map.map_to_local(tile)
	display.place(character, coord)
	
	board_state[tile] = character_id
	grid.fill(tile)

func move(character_id, path):
	var character = _find_character(character_id)
	var coords = _tile_path_to_coords(path)
	
	display.move(character, coords, path)
	
	temp_board_state[path[0]] = null
	temp_board_state[path[-1]] = character_id
	temp_filled.push_front(path[0])
	grid.fill(path[-1]) # actually mark destination tile solid

func attack(character_id, tile):
	var character = _find_character(character_id)
	display.attack(character, tile)

func cast(character, spell_id, tile):
	pass

func get_location_of(character_id):
	var found_key
	for key in board_state	:
		if board_state[key] == character_id:
			found_key = key
			break # Stop loop early
	return found_key

func get_path_from(from_tile, to_tile, to_closest_adjacent = false):
	var path: Array[Vector2i] = grid.get_tile_path_from(from_tile, to_tile, to_closest_adjacent)
	return path

func cleanup():
	for tile in temp_filled:
		grid.clear(tile)
	board_state.merge(temp_board_state, true)
	
	# clear for next loop run
	temp_filled = []
	temp_board_state = {}

# TODO: Really need to just select by ID
func _find_character(character_id):
	if character_id == "animal":
		return $Badger
	elif character_id == "banimal":
		return $Boar
	else:
		return null

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
