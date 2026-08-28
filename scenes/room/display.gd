class_name Display
extends Node2D

# handles character and spell animations
# all character sprites live in this scene

func initialize(tiles):
	pass

func find_character(character_id):
	return $"../Animal"

func move(character_id, path):
	# pause_input (at least for this character in
	var char = find_character("whatever")
	char.play_animation("walk")
	var tween = create_tween().set_parallel(true)
	tween.tween_property(char, "position", path[7], 3.0).set_ease(Tween.EASE_OUT)
	# unpause_input

func cast(character_id, spell_id, target_tile):
	pass
