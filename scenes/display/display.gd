class_name GameDisplay extends Node2D

# handles character and spell animations
# all character sprites live in this scene

func place(character, coords):
	character.position = coords
	if character.character_id.begins_with("a"):
		character.get_node("Sprite2D").self_modulate = Color.BLUE
	elif character.character_id.begins_with("b"):
		character.get_node("Sprite2D").self_modulate = Color.RED
	
	character.face("front")
	character.play_animation("idle")

func move(character, coords, tiles):
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
