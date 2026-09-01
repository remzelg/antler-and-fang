class_name Room extends Node2D

# This class has 2 main purposes
# Display map and animations on said map
# Store location data for all characters on map
#  and make calculations against said data

@onready var map: Map = $Map
@onready var grid: Grid = $Grid
@onready var display: Display = $Display

@onready var board_state: Dictionary = {}

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
	
	board_state[path[0]] = null
	board_state[path[-1]] = character_id
	grid.clear(path[0])
	grid.fill(path[-1])

func cast(character, spell_id, tile):
	pass

func get_path_from(from_tile, to_tile):
	return grid.get_tile_path_from(from_tile, to_tile)

# TODO:
func _find_character(character_id):
	if character_id == "animal":
		return $Animal
	elif character_id == "animal2":
		return $Animal2
	else:
		return null

func _ready():
	var grid_corners: Array[Vector2i] = [Vector2i(8,4), Vector2i(8,-3), Vector2i(12,-3), Vector2i(12,4)]
	var rect = _get_rect_from_vector2i_array(grid_corners)
	grid.initialize(rect)
	# setup board state dictionary with null for every tile
	var start = rect.position
	var end = rect.position + rect.size
	for x in range(start.x, end.x + 1):
		for y in range(start.y, end.y + 1):
			var point_id = Vector2i(x, y)
			
			board_state[point_id] = null

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
