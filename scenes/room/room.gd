class_name Room
extends Node2D

@onready var map: Map = $Map
@onready var grid: Grid = $Grid
@onready var display: Display = $Display

func _ready():
	var tiles = map.used_tiles()
	grid.initialize(tiles)
	display.initialize(tiles)
	
	var test_path = [Vector2(16,4), Vector2(16,3), Vector2(16,2), Vector2(16,1), Vector2(16,0), Vector2(16,-1), Vector2(16,-2), Vector2(16,-3)]
	var coords = _tile_path_to_coords(test_path)
	display.move("badger", coords)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		print(get_global_mouse_position())
		print(map.local_to_map(get_global_mouse_position()))

func preview_move(character, from_tile, to_tile):
	pass

func move(character, from_tile, to_tile):
	var move_path = grid.get_tile_path_from(from_tile, to_tile)
	display.move("active_character_id", move_path)

func preview_cast(character, spell_id, to_tile):
	pass

func cast(character, spell_id, to_tile):
	pass

func pass_turn(character):
	pass

func _tile_path_to_coords(tiles):
	var coords = []
	for tile in tiles:
		coords.push_back(map.map_to_local(tile))
	
	return coords
