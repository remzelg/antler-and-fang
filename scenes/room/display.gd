class_name Display extends Node2D

# handles character and spell animations
# all character sprites live in this scene

func place(character, coords):
	character.position = coords
	
	character.play_animation("idle", "front")

func move(character, coords, tiles):
	character.position = coords[0] # set character to correct starting position for testing
	
	var walk_duration = 1.0
	var tween = create_tween()
	var facing = "front"
	for i in range(1, coords.size()): # skip path[0], the tile the character currently occupies
		var destination_coords = Vector2(coords[i])
		facing = _determine_facing(tiles[i-1], tiles[i])
		tween.tween_callback(character.play_animation.bind("walk", facing))
		tween.tween_property(character, "position", destination_coords, walk_duration)
	tween.tween_callback(character.play_animation.bind("idle", facing))

func cast(character_id, spell_id, target_tile):
	pass

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
