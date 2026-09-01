var board_state #?
var time_passed = 0
var previous_loop_complete = true

func _process(delta):
	time_passed += delta
	if time_passed > 1 && previous_loop_complete:
		previous_loop_complete = false
		time_passed = 0
		#run_loop()

var animals = []

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

func determine_action(animal):
	pass

func conduct_action(animal, action, action_arg):
	pass
#
#func conduct_action(animal, action_name, action_arg):
	#if action_name == "move":
		#move(animal, action_arg)
	#elif action_name == "cast":
		#cast(animal, action_arg)
#
#func determine_action(animal):
	## check if enemy adjacent. If so attack
	#var target_tile = _check_for_adjacent_enemy(animal)
	#if target_tile:
		#return["cast", "melee_attack", target_tile]
	## if not, move towards nearest enemy
	## while moving, mark both the origin point, and destination as solid
	#var current_tile = _get_location_of(animal)
	#var tile_path = grid.get_tile_path_from(Vector2i(8,3), Vector2i(8,2))
	#
	## mark all the squares the animal is moving through as solid
	#return ["move", tile_path]

#func move(character, tile_path):
	#var coords_path = _tile_path_to_coords(tile_path)
	#
	#display.move(character, coords_path, tile_path)
#
## TODO:
#func cast(character, args):
	#var spell_id = args[0]
	#var target_tile = args[1]
	#
	#character.play_animation("attack", args[2])
