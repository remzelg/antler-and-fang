class_name Display extends Node2D

func place(character_id: String, coords: Vector2):
	var character = _find_character(character_id)
	character.position = coords
	if character.character_id.begins_with("a"):
		character.get_node("Sprite2D").self_modulate = Color.BLUE
	elif character.character_id.begins_with("b"):
		character.get_node("Sprite2D").self_modulate = Color.RED
	
	character.face("front")
	character.play_animation("idle")

func move(character_id: String, path: Array[Vector2]):
	var character = _find_character(character_id)
	character.position = path[0]
	
	var walk_duration = 1.0
	var tween = create_tween()
	for i in range(1, path.size()): # skip path[0], the tile the character currently occupies
		var destination_coords = Vector2(path[i])
		var facing = Utils.isometric.calculate_direction(path[i-1], path[i])
		tween.tween_callback(character.play_animation.bind("walk", facing))
		tween.tween_property(character, "position", destination_coords, walk_duration)
	#tween.tween_callback(character.play_animation.bind("idle"))

func attack(character_id, origin_tile, target_tile):
	var direction = Utils.isometric.calculate_direction(origin_tile, target_tile)
	var character = _find_character(character_id)
	character.play_animation("attack", direction)

func cast():
	pass

func idle(character_id):
	var character = _find_character(character_id)
	character.play_animation("idle")

func _find_character(character_id: String):
	var characters = get_tree().get_nodes_in_group("autobattler")
	
	for character in characters:
		if character.character_id == character_id:
			return character
	
	return null
