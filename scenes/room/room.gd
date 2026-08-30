class_name Room
extends Node2D

@onready var map: Map = $Map
@onready var grid: Grid = $Grid
@onready var display: Display = $Display

var time_passed: float = 0
var previous_loop_complete: bool = true
@onready var animals = [$Animal, $Animal2]

func _ready():
	var tiles = map.used_tiles()
	grid.initialize(tiles)
	display.initialize(grid.board_state)

func _process(delta: float):
	time_passed += delta
	if time_passed > 1 && previous_loop_complete:
		previous_loop_complete = false
		time_passed = 0
		run_loop()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		print(get_global_mouse_position())
		print(map.local_to_map(get_global_mouse_position()))

func run_loop():
	for animal in animals:
		var list_args = determine_action(animal)
		var action: String = list_args[0]
		var action_arg = list_args[1]
		conduct_action(animal, action, action_arg)
		# all animals act simultaneously, update state while animations fire
		# determine deaths
		# next loop
	previous_loop_complete = true

func conduct_action(animal, action_name, action_arg):
	if action_name == "move":
		move(animal, action_arg)
	elif action_name == "cast":
		cast(animal, action_arg)

func determine_action(animal):
	var current_tile = _get_location_of(animal)
	var tile_path = grid.get_tile_path_from(Vector2i(8,3), Vector2i(8,2))
	
	# mark all the squares the animal is moving through as solid
	return ["move", tile_path]

func move(character, tile_path):
	var coords_path = _tile_path_to_coords(tile_path)
	
	display.move(character, coords_path, tile_path)

# basic attacks are gonna be spells also
func cast(character, args):
	var spell_id = args[0]
	var target_tile = args[1]

func _get_location_of(animal):
	return Vector2i(8,3)

func _tile_path_to_coords(tiles):
	var coords = []
	for tile in tiles:
		coords.push_back(map.map_to_local(tile))
	
	return coords
