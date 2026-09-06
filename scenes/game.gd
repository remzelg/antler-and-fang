class_name Game extends Node2D

@export var autoplay = true

var time_passed = 0
var previous_loop_complete = true
var animals: Array[String] = ["animal", "banimal"] # array of character IDs

var room: Room

var remaining_animations_running = 0

func _ready():
	room = _load_room("res://scenes/_debug/test_room.tscn")
	room.place("animal", Vector2i(11,-1))
	room.place("banimal", Vector2i(11,1))

func _process(delta):
	if autoplay && room: # temporary, lets us turn off the autobattling
		time_passed += delta
		if time_passed > 1 && previous_loop_complete:
			previous_loop_complete = false
			time_passed = 0
			run_loop()

func run_loop():
	var chars = get_tree().get_nodes_in_group("autobattler")
	remaining_animations_running = chars.size()
	for animal in chars:
		var player = animal.get_node("AnimationPlayer")

		player.animation_finished.connect(func(anim_name):
			remaining_animations_running -= 1
			print(remaining_animations_running)
			, CONNECT_ONE_SHOT)
	# Move forward with your game logic here
	for character_id in animals:
		var current_tile = room.get_location_of(character_id)
		var list_args = determine_action(character_id, current_tile)
		var action: String = list_args[0]
		var action_arg = list_args[1]
		# all animals act simultaneously, update state while animations fire
		print(list_args)
		conduct_action(character_id, current_tile, action, action_arg)
	
	## Wait here until the counter hits zero
	while remaining_animations_running > 0:
		await get_tree().process_frame
	print("All animations completed!")
	
	# TODO: determine deaths
	
	_cleanup()
	previous_loop_complete = true

func determine_action(character_id, current_tile):
	var occupied_adj_tiles = _null_or_adjacent_char_tiles(current_tile)
	var nearest_enemy_tile = _null_or_nearest_enemy_tile(current_tile, character_id.substr(0,1))
	
	if occupied_adj_tiles:
		return ["attack", current_tile]
	elif nearest_enemy_tile:
		var path = room.get_path_from(current_tile, nearest_enemy_tile, true)
		return ["move", path.slice(0,2)]
	else:
		return ["pass", null]

func conduct_action(character_id, current_tile, action, action_arg):
	if action == "move":
		room.move(character_id, action_arg)
	elif action == "attack":
		var target_id = room.board_state[action_arg]
		room.attack(character_id, action_arg)
		# TODO: Update state AFTER animation completes
		CharacterStateManager.adjust_health(target_id, -1)
	elif action == "cast":
		pass
	else: # if can't do anything
		pass

func _null_or_adjacent_char_tiles(current_tile: Vector2i):
	var directions = [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1,  0),                  Vector2i(1,  0),
		Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1),
	]
	
	var adjacent_chars = []
	
	for dir in directions:
		var adj_tile = current_tile + dir
		if room.board_state.has(adj_tile) and room.board_state[adj_tile] != null:
			adjacent_chars.push_back(adj_tile)
	
	if adjacent_chars != []:
		return adjacent_chars
	
	return null

func _null_or_nearest_enemy_tile(current_tile, ally_prefix):
	var closest_tile = null
	var min_path_length: int = 99
	
	for tile_pos in room.board_state:
		var character_id = room.board_state[tile_pos]
		
		if !character_id:
			continue
		# Skip characters on your own team
		if character_id.begins_with(ally_prefix):
			continue
		
		# Get the path array of Vector2i points from your AStar grid
		var path: Array[Vector2i] = room.get_path_from(current_tile, tile_pos, true)
		
		# If the path is empty, the enemy is completely trapped/unreachable
		if path.is_empty():
			continue
			
		# The length of the array corresponds to the actual walking distance
		var path_length = path.size()
		if path_length < min_path_length:
			min_path_length = path_length
			closest_tile = tile_pos
		
	return closest_tile

func _cleanup():
	room.cleanup() # clear solid tiles after moving

func _load_room(path):
	var room = get_node_or_null("Room")
	if room:
		print(room)
		return room
	else:
		var scene = load(path)
		var room_inst = scene.instantiate()
		
		add_child(room_inst)
		return room_inst
