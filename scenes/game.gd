class_name Game extends Node2D

@export var autoplay = true

var time_passed = 0
var previous_loop_complete = true
@onready var animals: Array[Node] = get_tree().get_nodes_in_group("autobattler") # array of character IDs

var board: Board
var remaining_animations_running = 0

func _ready():
	board = _load_board("res://scenes/_debug/test_board.tscn")
	place("animal", Vector2i(11,-1))
	place("astag", Vector2i(10,-1))
	place("banimal", Vector2i(11,3))
	place("bboar", Vector2i(8,3))

func _process(delta):
	var mouse_position = get_global_mouse_position()
	var mouse_tile = board.map.local_to_map(mouse_position)
	if Input.is_action_just_pressed("left_click"):
		if Flipper.enabled(Flipper.Feature.LOGGING):
			print(mouse_tile)
	
	board.map.clear_all_tiles()
	board.map.fill_tile(mouse_tile)
	
	if autoplay && board: # temporary, lets us turn off the autobattling
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
			, CONNECT_ONE_SHOT)
	# Move forward with your game logic here
	for animal in animals:
		var character_id = animal.character_id
		var current_tile = board.get_location_of(character_id)
		var list_args = determine_action(character_id, current_tile)
		var action: String = list_args[0]
		var action_arg = list_args[1]
		# all animals act simultaneously, update state while animations fire
		conduct_action(character_id, current_tile, action, action_arg)
	
	## Wait here until the counter hits zero
	while remaining_animations_running > 0:
		await get_tree().process_frame
		# play death animation if characters are dead
		for animal in animals.filter(_is_dead):
			if !animal.get_node("AnimationPlayer").is_playing():
				animal.play_animation("die")
	if Flipper.enabled(Flipper.Feature.LOGGING):
		print("All action animations completed!")
	
	var a_animals = animals.filter(func(char): return char.character_id.begins_with("a"))
	var b_animals = animals.filter(func(char): return char.character_id.begins_with("b"))
	
	if a_animals.all(_is_dead) && b_animals.all(_is_dead):
		print("Draw!")
		get_tree().paused = true
	elif a_animals.all(_is_dead):
		print("You Lost")
		get_tree().paused = true
	elif b_animals.all(_is_dead):
		print("You Win")
		get_tree().paused = true
	
	_cleanup()
	previous_loop_complete = true

func _is_dead(character):
	return character.get_node("HealthBar").value <= 0

func determine_action(character_id, current_tile):
	var occupied_adj_tiles = _null_or_adjacent_enemy_tiles(current_tile)
	
	if occupied_adj_tiles:
		return ["attack", occupied_adj_tiles[0]]
	
	var nearest_enemy_tile = _null_or_nearest_enemy_tile(current_tile)
	if nearest_enemy_tile:
		var path = board.get_path_from(current_tile, nearest_enemy_tile, true)
		return ["move", path.slice(0,2)]
	
	return ["pass", null]

func conduct_action(character_id, current_tile, action, action_arg):
	if action == "move":
		var character = _find_character(character_id)
		var coords = board._tile_path_to_coords(action_arg)
		move(character, coords, action_arg)
	elif action == "attack":
		var target_id = board.board_state[action_arg]
		var character = _find_character(character_id)
		attack(character, board.get_location_of(character_id),action_arg)
		
		CharacterStateManager.adjust_health(target_id, -1)
	elif action == "cast":
		pass
	elif action == "pass":
		var character = _find_character(character_id)
		idle(character)
	else: # if can't do anything
		pass

#region Display
func place(character_id, tile):
	var coords = board.map_to_local(tile)
	var character = _find_character(character_id)
	
	character.position = coords
	if character.character_id.begins_with("a"):
		character.get_node("Sprite2D").self_modulate = Color.BLUE
	elif character.character_id.begins_with("b"):
		character.get_node("Sprite2D").self_modulate = Color.RED
	
	board.place(character_id, tile)
	
	character.face("front")
	character.play_animation("idle")

func move(character, coords, tiles):
	board.moving(character.character_id, tiles)
	if Flipper.enabled(Flipper.Feature.LOGGING):
		print(character.character_id + " moved from " + str(tiles[0]) + " to " + str(tiles[-1]))
	character.position = coords[0] # set character to correct starting position for testing
	
	var walk_duration = 1.0
	var tween = create_tween()
	for i in range(1, coords.size()): # skip path[0], the tile the character currently occupies
		var destination_coords = Vector2(coords[i])
		var facing = _determine_facing(tiles[i-1], tiles[i])
		tween.tween_callback(character.play_animation.bind("walk", facing))
		tween.tween_property(character, "position", destination_coords, walk_duration)
	#tween.tween_callback(character.play_animation.bind("idle"))

enum Facing {
	FRONT,
	RIGHT,
	BACK,
	LEFT,
	NONE,
}

func attack(character, origin_tile, target_tile):
	if Flipper.enabled(Flipper.Feature.LOGGING):
		print(character.character_id + " attacked " + str(target_tile))
	var direction = Utils.isometric.calculate_direction(origin_tile, target_tile)
	character.play_animation("attack", direction)

func cast(character, spell_id, target_tile):
	pass

func idle(character):
	if Flipper.enabled(Flipper.Feature.LOGGING):
		print(character.character_id + " idled")
	character.play_animation("idle")

# determine facing for animation purposes
var VECTOR_TO_DIRECTION = {
	Vector2i(0,-1): "front",
	Vector2i(1,0): "right",
	Vector2i(0,1): "back",
	Vector2i(-1,0): "left",
}

func _determine_facing(origin, destination):
	var vector = destination - origin
	if abs(vector.x) > abs(vector.y):
		return VECTOR_TO_DIRECTION[Vector2i(vector.x / abs(vector.x), 0)]
	else:
		return VECTOR_TO_DIRECTION[Vector2i(0, vector.y / abs(vector.y))]

#endregion

#region Private
func _find_character(character_id):
	var characters = get_tree().get_nodes_in_group("autobattler")
	
	for character in characters:
		if character.character_id == character_id:
			return character
	
	return null

func _null_or_adjacent_enemy_tiles(current_tile: Vector2i):
	var directions = [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1,  0),                  Vector2i(1,  0),
		Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1),
	]
	
	var adjacent_enemies = []
	var current_character_id = board.board_state[current_tile]
	
	for dir in directions:
		var adj_tile = current_tile + dir
		if board.board_state.has(adj_tile) and board.board_state[adj_tile] != null:
			var character_id = board.board_state[adj_tile]
			if !character_id.begins_with(current_character_id[0]):
				adjacent_enemies.push_back(adj_tile)
	
	if adjacent_enemies != []:
		return adjacent_enemies
	
	return null

func _null_or_nearest_enemy_tile(current_tile):
	var closest_tile = null
	var min_path_length: int = 99
	var ally_prefix = board.board_state[current_tile][0]
	
	for tile_pos in board.board_state:
		var character_id = board.board_state[tile_pos]
		
		if !character_id:
			continue
		# Skip characters on your own team
		if character_id.begins_with(ally_prefix):
			continue
		
		# Get the path array of Vector2i points from your AStar grid
		var path: Array[Vector2i] = board.get_path_from(current_tile, tile_pos, true)
		
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
	board.cleanup() # clear solid tiles after moving

func _load_board(path):
	var woom = get_node_or_null("Board")
	if woom:
		return woom
	else:
		var scene = load(path)
		var board_inst = scene.instantiate()
		
		add_child(board_inst)
		return board_inst
#endregion
